"""Default HTTP client selection proxy"""
import os
import typing as ty

from .http_common import (
	ClientSyncBase,
	StreamDecodeIteratorSync,
	
	addr_t, auth_t, cookies_t, headers_t, params_t, reqdata_sync_t, timeout_t,
	workarounds_t,
)


__all__ = (
	"addr_t", "auth_t", "cookies_t", "headers_t", "params_t", "reqdata_sync_t",
	"timeout_t", "workarounds_t",
	
	"build_client_sync",
	"StreamDecodeIteratorSync",
)

PREFER_HTTPX = (os.environ.get("PY_IPFS_HTTP_CLIENT_PREFER_HTTPX", "no").lower()
                not in ("0", "f", "false", "n", "no"))

if PREFER_HTTPX:  # pragma: http-backend=httpx
	try:
		from . import http_httpx as _backend
	except ImportError:
		from . import http_requests as _backend  # type: ignore[no-redef]
else:  # pragma: http-backend=requests
	try:
		from . import http_requests as _backend  # type: ignore[no-redef]
	except ImportError:  # pragma: no cover
		from . import http_httpx as _backend


def build_client_sync(  # type: ignore[no-any-unimported]
		addr: addr_t,
		base: str,
		offline: bool = False,
		auth: auth_t = None,
		cookies: cookies_t = None,
		headers: headers_t = None,
		timeout: timeout_t = 120
) -> ClientSyncBase[ty.Any]:

	return _backend.ClientSync(
		addr=addr,
		base=base,
		offline=offline,
		auth=auth,
		cookies=cookies,
		headers=headers or ty.cast(ty.Dict[str, str], {}),
		timeout=timeout
	)
