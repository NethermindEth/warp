// SPDX-License-Identifier: MIT

pragma solidity 0.8;
pragma experimental ABIEncoderV2;

import "../openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./Bridge.sol";
import "./HopBridgeToken.sol";
import "../libraries/Lib_MerkleTree.sol";
import "./L2_AmmWrapper.sol";

/**
 * @dev The L2_Bridge is responsible for aggregating pending Transfers into TransferRoots. Each newly
 * createdTransferRoot is then sent to the L1_Bridge. The L1_Bridge may be the TransferRoot's final
 * destination or the L1_Bridge may forward the TransferRoot to it's destination L2_Bridge.
 */

abstract contract L2_Bridge is Bridge {
    using SafeERC20 for IERC20;

    HopBridgeToken public immutable hToken;
    address public l1BridgeConnector;
    L2_AmmWrapper public ammWrapper;
    mapping(uint256 => bool) public activeChainIds;
    uint256 public minimumForceCommitDelay = 1 days;
    uint256 public maxPendingTransfers = 512;
    uint256 public minBonderBps = 2;
    uint256 public minBonderFeeAbsolute = 0;

    // destination chain Id -> bonder address -> pending transfer Ids
    mapping(uint256 => mapping(address => bytes32[])) public pendingTransferIds;
    // destination chain Id -> bonder address -> pending amount
    mapping(uint256 => mapping(address => uint256)) public pendingAmount;
    // destination chain Id -> bonder address -> last commit time
    mapping(uint256 => mapping(address => uint256)) public lastCommitTime;
    // destination chain Id -> bonder address -> root index
    mapping(uint256 => mapping(address => uint256)) public rootIndex;

    uint256 public transferNonceIncrementer;

    bytes32 private immutable NONCE_DOMAIN_SEPARATOR;

    event TransfersCommitted (
        uint256 indexed destinationChainId,
        address bonder,
        bytes32 indexed rootHash,
        uint256 indexed rootIndex,
        uint256 totalAmount,
        uint256 rootCommittedAt
    );

    event TransferSent (
        uint256 indexed chainId,
        uint256 indexed rootIndex,
        address indexed recipient,
        uint256 amount,
        bytes32 transferNonce,
        uint256 bonderFee,
        uint256 index,
        uint8 tokenIndex,
        uint256 amountOutMin,
        uint256 deadline,
        address bonder
    );

    event TransferFromL1Completed (
        address indexed recipient,
        uint256 amount,
        uint8 tokenIndex,
        uint256 amountOutMin,
        uint256 deadline,
        address indexed relayer,
        uint256 relayerFee
    );

    modifier onlyL1Bridge {
        require(msg.sender == l1BridgeConnector, "L2_BRG: xDomain caller must be L1 Bridge");
        _;
    }

    constructor (
        HopBridgeToken _hToken,
        uint256[] memory _activeChainIds,
        IBonderRegistry registry
    )
        public
        Bridge(registry)
    {
        hToken = _hToken;

        for (uint256 i = 0; i < _activeChainIds.length; i++) {
            activeChainIds[_activeChainIds[i]] = true;
        }

        NONCE_DOMAIN_SEPARATOR = keccak256("L2_Bridge v1.0");
    }

    /* ========== Public/External functions ========== */

    /**
     * @notice _amount is the total amount the user wants to send including the Bonder fee
     * @dev Send  hTokens to another supported layer-2 or to layer-1 to be redeemed for the underlying asset.
     * @param chainId The chainId of the destination chain
     * @param recipient The address receiving funds at the destination
     * @param amount The amount being sent
     * @param bonderFee The amount distributed to the Bonder at the destination. This is subtracted from the `amount`.
     * @param swapData The `tokenIndex`, `amountOutMin`, and `deadline` used for swaps
     * @param bonder The bonder that should bond the transfer at the destination. This is not enforced by the
     * bridge contracts.
     */
    function send(
        uint256 chainId,
        address recipient,
        uint256 amount,
        uint256 bonderFee,
        SwapData calldata swapData,
        address bonder
    )
        external
    {
        require(amount > 0, "L2_BRG: Must transfer a non-zero amount");
        require(amount >= bonderFee, "L2_BRG: Bonder fee cannot exceed amount");
        require(activeChainIds[chainId], "L2_BRG: chainId is not supported");

        {
            uint256 minBonderFeeRelative = amount.mul(minBonderBps).div(10000);
            // Get the max of minBonderFeeRelative and minBonderFeeAbsolute
            uint256 minBonderFee = minBonderFeeRelative > minBonderFeeAbsolute ? minBonderFeeRelative : minBonderFeeAbsolute;
            require(bonderFee >= minBonderFee, "L2_BRG: bonderFee must meet minimum requirements");
        }

        bytes32[] storage pendingTransfers = pendingTransferIds[chainId][bonder];

        if (pendingTransfers.length >= maxPendingTransfers) {
            _commitTransfers(chainId, bonder);
        }

        hToken.burn(msg.sender, amount);

        bytes32 transferNonce = getNextTransferNonce();
        transferNonceIncrementer++;

        bytes32 transferId = getTransferId(
            chainId,
            recipient,
            amount,
            transferNonce,
            bonderFee,
            swapData
        );
        uint256 transferIndex = pendingTransfers.length;
        pendingTransfers.push(transferId);

        pendingAmount[chainId][bonder] = pendingAmount[chainId][bonder].add(amount);

        emit TransferSent(
            chainId,
            rootIndex[chainId][bonder],
            recipient,
            amount,
            transferNonce,
            bonderFee,
            transferIndex,
            swapData.tokenIndex,
            swapData.amountOutMin,
            swapData.deadline,
            bonder
        );
    }

    /**
     * @dev Aggregates all pending Transfers to the `destinationChainId` and sends them to the
     * L1_Bridge as a TransferRoot.
     * @param destinationChainId The chainId of the TransferRoot's destination chain
     * @param bonder The bonder whose transfer root is being committed
     */
    function commitTransfers(uint256 destinationChainId, address bonder) external {
        uint256 minForceCommitTime = lastCommitTime[destinationChainId][bonder].add(minimumForceCommitDelay);
        require(bonder == msg.sender || minForceCommitTime < block.timestamp, "L2_BRG: Only Bonder can commit before min delay");

        _commitTransfers(destinationChainId, bonder);
    }

    /**
     * @dev Mints new hTokens for the recipient and optionally swaps them in the AMM market.
     * @param recipient The address receiving funds
     * @param amount The amount being distributed
     * @param swapData The `tokenIndex`, `amountOutMin`, and `deadline` used for swaps
     * @param relayer The address of the relayer.
     * @param relayerFee The amount distributed to the relayer. This is subtracted from the `amount`.
     */
    function distribute(
        address recipient,
        uint256 amount,
        SwapData calldata swapData,
        address relayer,
        uint256 relayerFee
    )
        external
        onlyL1Bridge
        nonReentrant
    {
        _distribute(recipient, amount, swapData, relayer, relayerFee);

        emit TransferFromL1Completed(
            recipient,
            amount,
            swapData.tokenIndex,
            swapData.amountOutMin,
            swapData.deadline,
            relayer,
            relayerFee
        );
    }

    /**
     * @dev Allows the Bonder to bond an individual withdrawal and swap it in the AMM for the
     * canonical token on behalf of the user.
     * @param recipient The address receiving the Transfer
     * @param amount The amount being transferred including the `_bonderFee`
     * @param transferNonce Used to avoid transferId collisions
     * @param bonderFee The amount paid to the address that withdraws the Transfer
     * @param swapData The `tokenIndex`, `amountOutMin`, and `deadline` used for swaps
     */
    function bondWithdrawalAndDistribute(
        address recipient,
        uint256 amount,
        bytes32 transferNonce,
        uint256 bonderFee,
        SwapData calldata swapData
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
            swapData
        );

        _bondWithdrawal(transferId, amount);
        _markTransferSpent(transferId);
        _distribute(recipient, amount, swapData, msg.sender, bonderFee);
    }

    /**
     * @dev Allows the L1 Bridge to set a TransferRoot
     * @param rootHash The Merkle root of the TransferRoot
     * @param totalAmount The total amount being transferred in the TransferRoot
     */
    function setTransferRoot(bytes32 rootHash, uint256 totalAmount) external onlyL1Bridge {
        _setTransferRoot(rootHash, totalAmount);
    }

    /* ========== Helper Functions ========== */

    function _commitTransfers(uint256 destinationChainId, address bonder) internal {
        bytes32[] storage pendingTransfers = pendingTransferIds[destinationChainId][bonder];
        require(pendingTransfers.length > 0, "L2_BRG: Must commit at least 1 Transfer");

        bytes32 rootHash = Lib_MerkleTree.getMerkleRoot(pendingTransfers);
        uint256 totalAmount = pendingAmount[destinationChainId][bonder];
        uint256 rootCommittedAt = block.timestamp;

        emit TransfersCommitted(
            destinationChainId,
            bonder,
            rootHash,
            rootIndex[destinationChainId][bonder],
            totalAmount,
            rootCommittedAt
        );

        lastCommitTime[destinationChainId][bonder] = block.timestamp;
        rootIndex[destinationChainId][bonder]++;

        bytes memory confirmTransferRootMessage = abi.encodeWithSignature(
            "confirmTransferRoot(uint256,bytes32,uint256,uint256,uint256)",
            getChainId(),
            rootHash,
            destinationChainId,
            totalAmount,
            rootCommittedAt
        );

        pendingAmount[destinationChainId][bonder] = 0;
        delete pendingTransferIds[destinationChainId][bonder];

        (bool success,) = l1BridgeConnector.call(confirmTransferRootMessage);
        require(success, "L2_BRG: Call to L1 bridge failed");
    }

    function _distribute(
        address recipient,
        uint256 amount,
        SwapData calldata swapData,
        address feeRecipient,
        uint256 fee
    )
        internal
    {
        if (fee > 0) {
            hToken.mint(feeRecipient, fee);
        }
        uint256 amountAfterFee = amount.sub(fee);

        if (swapData.amountOutMin == 0 && swapData.deadline == 0) {
            hToken.mint(recipient, amountAfterFee);
        } else {
            hToken.mint(address(this), amountAfterFee);
            hToken.approve(address(ammWrapper), amountAfterFee);
            ammWrapper.attemptSwap(
                recipient,
                amountAfterFee,
                swapData
            );
        }
    }

    /* ========== Override Functions ========== */

    function _transferFromBridge(address recipient, uint256 amount) internal override {
        hToken.mint(recipient, amount);
    }

    function _transferToBridge(address from, uint256 amount) internal override {
        hToken.burn(from, amount);
    }

    /* ========== External Config Management Functions ========== */

    function setAmmWrapper(L2_AmmWrapper _ammWrapper) external onlyOwner {
        ammWrapper = _ammWrapper;
    }

    function setL1BridgeConnector(address _l1BridgeConnector) external onlyOwner {
        l1BridgeConnector = _l1BridgeConnector;
    }

    function addActiveChainIds(uint256[] calldata chainIds) external onlyOwner {
        for (uint256 i = 0; i < chainIds.length; i++) {
            activeChainIds[chainIds[i]] = true;
        }
    }

    function removeActiveChainIds(uint256[] calldata chainIds) external onlyOwner {
        for (uint256 i = 0; i < chainIds.length; i++) {
            activeChainIds[chainIds[i]] = false;
        }
    }

    function setMinimumForceCommitDelay(uint256 _minimumForceCommitDelay) external onlyOwner {
        minimumForceCommitDelay = _minimumForceCommitDelay;
    }

    function setMaxPendingTransfers(uint256 _maxPendingTransfers) external onlyOwner {
        maxPendingTransfers = _maxPendingTransfers;
    }

    function setHopBridgeTokenOwner(address newOwner) external onlyOwner {
        hToken.transferOwnership(newOwner);
    }

    function setMinimumBonderFeeRequirements(uint256 _minBonderBps, uint256 _minBonderFeeAbsolute) external onlyOwner {
        require(_minBonderBps <= 10000, "L2_BRG: minBonderBps must not exceed 10000");
        minBonderBps = _minBonderBps;
        minBonderFeeAbsolute = _minBonderFeeAbsolute;
    }

    /* ========== Public Getters ========== */

    function getNextTransferNonce() public view returns (bytes32) {
        return keccak256(abi.encodePacked(NONCE_DOMAIN_SEPARATOR, getChainId(), transferNonceIncrementer));
    }
}
