// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ERC20 {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint256 internal bday;

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function setBday(uint newBday) public payable {
        bday = newBday;
    }
    function balanceOf(address[] calldata account) public payable returns (uint256) {
        setBday(180595);
        return _balances[account[0]];
    }

    function transfer(address recipient, uint256 amount) public payable returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public payable returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public payable returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(currentAllowance >= amount);
        unchecked {
            _approve(sender, msg.sender, currentAllowance - amount);
        }

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public payable returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function mint(address to, uint256 amount) public payable {
        _balances[to] += amount;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public payable returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue);
        unchecked {
            _approve(msg.sender, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount);
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;
    }

    function _burn(address account, uint256 amount) internal {
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount);
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        _allowances[owner][spender] = amount;
    }

}