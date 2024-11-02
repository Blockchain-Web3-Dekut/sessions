//1. Fund contract, keep track 
//2. Widhraw ETH to the creator of the contract
//3. Set minimum conribution amount

// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract FundMe {
    address public owner;

    constructor(){
        owner = msg.sender;
    }
    //keep track of users funding this smart contract
    address[] public funders;
    mapping(address => uint256) public addressToAmount;

    function fund() public payable {
        require(msg.value >= 1e16,"Not enough ETH");
        funders.push(msg.sender);
        addressToAmount[msg.sender] += msg.value;
    }
    
    function withdraw() payable public onlyOwner{
        for(uint256 index; index < funders.length; index++){
            address funder = funders[index];
            addressToAmount[funder] = 0;
        }
        //reset funders array to 0 funders
        funders = new address[](0);

        //send funds
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed");
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call");
        _;
    }


}