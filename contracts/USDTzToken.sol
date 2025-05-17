    // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract USDT {
    string public name = "Tetner USDT";
    string public symbol = "USDT";
    uint8 public decimals = 6;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address public owner;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address[5] memory recipients) {
        owner = msg.sender;

        uint256 total = 2750000000 * 10**6;
        uint256 amountPerWallet = total / recipients.length;

        for (uint i = 0; i < recipients.length; i++) {
            balanceOf[recipients[i]] = amountPerWallet;
            emit Transfer(address(0), recipients[i], amountPerWallet);
        }

        totalSupply = total;
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(balanceOf[msg.sender] >= value, "Not enough balance");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(balanceOf[from] >= value, "Not enough balance");
        require(allowance[from][msg.sender] >= value, "Allowance exceeded");
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    function mint(address to, uint256 value) public onlyOwner {
        totalSupply += value;
        balanceOf[to] += value;
        emit Transfer(address(0), to, value);
    }

    function burn(uint256 value) public {
        require(balanceOf[msg.sender] >= value, "Not enough balance");
        balanceOf[msg.sender] -= value;
        totalSupply -= value;
        emit Transfer(msg.sender, address(0), value);
    }
}
