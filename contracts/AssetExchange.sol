pragma solidity ^0.4.18;

import "./math/SafeMath.sol";
import "./AssetInterface.sol";

contract AssetExchange is assetInterface {

    using SafeMath for uint ;

    modifier isforSale {
        _;
    }

    function getAccountNonce() internal returns (uint nonce) {
        nonce = accountMap[msg.sender].AccountNonce ; 
        return nonce;
    }

    function getItem(bytes32 productHash) internal returns (Item listed) {
        return registry[productHash] ;
    }
    
    function ListItem(string Name, uint Price) returns(bool listed) {
        Item memory itemlisting;
        uint nonce = getAccountNonce() ;
        bytes32 productHash ;
        itemlisting.name = Name;
        itemlisting.price = 


    }
    
}