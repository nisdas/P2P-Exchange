pragma solidity ^0.4.18;

import "./math/SafeMath.sol";
import "./AssetInterface.sol";

contract AssetExchange is assetInterface {

    using SafeMath for uint ;

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

    function addBid(bytes32 productHash) internal {
        Item memory listed;
        listed = getItem(productHash);

    }

    function createItem(string name, uint price,  uint nonce) internal {
        Item memory itemlisting; 
         bytes32 productHash = keccak256(name , price, nonce , msg.sender) ;
        itemlisting.price = price ;
        itemlisting.name = name ; 
        itemlisting.itemState = state.for_sale ;
        registry[productHash] = itemlisting;


    }
    
    function listItem(string name, uint price) returns(bool listed) {
        uint nonce = getAccountNonce() ;
        createItem(name,price,nonce); 
        accountMap[msg.sender].AccountNonce = nonce.add(1);
        return true;

    }

    function bidItem(bytes32 productHash) isforSale(productHash) isValidBuyer(productHash) returns(bool result) {


    }
    
}