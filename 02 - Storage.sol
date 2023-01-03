pragma solidity ^0.8.17;

/**
 -  Contract Storage
 -  This contract simply stores a value the variable and returns it on user demand
*/

contract Storage {

    uint256 value;

    
    function storeValue(uint256 _value) public {
        value = _value;
    }

    
    function getValue() public view returns (uint256){
        return value;
    }
}
