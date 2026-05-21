// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract StorageMarket is ReentrancyGuard {
    struct Deal {
        address client;
        address provider;
        bytes32 dataRoot;
        uint256 size;
        uint256 pricePerBlock;
        uint256 endBlock;
        bool active;
    }

    IERC20 public paymentToken;
    mapping(uint256 => Deal) public deals;
    uint256 public dealCount;

    event DealCreated(uint256 indexed dealId, address indexed client, address indexed provider, bytes32 dataRoot);
    event DealTerminated(uint256 indexed dealId);

    constructor(address _token) {
        paymentToken = IERC20(_token);
    }

    function createDeal(
        address _provider,
        bytes32 _dataRoot,
        uint256 _size,
        uint256 _pricePerBlock,
        uint256 _duration
    ) external nonReentrant {
        uint256 totalCost = _pricePerBlock * _duration;
        paymentToken.transferFrom(msg.sender, address(this), totalCost);

        uint256 dealId = dealCount++;
        deals[dealId] = Deal({
            client: msg.sender,
            provider: _provider,
            dataRoot: _dataRoot,
            size: _size,
            pricePerBlock: _pricePerBlock,
            endBlock: block.number + _duration,
            active: true
        });

        emit DealCreated(dealId, msg.sender, _provider, _dataRoot);
    }

    function settleDeal(uint256 _dealId) external nonReentrant {
        Deal storage deal = deals[_dealId];
        require(block.number >= deal.endBlock, "Deal period not finished");
        require(deal.active, "Deal not active");

        deal.active = false;
        uint256 payout = (deal.endBlock - (deal.endBlock - (block.number - deal.endBlock))) * deal.pricePerBlock; // Simplified logic
        paymentToken.transfer(deal.provider, payout);

        emit DealTerminated(_dealId);
    }
}
