// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ExampleVariables{
    // All solidity variables are initialized by default, there is no "null" or "undefined"
    // Solidity does not have float values, 
    // instead every value is an integer and a good practice is to add a decimalPoint variable into your code which defines where in the values the decimal should be

    bool public myBool;
    // Unsigned integer, which by default is uint256 and holds only positive values(from 0 to 2^256 - 1)
    uint public myUint; // NB!! Assigning default values costs extra gas
    // Holds values between 0 and 2^8 -1 aka 255. 
    // If you go over this limit then in the version before solidity 0.8.0 it automatically reverted back to 0 but now it throws an error and doesnt change the state of the uint8 during the transaction
    uint8 public muUint8;

    function setMyBool(bool _myBool) public{
        myBool = _myBool;
    }
    function setMyUint(uint _myUint) public{
        myUint = _myUint;
    }

    // integer wraparound

    // Here we try to decrement unsigned integer with the value of 0
    // In solidity versions under 0.8.0 it would go from 0 to the max value and to achieve the error devs had to use outside libraries like SafeMath
    function decrementUint() public{
        myUint--;
    }
    // In this method we can decrement the 0 to the max value
    function decrementUintUnchecked() public{
        unchecked{
            myUint--;
        }
    }

    string public myString = "Desperado OY";

    // the memory keyword is used to indicate that this value should only remain in the temporary memory
    // Storing strings on blockchain is rather expensive (also indicates infinite gas because the strings length is not set)
    function setMyString(string memory _myString) public{
        myString = _myString;
    }

    // Solidity has no string manipulation methods built in. To compare two strings we have to compare their hashes
    function compareTwoStrings(string memory _myString) public view returns (bool) {
        // The hash function requires a single byte argument so thats why we use abi.ecodePacked
        return keccak256(abi.encodePacked(myString)) == keccak256(abi.encodePacked(_myString));
    }

    // Address variable stores an ethereum blockchian account address
    address public myEthAddress;
    address public someAddress;
    
    function setMyAddress(address _myAddress) public{
        myEthAddress = _myAddress;
    }

    function getAddressBalance() public view returns(uint){
        return myEthAddress.balance;
    }

    function updateSomeAddress() public{
        // msg.sender holds the account value that called the contract
        someAddress = msg.sender;
    }

    // function types

    // pure function - A reading function that can access only its parameters (variables that are not storage variables) and other pure functions
    uint8 public myStorageVariable;
    function getAddition (uint a, uint b) public pure returns(uint){
        return a+b;
    }
    
    // view function - A reading function that can also access variables outside of the functions scope
    function getMyStorageVariable() public view returns (uint){
        return myStorageVariable;
    }

    // Writing function
    // This is a bad example because writing functions do not actually return anything to the transaction initializer.
    // returning stuff is avalable for Events
    function setMyStorageVariable(uint8 _newVar) public returns(uint){
        myStorageVariable = _newVar;
        return  _newVar;
    }

    address public testerAddress;

    // This constructor method is automatically called during deploy and is used to initialize values for example
    // In solidity this method cannot be called again nor can it be overridden
    constructor(address _someAddress){
        testerAddress == _someAddress;
    }

}