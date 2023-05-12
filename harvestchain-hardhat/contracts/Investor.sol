//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Investor is ReentrancyGuard{
    
    struct Investors {
        address client;
        uint amount;
        uint balance;
        string userName;
    }
    mapping (address => Investors) public investors;
    

    function getUserName (string memory _userName) public { //get user name from investor
        require(bytes(investors[msg.sender].userName).length == 0, "User already registered");
        Investors storage investor = investors[msg.sender];
        investor.userName = _userName ;
        investor.client = msg.sender;
        investor.balance = _getInvestorBalance();
        
        
    }

    function getPayment() public payable{  //get payment from investor
        Investors storage investor = investors[msg.sender];
        investor.amount = msg.value;
    }

    function sendPayment() public payable nonReentrant {
        Investors storage investor = investors[msg.sender];
        require(investor.client == msg.sender,"You are not allowed to take any token");
        uint _amount = investor.amount;
        investor.amount  = 0 ;
        (bool ok,) = msg.sender.call{value: _amount}(" ");
        require(ok);
    }

    

    function getContractBalance() public view returns(uint) {
        return address(this).balance;
    }

    function _getInvestorBalance() internal view returns(uint) {
        return address(msg.sender).balance;
    }

    
}