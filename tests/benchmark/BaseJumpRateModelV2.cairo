# @title Logic for Compound's JumpRateModel Contract V2.
# @author Compound (modified by Dharma Labs, refactored by Arr00); StarkWare(Cairo rewrite by Artem)
# @notice Version 2 modifies Version 1 by enabling updateable parameters.

%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_nn, assert_not_zero, unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.starknet.common.syscalls import get_caller_address

# @notice The address of the owner, i.e. the Timelock contract, which can update parameters directly
@storage_var
func owner() -> (address):
end

@view
func getOwner{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (address):
    return owner.read()
end

# @notice The approximate number of blocks per year that is assumed by the interest rate model
const blocksPerYear = 2102400

@view
func getBlocksPerYear() -> (res):
    return (blocksPerYear)
end

# @notice The multiplier of utilization rate that gives the slope of the interest rate
@storage_var
func multiplierPerBlock() -> (res):
end

@view
func getMultiplierPerBlock{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        res):
    return multiplierPerBlock.read()
end

# @notice The base interest rate which is the y-intercept when utilization rate is 0
@storage_var
func baseRatePerBlock() -> (res):
end

@view
func getBaseRatePerBlock{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        res):
    return baseRatePerBlock.read()
end

# @notice The multiplierPerBlock after hitting a specified utilization point
@storage_var
func jumpMultiplierPerBlock() -> (res):
end

@view
func getJumpMultiplierPerBlock{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (res):
    return jumpMultiplierPerBlock.read()
end

# @notice The utilization point at which the jump multiplier is applied
@storage_var
func kink() -> (res):
end

@view
func getKink{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (res):
    return kink.read()
end

# @notice Construct an interest rate model
# @param baseRatePerYear The approximate target base APR, as a mantissa (scaled by 1e18)
# @param multiplierPerYear The rate of increase in interest rate wrt utilization (scaled by 1e18)
# @param jumpMultiplierPerYear The multiplierPerBlock after hitting a specified utilization point
# @param kink_ The utilization point at which the jump multiplier is applied
# @param owner_ The address of the owner, i.e. the Timelock contract (which has the ability to update parameters directly)
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        baseRatePerYear, multiplierPerYear, jumpMultiplierPerYear, kink_, owner_):
    owner.write(owner_)
    updateJumpRateModelInternal(baseRatePerYear, multiplierPerYear, jumpMultiplierPerYear, kink_)
    return ()
end

# @notice Update the parameters of the interest rate model (only callable by owner, i.e. Timelock)
# @param baseRatePerYear The approximate target base APR, as a mantissa (scaled by 1e18)
# @param multiplierPerYear The rate of increase in interest rate wrt utilization (scaled by 1e18)
# @param jumpMultiplierPerYear The multiplierPerBlock after hitting a specified utilization point
# @param kink_ The utilization point at which the jump multiplier is applied
@external
func updateJumpRateModel{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        baseRatePerYear, multiplierPerYear, jumpMultiplierPerYear, kink_):
    let (owner_) = owner.read()
    let (sender) = get_caller_address()
    assert owner_ = sender  # only the owner may call this function
    return updateJumpRateModelInternal(
        baseRatePerYear, multiplierPerYear, jumpMultiplierPerYear, kink_)
end

# @notice Calculates the utilization rate of the market: `borrows / (cash + borrows - reserves)`
# @param cash The amount of cash in the market
# @param borrows The amount of borrows in the market
# @param reserves The amount of reserves in the market (currently unused)
# @return The utilization rate as a mantissa between [0, 1e18]
@view
func utilizationRate{range_check_ptr}(cash, borrows, reserves) -> (res):
    # Utilization rate is 0 when there are no borrows
    if borrows == 0:
        return (0)
    end

    let divisor = cash + borrows - reserves
    assert_nn(divisor)
    return checked_div(borrows * 10 ** 18, divisor)
end

# @notice Calculates the current borrow rate per block, with the error code expected by the market
# @param cash The amount of cash in the market
# @param borrows The amount of borrows in the market
# @param reserves The amount of reserves in the market
# @return The borrow rate percentage per block as a mantissa (scaled by 1e18)
func getBorrowRateInternal{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        cash, borrows, reserves) -> (res):
    alloc_locals
    let (util) = utilizationRate(cash, borrows, reserves)
    let (kink_) = kink.read()
    let (multiplierPerBlock_) = multiplierPerBlock.read()
    let (baseRatePerBlock_) = baseRatePerBlock.read()
    let (le) = is_le(util, kink_)
    if le != 0:
        let (res) = checked_div(util * multiplierPerBlock_, 10 ** 18 + baseRatePerBlock_)
        return (res)
    else:
        let (normalRate) = checked_div(kink_ * multiplierPerBlock_, 10 ** 18 + baseRatePerBlock_)
        let excessUtil = util - kink_
        let (jumpMultiplierPerBlock_) = jumpMultiplierPerBlock.read()
        let (res) = checked_div(excessUtil * jumpMultiplierPerBlock_, 10 ** 18 + normalRate)
        return (res)
    end
end

# @notice Calculates the current supply rate per block
# @param cash The amount of cash in the market
# @param borrows The amount of borrows in the market
# @param reserves The amount of reserves in the market
# @param reserveFactorMantissa The current reserve factor for the market
# @return The supply rate percentage per block as a mantissa (scaled by 1e18)
@view
func getSupplyRate{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        cash, borrows, reserves, reserveFactorMantissa) -> (res):
    alloc_locals
    let oneMinusReserveFactor = 10 ** 18 - reserveFactorMantissa
    let (borrowRate) = getBorrowRateInternal(cash, borrows, reserves)
    let (rateToPool) = checked_div(borrowRate * oneMinusReserveFactor, 10 ** 18)
    let (utilizationRate_) = utilizationRate(cash, borrows, reserves)
    let (res) = checked_div(utilizationRate_ * rateToPool, 10 ** 18)
    return (res)
end

# @notice Internal function to update the parameters of the interest rate model
# @param baseRatePerYear The approximate target base APR, as a mantissa (scaled by 1e18)
# @param multiplierPerYear The rate of increase in interest rate wrt utilization (scaled by 1e18)
# @param jumpMultiplierPerYear The multiplierPerBlock after hitting a specified utilization point
# @param kink_ The utilization point at which the jump multiplier is applied
func updateJumpRateModelInternal{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        baseRatePerYear, multiplierPerYear, jumpMultiplierPerYear, kink_):
    alloc_locals
    let (baseRatePerBlock_) = checked_div(baseRatePerYear, blocksPerYear)
    let (multiplierPerBlock_) = checked_div(multiplierPerYear * 10 ** 18, blocksPerYear * kink_)
    let (jumpMultiplierPerBlock_) = checked_div(jumpMultiplierPerYear, blocksPerYear)

    baseRatePerBlock.write(baseRatePerBlock_)
    multiplierPerBlock.write(multiplierPerBlock_)
    jumpMultiplierPerBlock.write(jumpMultiplierPerBlock_)
    kink.write(kink_)
    return ()
end

func checked_div{range_check_ptr}(value, div) -> (q):
    assert_not_zero(div)
    let (q, _) = unsigned_div_rem(value, div)
    return (q)
end
