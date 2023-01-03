pragma solidity ^0.8.17;


contract divisible {

    /*
     -  Checks whether number is divisible by 2 or 5 and greater than 15
     -  param num is the Number to check
    */

    function chek(int num) public pure returns(bool){
        if (num % 2 == 0 || num % 5 == 0 && num > 15){
            return true;
        }
        return false;
    }
}
