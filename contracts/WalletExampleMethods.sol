// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract WalletExampleMethods {
    mapping(uint => bool) public myMapping; // Tagastab bool vaartuse olenevalt kas uint on array sees or not
    // mapping variable'l on automaatselt getter meetod, mis kysib parameetriks mappi base type value
    mapping (address => bool) public myAddressMapping;

    mapping(uint => mapping (uint => bool)) public uintUintBoolMapping; // kas see on in essence one to many seos v?

    function setValue(uint _index) public {
        myMapping[_index] = true; // maarab ara, et parameetri arvule tuleb edaspidi tagastada true, kui see nr antakse myMapping arrayle
    }

    function setMyAddressToTrue() public {
        myAddressMapping[msg.sender] = true;
    }
    function setUintUintBoolMapping(uint _key1, uint _key2, bool _value) public {
        uintUintBoolMapping[_key1][_key2] = _value;
    }


    // panga ylesande jaoks potentsiaalselt vajalikud asjad:

    mapping(address => uint) public userBalance;

    function sendMoney() public payable {
        userBalance[msg.sender] += msg.value;
    }

    function getBalance() public view returns(uint){
        return userBalance[msg.sender];
    }

    function withdrawAllMoney(address payable _to) public {
        uint balance = userBalance[msg.sender];
        // Oluline on kasutaja balance enne ara nullida, sest labi transfer meetodi on olukordi, 
        // kus kasutaja voib seda withdraw meetodit uuest valja kutsuda ja enda kontole sedasi mitu korda raha kanda
        userBalance[msg.sender] = 0;
        _to.transfer(balance);
    }
}