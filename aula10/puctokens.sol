pragma solidity 0.4.25;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

/**
@notice ERC-20 Token for PUC 2018-11 Classes
 */
contract PUCTokens2018 {
    using SafeMath for uint256;
    
    struct Investor {
        address account;
        uint256 dividendQuota;
    }
    
    // Public variables of the token
    string public name;
    string public symbol;
    uint8 public decimals = 0;
    // 18 decimals is the strongly suggested default, avoid changing it
    uint64 public totalSupply;

    constructor() public payable {        
        Investor memory investor = Investor(msg.sender, 1 finney);
        investors[msg.sender] = investor;
        investorsAccounts.push(msg.sender);
        name = "PUC Tokens Novembro - 2018";
        symbol = "PUC2018";
        totalSupply = 1 finney;
    }
    
    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    
    mapping(address => Investor) internal investors;
    address[] public investorsAccounts;
    
    mapping (address => mapping (address => uint256)) private _allowed;
    
    modifier dividentQuotaLimit (uint256 value) {
        require(value < 1 finney, "Invalid value");
        _;
    }

    function newInvestor(address _investorAccount, uint64 _dividendQuota) public dividentQuotaLimit(_dividendQuota) returns(address) {
        require(_investorAccount != address(0), "Invalid investor account");
        
        Investor storage investorRequester = investors[msg.sender];
        
        require(investorRequester.dividendQuota>=_dividendQuota, "The Investor requester must have dividendQuota balance in order to sell her dividendQuota");
        investorRequester.dividendQuota = investorRequester.dividendQuota.sub(_dividendQuota);
        
        Investor memory investor = Investor(_investorAccount, _dividendQuota);
        investors[_investorAccount] = investor;

        investorsAccounts.push(investor.account);
        return _investorAccount;
    }

    function totalInvestors() public view returns (uint256) {
        return investorsAccounts.length;
    }

    function getSingleInvestor(address _investorID) public view returns (address investorAccount, uint256 dividendQuota) {
        require(_investorID != address(0), "Investor ID must be valid Ethereum Address");
        Investor memory investor = investors[_investorID];
        investorAccount = investor.account;
        dividendQuota = investor.dividendQuota;
        return;
    }


    /**
    * @dev Get Investor's details based on his ID within the contract
    * @param _investorID The investor's ID
    * @return investorAccount investor's Ethereum Address
    * @return dividendQuota investor's divident quota
    * @return balance investor's balance
    */
    function getSingleInvestorByID(uint _investorID) public view returns (address investorAccount, uint256 dividendQuota) {
        require(_investorID >= 0, "Investor ID must be greater than zero");
        //require(devID <= numInvestors, "Dev ID must be valid. It is greather than total Investors available");
        address investorAddress = investorsAccounts[_investorID];
        (investorAccount, dividendQuota) = getSingleInvestor(investorAddress);
        return;
    }

     
    /**
    * @dev Gets the balance of the specified address.
    * @param owner The address to query the balance of.
    * @return An uint64 representing the amount owned by the passed address.
    */
    function balanceOf(address owner) public view returns (uint256) {
        Investor memory dev = investors[owner];
        return dev.dividendQuota;
    }
    
    
    /**
    * @dev Transfer tokens from one address to another
    * @param from address The address which you want to send tokens from
    * @param to address The address which you want to transfer to
    * @param value uint256 the amount of tokens to be transferred
    */
    function transferFrom(address from, address to, uint64 value) public dividentQuotaLimit(value) returns (bool)    {
                
        Investor storage investorRequester = investors[from];
        require(investorRequester.dividendQuota > 0, "The Investor receiver must exist");
        
        require(value <= balanceOf(from), "There is no enough balance to perform this operation");
        require(value <= _allowed[from][msg.sender], "Trader is not allowed to transact to this limit");

        Investor storage investorReciever = investors[to];
        if (investorReciever.account == address(0)) {
            Investor memory dev = Investor(to, 0);
            investors[to] = dev;
            investorsAccounts.push(to);
        }
        
        investorReciever = investors[to];
        require(investorReciever.account != address(0), "The Investor receiver must exist");
        
        investorRequester.dividendQuota = investorRequester.dividendQuota.sub(value);
        investorReciever.dividendQuota = investorReciever.dividendQuota.add(value);

        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        
        emit Transfer(from, to, value);
        return true;
    }

    /**
    * @dev Transfer token for a specified address
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(address to, uint64 value) public dividentQuotaLimit(value) returns (bool) {
        require(value <= balanceOf(msg.sender), "Spender does not have enough balance");
        require(to != address(0), "Invalid new owner address");
             
        Investor storage investorRequester = investors[msg.sender];
        
        require(investorRequester.dividendQuota >= value, "The Investor requester must have dividendQuota balance in order to sell her dividendQuota");
        investorRequester.dividendQuota = investorRequester.dividendQuota.sub(value);
        
        Investor storage investorReciever = investors[to];
        if (investorReciever.account == address(0)) {
            address newAccount = newInvestor(to, value);
            if (newAccount != address(0)) {
                investorReciever.dividendQuota = investorReciever.dividendQuota.add(value);
                emit Transfer(msg.sender, to, value);
                return true;
            }  else {
                return false;
            }
        }
        
        
        return true;
    }
    
    /**
    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
    * Beware that changing an allowance with this method brings the risk that someone may use both the old
    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    * @param spender The address which will spend the funds.
    * @param value The amount of tokens to be spent.
    */
    function approve(address spender, uint64 value) public dividentQuotaLimit(value) returns (bool) {
        require(spender != address(0), "Invalid spender");
    
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
    * @dev Function to check the amount of tokens that an owner allowed to a spender.
    * @param owner address The address which owns the funds.
    * @param spender address The address which will spend the funds.
    * @return A uint64 specifying the amount of tokens still available for the spender.
    */
    function allowance(address owner, address spender) public view returns (uint256)    {
        return _allowed[owner][spender];
    }


    /**
    * @dev Increase the amount of tokens that an owner allowed to a spender.
    * approve should be called when allowed_[_spender] == 0. To increment
    * allowed value is better to use this function to avoid 2 calls (and wait until
    * the first transaction is mined)
    * @param spender The address which will spend the funds.
    * @param addedValue The amount of tokens to increase the allowance by.
    */
    function increaseAllowance(address spender, uint64 addedValue) public dividentQuotaLimit(addedValue) returns (bool)    {
        require(spender != address(0), "Invalid spender");
        
        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }
    

    /**
    * @dev Decrease the amount of tokens that an owner allowed to a spender.
    * approve should be called when allowed_[_spender] == 0. To decrement
    * allowed value is better to use this function to avoid 2 calls (and wait until
    * the first transaction is mined)
    * @param spender The address which will spend the funds.
    * @param subtractedValue The amount of tokens to decrease the allowance by.
    */
    function decreaseAllowance(address spender, uint256 subtractedValue) public dividentQuotaLimit(subtractedValue) returns (bool)    {
        require(spender != address(0), "Invalid spender");
        
        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

}
