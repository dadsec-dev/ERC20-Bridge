// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SideBridge is ReentrancyGuard {
    IERC20Child private sideToken;
    bool bridgeInitState;
    address owner;
    address gateway;

    address[] public gateways;
    address[] public owners;

    event BridgeInitialized(address childTokenAddress, uint indexed timestamp);
    event BridgeUnInitialized(address uninitializer, uint256 indexed timestamp);
    event TokensBridged(
        address indexed requester,
        bytes32 indexed mainDepositHash,
        uint amount,
        uint timestamp
    );
    event TokensReturned(
        address indexed requester,
        bytes32 indexed sideDepositHash,
        uint amount,
        uint timestamp
    );
    event GateWayUpdated(address indexed newGatway, uint256 indexed timestamp);
    event OwnerUpdated(address indexed newOwner, uint256 indexed timestamp);

    error BridgeNotInitialized();
    error NotAuthorizedGateway();
    error NotContractOwner();

    constructor(address _gateway) ReentrancyGuard() {
        gateway = _gateway;
        owner = msg.sender;

        gateways.push(gateway);
        owners.push(owner);
    }

    modifier verifyInitialization() {
        if (!bridgeInitState) {
            revert BridgeNotInitialized();
        }
        _;
    }

    modifier onlyGateway() {
        if (msg.sender != gateway) {
            revert NotAuthorizedGateway();
        }
        _;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotContractOwner();
        }
        _;
    }

    function initializeBridge(address _childTokenAddress) external onlyOwner {
        sideToken = IERC20Child(_childTokenAddress);
        bridgeInitState = true;
        emit BridgeInitialized(_childTokenAddress, block.timestamp);
    }

    function unitializeBridge() external onlyOwner {
        bridgeInitState = false;
        emit BridgeUnInitialized(msg.sender, block.timestamp);
    }

    function updateGateway(
        address _newGateWayAddress
    ) external verifyInitialization onlyOwner {
        gateway = _newGateWayAddress;
        emit GateWayUpdated(_newGateWayAddress, block.timestamp);
    }

    function updateOwner(
        address _newOwner
    ) external verifyInitialization onlyOwner {
        owner = _newOwner;
        emit OwnerUpdated(_newOwner, block.timestamp);
    }

    function bridgeTokens(
        address _requester,
        uint256 _amount,
        bytes32 _txHash
    ) external verifyInitialization onlyGateway nonReentrant {
        require(_requester != address(0), "Invalid requester");
        sideToken.mint(_requester, _amount);
        emit TokensBridged(_requester, _txHash, _amount, block.timestamp);
    }

    function returnTokens(
        address _requester,
        uint _amount,
        bytes32 _txHash
    ) external verifyInitialization onlyGateway {
        sideToken.burn(_amount);
        emit TokensReturned(_requester, _txHash, _amount, block.timestamp);
    }
}
