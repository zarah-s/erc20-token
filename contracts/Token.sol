// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract Token {
    uint256 totalSupply;
    address immutable owner;
    string public constant name = "Pyde Pyper";
    string public constant symbol = "Pyde";
    uint8 immutable decimal;
    event Approve(address indexed by, address indexed to, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    mapping(address => uint256) balance;
    mapping(address => mapping(address => uint256)) allowance;

    constructor() {
        decimal = 12;
        totalSupply = calculateDecimal(10_000_000_000);
        owner = msg.sender;
        balance[msg.sender] = totalSupply;
    }

    function transfer(address _recipient, uint256 _amount) external {
        require(_amount > 0, "Zero values are not allowed");
        uint256 charge = calculatePercentageCharge(calculateDecimal(_amount));
        require(
            totalSupply >= calculateDecimal(_amount) + charge,
            "Insufficient balance"
        );
        if (msg.sender == owner) {
            totalSupply -= (calculateDecimal(_amount) + charge);
        }
        uint256 _userAvailableBalance = balance[_recipient];
        balance[_recipient] = _userAvailableBalance + calculateDecimal(_amount);
        balance[msg.sender] =
            balance[msg.sender] -
            calculateDecimal(_amount) -
            charge;
    }

    function transferFrom(
        address _from,
        address _receiver,
        uint256 _amount
    ) external {
        require(_from != address(0), "Invalid sender address");
        require(_receiver != address(0), "Invalid recipient address");
        require(_amount > 0, "Zero values are not allowed");
        uint256 charge = calculatePercentageCharge(calculateDecimal(_amount));
        uint256 _total = calculateDecimal(_amount) + charge;
        require(balance[_from] >= _total, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _total, "Allowance exceeded");
        balance[_from] -= _total;
        balance[_receiver] += calculateDecimal(_amount);
        allowance[_from][msg.sender] -= calculateDecimal(_amount);
        emit Transfer(msg.sender, _receiver, _amount);
    }

    function approve(address _user, uint256 _amount) external {
        require(msg.sender != address(0), "Invalid address");
        require(_amount > 0, "Zero values are not allowed");
        require(
            _user != address(0),
            "Transfers are not allowed to address zero"
        );
        allowance[msg.sender][_user] = calculateDecimal(_amount);
        emit Approve(msg.sender, _user, _amount);
    }

    function burn(uint256 _amount) external {
        require(msg.sender == owner, "Only owner has this privilege");
        require(
            totalSupply >= calculateDecimal(_amount),
            "Insufficient balance to burn"
        );
        totalSupply -= calculateDecimal(_amount);
        balance[owner] -= calculateDecimal(_amount);
    }

    function calculatePercentageCharge(
        uint256 _amount
    ) internal pure returns (uint256) {
        return (10 * _amount) / 100;
    }

    function calculateDecimal(uint256 _amount) internal view returns (uint256) {
        return _amount * 10 ** decimal;
    }
}
