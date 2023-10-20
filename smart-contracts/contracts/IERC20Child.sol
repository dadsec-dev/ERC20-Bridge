// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

///@dev erc20 interface for use on the l2 networks to bridge into
interface IERC20Child is IERC20 {

    /**
     * @notice called by bridge gateway when tokens are deposited on main chain
     * Should handle deposits by minting the required amount for the recipient
     * 
     *  @param recipient an address for whom minting is being done
     * @param amount total amount to mint
     */

    function mint(address recipient, uint256 amount) external;


  /**
   * @notice called by bridge gateway when tokens are withdrawn back to main chain
   * @dev Should burn recipient's tokens on the l2 or side chain
   *
   * @param amount total amount to burn
   */
  function burn(uint256 amount) external;

    /**
   *
   * @param account an address for whom burning is being done
   * @param amount total amount to burn
   */

  function burnFrom(address account, unit256 amount) external;
  

}