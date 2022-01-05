//SPDX-License-Identifier: MIT
 
 pragma solidity 0.8.1;

 import "./Allowance.sol";

 contract SharedWallet is Allowance {
    // events for logging purposes.
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    // withdraw money function 
    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Contract doesn't own enough money");
        if (!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

    // overriding openzeppelins function so it can't be used
    function renounceOwnership() public override onlyOwner {
        revert("can't renounceOwnership here");
    }

    // fallback function for depositing funds    
    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
 }