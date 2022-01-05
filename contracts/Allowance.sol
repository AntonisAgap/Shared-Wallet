//SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

// import OpenZeppelin Ownable smart contract for better security.
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Ownable {
    // event for logging purposes
    event AllowanceChanged(address indexed _forWho, address indexed _byWhom, uint _oldAmount, uint _newAmount);
    // mappinf the users to their allowance
    mapping(address=>uint) public allowance;

    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }

    // function to set allowance for a user only if address is the owner of the smart contract
    function setAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        Allowance
    }

    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount, "You are not the owner");
        _;
    }

    function reduceAllowance(address _who, uint _amount) internal ownerOrAllowed(_amount) {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[who] - _amount);
        allowance[_who] -= _amount;
    }
}