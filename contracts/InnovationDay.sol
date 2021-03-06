pragma solidity ^0.4.23;

library SafeMath
{
    function add(uint a, uint b) internal pure returns (uint c)
    {
        c = a + b;
        require(c >= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c)
    {
        require(b <= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c)
    {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c)
    {
        require(b > 0);
        c = a / b;
    }
}

contract InnovationDay
{
    address admin;
    string public name;
    string public symbol;
    uint256 price;
    mapping(bytes32 => bool) allowedCodes;
    mapping(address => uint) balances;
    mapping(address => mapping(bytes32 => bool)) usedCodes;

    using SafeMath for uint;

    modifier onlyAdmin()
    {
        require(msg.sender == admin);
        _;
    }

    constructor() public
    {
        admin = msg.sender;
        name = "INNOVATION";
        symbol = "INN";
        //price = 1 ether;
        emit ContractDeployed();
    }

    // administration
    function allowCode(string code) public onlyAdmin returns (bool success)
    {
        allowedCodes[sha256(code)] = true;
        return true;
    }

    function allowHashedCode(bytes32 hashedcode) public onlyAdmin returns (bool success)
    {
        allowedCodes[hashedcode] = true;
        return true;
    }

    function allowedCode(bytes32 hashedcode) public view returns (bool success)
    {
        return allowedCodes[hashedcode];
    }

    function addTokens(address tokenOwner, uint tokens) public onlyAdmin returns (bool success)
    {
        balances[tokenOwner] = balances[tokenOwner].add(tokens);
        return true;
    }

    function setPrice(uint256 _price) public onlyAdmin
    {
        // One Ether is 1000000000000000000 wei
        price = _price;
    }

    function setPriceInEther(uint256 _price) public onlyAdmin
    {
        // One Ether is 1000000000000000000 wei
        price = _price * 1 ether;
    }

    // user functions
    function buyToken() public payable returns(uint amount)
    {
        amount = msg.value.div(price);
        balances[msg.sender] = balances[msg.sender].add(amount);
        return amount;
    }

    function spendToken(bytes32 hashedcode) public returns (bool success)
    {
        require(balances[msg.sender]>0);
        require(allowedCodes[hashedcode]);
        // require(usedCodes[msg.sender][hashedcode] == false);
        usedCodes[msg.sender][hashedcode] = true;
        balances[msg.sender] = balances[msg.sender].sub(1);
        emit TokenSpent("");
        return true;
    }

    function spendToken(bytes32 hashedcode, string data) public returns (bool success)
    {
        require(balances[msg.sender]>0);
        require(allowedCodes[hashedcode]);
        // require(usedCodes[msg.sender][hashedcode] == false);
        usedCodes[msg.sender][hashedcode] = true;
        balances[msg.sender] = balances[msg.sender].sub(1);
        emit TokenSpent(data);
        return true;
    }

    function codeUsedByUser(bytes32 hashedcode) public view returns (bool used)
    {
        return usedCodes[msg.sender][hashedcode];
    }

    function balanceOf(address tokenOwner) public view returns (uint balance)
    {
        return balances[tokenOwner];
    }

    event ContractDeployed();
    event TokenSpent(string data);
}
