// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Messenger{
    string private messageString;
    int256 private messageEditCounter;
    address private owner;

    constructor(){
        owner = msg.sender;
    }

    modifier OnlyOwner(){
        require(msg.sender == owner, "Only the deployer can edit the message");
        _;
    }

    function SetMessage(string memory _message) public OnlyOwner{
        messageString = _message;
        messageEditCounter++;
    }

    function ReadMessage() public view returns(string memory){
        return  messageString;
    }
    function ViewMessageEditCounter() public view returns(int256) {
        return  messageEditCounter;
    }
}