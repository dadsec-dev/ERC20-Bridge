// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract TokenChild is ERC20, ERC20Burnable {
    
    address bridge;

    constructor (address _bridge) ERC20("Oracle cloudChild", "OCC") {
        bridge = _bridge;
    }

    event TokenMinted(address indexed recipient, uint256 indexed amount);
    event TokenBurnt(uint256 indexed amount);
    event AccountBurntFrom(address indexed address, uint256 indexed amount);

    /**
    * @dev Only callable by account with access (gateway role)
    */

    function mint(
        address _recipient,
        uint256 _amount
        )
        public
        virtual
        onlyBridge
        {
        _mint(recipient, amount);

        emit TokenMinted(_recipient, _amount);
    }

    /**
    * @dev Only callable by account with access (gateway role)
    * @inheritdoc ERC20Burnable
    */
    function burn(
        uint256 _amount
        )
        public
        override(ERC20Burnable)
        virtual
        onlyBridge
        {
        super.burn(_amount);

        emit TokenBurnt(_amount);
    }

    /**
    * @dev Only callable by account with access (gateway role)
    * @inheritdoc ERC20Burnable
    */
    function burnFrom(
        address _account,
        uint256 _amount
        )
        public
        override(ERC20Burnable)
        virtual
        onlyBridge
        {
        super.burnFrom(_account, _amount);

        emit AccountBurntFrom(_account, _amount);
    }

    modifier onlyBridge {
      require(msg.sender == bridge, "only bridge has access to this child token function");
      _;
    }




}