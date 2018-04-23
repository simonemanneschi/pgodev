pragma solidity ^0.4.4;

import "./StandardToken.sol";
import "./Ownable.sol";
import "./SafeMath.sol";

/**
 * @title ParkingGo
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `StandardToken` functions.
 */

contract PGO is StandardToken, Ownable {
using SafeMath for uint256;
  string public constant name = "ParkingGo"; // solium-disable-line uppercase
  string public constant symbol = "PGO"; // solium-disable-line uppercase
  uint8 public constant decimals = 18; // solium-disable-line uppercase

  uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));

  uint256 public constant ICO_SUPPLY = 17000000 * (10 ** uint256(decimals));

  //Pre-assignment token distribution
  uint256 public constant PARTNER_SUPPLY = 10000000 * (10 ** uint256(decimals));
  uint256 public constant FOUNDER_SUPPLY = 10000000 * (10 ** uint256(decimals));
  uint256 public constant ADVISOR_SUPPLY = 3000000 * (10 ** uint256(decimals));
  uint256 public constant FONDOLIQ_SUPPLY = 17000000 * (10 ** uint256(decimals));
  uint256 public constant FONDOAZ_SUPPLY = 35000000 * (10 ** uint256(decimals));
  uint256 public constant PRESALE_SUPPLY = 8000000 * (10 ** uint256(decimals));
  
  //Crowdsale token contract
  address Crowdsale;
  
  /**
   * @dev Constructor that assign presales and reserved tokens, all 
   *   ico token are assigned to msg.sender than moved to crowdsale contract.
   */
  function PGO() public {
    totalSupply_ = INITIAL_SUPPLY;
    //here all presaled token assignment
    address Partner = address(0x8929207c7c0E8A9aB480040e305CDa3925E9F338);
    address Founder = address(0x8070911d2E6A8C2aD828909c5ACf937F6220Ea27);
    address Advisor = address(0x9f7aE4C0064134D46754f727e67e73AdF4eCA986);  
    address FondoLiq = address(0xc43b22956a3aBDD4acDb1689C8201873E282CfED);
    address FondoAz = address(0xC36e878B65e54336Cc39Df50CFcbD99Ea0D195da);
    address Pre3 = address(0x955ccA7d83dFbfBEC98AA15E8332966EBC954867);

    balances[Partner] = PARTNER_SUPPLY;
    emit Transfer(0x0, Partner, PARTNER_SUPPLY);

    balances[Founder] = FOUNDER_SUPPLY;
    emit Transfer(0x0, Founder, FOUNDER_SUPPLY);

    balances[Advisor] = ADVISOR_SUPPLY;
    emit Transfer(0x0, Advisor, ADVISOR_SUPPLY);

    balances[FondoLiq] = FONDOLIQ_SUPPLY;
    emit Transfer(0x0, FondoLiq, FONDOLIQ_SUPPLY);

    balances[FondoAz] = FONDOAZ_SUPPLY;
    emit Transfer(0x0, FondoAz, FONDOAZ_SUPPLY);

    balances[Pre3] = PRESALE_SUPPLY;
    emit Transfer(0x0, Pre3, PRESALE_SUPPLY);
    
    balances[msg.sender] = ICO_SUPPLY;
    emit Transfer(0x0, msg.sender, ICO_SUPPLY);
  }

    function SetCrowdSaleAddress(address _crowdSaleContractAddress) public onlyOwner{
        Crowdsale = _crowdSaleContractAddress;
        transfer(Crowdsale,ICO_SUPPLY);
    }

 

}
