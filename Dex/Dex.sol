// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DEX {
    struct Order {
        address trader;      // Address of the trader who created the order
        uint256 amount;      // Amount of tokens in the order
        uint256 price;       // Price per token in the order
        bool isBuyOrder;     // Flag indicating whether it's a buy order or sell order
    }

    // Balances of each trader
    mapping(address => uint256) public balances;

    // Orders placed by traders
    mapping(address => mapping(bytes32 => Order)) public orders;

    // Filled orders to prevent double-filling
    mapping(bytes32 => bool) public filledOrders;

    // Amount filled for each order
    mapping(bytes32 => uint256) public orderFills;

    // Liquidity pools of traders
    mapping(address => uint256) public liquidityPools;

    // Event emitted when an order is created
    event OrderCreated(
        bytes32 indexed orderId,
        address indexed trader,
        uint256 amount,
        uint256 price,
        bool isBuyOrder
    );

    // Event emitted when an order is filled
    event OrderFilled(
        bytes32 indexed orderId,
        address indexed trader,
        uint256 filledAmount,
        uint256 price,
        bool isBuyOrder
    );

    // Function to create a new order
    function createOrder(bytes32 orderId, uint256 amount, uint256 price, bool isBuyOrder) external {
        require(amount > 0, "Amount must be greater than zero");

        // Create the order and store it in the mapping
        orders[msg.sender][orderId] = Order({
            trader: msg.sender,
            amount: amount,
            price: price,
            isBuyOrder: isBuyOrder
        });

        // Emit the OrderCreated event
        emit OrderCreated(orderId, msg.sender, amount, price, isBuyOrder);
    }

    // Function to fill an existing order
    function fillOrder(bytes32 orderId, address trader, uint256 amount) external {
        require(!filledOrders[orderId], "Order has already been filled");

        // Retrieve the order from the mapping
        Order memory order = orders[trader][orderId];
        require(order.trader != address(0), "Order does not exist");

        // Calculate the filled amount and validate it
        uint256 filledAmount = orderFills[orderId] + amount;
        require(filledAmount <= order.amount, "Fill amount exceeds order amount");

        // Calculate the trade value
        uint256 tradeValue = amount * order.price;
        require(balances[msg.sender] >= tradeValue, "Insufficient balance");

        // Transfer tokens between the buyer and seller
        balances[msg.sender] -= tradeValue;
        balances[order.trader] += tradeValue;
        orderFills[orderId] = filledAmount;

        // Emit the OrderFilled event
        emit OrderFilled(orderId, order.trader, amount, order.price, order.isBuyOrder);

        // Mark the order as filled if fully filled
        if (filledAmount == order.amount) {
            filledOrders[orderId] = true;
        }
    }

    // Function to add tokens to the liquidity pool
    function addToLiquidityPool(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        // Increase the balances and liquidity pools of the trader
        balances[msg.sender] += amount;
        liquidityPools[msg.sender] += amount;
    }

    // Function to remove tokens from the liquidity pool
    function removeFromLiquidityPool(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(liquidityPools[msg.sender] >= amount, "Insufficient liquidity");

        // Decrease the balances and liquidity pools of the trader
        balances[msg.sender] -= amount;
        liquidityPools[msg.sender] -= amount;
    }
}
