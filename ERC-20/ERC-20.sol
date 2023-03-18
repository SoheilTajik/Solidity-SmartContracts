
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ERC20Interface {
    
    //Onlt the first three function are mandatory:
    function totalSupply() external view returns(uint);
    function balanceOf(address tokenOwner) external view returns(uint balance);
    function transfer(address to, uint tokens)external returns(bool success);

    function allowance(address tokenOwner, address spender) external view returns(uint remaining);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferForm(address from, address to, uint tokens) external returns(bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract Solium is ERC20Interface{


    string public name = "Solium";
    string public symbol = "SLM";
    uint public decimals = 0;
    uint public override totalSupply;

    address public founder;
    mapping(address => uint) public balances;

    mapping(address => mapping(address => uint)) allowed;

    constructor(){
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns(uint balance){
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens)external override returns(bool success){
        require(balances[msg.sender] >= tokens);

        balances[msg.sender] -= tokens;
        balances[to] += tokens;
        emit Transfer(msg.sender, to , tokens);

        return true;
    }

    function allowance(address tokenOwner, address spender)view public override returns(uint){
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) public override returns (bool success){
        require(balances[msg.sender] >= tokens);
        require(tokens > 0);

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;
    }

     function transferForm(address from, address to, uint tokens) external override returns(bool success){
         require(allowed[from][msg.sender] >= tokens);
         require(balances[from] >= tokens);

         balances[from] -= tokens;
         allowed[from][msg.sender] -= tokens;
         balances[to] += tokens;

         emit Transfer(from, to, tokens);

         return true;

     }

}
