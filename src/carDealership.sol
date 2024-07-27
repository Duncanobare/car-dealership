// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract CarDealership {
    address payable owner;
    enum Status {
        Available,
        Sold,
        Repair
    }
    struct Car {
        string model;
        uint256 year;
        uint256 purchasePrice;
        uint256 sellPrice;
        Status status;
    }
    Car[] public cars;

    constructor() {
        owner = payable(msg.sender);
    }

    function registerCar(
        string memory _model,
        uint256 _year,
        uint256 _purchasePrice,
        uint256 _sellPrice,
        Status _status
    ) external {
        Car memory newCar = Car({
            model: _model,
            year: _year,
            purchasePrice: _purchasePrice,
            sellPrice: _sellPrice,
            status: _status
        });
        cars.push(newCar);
    }

    function updateCarStatus(uint256 carIndex, Status _status) external {
        require(
            cars[carIndex].status != Status.Sold,
            "Cannot update status of a sold car."
        );
        cars[carIndex].status = _status;
    }

    function viewCar(
        uint256 carIndex
    ) external view returns (string memory, uint256, uint256, uint256, Status) {
        Car memory car = cars[carIndex];
        return (
            car.model,
            car.year,
            car.purchasePrice,
            car.sellPrice,
            car.status
        );
    }

    function buyCar(uint256 carIndex) external payable {
        require(
            cars[carIndex].status == Status.Available,
            "Car is not available for purchase."
        );
        require(
            msg.value >= cars[carIndex].sellPrice,
            "Insufficient funds to purchase car."
        );
        owner.transfer(cars[carIndex].sellPrice);
        cars[carIndex].status = Status.Sold;
    }
}
