"""
A server exposing Starknet functionalities as API endpoints.
"""

import asyncio
import os
import sys

from flask import Flask, jsonify
from flask_cors import CORS
from gunicorn.app.base import BaseApplication
from starkware.starkware_utils.error_handling import StarkException

from .blueprints.base import base
from .blueprints.feeder_gateway import feeder_gateway
from .blueprints.gateway import gateway
from .blueprints.postman import postman
from .blueprints.rpc.routes import rpc
from .devnet_config import DevnetConfig, DumpOn, parse_args
from .starknet_wrapper import StarknetWrapper
from .state import state
from .util import StarknetDevnetException

app = Flask(__name__)
CORS(app)

# if this is removed, the tests which don't run the main function will fail
@app.before_first_request
async def initialize_starknet():
    """Initialize Starknet to assert it's defined before its first use."""
    await state.starknet_wrapper.initialize()


app.register_blueprint(base)
app.register_blueprint(gateway)
app.register_blueprint(feeder_gateway)
app.register_blueprint(postman)
app.register_blueprint(rpc)

# We don't need init method here.
# pylint: disable=W0223
class GunicornServer(BaseApplication):
    """Our Gunicorn application."""

    def __init__(self, application, args):
        self.args = args
        self.application = application
        super().__init__()

    def load_config(self):
        self.cfg.set("bind", f"{self.args.host}:{self.args.port}")
        self.cfg.set("workers", 1)
        self.cfg.set("timeout", self.args.timeout)
        self.cfg.set(
            "logconfig_dict",
            {
                "loggers": {
                    "gunicorn.error": {
                        # Disable info messages like "Starting gunicorn"
                        "level": "WARNING",
                        "handlers": ["error_console"],
                        "propagate": False,
                        "qualname": "gunicorn.error",
                    },
                    "gunicorn.access": {
                        "level": "INFO",
                        # Log access to stderr to maintain backward compatibility
                        "handlers": ["error_console"],
                        "propagate": False,
                        "qualname": "gunicorn.access",
                    },
                },
            },
        )

    def load(self):
        return self.application


def main():
    """Runs the server."""

    args = parse_args(sys.argv[1:])

    try:
        if args.load_path:
            state.load(args.load_path)
        else:
            state.set_starknet_wrapper(StarknetWrapper(DevnetConfig(args)))

        state.set_dump_options(args.dump_path, args.dump_on)
    except StarknetDevnetException as error:
        sys.exit(error.message)

    asyncio.run(state.starknet_wrapper.initialize())

    try:
        print(f" * Listening on http://{args.host}:{args.port}/ (Press CTRL+C to quit)")
        main_pid = os.getpid()
        GunicornServer(app, args).run()
    except KeyboardInterrupt:
        pass
    finally:
        # Dump only if process is worker (not main)
        if args.dump_on == DumpOn.EXIT and os.getpid() != main_pid:
            state.dumper.dump()
            sys.exit(0)


@app.errorhandler(StarkException)
def handle(error: StarkException):
    """Handles the error and responds in JSON."""
    return {
        "message": error.message,
        "code": str(error.code),
    }, error.status_code


@app.route("/api", methods=["GET"])
def api():
    """Return available endpoints."""
    routes = {}
    for url in app.url_map.iter_rules():
        if url.endpoint != "static":
            routes[url.rule] = {
                "functionName": url.endpoint,
                "methods": list(url.methods),
                "doc": app.view_functions[url.endpoint].__doc__.strip(),
            }
    return jsonify(routes)


if __name__ == "__main__":
    main()
