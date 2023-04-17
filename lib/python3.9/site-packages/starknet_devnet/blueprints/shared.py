"""
Shared functions between blueprints
"""

from marshmallow import ValidationError
from starkware.starknet.services.api.gateway.transaction import Transaction
from starkware.starkware_utils.error_handling import StarkErrorCode

from starknet_devnet.constants import CAIRO_LANG_VERSION
from starknet_devnet.util import StarknetDevnetException


def validate_transaction(data: bytes) -> Transaction:
    """Ensure `transaction_dict` is a valid Starknet transaction. Returns the parsed Transaction."""
    try:
        return Transaction.loads(data)
    except (TypeError, ValidationError) as err:
        msg = f"""Invalid tx: {err}
Be sure to use the correct compilation (json) artifact. Devnet-compatible cairo-lang version: {CAIRO_LANG_VERSION}"""
        raise StarknetDevnetException(
            code=StarkErrorCode.MALFORMED_REQUEST, message=msg, status_code=400
        ) from err
