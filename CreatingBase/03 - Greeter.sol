pragma solidity ^0.8.17;

/*
 -  Contract Greeter
 -  This contract sets greeting as a message string and returns it on user demand
*/

contract Greeter {

    string private greeting;

   
    function setMessage(string memory message) public {
        greeting = message;
    }


    function getGreeting() public view returns (string memory){
        return greeting;
    }
}
