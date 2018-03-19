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
    address owner;
    state itemState;
    uint transacStart;
    uint transacEnd;
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

    function getAccountNonce() internal returns (uint nonce) ;

    function getItem(bytes32 productHash) internal returns (Item) ;

    function getProductHash(uint nonce) internal returns (bytes32) ;

    function getBidder(bytes32 productHash) internal returns (address) ;

    function addBid(bytes32 productHash) internal ;

    function confirmSig(bytes32 messageHash, bytes signature) internal returns(address) ;

    function createItem(string name, uint price,  uint nonce) internal ;

    function endSale(bytes32 productHash) internal ;
    
    function listItem(string name, uint price) returns(bool listed) ;

    function bidItem(bytes32 productHash) payable returns(bool result) ;

    function completeSale(bytes32 productHash, bytes32 messageHash , bytes signature);
    
}