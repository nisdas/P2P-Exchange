pragma solidity ^0.4.18;

contract assetInterface {

    enum state {for_sale,
                bid_offered,
                sale_completed
                }

    struct Item {
    string name;
    uint price;
    address bidder;
    state itemState;
    uint TransacStart;
    uint TransacEnd;
}
    struct Account {

        mapping (uint => bytes32) itemMap;
        uint AccountNonce;
    }

    mapping (address => uint) public bidderBalance;
    mapping (address => uint) public fallbackBalance;
    mapping(bytes32 => mapping (address => bool)) public CompleteSale;
    mapping (bytes32 => Item) public registry;
    mapping(address => Account ) public accountMap;
    bytes32[] public itemlist;
    event ItemListed(bytes32 productHash, address owner, string name, uint price);
    event ItemBid(bytes32 productHash, address buyer, uint price, uint TransacStart);
    event ItemSold(bytes32 productHash, address buyer, uint TransacEnd);

function ListItem(string name, uint price) returns (bool listed);

function bid(Item memory Listed, uint bidderBalance)  internal returns(Item,uint);

function completedSale(Item memory Listed, string buyerSign, bool ownerRes, uint  bidderBalance) internal returns(Item,uint);
    
}