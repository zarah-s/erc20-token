// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CoitonERC20 is ERC20, Ownable {
    constructor(address owner) ERC20("COITON", "CTN") Ownable(owner) {
        _mint(owner, 100000000 * 10 ** decimals());
    }

    function mintTo(address to, uint amount) external onlyOwner {
        _mint(to, amount);
    }
}
