// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ContractOne {
    mapping (address => uint) public  addressBalances;

    function deposit() public payable{
        addressBalances[msg.sender] += msg.value;
    }
}

contract ContractTwo{
    receive() external payable { }

    function depositToContractOne(address _contractOne) public {
        ContractOne one = ContractOne(_contractOne);
        one.deposit{value:10, gas: 1000000}(/*siia tuleks meetodi parameetrid*/);
    }
}

contract ContractThree{
    receive() external payable { }

    function depositToContractOne(address _contractOne) public {
        bytes memory payload = abi.encodeWithSignature("deposit()");
        // Kui payloadi ei provideta siis see hitib contracti fallback functionit
        (bool success, /*siia tuleks return value holder*/) = _contractOne.call{value:10, gas: 1000000}(payload); 
        require(success);
    }
}