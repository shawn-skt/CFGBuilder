pragma solidity 0.4.24;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b; //alicia 2
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
    * account.
    */
    constructor(address _owner) public {
        owner = _owner;
    }

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param newOwner The address to transfer ownership to.
    */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

}


contract Whitelist is Ownable {
    mapping(address => bool) internal investorMap;

    /**
    * event for investor approval logging
    * @param investor approved investor
    */
    event Approved(address indexed investor);

    /**
    * event for investor disapproval logging
    * @param investor disapproved investor
    */
    event Disapproved(address indexed investor);

    constructor(address _owner) 
        public 
        Ownable(_owner) 
    {
        
    }

    /** @param _investor the address of investor to be checked
      * @return true if investor is approved
      */
    function isInvestorApproved(address _investor) external view returns (bool) {
        require(_investor != address(0));
        return investorMap[_investor];
    }

    /** @dev approve an investor
      * @param toApprove investor to be approved
      */
    function approveInvestor(address toApprove) external onlyOwner {
        investorMap[toApprove] = true;
        emit Approved(toApprove);
    }

    /** @dev approve investors in bulk
      * @param toApprove array of investors to be approved
      */
    function approveInvestorsInBulk(address[] toApprove) external onlyOwner {
        for (uint i = 0; i < toApprove.length; i++) {
            investorMap[toApprove[i]] = true;
            emit Approved(toApprove[i]);
        }
    }

    /** @dev disapprove an investor
      * @param toDisapprove investor to be disapproved
      */
    function disapproveInvestor(address toDisapprove) external onlyOwner {
        delete investorMap[toDisapprove];
        emit Disapproved(toDisapprove);
    }

    /** @dev disapprove investors in bulk
      * @param toDisapprove array of investors to be disapproved
      */
    function disapproveInvestorsInBulk(address[] toDisapprove) external onlyOwner {
        for (uint i = 0; i < toDisapprove.length; i++) {
            delete investorMap[toDisapprove[i]];
            emit Disapproved(toDisapprove[i]);
        }
    }
}


/**
 * @title Validator
 * @dev The Validator contract has a validator address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Validator {
    address public validator;

    /**
    * event for validator address update logging
    * @param previousOwner address of the old validator
    * @param newValidator address of the new validator
    */
    event NewValidatorSet(address indexed previousOwner, address indexed newValidator);

    /**
    * @dev The Validator constructor sets the original `validator` of the contract to the sender
    * account.
    */
    constructor() public {
        validator = msg.sender;
    }

    /**
    * @dev Throws if called by any account other than the validator.
    */
    modifier onlyValidator() {
        require(msg.sender == validator);
        _;
    }

    /**
    * @dev Allows the current validator to transfer control of the contract to a newValidator.
    * @param newValidator The address to become next validator.
    */
    function setNewValidator(address newValidator) public onlyValidator {
        require(newValidator != address(0));
        emit NewValidatorSet(validator, newValidator);
        validator = newValidator;
    }
}


/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  uint256 totalSupply_;

  /**
  * @dev total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

}


/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}


/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
 */
contract MintableToken is StandardToken, Ownable {
    event Mint(address indexed to, uint256 amount);
    event MintFinished();

    bool public mintingFinished = false;


    modifier canMint() {
        require(!mintingFinished);
        _;
    }

    constructor(address _owner) 
        public 
        Ownable(_owner) 
    {

    }

    /**
    * @dev Function to mint tokens
    * @param _to The address that will receive the minted tokens.
    * @param _amount The amount of tokens to mint.
    * @return A boolean that indicates if the operation was successful.
    */
    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
        return true;
    }

    /**
    * @dev Function to stop minting new tokens.
    * @return True if the operation was successful.
    */
    function finishMinting() onlyOwner canMint public returns (bool) {
        mintingFinished = true;
        emit MintFinished();
        return true;
    }
}


contract DetailedERC20 {
  string public name;
  string public symbol;
  uint8 public decimals;

  constructor(string _name, string _symbol, uint8 _decimals) public {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
  }
}


/** @title Compliant Token */
contract CompliantToken is Validator, DetailedERC20, MintableToken {
    Whitelist public whiteListingContract;

    struct TransactionStruct {
        address from;
        address to;
        uint256 value;
        uint256 fee;
        address spender;
    }

    mapping (uint => TransactionStruct) public pendingTransactions;
    mapping (address => mapping (address => uint256)) public pendingApprovalAmount;
    uint256 public currentNonce = 0;
    uint256 public transferFee;
    address public feeRecipient;

    modifier checkIsInvestorApproved(address _account) {
        require(whiteListingContract.isInvestorApproved(_account));
        _;
    }

    modifier checkIsAddressValid(address _account) {
        require(_account != address(0));
        _;
    }

    modifier checkIsValueValid(uint256 _value) {
        require(_value > 0);
        _;
    }

    /**
    * event for rejected transfer logging
    * @param from address from which tokens have to be transferred
    * @param to address to tokens have to be transferred
    * @param value number of tokens
    * @param nonce request recorded at this particular nonce
    * @param reason reason for rejection
    */
    event TransferRejected(
        address indexed from,
        address indexed to,
        uint256 value,
        uint256 indexed nonce,
        uint256 reason
    );

    /**
    * event for transfer tokens logging
    * @param from address from which tokens have to be transferred
    * @param to address to tokens have to be transferred
    * @param value number of tokens
    * @param fee fee in tokens
    */
    event TransferWithFee(
        address indexed from,
        address indexed to,
        uint256 value,
        uint256 fee
    );

    /**
    * event for transfer/transferFrom request logging
    * @param from address from which tokens have to be transferred
    * @param to address to tokens have to be transferred
    * @param value number of tokens
    * @param fee fee in tokens
    * @param spender The address which will spend the tokens
    */
    event RecordedPendingTransaction(
        address indexed from,
        address indexed to,
        uint256 value,
        uint256 fee,
        address indexed spender
    );

    /**
    * event for whitelist contract update logging
    * @param _whiteListingContract address of the new whitelist contract
    */
    event WhiteListingContractSet(address indexed _whiteListingContract);

    /**
    * event for fee update logging
    * @param previousFee previous fee
    * @param newFee new fee
    */
    event FeeSet(uint256 indexed previousFee, uint256 indexed newFee);

    /**
    * event for fee recipient update logging
    * @param previousRecipient address of the old fee recipient
    * @param newRecipient address of the new fee recipient
    */
    event FeeRecipientSet(address indexed previousRecipient, address indexed newRecipient);

    /** @dev Constructor
      * @param _owner Token contract owner
      * @param _name Token name
      * @param _symbol Token symbol
      * @param _decimals number of decimals in the token(usually 18)
      * @param whitelistAddress Ethereum address of the whitelist contract
      * @param recipient Ethereum address of the fee recipient
      * @param fee token fee for approving a transfer
      */
    constructor(
        address _owner,
        string _name, 
        string _symbol, 
        uint8 _decimals,
        address whitelistAddress,
        address recipient,
        uint256 fee
    )
        public
        MintableToken(_owner)
        DetailedERC20(_name, _symbol, _decimals)
        Validator()
    {
        setWhitelistContract(whitelistAddress);
        setFeeRecipient(recipient);
        setFee(fee);
    }

    /** @dev Updates whitelist contract address
      * @param whitelistAddress New whitelist contract address
      */
    function setWhitelistContract(address whitelistAddress)
        public
        onlyValidator
        checkIsAddressValid(whitelistAddress)
    {
        whiteListingContract = Whitelist(whitelistAddress);
        emit WhiteListingContractSet(whiteListingContract);
    }

    /** @dev Updates token fee for approving a transfer
      * @param fee New token fee
      */
    function setFee(uint256 fee)
        public
        onlyValidator
    {
        emit FeeSet(transferFee, fee);
        transferFee = fee;
    }

    /** @dev Updates fee recipient address
      * @param recipient New whitelist contract address
      */
    function setFeeRecipient(address recipient)
        public
        onlyValidator
        checkIsAddressValid(recipient)
    {
        emit FeeRecipientSet(feeRecipient, recipient);
        feeRecipient = recipient;
    }

    /** @dev Updates token name
      * @param _name New token name
      */
    function updateName(string _name) public onlyOwner {
        require(bytes(_name).length != 0);
        name = _name;
    }

    /** @dev Updates token symbol
      * @param _symbol New token name
      */
    function updateSymbol(string _symbol) public onlyOwner {
        require(bytes(_symbol).length != 0);
        symbol = _symbol;
    }

    /** @dev transfer request
      * @param _to address to which the tokens have to be transferred
      * @param _value amount of tokens to be transferred
      */
    function transfer(address _to, uint256 _value)
        public
        checkIsInvestorApproved(msg.sender)
        checkIsInvestorApproved(_to)
        checkIsValueValid(_value)
        returns (bool)
    {
        uint256 pendingAmount = pendingApprovalAmount[msg.sender][address(0)];

        if (msg.sender == feeRecipient) {
            require(_value.add(pendingAmount) <= balances[msg.sender]);
            pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value);
        } else {
            require(_value.add(pendingAmount).add(transferFee) <= balances[msg.sender]);
            pendingApprovalAmount[msg.sender][address(0)] = pendingAmount.add(_value).add(transferFee);
        }

        pendingTransactions[currentNonce] = TransactionStruct(
            msg.sender,
            _to,
            _value,
            transferFee,
            address(0)
        );

        emit RecordedPendingTransaction(msg.sender, _to, _value, transferFee, address(0));
        currentNonce++;

        return true;
    }

    /** @dev transferFrom request
      * @param _from address from which the tokens have to be transferred
      * @param _to address to which the tokens have to be transferred
      * @param _value amount of tokens to be transferred
      */
    function transferFrom(address _from, address _to, uint256 _value)
        public 
        checkIsInvestorApproved(_from)
        checkIsInvestorApproved(_to)
        checkIsValueValid(_value)
        returns (bool)
    {
        uint256 allowedTransferAmount = allowed[_from][msg.sender];
        uint256 pendingAmount = pendingApprovalAmount[_from][msg.sender];
        
        if (_from == feeRecipient) {
            require(_value.add(pendingAmount) <= balances[_from]);
            require(_value.add(pendingAmount) <= allowedTransferAmount);
            pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value);
        } else {
            require(_value.add(pendingAmount).add(transferFee) <= balances[_from]);
            require(_value.add(pendingAmount).add(transferFee) <= allowedTransferAmount);
            pendingApprovalAmount[_from][msg.sender] = pendingAmount.add(_value).add(transferFee);
        }

        pendingTransactions[currentNonce] = TransactionStruct(
            _from,
            _to,
            _value,
            transferFee,
            msg.sender
        );

        emit RecordedPendingTransaction(_from, _to, _value, transferFee, msg.sender);
        currentNonce++;

        return true;
    }

    /** @dev approve transfer/transferFrom request
      * @param nonce request recorded at this particular nonce
      */
    function approveTransfer(uint256 nonce)
        external 
        onlyValidator 
        checkIsInvestorApproved(pendingTransactions[nonce].from)
        checkIsInvestorApproved(pendingTransactions[nonce].to)
        checkIsValueValid(pendingTransactions[nonce].value)
        returns (bool)
    {   
        address from = pendingTransactions[nonce].from;
        address spender = pendingTransactions[nonce].spender;
        address to = pendingTransactions[nonce].to;
        uint256 value = pendingTransactions[nonce].value;
        uint256 allowedTransferAmount = allowed[from][spender];
        uint256 pendingAmount = pendingApprovalAmount[from][spender];
        uint256 fee = pendingTransactions[nonce].fee;
        uint256 balanceFrom = balances[from];
        uint256 balanceTo = balances[to];

        delete pendingTransactions[nonce];

        if (from == feeRecipient) {
            fee = 0;
            balanceFrom = balanceFrom.sub(value);
            balanceTo = balanceTo.add(value);

            if (spender != address(0)) {
                allowedTransferAmount = allowedTransferAmount.sub(value);
            } 
            pendingAmount = pendingAmount.sub(value);

        } else {
            balanceFrom = balanceFrom.sub(value.add(fee));
            balanceTo = balanceTo.add(value);
            balances[feeRecipient] = balances[feeRecipient].add(fee);

            if (spender != address(0)) {
                allowedTransferAmount = allowedTransferAmount.sub(value).sub(fee);
            }
            pendingAmount = pendingAmount.sub(value).sub(fee);
        }

        emit TransferWithFee(
            from,
            to,
            value,
            fee
        );

        emit Transfer(
            from,
            to,
            value
        );
        
        balances[from] = balanceFrom;
        balances[to] = balanceTo;
        allowed[from][spender] = allowedTransferAmount;
        pendingApprovalAmount[from][spender] = pendingAmount;
        return true;
    }

    /** @dev reject transfer/transferFrom request
      * @param nonce request recorded at this particular nonce
      * @param reason reason for rejection
      */
    function rejectTransfer(uint256 nonce, uint256 reason)
        external 
        onlyValidator
        checkIsAddressValid(pendingTransactions[nonce].from)
    {        
        address from = pendingTransactions[nonce].from;
        address spender = pendingTransactions[nonce].spender;

        if (from == feeRecipient) {
            pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
                .sub(pendingTransactions[nonce].value);
        } else {
            pendingApprovalAmount[from][spender] = pendingApprovalAmount[from][spender]
                .sub(pendingTransactions[nonce].value).sub(pendingTransactions[nonce].fee);
        }
        
        emit TransferRejected(
            from,
            pendingTransactions[nonce].to,
            pendingTransactions[nonce].value,
            nonce,
            reason
        );
        
        delete pendingTransactions[nonce];
    }
}