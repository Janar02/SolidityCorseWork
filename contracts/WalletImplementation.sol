// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract PersonsBankAccount{
    function GetBalance() public view returns (uint){
        return address(this).balance;
    }

    function deposit() public payable {}
}

contract WalletImplementation {
    address payable public owner;

    mapping (address => uint) public allowance;
    mapping(address => bool) public isAllowedToTakeMoney;

    mapping(address => bool) public guardians;

    mapping(address => mapping(address => bool)) guardianVotesForAddress;

    address payable newOwner;

    uint guardianVotesForOwnerChange;
    uint public constant confirmationsFromGuaridansForOwnerChange = 3;

    constructor(){
        owner = payable(msg.sender);
    }

    receive() external payable { } // Tahendab, et contracti saab igal juhul raha kanda

    function setGuardian(address _guardian, bool _isGuardian) public{
        require(msg.sender == owner, "Function caller is not the owner of the wallet");
        guardians[_guardian] = _isGuardian;
    }

    function proposeNewOwner(address payable _newOwner) public {
        require(guardians[msg.sender], "Function caller is not set as a guardian");
        require(guardianVotesForAddress[_newOwner][msg.sender] == false, "Function caller has already voted for this candidate.");
        if (newOwner != _newOwner){
            newOwner = _newOwner;
            guardianVotesForOwnerChange = 0;
        }
        guardianVotesForAddress[_newOwner][msg.sender] = true;
        guardianVotesForOwnerChange++;
        if(guardianVotesForOwnerChange >= confirmationsFromGuaridansForOwnerChange){
            owner = _newOwner;
        }
    }

    function setAllowance(address _for, uint _amount) public {
        require(msg.sender == owner, "Function caller is not the owner of the wallet");
        allowance[_for] = _amount;
        if(_amount > 0)
            isAllowedToTakeMoney[_for] = true;
        else 
            isAllowedToTakeMoney[_for] = false;
    }

    function transferWithWallet (address payable _to, uint _amount, bytes memory _payload) public returns(bytes memory){
        // require(msg.sender == owner, "Function caller is not the owner of the wallet");
        if(msg.sender != owner){ // Ylesande raames peavad saama koik autoriseeritud inimesed selle walletiga suhelda saama
            require(isAllowedToTakeMoney[msg.sender], "You are not allowed to take money from this wallet");
            require(allowance[msg.sender] >= _amount, "The amount exceeds your allowance");

            allowance[msg.sender] -= _amount;
        }
        
        //_to.transfer(_amount);
        (bool success, bytes memory returnData) = _to.call{value: _amount}(_payload);
        require(success, "Aborting, payload call was not successful");
        return returnData;
    }
}