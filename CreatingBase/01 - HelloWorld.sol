pragma solidity ^0.8.17;

/*
 -  Contract HelloWorld
 -  This contract implements a function that prints "Hello World!"
 -  This is the entry point in the world of smart contract development
*/

contract HelloWorld {
    
    function print() public pure returns (string memory){
        return "Hello World!";
    }
}
