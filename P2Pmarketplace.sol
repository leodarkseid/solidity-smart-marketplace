pragma solidity ^0.8.0;

contract Marketplace {
    struct Product {
        uint id;
        string name;
        uint price;
        address payable seller;
        bool purchased;
    }

    mapping(uint => Product) public products;
    uint public productsCount;

    event ProductCreated(
        uint id,
        string name,
        uint price,
        address payable seller,
        bool purchased
    );

    event ProductPurchased(
        uint id,
        string name,
        uint price,
        address payable seller,
        bool purchased
    );

    function createProduct(string memory _name, uint _price) public {
        // Increment the product count
        productsCount++;

        // Add the product to the products mapping
        products[productsCount] = Product(
            productsCount,
            _name,
            _price,
            payable(msg.sender),
            false
        );

        // Emit the ProductCreated event
        emit ProductCreated(productsCount, _name, _price, payable(msg.sender), false);
    }

    function purchaseProduct(uint _id) public payable {
        // Get the product from the products mapping
        Product memory _product = products[_id];

        // Make sure the product exists and is not already purchased
        require(_product.id > 0 && _product.id <= productsCount, "Product does not exist");
        require(!_product.purchased, "Product already purchased");
        require(msg.value >= _product.price, "Insufficient funds");

        // Transfer funds to the seller
        _product.seller.transfer(msg.value);

        // Mark the product as purchased
        _product.purchased = true;

        // Update the products mapping
        products[_id] = _product;

        // Emit the ProductPurchased event
        emit ProductPurchased(_id, _product.name, _product.price, _product.seller, true);
    }
}
