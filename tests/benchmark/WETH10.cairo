%lang starknet
%builtins pedersen range_check ecdsa

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.starknet.common.syscalls import get_contract_address, get_caller_address
from starkware.cairo.common.math_cmp import is_le

from starkware.cairo.common.uint256 import Uint256, uint256_add, uint256_sub, uint256_le, uint256_lt

const true = 1
const false = 0
const maxUint112 = 0x1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111

const maxFelt = 0x11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111

@contract_interface
namespace IERC3156FlashBorrower:
    func onFlashLoan(
            initiator : felt, token : felt, amount : felt, fee : felt, data_len : felt,
            data : felt*) -> (res : Uint256):
    end
end

@contract_interface
namespace ITransferReceiver:
    func onTokenTransfer(add : felt, val : felt, cd_len : felt, cd : felt*) -> (success : felt):
    end
end

@contract_interface
namespace IApprovalReceiver:
    func onTokenApproval(add : felt, val : felt, cd_len : felt, cd : felt*) -> (success : felt):
    end
end

const name = 'Wrapped Ether v10'
const symbol = 'WETH10'
const decimals = 18

# keccak256("ERC3156FlashBorrower.onFlashLoan");
const CALLBACK_SUCCESS_high = 0x439148f0bbc682ca079e46d6e2c2f0c1
const CALLBACK_SUCCESS_low = 0xe3b820f1a291b069d8882abf8cf18dd9

# keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
# const PERMIT_TYPEHASH.high = 0x6e71edae12b1b97f4d1f60370fef1010
# const PERMIT_TYPEHASH.low  = 0x5fa2faae0126114a169c64845d6126c9

@storage_var
func balanceOf(add : felt) -> (res : felt):
end

@storage_var
func nonces(add : felt) -> (res : felt):
end

@storage_var
func allowance(owner : felt, spender : felt) -> (res : felt):
end

@storage_var
func flashMinted() -> (res : felt):
end

@view
func totalSupply{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        res : felt):
    let (fMinted) = flashMinted.read()
    let (add) = get_contract_address()
    let (balance) = balanceOf.read(add)
    return (fMinted + balance)
end

@external
func receive{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(value : felt):
    let (sender) = get_caller_address()
    let (balance) = balanceOf.read(sender)
    balanceOf.write(sender, balance + value)
    return ()
end

@external
func deposit{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(value : felt):
    let (sender) = get_caller_address()
    let (balance) = balanceOf.read(sender)
    balanceOf.write(sender, balance + value)
    return ()
end

@external
func depositTo{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        add : felt, value : felt):
    let (balance) = balanceOf.read(add)
    balanceOf.write(add, balance + value)
    return ()
end

@external
func depositToAndCall{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        add_to : felt, value : felt, data_len : felt, data : felt*) -> (success : felt):
    alloc_locals
    depositTo(add_to, value)
    let (sender) = get_caller_address()
    let (success) = ITransferReceiver.onTokenTransfer(add_to, sender, value, data_len, data)
    return (success)
end

@view
func maxFlashLoan{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        token : felt) -> (res : felt):
    let (add) = get_contract_address()
    if add == token:
        let (fMinted) = flashMinted.read()
        return (maxUint112 - fMinted)
    else:
        return (0)
    end
end

@view
func flashFee{syscall_ptr : felt*, range_check_ptr}(token : felt, ignore : felt) -> (
        success : felt):
    alloc_locals
    let (add) = get_contract_address()
    # "WETH: flash mint only WETH10"
    assert add = token
    return (0)
end

@external
func flashLoan{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        receiver : felt, token : felt, value : felt, data_len : felt, data : felt*) -> (
        success : felt):
    alloc_locals
    let (add) = get_contract_address()
    assert token = add
    # "WETH: flash mint only WETH10"
    let (cond) = is_le(maxUint112 + 1, value)
    assert cond = 0
    # WETH: individual loan limit exceeded
    let (fMinted) = flashMinted.read()
    let (cond) = is_le(maxUint112 + 1, fMinted + value)
    assert cond = 0
    # WETH: total loan limit exceeded
    flashMinted.write(fMinted + value)

    let (balance) = balanceOf.read(receiver)
    balanceOf.write(receiver, balance + value)
    let (sender) = get_caller_address()
    let (add) = get_contract_address()
    let (res) = IERC3156FlashBorrower.onFlashLoan(receiver, sender, add, value, 0, data_len, data)
    assert res.high = CALLBACK_SUCCESS_high
    # WATH: flash loan failed

    assert res.low = CALLBACK_SUCCESS_low
    # WATH: flash loan failed
    let (allowed) = allowance.read(receiver, add)
    let (cond) = is_le(allowed + 1, value)

    if allowed != maxFelt:
        assert cond = 0
        # WETH: request exceeds allowance
        let reduced = allowed - value
        allowance.write(receiver, add, reduced)
        tempvar syscall_ptr : felt* = syscall_ptr
        tempvar range_check_ptr = range_check_ptr
        tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
    else:
        tempvar syscall_ptr : felt* = syscall_ptr
        tempvar range_check_ptr = range_check_ptr
        tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
    end

    let (balance) = balanceOf.read(receiver)
    let (cond) = is_le(balance + 1, value)
    assert cond = 0
    # WETH: burn amount exceeds balance

    balanceOf.write(receiver, balance - value)
    let (fMinted) = flashMinted.read()
    flashMinted.write(fMinted - value)
    return (true)
end

@external
func withdraw{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(value : felt):
    alloc_locals
    let (local sender) = get_caller_address()
    let (balance) = balanceOf.read(sender)
    let (cond) = is_le(balance + 1, value)
    assert cond = 0
    # WETH: burn amount axceeds balance
    balanceOf.write(sender, balance - value)
    # add value to calling contract
    # (bool success, ) = msg.sender.call{value: value}("");
    return ()
end

@external
func withdrawTo{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        to : felt, value : felt):
    alloc_locals
    let (local sender) = get_caller_address()
    let (balance) = balanceOf.read(sender)
    let (cond) = is_le(balance + 1, value)
    assert cond = 0
    # "WETH: burn amount exceeds balance"
    balanceOf.write(sender, balance - value)
    # emit Transfer(sender, get_current_address(), value)
    # add value to the calling contract
    # (bool success, ) = to.call{value: value}("")
    # if success == 0:
    #  assert 1 = 0
    # end
    return ()
end
@external
func approve{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        spender : felt, value : felt) -> (success : felt):
    let (sender) = get_caller_address()
    allowance.write(sender, spender, value)
    return (true)
end

@external
func approveAndCall{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        spender : felt, value : felt, data_len : felt, data : felt*) -> (success : felt):
    alloc_locals
    let (sender) = get_caller_address()
    allowance.write(sender, spender, value)
    let (success) = IApprovalReceiver.onTokenApproval(spender, sender, value, data_len, data)
    return (success)
end

@external
func permit{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        owner : felt, spender : felt, value : felt, v : felt, r : felt, s : felt):
    return ()
end

@external
func transfer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        to : felt, value : felt) -> (success : felt):
    alloc_locals
    let (sender) = get_caller_address()
    if to != 0:
        let balance : felt = balanceOf.read(sender)
        let (cond) = is_le(balance + 1, value)
        assert cond = 0
        # WETH: transfer amount exceeds balance
        balanceOf.write(sender, balance - value)
        let (balance_to) = balanceOf.read(to)
        balanceOf.write(to, balance_to + value)
    else:
        let (balance) = balanceOf.read(sender)
        let (cond) = is_le(balance + 1, value)
        assert cond = 0
        # WETH: burn amount axceeds balance
        balanceOf.write(sender, balance - value)
        # (bool success, ) = msg.sender.call{value: value}("");
        # require(success, "WETH: ETH transfer failed");
    end
    return (true)
end

@external
func transferFrom{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        from_ : felt, to : felt, value : felt) -> (success : felt):
    alloc_locals
    let (local sender) = get_caller_address()
    let (balance) = balanceOf.read(from_)

    if from_ != sender:
        let (allowed) = allowance.read(from_, sender)

        if allowed != maxFelt:
            let (cond) = is_le(allowed + 1, value)
            assert cond = 0
            # WETH: request exceedss allowance
            let reduced = allowed - value
            allowance.write(from_, sender, reduced)
            tempvar syscall_ptr : felt* = syscall_ptr
            tempvar range_check_ptr = range_check_ptr
            tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
        else:
            tempvar syscall_ptr : felt* = syscall_ptr
            tempvar range_check_ptr = range_check_ptr
            tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
        end
        tempvar syscall_ptr : felt* = syscall_ptr
        tempvar range_check_ptr = range_check_ptr
        tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
    else:
        tempvar syscall_ptr : felt* = syscall_ptr
        tempvar range_check_ptr = range_check_ptr
        tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
    end

    tempvar syscall_ptr : felt* = syscall_ptr
    tempvar range_check_ptr = range_check_ptr
    tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
    if to != 0:
        let (cond) = is_le(balance + 1, value)
        assert cond = 0
        # WETH: transfer amount exceeds balance
        let (balance_to) = balanceOf.read(to)
        balanceOf.write(from_, balance - value)
        balanceOf.write(to, balance_to + value)
        tempvar syscall_ptr : felt* = syscall_ptr
        tempvar range_check_ptr = range_check_ptr
        tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
    else:
        let (cond) = is_le(balance + 1, value)
        assert cond = 0
        # WETH: transfer amount exceeds balance

        balanceOf.write(from_, balance - value)
        # (bool success, ) = msg.sender.call{value: value}("");
        # require(success, "WETH: ETH transfer failed");
        tempvar syscall_ptr : felt* = syscall_ptr
        tempvar range_check_ptr = range_check_ptr
        tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
    end
    return (true)
end

@external
func transferAndCall{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        to : felt, value : felt, data_len : felt, data : felt*) -> (success : felt):
    alloc_locals
    let (local sender) = get_caller_address()
    if to != 0:
        let (balance) = balanceOf.read(sender)
        let (cond) = is_le(balance + 1, value)
        assert cond = 0
        # WETH: transfer amount exceeds balance
        balanceOf.write(sender, balance - value)
        let (balance_to) = balanceOf.read(to)
        balanceOf.write(to, balance_to + value)
    else:
        let (balance) = balanceOf.read(sender)
        let (cond) = is_le(balance + 1, value)
        assert cond = 0
        # WETH: burn amount axceeds balance
        balanceOf.write(sender, balance - value)
        # (bool success, ) = msg.sender.call{value: value}("");
        # require(success, "WETH: ETH transfer failed");
    end
    local pedersen_ptr : HashBuiltin* = pedersen_ptr
    let (success) = ITransferReceiver.onTokenTransfer(to, sender, value, data_len, data)
    return (success)
end

@external
func withdrawFrom{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        from_ : felt, to : felt, value : felt):
    alloc_locals
    let (sender) = get_caller_address()
    if from_ != sender:
        let (allowed) = allowance.read(from_, sender)
        let (cond) = is_le(allowed + 1, value)
        if allowed != maxFelt:
            assert cond = 0
            # WETH: request exceeds allowance
            let reduced = allowed - value
            allowance.write(from_, sender, reduced)
            # emit Approval(from_, sender, reduced)
            tempvar syscall_ptr : felt* = syscall_ptr
            tempvar range_check_ptr = range_check_ptr
            tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
        else:
            tempvar syscall_ptr : felt* = syscall_ptr
            tempvar range_check_ptr = range_check_ptr
            tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
        end
        tempvar syscall_ptr : felt* = syscall_ptr
        tempvar range_check_ptr = range_check_ptr
        tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
    else:
        tempvar syscall_ptr : felt* = syscall_ptr
        tempvar range_check_ptr = range_check_ptr
        tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
    end

    let (balance) = balanceOf.read(from_)
    let (cond) = is_le(balance + 1, value)
    assert cond = 0
    # "WETH: burn amount exceeds balance"
    # WETH: Ether transfer failed

    balanceOf.write(from_, balance - value)
    # emit Transfer(from_, address(0), value)
    # (bool success, ) = to.call{value: value}("")
    # if success == 0:
    #  assert 1 = 0
    # end
    return ()
end
