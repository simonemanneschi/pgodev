pragma solidity ^0.4.18;

import "./PGO.sol";
import "./SafeMath.sol";
import "./Whitelist.sol";

/**
 * @title PGOCrowdsale
 * @dev PGOCrowdsale is a base contract for managing a token crowdsale,
 * allowing investors to purchase tokens with ether. This contract implements
 * such functionality in its most fundamental form and can be extended to provide additional
 * functionality and/or custom behavior.
 * The external interface represents the basic interface for purchasing tokens, and conform
 * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
 * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
 * the methods to add functionality. Consider using 'super' where appropiate to concatenate
 * behavior.
 */

contract PGOCrowdsale is Whitelist {
  using SafeMath for uint256;

  uint8 public constant decimals = 18; // solium-disable-line uppercase
  
  uint256 public constant ICO_SUPPLY_TOKEN = 10000  * (10 ** uint256(decimals));

  uint256 public constant RC_SUPPLY_TOKEN = 7000  * (10 ** uint256(decimals));

  //How many token units a buyer gets per ether
  uint256 public constant rate = 833 * (10 ** uint256(decimals));
  

  // The token being sold
  PGO public token;

  // Address where funds are collected
  address public wallet;

  // Amount of wei raised
  uint256 public weiRaisedICO;
  //amount of wei raised during reservation contracts
  uint256 public weiRaisedRC;
  //amount of token raised
  uint256 public tokenRaisedICO;
  //amount of token raised
  uint256 public tokenRaisedRC;
  
  /**
   * Event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

  /**
   * @param _wallet Address where collected funds will be forwarded to
   * @param _token Address of the token being sold
   */
  function PGOCrowdsale(address _wallet, PGO _token) public {
    require(_wallet != address(0));
    require(_token != address(0));

    wallet = _wallet;
    token = _token;
  }
  
  

  // -----------------------------------------
  // Crowdsale external interface
  // -----------------------------------------

  /**
   * @dev fallback function ***DO NOT OVERRIDE***
   */
  function () external payable {
    buyTokens(msg.sender);
  }

  /**
   * @dev low level token purchase ***DO NOT OVERRIDE***
   * @param _beneficiary Address performing the token purchase
   */
  function buyTokens(address _beneficiary) public payable {

    uint256 weiAmount = msg.value;
    _preValidatePurchase(_beneficiary, weiAmount);

    // calculate token amount to be created
    uint256 tokens = _getTokenAmount(weiAmount);

    // update state
    weiRaisedICO = weiRaisedICO.add(weiAmount);
    tokenRaisedICO = tokenRaisedICO.add(tokens);

    _processPurchase(_beneficiary, tokens);
    emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);

    _updatePurchasingState(_beneficiary, weiAmount);

    _forwardFunds();
    _postValidatePurchase(_beneficiary, weiAmount);
  }

  // -----------------------------------------
  // Internal interface (extensible)
  // -----------------------------------------

  /**
   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
   * @param _beneficiary Address performing the token purchase
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
    require(_beneficiary != address(0));
    require(_weiAmount != 0);
  }

  /**
   * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
   * @param _beneficiary Address performing the token purchase
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
    // optional override
  }

  /**
   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
   * @param _beneficiary Address performing the token purchase
   * @param _tokenAmount Number of tokens to be emitted
   */
  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
    token.transfer(_beneficiary, _tokenAmount);
  }

  /**
   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
   * @param _beneficiary Address receiving the tokens
   * @param _tokenAmount Number of tokens to be purchased
   */
  function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
    _deliverTokens(_beneficiary, _tokenAmount);
  }

  /**
   * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
   * @param _beneficiary Address receiving the tokens
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
    // optional override
  }

  /**
   * @dev Override to extend the way in which ether is converted to tokens.
   * @param _weiAmount Value in wei to be converted into tokens
   * @return Number of tokens that can be purchased with the specified _weiAmount
   */
  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
    uint256 _weiRate = rate / (10 ** uint256(decimals));
    return _weiAmount.mul(_weiRate);
  }

  /**
   * @dev Determines how ETH is stored/forwarded on purchases.
   */
  function _forwardFunds() internal {
    wallet.transfer(msg.value);
  }

  /**
   * @dev low level token purchase only called by reservation contracts ***DO NOT OVERRIDE***
   * @param buyer Address performing the token purchase
   * @param tokenAmount uint256 amount of token purchased
   */
  function RCPurchase(address buyer, uint256 tokenAmount) public payable onlyWhitelisted {
    require(buyer != address(0));
    require(tokenAmount != 0);
    require(msg.value !=0 );
    require(tokenRaisedRC.add(tokenAmount) < RC_SUPPLY_TOKEN);
    // set token amount from reservation contract
    uint256 tokens = tokenAmount;
    uint256 weiAmount = msg.value;
    // update state
    //weiRaisedICO = weiRaisedICO.add(weiAmount);
    // update wei raised RC
    weiRaisedRC = weiRaisedRC.add(weiAmount);
    
    tokenRaisedRC = tokenRaisedRC.add(tokenAmount);

    _processPurchase(buyer, tokens);
    emit TokenPurchase(msg.sender, buyer, weiAmount, tokens);

    _updatePurchasingState(buyer, weiAmount);

    _forwardFunds();
    _postValidatePurchase(buyer, weiAmount);
  }
}
