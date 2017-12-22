pragma solidity ^0.4.19;

library FunctionSet {


struct Item {
    string name;
    uint price;
    address owner;
    uint AccountNonce;
    bytes32 productHash;
    string state;
    address buyer;
    uint TransacStart;
    uint TransacEnd;
}


function listItem(string name, uint price, uint nonce) internal returns(Item memory Listed) {
        nonce += 1;
        Listed.AccountNonce += nonce;
        Listed.name = name;
        Listed.price = price;
        Listed.owner = msg.sender;
        bytes32 productHash = keccak256(Listed.price, Listed.name, Listed.AccountNonce, Listed.owner, now);
        Listed.productHash = productHash;
        Listed.state = "For Sale";
        assert(keccak256(Listed.name) == keccak256(name) && Listed.price == price && Listed.owner == msg.sender && Listed.AccountNonce == nonce && keccak256(Listed.state) == keccak256("For Sale"));
        //ListItem(Listed.productHash,Listed.owner,Listed.name,Listed.price);
        return Listed;
    }

    function bid(Item memory Listed, uint bidderBalance)  internal returns(Item) {

       
      // Listed = registry(productHash);
       require(msg.value >= 0 && msg.value >= Listed.price && keccak256(Listed.state) == keccak256("For Sale"));
       bidderBalance += msg.value;
       Listed.state = "Bid Offered";
       Listed.TransacStart = now;
       Listed.buyer = msg.sender;
       return Listed;
         

    }

    function completedSale(Item memory Listed, bool buyerRes, bool ownerRes, uint  bidderBalance) internal returns(Item) {
            require(Listed.TransacStart > 0 && (msg.sender == Listed.buyer || msg.sender == Listed.owner ));
            if (msg.sender == Listed.buyer) {
                 buyerRes = true;
            }
            if (msg.sender == Listed.owner) {
                 ownerRes = true;
            }
            if (buyerRes && ownerRes ) {
                bidderBalance -= Listed.price;
                Listed.owner.transfer(Listed.price);
                Listed.state = "Sale Completed";
                Listed.TransacEnd = now;
                return Listed;


            }
    } 

}

contract Transaction {
 

    mapping (address => uint) public bidderBalance;
    mapping (address => uint) public fallbackBalance;
    mapping(bytes32 => mapping (address => bool)) CompleteSale;
    mapping (bytes32 => FunctionSet.Item) public registry;
    mapping(address => uint) public nonce;
    event ItemListed(bytes32 productHash, address owner, string name, uint price);
    event ItemBid(bytes32 productHash, address buyer, uint price, uint TransacStart);
    event ItemSold(bytes32 productHash, address buyer, uint TransacEnd);

    

    function () public payable {
        fallbackBalance[msg.sender] += msg.value;
    }

    function _listItem(string name, uint price) public returns(bytes32) {
        FunctionSet.Item memory Listed;
        Listed = FunctionSet.listItem(name,price,nonce[msg.sender]);
        registry[Listed.productHash] = Listed;
        ItemListed(Listed.productHash,Listed.owner,Listed.name,Listed.price);
        return Listed.productHash;   
    }

    function _bid(bytes32 productHash) payable public {
        FunctionSet.Item memory Listed;
        Listed = FunctionSet.bid(registry[productHash], bidderBalance[msg.sender]);
        ItemBid(Listed.productHash,Listed.buyer,Listed.price,Listed.TransacStart);


    }

    function _completedSale(bytes32 productHash) public returns(FunctionSet.Item Listed){
        Listed = registry[productHash];
        Listed = FunctionSet.completedSale(Listed,CompleteSale[productHash][Listed.owner],CompleteSale[productHash][Listed.buyer],bidderBalance[Listed.buyer]);
        if (keccak256(Listed.state) == keccak256("Sale Completed")) {
            ItemSold(Listed.productHash,Listed.buyer,Listed.TransacEnd);
        return Listed;
        }
    }


}

