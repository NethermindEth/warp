// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "./Accounting.sol";
import "../libraries/Lib_MerkleTree.sol";
import "./SwapDataConsumer.sol";

/**
 * @dev Bridge extends the accounting system and encapsulates the logic that is shared by both the
 * L1 and L2 Bridges. It allows to TransferRoots to be set by parent contracts and for those
 * TransferRoots to be withdrawn against. It also allows the bonder to bond and withdraw Transfers
 * directly through `bondWithdrawal` and then settle those bonds against their TransferRoot once it
 * has been set.
 */

abstract contract Bridge is Accounting, SwapDataConsumer {
    using Lib_MerkleTree for bytes32;

    struct TransferRoot {
        uint256 total;
        uint256 amountWithdrawn;
        uint256 createdAt;
    }

    /* ========== Events ========== */

    event Withdrew(
        bytes32 indexed transferId,
        address indexed recipient,
        uint256 amount,
        bytes32 transferNonce
    );

    event WithdrawalBonded(
        bytes32 indexed transferId,
        uint256 amount,
        address bonder
    );

    event WithdrawalBondSettled(
        address indexed bonder,
        bytes32 indexed transferId,
        bytes32 indexed rootHash
    );

    event MultipleWithdrawalsSettled(
        address indexed bonder,
        bytes32 indexed rootHash,
        uint256 totalBondsSettled
    );

    event TransferRootSet(
        bytes32 indexed rootHash,
        uint256 totalAmount
    );

    /* ========== State ========== */

    mapping(bytes32 => TransferRoot) private _transferRoots;
    mapping(bytes32 => bool) private _spentTransferIds;
    mapping(address => mapping(bytes32 => uint256)) private _bondedWithdrawalAmounts;

    uint256 constant RESCUE_DELAY = 8 weeks;

    constructor(IBonderRegistry _registry) public Accounting(_registry) {}

    /* ========== Public Getters ========== */

    /**
     * @dev Get the hash that represents an individual Transfer.
     * @param chainId The id of the destination chain
     * @param recipient The address receiving the Transfer
     * @param amount The amount being transferred including the `_bonderFee`
     * @param transferNonce Used to avoid transferId collisions
     * @param bonderFee The amount paid to the address that withdraws the Transfer
     * @param swapData The `tokenIndex`, `amountOutMin`, and `deadline` used for swaps
     */
    function getTransferId(
        uint256 chainId,
        address recipient,
        uint256 amount,
        bytes32 transferNonce,
        uint256 bonderFee,
        SwapData memory swapData
    )
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(
            chainId,
            recipient,
            amount,
            transferNonce,
            bonderFee,
            swapData
        ));
    }

    /**
     * @notice getChainId can be overridden by subclasses if needed for compatibility or testing purposes.
     * @dev Get the current chainId
     * @return chainId The current chainId
     */
    function getChainId() public virtual view returns (uint256 chainId) {
        this; // Silence state mutability warning without generating any additional byte code
        assembly {
            chainId := chainid()
        }
    }

    /**
     * @dev Get the TransferRoot id for a given rootHash and totalAmount
     * @param rootHash The Merkle root of the TransferRoot
     * @param totalAmount The total of all Transfers in the TransferRoot
     * @return The calculated transferRootId
     */
    function getTransferRootId(bytes32 rootHash, uint256 totalAmount) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(rootHash, totalAmount));
    }

    /**
     * @dev Get the TransferRoot for a given rootHash and totalAmount
     * @param rootHash The Merkle root of the TransferRoot
     * @param totalAmount The total of all Transfers in the TransferRoot
     * @return The TransferRoot with the calculated transferRootId
     */
    function getTransferRoot(bytes32 rootHash, uint256 totalAmount) public view returns (TransferRoot memory) {
        return _transferRoots[getTransferRootId(rootHash, totalAmount)];
    }

    /**
     * @dev Get the amount bonded for the withdrawal of a transfer
     * @param bonder The Bonder of the withdrawal
     * @param transferId The Transfer's unique identifier
     * @return The amount bonded for a Transfer withdrawal
     */
    function getBondedWithdrawalAmount(address bonder, bytes32 transferId) external view returns (uint256) {
        return _bondedWithdrawalAmounts[bonder][transferId];
    }

    /**
     * @dev Get the spent status of a transfer ID
     * @param transferId The transfer's unique identifier
     * @return True if the transferId has been spent
     */
    function isTransferIdSpent(bytes32 transferId) external view returns (bool) {
        return _spentTransferIds[transferId];
    }

    /* ========== User/Relayer External Functions ========== */

    /**
     * @notice Can be called by anyone (recipient or relayer)
     * @dev Withdraw a Transfer from its destination bridge
     * @param recipient The address receiving the Transfer
     * @param amount The amount being transferred including the `_bonderFee`
     * @param transferNonce Used to avoid transferId collisions
     * @param bonderFee The amount paid to the address that withdraws the Transfer
     * @param swapData The `tokenIndex`, `amountOutMin`, and `deadline` used for swaps
     * @param rootHash The Merkle root of the TransferRoot
     * @param transferRootTotalAmount The total amount being transferred in a TransferRoot
     * @param transferIdTreeIndex The index of the transferId in the Merkle tree
     * @param siblings The siblings of the transferId in the Merkle tree
     * @param totalLeaves The total number of leaves in the Merkle tree
     */
    function withdraw(
        address recipient,
        uint256 amount,
        bytes32 transferNonce,
        uint256 bonderFee,
        SwapData calldata swapData,
        bytes32 rootHash,
        uint256 transferRootTotalAmount,
        uint256 transferIdTreeIndex,
        bytes32[] calldata siblings,
        uint256 totalLeaves
    )
        external
        nonReentrant
    {
        bytes32 transferId = getTransferId(
            getChainId(),
            recipient,
            amount,
            transferNonce,
            bonderFee,
            swapData
        );

        require(
            rootHash.verify(
                transferId,
                transferIdTreeIndex,
                siblings,
                totalLeaves
            )
        , "BRG: Invalid transfer proof");
        bytes32 transferRootId = getTransferRootId(rootHash, transferRootTotalAmount);
        _addToAmountWithdrawn(transferRootId, amount);
        _fulfillWithdraw(transferId, recipient, amount, uint256(0));

        emit Withdrew(transferId, recipient, amount, transferNonce);
    }

    /**
     * @dev Allows the bonder to bond individual withdrawals before their TransferRoot has been committed.
     * @param recipient The address receiving the Transfer
     * @param amount The amount being transferred including the `_bonderFee`
     * @param transferNonce Used to avoid transferId collisions
     * @param bonderFee The amount paid to the address that withdraws the Transfer
     */
    function bondWithdrawal(
        address recipient,
        uint256 amount,
        bytes32 transferNonce,
        uint256 bonderFee
    )
        external
        onlyBonder
        requirePositiveBalance
        nonReentrant
    {
        bytes32 transferId = getTransferId(
            getChainId(),
            recipient,
            amount,
            transferNonce,
            bonderFee,
            SwapData(0,0,0)
        );

        _bondWithdrawal(transferId, amount);
        _fulfillWithdraw(transferId, recipient, amount, bonderFee);
    }

    /**
     * @dev Refunds the Bonder's stake from a bonded withdrawal and counts that withdrawal against
     * its TransferRoot.
     * @param bonder The Bonder of the withdrawal
     * @param transferId The Transfer's unique identifier
     * @param rootHash The Merkle root of the TransferRoot
     * @param transferRootTotalAmount The total amount being transferred in a TransferRoot
     * @param transferIdTreeIndex The index of the transferId in the Merkle tree
     * @param siblings The siblings of the transferId in the Merkle tree
     * @param totalLeaves The total number of leaves in the Merkle tree
     */
    function settleBondedWithdrawal(
        address bonder,
        bytes32 transferId,
        bytes32 rootHash,
        uint256 transferRootTotalAmount,
        uint256 transferIdTreeIndex,
        bytes32[] calldata siblings,
        uint256 totalLeaves
    )
        external
    {
        require(
            rootHash.verify(
                transferId,
                transferIdTreeIndex,
                siblings,
                totalLeaves
            )
        , "BRG: Invalid transfer proof");
        bytes32 transferRootId = getTransferRootId(rootHash, transferRootTotalAmount);

        uint256 amount = _bondedWithdrawalAmounts[bonder][transferId];
        require(amount > 0, "L2_BRG: transferId has no bond");

        _bondedWithdrawalAmounts[bonder][transferId] = 0;
        _addToAmountWithdrawn(transferRootId, amount);
        _subDebit(bonder, amount);

        emit WithdrawalBondSettled(bonder, transferId, rootHash);
    }

    /**
     * @dev Refunds the Bonder for all withdrawals that they bonded in a TransferRoot.
     * @param bonder The address of the Bonder being refunded
     * @param transferIds All transferIds in the TransferRoot in order
     * @param totalAmount The totalAmount of the TransferRoot
     */
    function settleBondedWithdrawals(
        address bonder,
        // transferIds _must_ be calldata or it will be mutated by Lib_MerkleTree.getMerkleRoot
        bytes32[] calldata transferIds,
        uint256 totalAmount
    )
        public
    {
        uint256 totalBondsSettled = 0;
        for(uint256 i = 0; i < transferIds.length; i++) {
            uint256 transferBondAmount = _bondedWithdrawalAmounts[bonder][transferIds[i]];
            if (transferBondAmount > 0) {
                totalBondsSettled = totalBondsSettled.add(transferBondAmount);
                _bondedWithdrawalAmounts[bonder][transferIds[i]] = 0;
            }
        }

        bytes32 rootHash = Lib_MerkleTree.getMerkleRoot(transferIds);
        bytes32 transferRootId = getTransferRootId(rootHash, totalAmount);

        _addToAmountWithdrawn(transferRootId, totalBondsSettled);
        _subDebit(bonder, totalBondsSettled);

        emit MultipleWithdrawalsSettled(bonder, rootHash, totalBondsSettled);
    }

    /* ========== External TransferRoot Rescue ========== */

    /**
     * @dev Allows governance to withdraw the remaining amount from a TransferRoot after the rescue delay has passed.
     * @param rootHash the Merkle root of the TransferRoot
     * @param originalAmount The TransferRoot's recorded total
     * @param recipient The address receiving the remaining balance
     */
    function rescueTransferRoot(bytes32 rootHash, uint256 originalAmount, address recipient) external onlyOwner {
        bytes32 transferRootId = getTransferRootId(rootHash, originalAmount);
        TransferRoot memory transferRoot = getTransferRoot(rootHash, originalAmount);

        require(transferRoot.createdAt != 0, "BRG: TransferRoot not found");
        assert(transferRoot.total == originalAmount);
        uint256 rescueDelayEnd = transferRoot.createdAt.add(RESCUE_DELAY);
        require(block.timestamp >= rescueDelayEnd, "BRG: TransferRoot cannot be rescued before the Rescue Delay");

        uint256 remainingAmount = transferRoot.total.sub(transferRoot.amountWithdrawn);
        _addToAmountWithdrawn(transferRootId, remainingAmount);
        _transferFromBridge(recipient, remainingAmount);
    }

    /* ========== Internal Functions ========== */

    function _markTransferSpent(bytes32 transferId) internal {
        require(!_spentTransferIds[transferId], "BRG: The transfer has already been withdrawn");
        _spentTransferIds[transferId] = true;
    }

    function _addToAmountWithdrawn(bytes32 transferRootId, uint256 amount) internal {
        TransferRoot storage transferRoot = _transferRoots[transferRootId];
        require(transferRoot.total > 0, "BRG: Transfer root not found");

        uint256 newAmountWithdrawn = transferRoot.amountWithdrawn.add(amount);
        require(newAmountWithdrawn <= transferRoot.total, "BRG: Withdrawal exceeds TransferRoot total");

        transferRoot.amountWithdrawn = newAmountWithdrawn;
    }

    function _setTransferRoot(bytes32 rootHash, uint256 totalAmount) internal {
        bytes32 transferRootId = getTransferRootId(rootHash, totalAmount);
        require(_transferRoots[transferRootId].total == 0, "BRG: Transfer root already set");
        require(totalAmount > 0, "BRG: Cannot set TransferRoot totalAmount of 0");

        _transferRoots[transferRootId] = TransferRoot(totalAmount, 0, block.timestamp);

        emit TransferRootSet(rootHash, totalAmount);
    }

    function _bondWithdrawal(bytes32 transferId, uint256 amount) internal {
        require(_bondedWithdrawalAmounts[msg.sender][transferId] == 0, "BRG: Withdrawal has already been bonded");
        _addDebit(msg.sender, amount);
        _bondedWithdrawalAmounts[msg.sender][transferId] = amount;

        emit WithdrawalBonded(transferId, amount, msg.sender);
    }

    /* ========== Private Functions ========== */

    /// @dev Completes the Transfer, distributes the Bonder fee and marks the Transfer as spent.
    function _fulfillWithdraw(
        bytes32 transferId,
        address recipient,
        uint256 amount,
        uint256 bonderFee
    ) private {
        _markTransferSpent(transferId);
        _transferFromBridge(recipient, amount.sub(bonderFee));
        if (bonderFee > 0) {
            _transferFromBridge(msg.sender, bonderFee);
        }
    }
}
