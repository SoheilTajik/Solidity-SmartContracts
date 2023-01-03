pragma solidity ^0.8.17;

contract Enrolling {
    
    struct Students {
        string name;
        uint256 studentNumber;
    }

    Students[] public student;

    mapping(uint256 => string) public enrolledStudent;

    event Enrolled(string aName, uint256 aNumber);

    /*
     -  Enrolls student with their _name and _studentNumber
    */

    function enroll(string memory _name, uint256 _studentNumber) public {
        student.push(Students(_name,_studentNumber));
        enrolledStudent[_studentNumber] = _name;
        emit Enrolled(_name,_studentNumber);
    }
}
