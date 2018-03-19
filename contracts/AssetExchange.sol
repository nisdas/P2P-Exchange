pragma solidity ^0.4.18;

import "./math/SafeMath.sol";
import "./AssetInterface.sol";
import "./ECVerify.sol";

contract AssetExchange is assetInterface {

    using SafeMath for uint ;
    using ECVerify for bytes32;

    modifier isforSale(bytes32 productHash) {
        Item memory listed;
        listed = getItem(productHash);
        require(listed.itemState == state.for_sale );
        _;
    }

    modifier isValidBuyer(bytes32 productHash) {
        Item memory listed;
        listed = getItem(productHash);
        require(listed.price <= msg.value );
        _;
    }

    modifier isBidder(bytes32 productHash) {
        require(registry[productHash].bidder == msg.sender);
        _;
    }

    function getAccountNonce() internal returns (uint nonce) {
        nonce = accountMap[msg.sender].AccountNonce ; 
        return nonce;
    }

    function getItem(bytes32 productHash) internal returns (Item) {
        return registry[productHash] ;
    }

    function getProductHash(uint nonce) internal returns (bytes32) {
        return accountMap[msg.sender].itemMap[nonce] ;
    }

    function getBidder(bytes32 productHash) internal returns (address) {
        return registry[productHash].bidder ;
    }

    function addBid(bytes32 productHash) internal {
        registry[productHash].bidder = msg.sender;
        registry[productHash].itemState = state.bid_offered;
        registry[productHash].transacStart = block.timestamp;

    }

    function confirmSig(bytes32 messageHash, bytes signature) internal returns(address) {
       var (result, bidderaddress) = messageHash.ecrecovery(signature);
       if(result) {
           return (bidderaddress);
       }

        

    }

    function createItem(string name, uint price,  uint nonce) internal {
        Item memory itemlisting; 
         bytes32 productHash = keccak256(name , price, nonce , msg.sender) ;
        itemlisting.price = price ;
        itemlisting.name = name ; 
        itemlisting.itemState = state.for_sale ;
        itemlisting.owner = msg.sender;
        registry[productHash] = itemlisting;


    }

    function endSale(bytes32 productHash) internal {
        address bidder = getBidder(productHash);
        bidderBalance[bidder] = bidderBalance[bidder].sub(registry[productHash].price);
        registry[productHash].transacEnd = block.timestamp ;
        registry[productHash].itemState = state.sale_completed;
        bidder.transfer(registry[productHash].price);

    }
    
    function listItem(string name, uint price) returns(bool listed) {
        uint nonce = getAccountNonce() ;
        createItem(name,price,nonce); 
        accountMap[msg.sender].AccountNonce = nonce.add(1);
        return true;

    }

    function bidItem(bytes32 productHash) isforSale(productHash) isValidBuyer(productHash) payable returns(bool result) {
        addBid(productHash);
        bidderBalance[msg.sender] = msg.value ;
        return true;

    }

    function completeSale(bytes32 productHash, bytes32 messageHash , bytes signature) isBidder(productHash) {
        address bidder = getBidder(productHash);
        require(bidder == confirmSig(messageHash,signature));
        endSale(productHash);
        




    }
    
}