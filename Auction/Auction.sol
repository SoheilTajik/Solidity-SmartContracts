// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract Auction {
    address payable public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash;
    
    enum State {Started, Running, Ended, Canceled}  //Enums Do Not need " ; "
    State public auctionState; 

    uint public highestBindingBid;
    address payable public highestBidder;

    mapping(address => uint) public bids;

    uint bidIncremenet;

    constructor(){
        owner = payable(msg.sender);
        auctionState = State.Running;
        startBlock = block.number;
        endBlock = startBlock +40320;
        ipfsHash = "";
        bidIncremenet = 100; // in Wei
    }

    modifier onlyOwner(){
        require(msg.sender ==  owner);
        _;
    }

    modifier notOwner(){
        require(msg.sender != owner);
        _;
    }

    modifier afterStart(){
        require(block.number >= startBlock);
        _;
    }

    modifier beforeEnd(){
        require(block.number <= endBlock);
        _;
    }

    function min(uint a, uint b) pure internal returns(uint){
        if(a <= b){
            return a;
        }else {
            return b;
        }
    }
    
    function cancelAuction() public onlyOwner{
        auctionState = State.Canceled;
    }
    
    function placeBid() public payable notOwner afterStart beforeEnd {
        require(auctionState == State.Running);
        require(msg.value >= 100);

        uint currentBid = bids[msg.sender] + msg.value;
        require(currentBid > highestBindingBid); 

        bids[msg.sender] = currentBid;

        if(currentBid <= bids[highestBidder]){
            highestBindingBid = min(currentBid + bidIncremenet, bids[highestBidder]);
        }else {
            highestBindingBid = min(currentBid, bids[highestBidder] + bidIncremenet);
            highestBidder = payable(msg.sender);
        }
    }   

    function finalizFunction() public {
        require(auctionState == State.Canceled || block.number > endBlock);
        require(msg.sender == owner || bids[msg.sender] > 0);

        address payable recipient;
        uint value;

        if(auctionState == State.Canceled){ //auction was canceled
            recipient =payable(msg.sender);
            value = bids[msg.sender];
        }else {
            if(msg.sender ==owner){ // this is the owner
                recipient = owner;
                value = highestBindingBid;
            }else{// this is a bidder
                if(msg.sender ==highestBidder){
                    recipient = highestBidder;
                    value = bids[highestBidder] = highestBindingBid;
                }else { //This is neither the owner nor the highestBidder
                    recipient = payable(msg.sender);
                    value = bids[msg.sender];
                }
            }
        }

        //resetting the bids of the recipient to zero
        bids[recipient] = 0;
        recipient.transfer(value);
    }
}

