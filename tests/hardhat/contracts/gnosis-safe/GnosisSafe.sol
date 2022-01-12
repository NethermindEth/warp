// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.0;

import './base/ModuleManager.sol';
import './base/OwnerManager.sol';
import './base/FallbackManager.sol';
import './base/GuardManager.sol';
import './common/EtherPaymentFallback.sol';
import './common/Singleton.sol';
import './common/SignatureDecoder.sol';
import './common/SecuredTokenTransfer.sol';
import './common/StorageAccessible.sol';
import './interfaces/ISignatureValidator.sol';
import './external/GnosisSafeMath.sol';

/// @title Gnosis Safe - A multisignature wallet with support for confirmations using signed messages based on ERC191.
/// @author Stefan George - <stefan@gnosis.io>
/// @author Richard Meissner - <richard@gnosis.io>
contract GnosisSafe is
  EtherPaymentFallback,
  Singleton,
  ModuleManager,
  OwnerManager,
  SignatureDecoder,
  SecuredTokenTransfer,
  ISignatureValidatorConstants,
  FallbackManager,
  StorageAccessible,
  GuardManager
{
  using GnosisSafeMath for uint256;

  string public constant VERSION = '1.3.0';

  // keccak256(
  //     "EIP712Domain(uint256 chainId,address verifyingContract)"
  // );
  bytes32 private constant DOMAIN_SEPARATOR_TYPEHASH =
    0x47e79534a245952e8b16893a336b85a3d9ea9fa8c573f3d803afb92a79469218;

  // keccak256(
  //     "SafeTx(address to,uint256 value,bytes data,uint8 operation,uint256 safeTxGas,uint256 baseGas,uint256 gasPrice,address gasToken,address refundReceiver,uint256 nonce)"
  // );
  bytes32 private constant SAFE_TX_TYPEHASH =
    0xbb8310d486368db6bd6f849402fdd73ad53d316b5a4b2644ad6efe0f941286d8;

  uint256 public nonce;
  bytes32 private _deprecatedDomainSeparator;
  // Mapping to keep track of all message hashes that have been approved by ALL REQUIRED owners
  mapping(bytes32 => uint256) public signedMessages;
  // Mapping to keep track of all hashes (message or transaction) that have been approved by ANY owners
  mapping(address => mapping(bytes32 => uint256)) public approvedHashes;

  // This constructor ensures that this contract can only be used as a master copy for Proxy contracts
  constructor() {
    // By setting the threshold it is not possible to call setup anymore,
    // so we create a Safe with 0 owners and threshold 1.
    // This is an unusable Safe, perfect for the singleton
    threshold = 1;
  }

  /// @dev Setup function sets initial storage of contract.
  /// @param _owners List of Safe owners.
  /// @param _threshold Number of required confirmations for a Safe transaction.
  /// @param to Contract address for optional delegate call.
  /// @param data Data payload for optional delegate call.
  /// @param fallbackHandler Handler for fallback calls to this contract
  /// @param paymentToken Token that should be used for the payment (0 is ETH)
  /// @param payment Value that should be paid
  /// @param paymentReceiver Address that should receive the payment (or 0 if tx.origin)
  function setup(
    address[] calldata _owners,
    uint256 _threshold,
    address to,
    bytes calldata data,
    address fallbackHandler,
    address paymentToken,
    uint256 payment,
    address payable paymentReceiver
  ) external {
    // setupOwners checks if the Threshold is already set, therefore preventing that this method is called twice
    setupOwners(_owners, _threshold);
    if (fallbackHandler != address(0)) internalSetFallbackHandler(fallbackHandler);
    // As setupOwners can only be called if the contract has not been initialized we don't need a check for setupModules
    setupModules(to, data);

    if (payment > 0) {
      // To avoid running into issues with EIP-170 we reuse the handlePayment function (to avoid adjusting code of that has been verified we do not adjust the method itself)
      // baseGas = 0, gasPrice = 1 and gas = payment => amount = (payment + 0) * 1 = payment
      handlePayment(payment, 0, 1, paymentToken, paymentReceiver);
    }
  }

  /// @dev Allows to execute a Safe transaction confirmed by required number of owners and then pays the account that submitted the transaction.
  ///      Note: The fees are always transferred, even if the user transaction fails.
  /// @param to Destination address of Safe transaction.
  /// @param value Ether value of Safe transaction.
  /// @param data Data payload of Safe transaction.
  /// @param operation Operation type of Safe transaction.
  /// @param safeTxGas Gas that should be used for the Safe transaction.
  /// @param baseGas Gas costs that are independent of the transaction execution(e.g. base transaction fee, signature check, payment of the refund)
  /// @param gasPrice Gas price that should be used for the payment calculation.
  /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
  /// @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin).
  /// @param signatures Packed signature data ({bytes32 r}{bytes32 s}{uint8 v})
  function execTransaction(
    address to,
    uint256 value,
    bytes calldata data,
    Enum.Operation operation,
    uint256 safeTxGas,
    uint256 baseGas,
    uint256 gasPrice,
    address gasToken,
    address payable refundReceiver,
    bytes memory signatures
  ) public payable virtual returns (bool success) {
    bytes32 txHash;
    // Use scope here to limit variable lifetime and prevent `stack too deep` errors
    {
      bytes memory txHashData = encodeTransactionData(
        // Transaction info
        to,
        value,
        data,
        operation,
        safeTxGas,
        // Payment info
        baseGas,
        gasPrice,
        gasToken,
        refundReceiver,
        // Signature info
        nonce
      );
      // Increase nonce and execute transaction.
      nonce++;
      txHash = keccak256(txHashData);
      checkSignatures(txHash, txHashData, signatures);
    }
    address guard = getGuard();
    {
      if (guard != address(0)) {
        Guard(guard).checkTransaction(
          // Transaction info
          to,
          value,
          data,
          operation,
          safeTxGas,
          // Payment info
          baseGas,
          gasPrice,
          gasToken,
          refundReceiver,
          // Signature info
          signatures,
          msg.sender
        );
      }
    }
    // We require some gas to emit the events (at least 2500) after the execution and some to perform code until the execution (500)
    // We also include the 1/64 in the check that is not send along with a call to counteract potential shortings because of EIP-150
    require(gasleft() >= ((safeTxGas * 64) / 63).max(safeTxGas + 2500) + 500, 'GS010');
    // Use scope here to limit variable lifetime and prevent `stack too deep` errors
    {
      uint256 gasUsed = gasleft();
      // If the gasPrice is 0 we assume that nearly all available gas can be used (it is always more than safeTxGas)
      // We only substract 2500 (compared to the 3000 before) to ensure that the amount passed is still higher than safeTxGas
      success = execute(
        to,
        value,
        data,
        operation,
        gasPrice == 0 ? (gasleft() - 2500) : safeTxGas
      );
      gasUsed = gasUsed.sub(gasleft());
      // If no safeTxGas and no gasPrice was set (e.g. both are 0), then the internal tx is required to be successful
      // This makes it possible to use `estimateGas` without issues, as it searches for the minimum gas where the tx doesn't revert
      require(success || safeTxGas != 0 || gasPrice != 0, 'GS013');
      // We transfer the calculated tx costs to the tx.origin to avoid sending it to intermediate contracts that have made calls
      uint256 payment = 0;
      if (gasPrice > 0) {
        payment = handlePayment(gasUsed, baseGas, gasPrice, gasToken, refundReceiver);
      }
    }
    {
      if (guard != address(0)) {
        Guard(guard).checkAfterExecution(txHash, success);
      }
    }
  }

  function handlePayment(
    uint256 gasUsed,
    uint256 baseGas,
    uint256 gasPrice,
    address gasToken,
    address payable refundReceiver
  ) private returns (uint256 payment) {
    // solhint-disable-next-line avoid-tx-origin
    address payable receiver = refundReceiver == address(0)
      ? payable(tx.origin)
      : refundReceiver;
    if (gasToken == address(0)) {
      // For ETH we will only adjust the gas price to not be higher than the actual used gas price
      payment = gasUsed.add(baseGas).mul(gasPrice < tx.gasprice ? gasPrice : tx.gasprice);
      require(receiver.send(payment), 'GS011');
    } else {
      payment = gasUsed.add(baseGas).mul(gasPrice);
      require(transferToken(gasToken, receiver, payment), 'GS012');
    }
  }

  /**
   * @dev Checks whether the signature provided is valid for the provided data, hash. Will revert otherwise.
   * @param dataHash Hash of the data (could be either a message hash or transaction hash)
   * @param data That should be signed (this is passed to an external validator contract)
   * @param signatures Signature data that should be verified. Can be ECDSA signature, contract signature (EIP-1271) or approved hash.
   */
  function checkSignatures(
    bytes32 dataHash,
    bytes memory data,
    bytes memory signatures
  ) public view {
    // Load threshold to avoid multiple storage loads
    uint256 _threshold = threshold;
    // Check that a threshold is set
    require(_threshold > 0, 'GS001');
    checkNSignatures(dataHash, data, signatures, _threshold);
  }

  /**
   * @dev Checks whether the signature provided is valid for the provided data, hash. Will revert otherwise.
   * @param dataHash Hash of the data (could be either a message hash or transaction hash)
   * @param data That should be signed (this is passed to an external validator contract)
   * @param signatures Signature data that should be verified. Can be ECDSA signature, contract signature (EIP-1271) or approved hash.
   * @param requiredSignatures Amount of required valid signatures.
   */
  function checkNSignatures(
    bytes32 dataHash,
    bytes memory data,
    bytes memory signatures,
    uint256 requiredSignatures
  ) public view {
    // Check that the provided signature data is not too short
    require(signatures.length >= requiredSignatures.mul(65), 'GS020');
    // There cannot be an owner with address 0.
    address lastOwner = address(0);
    address currentOwner;
    uint8 v;
    bytes32 r;
    bytes32 s;
    uint256 i;
    for (i = 0; i < requiredSignatures; i++) {
      (v, r, s) = signatureSplit(signatures, i);
      if (v == 0) {
        // If v is 0 then it is a contract signature
        // When handling contract signatures the address of the contract is encoded into r
        currentOwner = address(uint256(r));

        // Check that signature data pointer (s) is not pointing inside the static part of the signatures bytes
        // This check is not completely accurate, since it is possible that more signatures than the threshold are send.
        // Here we only check that the pointer is not pointing inside the part that is being processed
        require(uint256(s) >= requiredSignatures.mul(65), 'GS021');

        // Check that signature data pointer (s) is in bounds (points to the length of data -> 32 bytes)
        require(uint256(s).add(32) <= signatures.length, 'GS022');

        // Check if the contract signature is in bounds: start of data is s + 32 and end is start + signature length
        uint256 contractSignatureLen;
        // solhint-disable-next-line no-inline-assembly
        assembly {
          contractSignatureLen := mload(add(add(signatures, s), 0x20))
        }
        require(
          uint256(s).add(32).add(contractSignatureLen) <= signatures.length,
          'GS023'
        );

        // Check signature
        bytes memory contractSignature;
        // solhint-disable-next-line no-inline-assembly
        assembly {
          // The signature data for contract signatures is appended to the concatenated signatures and the offset is stored in s
          contractSignature := add(add(signatures, s), 0x20)
        }
        require(
          ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) ==
            EIP1271_MAGIC_VALUE,
          'GS024'
        );
      } else if (v == 1) {
        // If v is 1 then it is an approved hash
        // When handling approved hashes the address of the approver is encoded into r
        currentOwner = address(uint256(r));
        // Hashes are automatically approved by the sender of the message or when they have been pre-approved via a separate transaction
        require(
          msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0,
          'GS025'
        );
      } else if (v > 30) {
        // If v > 30 then default va (27,28) has been adjusted for eth_sign flow
        // To support eth_sign and similar we adjust v and hash the messageHash with the Ethereum message prefix before applying ecrecover
        currentOwner = ecrecover(
          keccak256(abi.encodePacked('\x19Ethereum Signed Message:\n32', dataHash)),
          v - 4,
          r,
          s
        );
      } else {
        // Default is the ecrecover flow with the provided data hash
        // Use ecrecover with the messageHash for EOA signatures
        currentOwner = ecrecover(dataHash, v, r, s);
      }
      require(
        currentOwner > lastOwner &&
          owners[currentOwner] != address(0) &&
          currentOwner != SENTINEL_OWNERS,
        'GS026'
      );
      lastOwner = currentOwner;
    }
  }

  /// @dev Allows to estimate a Safe transaction.
  ///      This method is only meant for estimation purpose, therefore the call will always revert and encode the result in the revert data.
  ///      Since the `estimateGas` function includes refunds, call this method to get an estimated of the costs that are deducted from the safe with `execTransaction`
  /// @param to Destination address of Safe transaction.
  /// @param value Ether value of Safe transaction.
  /// @param data Data payload of Safe transaction.
  /// @param operation Operation type of Safe transaction.
  /// @return Estimate without refunds and overhead fees (base transaction and payload data gas costs).
  /// @notice Deprecated in favor of common/StorageAccessible.sol and will be removed in next version.
  function requiredTxGas(
    address to,
    uint256 value,
    bytes calldata data,
    Enum.Operation operation
  ) external returns (uint256) {
    uint256 startGas = gasleft();
    // We don't provide an error message here, as we use it to return the estimate
    require(execute(to, value, data, operation, gasleft()));
    uint256 requiredGas = startGas - gasleft();
    // Convert response to string and return via error message
    revert(string(abi.encodePacked(requiredGas)));
  }

  /**
   * @dev Marks a hash as approved. This can be used to validate a hash that is used by a signature.
   * @param hashToApprove The hash that should be marked as approved for signatures that are verified by this contract.
   */
  function approveHash(bytes32 hashToApprove) external {
    require(owners[msg.sender] != address(0), 'GS030');
    approvedHashes[msg.sender][hashToApprove] = 1;
  }

  /// @dev Returns the chain id used by this contract.
  function getChainId() public view returns (uint256) {
    uint256 id;
    // solhint-disable-next-line no-inline-assembly
    assembly {
      id := chainid()
    }
    return id;
  }

  function domainSeparator() public view returns (bytes32) {
    return keccak256(abi.encode(DOMAIN_SEPARATOR_TYPEHASH, getChainId(), this));
  }

  /// @dev Returns the bytes that are hashed to be signed by owners.
  /// @param to Destination address.
  /// @param value Ether value.
  /// @param data Data payload.
  /// @param operation Operation type.
  /// @param safeTxGas Gas that should be used for the safe transaction.
  /// @param baseGas Gas costs for that are independent of the transaction execution(e.g. base transaction fee, signature check, payment of the refund)
  /// @param gasPrice Maximum gas price that should be used for this transaction.
  /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
  /// @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin).
  /// @param _nonce Transaction nonce.
  /// @return Transaction hash bytes.
  function encodeTransactionData(
    address to,
    uint256 value,
    bytes calldata data,
    Enum.Operation operation,
    uint256 safeTxGas,
    uint256 baseGas,
    uint256 gasPrice,
    address gasToken,
    address refundReceiver,
    uint256 _nonce
  ) public view returns (bytes memory) {
    bytes32 safeTxHash = keccak256(
      abi.encode(
        SAFE_TX_TYPEHASH,
        to,
        value,
        keccak256(data),
        operation,
        safeTxGas,
        baseGas,
        gasPrice,
        gasToken,
        refundReceiver,
        _nonce
      )
    );
    return abi.encodePacked(bytes1(0x19), bytes1(0x01), domainSeparator(), safeTxHash);
  }

  /// @dev Returns hash to be signed by owners.
  /// @param to Destination address.
  /// @param value Ether value.
  /// @param data Data payload.
  /// @param operation Operation type.
  /// @param safeTxGas Fas that should be used for the safe transaction.
  /// @param baseGas Gas costs for data used to trigger the safe transaction.
  /// @param gasPrice Maximum gas price that should be used for this transaction.
  /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
  /// @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin).
  /// @param _nonce Transaction nonce.
  /// @return Transaction hash.
  function getTransactionHash(
    address to,
    uint256 value,
    bytes calldata data,
    Enum.Operation operation,
    uint256 safeTxGas,
    uint256 baseGas,
    uint256 gasPrice,
    address gasToken,
    address refundReceiver,
    uint256 _nonce
  ) public view returns (bytes32) {
    return
      keccak256(
        encodeTransactionData(
          to,
          value,
          data,
          operation,
          safeTxGas,
          baseGas,
          gasPrice,
          gasToken,
          refundReceiver,
          _nonce
        )
      );
  }
}
