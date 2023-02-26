// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract Lotter{

  //Definnig the state variables

  address payable[] public players;
  address public manager;

  constructor(){
    manager = msg.sender;
  }

  receive() external payable{
    require(msg.value == 0.1 ether,"You need to send 0.1 Ether to enter the Lottery pool");
    players.push(payable(msg.sender));
  }

  function getBalance()public view returns(uint){
    require(msg.sender == manager, "Only the Manager has access to the acount balance");
    return address(this).balance;
  }
  
  //This has to update with Chainlink random genrator contract(https://docs.chain.link/vrf/v2/subscription/examples/get-a-random-number)
  function random() public view returns(uint){
    return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp,players.length)));
  }

  function pickWinner() public{
    require(msg.sender == manager);
    require(players.length >= 3);

    uint r = random();
    address payable winner;

    uint index = r % players.length;
    winner = players[index];
    
    winner.transfer(getBalance());
    players = new address payable[](0);//Reseting the Lottery
  }

    
}
 
