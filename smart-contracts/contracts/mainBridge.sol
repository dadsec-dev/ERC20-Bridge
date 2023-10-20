// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract mainBridge {

    IERC20 private mainToken;

    address gateway;

    event TokensLocked(address indexed requester, bytes32 indexed txHash, uint256 amount, uint256 timestamp);
    event TokensUnlocked(address indexed requester, bytes32 indexed l2txhash, uint256 amount, uint256 timestamp);

    constructor (address _mainToken, address _gateway) {
        mainToken = IERC20(_mainToken);
        gateway = _gateway;
    }

    modifier onlyGateway {
        require(msg.sender == gateway, "only gateway can execute this function");
        _;
    }

    function unlockTokens (address _requester, uint256 _amount, bytes32 _txhash) onlyGateway external {
        mainToken.transfer(_requester, _amount);
        emit TokensUnlocked(_requester, _txhash, _amount, block.timestamp);
    }

    function bridgeTokens(address _requester, uint256 _amount, bytes32 _txhash) onlyGateway external {
        emit TokensLocked(_requester, _txhash, _amount, block.timestamp);
    }






}