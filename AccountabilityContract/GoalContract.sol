// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract GoalSettingContract {
    //setup structure for our task

    struct Task {
        string description;
        bool isCompleted;
    }

    Task[] public tasks; //array of tasks
    uint256 public deposit; // the amount we deposit ang get back after we finish our tasks
    address public owner; // the owner of the contract

    event TaskCreated(uint256 taskId, string description);
    event TaskCompleted(uint256 taskId);
    event DepositWithdrawn(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function"); //check if the caller is the owner
        _;
    }

    constructor() {
        owner = msg.sender; //set the owner of the contract
    }

    function cerateTask(string memory _description) public onlyOwner {
        tasks.push(Task(_description, false)); //push the task to the array
        emit TaskCreated(tasks.length - 1, _description); //emit the event
    }

    function depositFunds() public payable onlyOwner {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        deposit += msg.value; //add the value to the deposit
    }

    function withdrawDepositSafely() public onlyOwner {
        require(deposit > 0, "Deposit must be greater than 0");
        uint256 amount = deposit; //save the deposit amount
        payable(msg.sender).transfer(amount); //transfer the amount to the owner
        deposit = 0; //set the deposit to
        emit DepositWithdrawn(amount); //emit the event
    }

    function allTaskCompleted() private view returns (bool) {
        for (uint256 i = 0; i < tasks.length; i++) {
            if (!tasks[i].isCompleted) {
                return false;
            }
        }
        return true;
    }

    function clearTasks() private onlyOwner {
        delete tasks; //delete all tasks
    }

    function completeTask(uint256 _taskId) public onlyOwner {
        require(_taskId < tasks.length, "Invalid task id");
        require(tasks[_taskId].isCompleted, "Task already completed"); //check if the task is already completed
        tasks[_taskId].isCompleted = true; //set the task to completed
        emit TaskCompleted(_taskId); //emit the event

        if (allTaskCompleted()) {
            uint256 amount = deposit; //save the deposit amount
            payable(owner).transfer(amount); //transfer the amount to the owner
            deposit = 0; //set the deposit to
            emit DepositWithdrawn(amount); //emit the event
            clearTasks(); //clear all tasks
        }
    }

    function getTaskCount() public view returns (uint256) {
        return tasks.length;
    }

    function getDeposit() public view returns (uint256) {
        return deposit;
    }

    function getTasks() public view returns (Task[] memory) {
        return tasks;
    }
}
