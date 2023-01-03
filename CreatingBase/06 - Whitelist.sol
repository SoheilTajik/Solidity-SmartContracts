//SPDX-License-Identifier: MIT


pragma solidity ^0.8.17;

contract WhiteList {

    address[] private whitelisted;

    /*
     -  add address in whitelist array but only the adress interacting with it can add to list
     -  param addr address to add
    */

    function creatList(address addr) public {
        require( msg.sender == addr,"You are not the Oner");
        whitelisted.push(addr);
    }

    /*
     -  Check if an address has listed in whitelist array
    */
    
    function checkList(address listed) public view returns(bool){
        for(uint i = 0; i < whitelisted.length; i++){
            if (whitelisted[i] == listed){
                return true;
            }
            return false;
        }
    }
}
