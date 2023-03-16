// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CrowdFunding {
    address public admin;
    mapping (address => uint) public contributors;
    uint public numOfContributors;
    uint public minContribution;
    uint public deadline;
    uint public goal;
    uint public raisedAmount;

    event ContributeEvent(address _sender, uint _value);
    event CreateRequestEvent(string _description, address _recipient, uint _value);
    event MakePayamentEvent(address _recipient, uint _value);

    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint numOfVoters;
        mapping(address => bool) voters;
    }

    mapping(uint => Request) public requests;
    uint public numRequests;

    constructor( uint _goal, uint _deadline) {
    admin = msg.sender;
    minContribution = 100 wei;
    goal = _goal;
    deadline = block.timestamp + _deadline;
    }

    function contribute () public payable {
        require(block.timestamp < deadline , "The deadline for this Campaign has passed.");
        require(msg.value > minContribution, "The amount you sent is not enought");

        if(contributors[msg.sender] == 0){
            numOfContributors++;
        }

        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;

        emit ContributeEvent(msg.sender, msg.value);

    }

    receive() payable external{
        contribute();
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function getRefund() public {
        require (block.timestamp > deadline && raisedAmount < goal);
        require (contributors[msg.sender] > 0, "We could not find funds related to this address");

        
        /*the 3 line of code below is equal to: payable(msg.sender).transfer(contributors[msg.sender] */
        address payable recipient = payable(msg.sender);
        uint value = contributors[msg.sender];

        /* To avoid re-entrance attack value sent by contributors should be reset before transfering funds*/
        contributors[msg.sender] = 0;
        recipient.transfer(value);
    }


    /* -Spending Request: Contributors vote for specific spending request.
       - If more than 50% of the total contributors voted for that request, then admin would have the permission to spend the specific amount
       - Codes in line 14, 23, 24 are related to Spending Request Function  */


    modifier onlyAdmin(){
        require(msg.sender == admin, "Only Admin can call this function");
        _;
    }

    function createRequest(string memory _description, address payable _recipient, uint _value) public onlyAdmin{
        Request storage newRequest = requests[numRequests];
        numRequests++;

        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.numOfVoters = 0;

        emit CreateRequestEvent(_description, _recipient, _value);
    }

    function voteRequest(uint _requestNo)public {
        require(contributors[msg.sender] > 0, "You must considered to be Contributor to be able to Vote." );
        Request storage thisRequest = requests[_requestNo];

        require(thisRequest.voters[msg.sender] == false, "You have already voted");
        thisRequest.voters[msg.sender] = true;
        thisRequest.numOfVoters++;
    }

    function makePayment(uint _requestNo) public onlyAdmin {
        require(raisedAmount >= goal);
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false, "The request has been completed.");
        require(thisRequest.numOfVoters > numOfContributors / 2);

        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;

        emit MakePayamentEvent(thisRequest.recipient, thisRequest.value);
    }


}
