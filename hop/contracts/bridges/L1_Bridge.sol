// SPDX-License-Identifier: MIT

pragma solidity ^0.8;
pragma experimental ABIEncoderV2;

import "../openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./Bridge.sol";
import "./L2_Bridge.sol";

/**
 * @dev L1_Bridge is responsible for the bonding and challenging of TransferRoots. All TransferRoots
 * originate in the L1_Bridge through `bondTransferRoot` and are propagated up to destination L2s.
 */

abstract contract L1_Bridge is Bridge {
    using SafeERC20 for IERC20;

    struct TransferBond {
        address bonder;
        uint256 createdAt;
        uint256 totalAmount;
        uint256 challengeStartTime;
        address challenger;
        bool challengeResolved;
    }

    /* ========== Constants ========== */

    address constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    /* ========== State ========== */

    address public immutable token;
    mapping(uint256 => mapping(bytes32 => uint256)) public transferRootCommittedAt;
    mapping(bytes32 => TransferBond) public transferBonds;
    mapping(uint256 => mapping(address => uint256)) public timeSlotToAmountBonded;
    mapping(uint256 => uint256) public chainBalance;

    /* ========== Config State ========== */

    mapping(uint256 => address) public xDomainConnectors;
    mapping(uint256 => bool) public isChainIdPaused;
    uint256 public challengePeriod = 1 days;
    uint256 public challengeResolutionPeriod = 10 days;
    uint256 public minTransferRootBondDelay = 15 minutes;
    
    uint256 public constant CHALLENGE_AMOUNT_DIVISOR = 10;
    uint256 public constant TIME_SLOT_SIZE = 4 hours;

    /* ========== Events ========== */

    event TransferSentToL2(
        uint256 indexed chainId,
        address indexed recipient,
        uint256 amount,
        uint256 tokenIndex,
        uint256 amountOutMin,
        uint256 deadline,
        address indexed relayer,
        uint256 relayerFee
    );

    event TransferRootBonded (
        bytes32 indexed root,
        uint256 amount,
        uint256 destinationChainid
    );

    event TransferRootConfirmed(
        uint256 indexed originChainId,
        uint256 indexed destinationChainId,
        bytes32 indexed rootHash,
        uint256 totalAmount
    );

    event TransferBondChallenged(
        bytes32 indexed transferRootId,
        bytes32 indexed rootHash,
        uint256 originalAmount
    );

    event ChallengeResolved(
        bytes32 indexed transferRootId,
        bytes32 indexed rootHash,
        uint256 originalAmount
    );

    /* ========== Modifiers ========== */

    modifier onlyL2Bridge(uint256 chainId) {
        require(msg.sender == xDomainConnectors[chainId], "L1_BRG: Caller must be bridge connector");
        _;
    }

    constructor (
        IBonderRegistry _registry,
        address _token
    )
        public
        Bridge(_registry)
    {
        token = _token;
    }

    /* ========== Send Functions ========== */

    /**
     * @notice `swapData` should contain all 0s when no swap is intended at the destination.
     * @notice `amount` is the total amount the user wants to send including the relayer fee
     * @dev Send tokens to a supported layer-2 to mint hToken and optionally swap the hToken in the
     * AMM at the destination.
     * @param chainId The chainId of the destination chain
     * @param recipient The address receiving funds at the destination
     * @param amount The amount being sent
     * @param swapData The `tokenIndex`, `amountOutMin`, and `deadline` used for swaps
     * @param relayer The address of the relayer at the destination.
     * @param relayerFee The amount distributed to the relayer at the destination. This is subtracted from the `amount`.
     */
    function sendToL2(
        uint256 chainId,
        address recipient,
        uint256 amount,
        SwapData calldata swapData,
        address relayer,
        uint256 relayerFee
    )
        external
        payable
    {
        address xDomainConnector = xDomainConnectors[chainId];
        require(xDomainConnector != address(0), "L1_BRG: chainId not supported");
        require(isChainIdPaused[chainId] == false, "L1_BRG: Sends to this chainId are paused");
        require(amount > 0, "L1_BRG: Must transfer a non-zero amount");
        require(amount >= relayerFee, "L1_BRG: Relayer fee cannot exceed amount");

        _transferToBridge(msg.sender, amount);

        chainBalance[chainId] = chainBalance[chainId].add(amount);

        uint256 forwardedValue;
        if (token == ETH_ADDRESS) {
            forwardedValue = msg.value.sub(amount, "L1_BRG: Value is less than amount");
        } else {
            forwardedValue = msg.value;
        }

        L2_Bridge(xDomainConnector).distribute(
            recipient,
            amount,
            swapData,
            relayer,
            relayerFee
        );

        emit TransferSentToL2(
            chainId,
            recipient,
            amount,
            swapData.tokenIndex,
            swapData.amountOutMin,
            swapData.deadline,
            relayer,
            relayerFee
        );
    }

    /* ========== TransferRoot Functions ========== */

    /**
     * @dev Setting a TransferRoot is a two step process.
     * @dev   1. The TransferRoot is bonded with `bondTransferRoot`. Withdrawals can now begin on L1
     * @dev      and recipient L2's
     * @dev   2. The TransferRoot is confirmed after `confirmTransferRoot` is called by the l2 bridge
     * @dev      where the TransferRoot originated.
     */

    /**
     * @dev Used by the Bonder to bond a TransferRoot and propagate it up to destination L2s
     * @param rootHash The Merkle root of the TransferRoot Merkle tree
     * @param destinationChainId The id of the destination chain
     * @param totalAmount The amount destined for the destination chain
     */
    function bondTransferRoot(
        bytes32 rootHash,
        uint256 destinationChainId,
        uint256 totalAmount
    )
        external
        onlyBonder
        requirePositiveBalance
    {
        _bondTransferRoot(rootHash, destinationChainId, totalAmount);
    }

    /**
     * @dev Convenience function used by the Bonder to bond a TransferRoot and immediately settle it on L1
     * @param rootHash The Merkle root of the TransferRoot Merkle tree
     * @param destinationChainId The id of the destination chain
     * @param transferIds All transferIds in the TransferRoot in order
     * @param totalAmount The amount destined for the destination chain
     */
    function bondTransferRootAndSettle(
        bytes32 rootHash,
        uint256 destinationChainId,
        // transferIds _must_ be calldata or it will be mutated by Lib_MerkleTree.getMerkleRoot
        bytes32[] calldata transferIds,
        uint256 totalAmount
    )
        external
        onlyBonder
        requirePositiveBalance
    {
        require(destinationChainId == getChainId(), "L1_BRG: bondTransferRootAndSettle is for L1 only");
        _bondTransferRoot(rootHash, destinationChainId, totalAmount);
        settleBondedWithdrawals(msg.sender, transferIds, totalAmount);
    }

    /**
     * @dev Used by an L2 bridge to confirm a TransferRoot via cross-domain message. Once a TransferRoot
     * has been confirmed, any challenge against that TransferRoot can be resolved as unsuccessful.
     * @param originChainId The id of the origin chain
     * @param rootHash The Merkle root of the TransferRoot Merkle tree
     * @param destinationChainId The id of the destination chain
     * @param totalAmount The amount destined for each destination chain
     * @param rootCommittedAt The block timestamp when the TransferRoot was committed on its origin chain
     */
    function confirmTransferRoot(
        uint256 originChainId,
        bytes32 rootHash,
        uint256 destinationChainId,
        uint256 totalAmount,
        uint256 rootCommittedAt
    )
        external
        onlyL2Bridge(originChainId)
    {
        bytes32 transferRootId = getTransferRootId(rootHash, totalAmount);
        require(transferRootCommittedAt[destinationChainId][transferRootId] == 0, "L1_BRG: TransferRoot already confirmed");
        require(rootCommittedAt > 0, "L1_BRG: rootCommittedAt must be greater than 0");
        transferRootCommittedAt[destinationChainId][transferRootId] = rootCommittedAt;
        chainBalance[originChainId] = chainBalance[originChainId].sub(totalAmount, "L1_BRG: Amount exceeds chainBalance. This indicates a layer-2 failure.");

        // If the TransferRoot was never bonded, distribute the TransferRoot.
        TransferBond storage transferBond = transferBonds[transferRootId];
        if (transferBond.createdAt == 0) {
            _distributeTransferRoot(rootHash, destinationChainId, totalAmount);
        }

        emit TransferRootConfirmed(originChainId, destinationChainId, rootHash, totalAmount);
    }

    function _distributeTransferRoot(
        bytes32 rootHash,
        uint256 chainId,
        uint256 totalAmount
    )
        internal
    {
        // Set TransferRoot on recipient Bridge
        if (chainId == getChainId()) {
            // Set L1 TransferRoot
            _setTransferRoot(rootHash, totalAmount);
        } else {
            chainBalance[chainId] = chainBalance[chainId].add(totalAmount);

            address xDomainConnector = xDomainConnectors[chainId];
            require(xDomainConnector != address(0), "L1_BRG: chainId not supported");

            // Set L2 TransferRoot
            L2_Bridge(xDomainConnector).setTransferRoot(rootHash, totalAmount);
        }
    }

    function _bondTransferRoot(
        bytes32 rootHash,
        uint256 destinationChainId,
        uint256 totalAmount
    )
        internal
    {
        bytes32 transferRootId = getTransferRootId(rootHash, totalAmount);
        require(transferRootCommittedAt[destinationChainId][transferRootId] == 0, "L1_BRG: TransferRoot has already been confirmed");
        require(transferBonds[transferRootId].createdAt == 0, "L1_BRG: TransferRoot has already been bonded");

        uint256 currentTimeSlot = getTimeSlot(block.timestamp);
        uint256 bondAmount = getBondForTransferAmount(totalAmount);
        timeSlotToAmountBonded[currentTimeSlot][msg.sender] = timeSlotToAmountBonded[currentTimeSlot][msg.sender].add(bondAmount);

        transferBonds[transferRootId] = TransferBond(
            msg.sender,
            block.timestamp,
            totalAmount,
            uint256(0),
            address(0),
            false
        );

        _distributeTransferRoot(rootHash, destinationChainId, totalAmount);

        emit TransferRootBonded(rootHash, totalAmount, destinationChainId);
    }

    /* ========== External TransferRoot Challenges ========== */

    /**
     * @dev Challenge a TransferRoot believed to be fraudulent
     * @param rootHash The Merkle root of the TransferRoot Merkle tree
     * @param originalAmount The total amount bonded for this TransferRoot
     * @param destinationChainId The id of the destination chain
     */
    function challengeTransferBond(bytes32 rootHash, uint256 originalAmount, uint256 destinationChainId) external payable {
        bytes32 transferRootId = getTransferRootId(rootHash, originalAmount);
        TransferBond storage transferBond = transferBonds[transferRootId];

        require(transferRootCommittedAt[destinationChainId][transferRootId] == 0, "L1_BRG: TransferRoot has already been confirmed");
        require(transferBond.createdAt != 0, "L1_BRG: TransferRoot has not been bonded");
        uint256 challengePeriodEnd = transferBond.createdAt.add(challengePeriod);
        require(challengePeriodEnd >= block.timestamp, "L1_BRG: TransferRoot cannot be challenged after challenge period");
        require(transferBond.challengeStartTime == 0, "L1_BRG: TransferRoot already challenged");

        transferBond.challengeStartTime = block.timestamp;
        transferBond.challenger = msg.sender;

        // Move amount from timeSlotToAmountBonded to debit
        uint256 timeSlot = getTimeSlot(transferBond.createdAt);
        uint256 bondAmount = getBondForTransferAmount(originalAmount);
        address bonder = transferBond.bonder;
        timeSlotToAmountBonded[timeSlot][bonder] = timeSlotToAmountBonded[timeSlot][bonder].sub(bondAmount);

        _addDebit(transferBond.bonder, bondAmount);

        // Get stake for challenge
        uint256 challengeStakeAmount = getChallengeAmountForTransferAmount(originalAmount);
        _transferToBridge(msg.sender, challengeStakeAmount);

        emit TransferBondChallenged(transferRootId, rootHash, originalAmount);
    }

    /**
     * @dev Resolve a challenge after the `challengeResolutionPeriod` has passed
     * @param rootHash The Merkle root of the TransferRoot Merkle tree
     * @param originalAmount The total amount originally bonded for this TransferRoot
     * @param destinationChainId The id of the destination chain
     */
    function resolveChallenge(bytes32 rootHash, uint256 originalAmount, uint256 destinationChainId) external {
        bytes32 transferRootId = getTransferRootId(rootHash, originalAmount);
        TransferBond storage transferBond = transferBonds[transferRootId];

        require(transferBond.challengeStartTime != 0, "L1_BRG: TransferRoot has not been challenged");
        require(block.timestamp > transferBond.challengeStartTime.add(challengeResolutionPeriod), "L1_BRG: Challenge period has not ended");
        require(transferBond.challengeResolved == false, "L1_BRG: TransferRoot already resolved");
        transferBond.challengeResolved = true;

        uint256 challengeStakeAmount = getChallengeAmountForTransferAmount(originalAmount);

        if (transferRootCommittedAt[destinationChainId][transferRootId] > 0) {
            // Invalid challenge

            // Credit the bonder back with the bond amount
            _subDebit(transferBond.bonder, getBondForTransferAmount(originalAmount));

            if (transferBond.createdAt > transferRootCommittedAt[destinationChainId][transferRootId].add(minTransferRootBondDelay)) {
                // Credit the bonder the challenger's stake
                _addCredit(transferBond.bonder, challengeStakeAmount);
            } else {
                // If the TransferRoot was bonded before it was committed, the challenger and Bonder
                // get their stake back. This discourages Bonders from tricking challengers into
                // challenging a valid TransferRoots that haven't yet been committed. It also ensures
                // that Bonders are not punished if a TransferRoot is bonded too soon in error.

                // Return the challenger's stake
                _addCredit(transferBond.challenger, challengeStakeAmount);
            }
        } else {
            // Valid challenge
            // Burn 25% of the challengers stake
            _transferFromBridge(address(0xdead), challengeStakeAmount.mul(1).div(4));
            // Reward challenger with the remaining 75% of their stake plus 100% of the Bonder's stake
            _addCredit(transferBond.challenger, challengeStakeAmount.mul(7).div(4));
        }

        emit ChallengeResolved(transferRootId, rootHash, originalAmount);
    }

    /* ========== Override Functions ========== */

    function _additionalDebit(address bonder) internal view override returns (uint256) {
        uint256 currentTimeSlot = getTimeSlot(block.timestamp);
        uint256 bonded = 0;

        uint256 numTimeSlots = challengePeriod / TIME_SLOT_SIZE;
        for (uint256 i = 0; i < numTimeSlots; i++) {
            bonded = bonded.add(timeSlotToAmountBonded[currentTimeSlot - i][bonder]);
        }

        return bonded;
    }

    /* ========== Override Functions ========== */

    function _transferFromBridge(address recipient, uint256 amount) internal override {
        if (token == ETH_ADDRESS) {
            (bool success, ) = recipient.call{value: amount}(new bytes(0));
            require(success, 'L1_ETH_BRG: ETH transfer failed');
        } else {
            IERC20(token).safeTransfer(recipient, amount);
        }
    }

    function _transferToBridge(address from, uint256 amount) internal override {
        if (token == ETH_ADDRESS) {
            require(msg.value >= amount, "L1_ETH_BRG: Value is less than amount");
        } else {
            IERC20(token).safeTransferFrom(from, address(this), amount);
        }
    }

    /* ========== External Config Management Setters ========== */

    function setXDomainConnector(uint256 chainId, address _xDomainConnector) external onlyOwner {
        xDomainConnectors[chainId] = _xDomainConnector;
    }

    function setChainIdDepositsPaused(uint256 chainId, bool isPaused) external onlyOwner {
        isChainIdPaused[chainId] = isPaused;
    }

    function setChallengePeriod(uint256 _challengePeriod) external onlyOwner {
        require(_challengePeriod % TIME_SLOT_SIZE == 0, "L1_BRG: challengePeriod must be divisible by TIME_SLOT_SIZE");

        challengePeriod = _challengePeriod;
    }

    function setChallengeResolutionPeriod(uint256 _challengeResolutionPeriod) external onlyOwner {
        challengeResolutionPeriod = _challengeResolutionPeriod;
    }

    function setMinTransferRootBondDelay(uint256 _minTransferRootBondDelay) external onlyOwner {
        minTransferRootBondDelay = _minTransferRootBondDelay;
    }

    /* ========== Public Getters ========== */

    function getBondForTransferAmount(uint256 amount) public pure returns (uint256) {
        // Bond covers amount plus a bounty to pay a potential challenger
        return amount.add(getChallengeAmountForTransferAmount(amount));
    }

    function getChallengeAmountForTransferAmount(uint256 amount) public pure returns (uint256) {
        // Bond covers amount plus a bounty to pay a potential challenger
        return amount.div(CHALLENGE_AMOUNT_DIVISOR);
    }

    function getTimeSlot(uint256 time) public pure returns (uint256) {
        return time / TIME_SLOT_SIZE;
    }
}
