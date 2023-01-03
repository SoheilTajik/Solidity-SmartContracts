pragma solidity ^0.8.17;


contract EvenOdd {

    /*
     -  accepts a number and return whether the passed number is odd or even without consuming gas.
     -  param num Number to check
    */

    function Check(int num) public pure returns(string memory){
        if (num % 2 == 0){
            return "EVEN";
        }        
        return "ODD";
    }
}
