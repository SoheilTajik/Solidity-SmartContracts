pragma solidity ^0.8.17;

/*
 -  Contract Owner
 -  This contract sets owner address and returns it on user demand
*/

contract owner {

    address private _owner;
    event settingOwner(address owner);

    function setTheOwner(address addressOwner) public {

        _owner = addressOwner;
        emit settingOwner(_owner);
    }

  

    function getTheOwner() public view returns(address){
        
        return _owner;
    }

        
}
