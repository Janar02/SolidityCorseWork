// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// Deploy guide
// First deploy Wallet contract. Click the payContract method
// Click the payment button and copy the address of that contract.

// Now scroll back up and deploy the paymentreceived contract but paste the contract address into the At Address field

contract Wallet {
    PaymentReceived public payment;

    function payContract() public payable {
        payment = new PaymentReceived(msg.sender, msg.value);
    }

}

contract PaymentReceived{
    address public from;
    uint public amount;

    constructor(address _from, uint _amount){
        from = _from;
        amount =_amount;
    }
}

// Wallet 2 is going to showcase how the same functionality can be achieved through structs

contract Wallet2 {
    // Structs help keep gas costs lower as no new contracts need to be deployed on the chain
    struct PaymnetReceivedStruct {
        address from;
        uint amount;
    }

    PaymnetReceivedStruct public payment;

    function payContract() public payable {
        payment = PaymnetReceivedStruct(msg.sender, msg.value);
        // Second variant
        // payment.from = msg.sender;
        // payment.amount = msg.value;
    }
}

// How to combine structs with mapping

contract MappingStructExample{
    
    struct Transaction {
        uint amount;
        uint timestamp;
    }

    struct Balance{
        uint totalBalance;
        uint countDeposits;
        mapping (uint => Transaction) deposits;
        uint countWithdrawals;
        mapping(uint => Transaction) withdrawals;
    }

    mapping(address => Balance) public balances;
    
    function depositMoney() public payable {
        balances[msg.sender].totalBalance += msg.value;
        
        Transaction memory deposit = Transaction(msg.value,block.timestamp);
        balances[msg.sender].deposits[balances[msg.sender].countDeposits] = deposit;
        balances[msg.sender].countDeposits++;
    }

    function withdrawMoney(address payable _to, uint _amount) public {
        balances[msg.sender].totalBalance -= _amount;
        
        Transaction memory withdrawal = Transaction(_amount,block.timestamp);
        balances[msg.sender].withdrawals[balances[msg.sender].countWithdrawals] = withdrawal;
        balances[msg.sender].countWithdrawals++;

        _to.transfer(_amount);
    }
}