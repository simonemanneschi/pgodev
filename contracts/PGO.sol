pragma solidity ^0.4.4;

import "../node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
/**
 * @title RockerCoin
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `StandardToken` functions.
 */

contract PGO is StandardToken {

  string public constant name = "ParkingGo"; // solium-disable-line uppercase
  string public constant symbol = "PGO"; // solium-disable-line uppercase
  uint8 public constant decimals = 18; // solium-disable-line uppercase

  uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));

  /**
   * @dev Constructor that gives msg.sender all of existing tokens.
   */
  function PGO() public {
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
    emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
  }

}
