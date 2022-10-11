// SPDX-License-Identifier: GPL-3.0

pragma solidity ^ 0.8.7 ;

contract ERC20Mintable{
    address public owner;
    string public constant name = "ProjectToken";
    string public constant symbol = "Kryptonite";
    uint public totalSupply = 10000 ether;
    uint public remainingTokens = totalSupply;
    uint public firstMonthPrice = 0.005 ether;
    uint public secondMonthPrice = 0.01 ether;
    uint public finalPrice = 0.1 ether;
    uint public immutable time;
    uint public immutable decimals;
    uint private constant VALUE = 1000000000000000000;


event Transfer(address indexed recipient, address indexed to, uint amount);
event Allowance(address indexed from, address indexed to, uint amount);

mapping(address => uint) private balance;
mapping(address => mapping(address => uint)) public allowed;

constructor(){
        owner = msg.sender;
        time = block.timestamp;
        balance[msg.sender] = totalSupply;
        decimals = 18;}


modifier onlyOwner(){
        require(msg.sender == owner,"You Are Not The Owner");
        _;}

function buyTokens(uint _amount) public payable returns(bool){
    remainingTokens = remainingTokens - (VALUE * _amount);
    require(remainingTokens > 0,"");
    if(block.timestamp <= time + 30 days){
        require(msg.value >= firstMonthPrice * _amount);
        balance[msg.sender] += VALUE * _amount;
        return true;}
    else if(block.timestamp <= time + 60 days){
        require(msg.value >= secondMonthPrice * _amount);
        balance[msg.sender] += VALUE * _amount;
        return true;}
    else {require(msg.value >= finalPrice * _amount);
    balance[msg.sender] += VALUE * _amount;
    return true;}
}         

function withdrawMoney() public onlyOwner{
    require(address(this).balance > 0,"");
    payable(owner).transfer(address(this).balance);
}

 function transfer(address reciever, uint amount)public returns(bool){
    require(balance[msg.sender] >= VALUE * amount,"You Do Not Have Enough Tokens");
    balance[msg.sender] -= VALUE * amount;
    balance[reciever] += VALUE * amount;
    emit Transfer(msg.sender, reciever, amount);
    return true;
 }

 function mintToken(uint quantity) public onlyOwner returns(uint){
    totalSupply += quantity;
    remainingTokens += quantity;
    balance[msg.sender] += quantity;
    return totalSupply;
}

function burnToken(address user, uint amount) public onlyOwner returns(uint){
    require(balance[user] >= amount,"You Have Insufficient Tokens");
    balance[user] -= amount;
    totalSupply -= amount;
    remainingTokens -= amount;
    return totalSupply;
}          

function allowance(address _owner, address spender) public view returns(uint){
    return allowed[_owner][spender];
}

function approval(address spender, uint value) public returns(bool success){
    allowed[msg.sender][spender] = value;
    emit Allowance(msg.sender, spender, value);
    return true;
}

function TransferFrom(address from, address to, uint value) public returns(bool success){
    uint allowedTokens = allowed[from][msg.sender];
    require(balance[from] >= value && allowedTokens >= value);
    balance[from] -= value;
    balance[to] += value;
    allowed[from][msg.sender] -= value;
    emit Transfer(from, to, value);
    return true;
}

function contractBalance() public view returns(uint){
    return address(this).balance;
}

function balanceOf(address user) public view returns(uint){
    return balance[user];
}

function Owner() public view returns(address){
    return owner;
}

function RealTime() public view returns(uint){
    return block.timestamp;
}

}
 
