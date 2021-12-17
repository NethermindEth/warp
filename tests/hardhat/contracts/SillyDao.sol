pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DAO {
    enum Side {
        Yes,
        No
    }
    enum Status {
        Undecided,
        Approved,
        Rejected
    }

    struct Proposal {
        address author;
        bytes32 hash;
        uint256 createdAt;
        uint256 votesYes;
        uint256 votesNo;
        Status status;
    }

    mapping(bytes32 => Proposal) public proposals;
    mapping(address => mapping(bytes32 => bool)) public hasVoted;
    mapping(address => uint256) public shares;
    uint256 public totalShares;
    IERC20 public token;

    uint256 constant CRATE_PROP_MIN_SHARE = 1000 * 10**18;
    uint256 constant VOTING_PERIOD = 7 days;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function deposit(uint256 amount) external {
        shares[msg.sender] += amount;
        totalShares += amount;
        token.transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(uint256 amount) external {
        require(
            shares[msg.sender] >= amount,
            "Withdrawal amount larger than deposited balance"
        );
        shares[msg.sender] -= amount;
        totalShares -= amount;
        token.transfer(msg.sender, amount);
    }

    function createProposal(bytes32 propHash) external {
        require(
            shares[msg.sender] >= CRATE_PROP_MIN_SHARE,
            "You do not have enough shares to crate a proposal"
        );
        require(proposals[propHash].hash == bytes32(0));
        proposals[propHash] = Proposal(
            msg.sender,
            propHash,
            block.timestamp,
            0,
            0,
            Status.Undecided
        );
    }

    function vote(bytes32 propHash, Side side) external {
        Proposal storage proposal = proposals[propHash];
        require(
            hasVoted[msg.sender][propHash] == false,
            "You have already voted on this proposal"
        );
        require(
            proposals[propHash].hash != bytes32(0),
            "Proposal Already Exists"
        );
        require(
            block.timestamp <= proposal.createdAt + VOTING_PERIOD,
            "The voting period for this proposal has already ended"
        );
        require(
            (side == Side.Yes || side == Side.No),
            "You did not input Side.Yes or Side.No"
        );
        hasVoted[msg.sender][propHash] = true;

        if (side == Side.Yes) {
            proposal.votesYes += shares[msg.sender];
            if ((proposal.votesYes * 100) / totalShares > 50) {
                proposal.status = Status.Approved;
            }
        } else {
            proposal.votesNo += shares[msg.sender];
            if ((proposal.votesNo * 100) / totalShares > 50) {
                proposal.status = Status.Rejected;
            }
        }
    }
}
