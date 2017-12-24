pragma solidity ^0.4.19;

//Library containing all the relevant functions
library FunctionSet {

/* The item struct consists of the different properties of the Item that is to be listed.

The AccountNonce is added to the item struct so as to allow any user to list items with the same name and price on the platform,
without resulting in those item's productHash being the same.

The productHash is the unique identifier for that item, and is pretty much the key property for that struct. It is the basis of identification 
for that item throughout the whole platform.


*/
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

/*
This function Lists the item on the blockchain, the name and price is inputted by the user which is used to
generate the resultant productHash. All the other relevant properties are written into the struct instance, so that
they can be pushed onto and be permanently stored on the blockchain. 
*/
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
    
        return Listed;
    }

/*
This function allows another user to bid an item of their choice and deposit the value of that item to the contract. A bidder balance mapping is used to keep track 
of how much a bidder has transferred into the contract. The item's status is then updated on the blockchain.
*/

    function bid(Item memory Listed, uint bidderBalance)  internal returns(Item,uint) {

       require(msg.value >= 0 && msg.value >= Listed.price && keccak256(Listed.state) == keccak256("For Sale") && msg.sender != Listed.owner);
       bidderBalance += msg.value;
       Listed.state = "Bid Offered";
       Listed.TransacStart = now;
       Listed.buyer = msg.sender;
       return (Listed, bidderBalance);
         

    }
/*
This function is called by the buyer of the item to signal that he has received the item , and the seller of the item that he/she has delivered the item
to the buyer. Once both of them call this function, this transaction is marked as complete and the item is regarded as sold. The seller of the item 
then has the resulting amount transferred to him.
*/

    function completedSale(Item memory Listed, bool buyerRes, bool ownerRes, uint  bidderBalance) internal returns(Item,uint) {
            require(Listed.TransacStart > 0 && (msg.sender == Listed.buyer || msg.sender == Listed.owner ));
         
            if (buyerRes == true && ownerRes == true ) {
                bidderBalance -= Listed.price;
                Listed.owner.transfer(Listed.price);
                Listed.state = "Sale Completed";
                Listed.TransacEnd = now;
            }

            return (Listed, bidderBalance);
    } 

}

contract Transaction {

    /*
    All the mappings store the data regarding the item's being listed, their state, the user's data etc in the `registry`. Events are triggered upon the 
    succesful use of any function.
    */

    mapping (address => uint) public bidderBalance;
    mapping (address => uint) public fallbackBalance;
    mapping(bytes32 => mapping (address => bool)) public CompleteSale;
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
        var ( Listed, balance)  = FunctionSet.bid(registry[productHash], bidderBalance[msg.sender]);
        registry[productHash] = Listed;
        bidderBalance[msg.sender] = balance;
        ItemBid(Listed.productHash,Listed.buyer,Listed.price,Listed.TransacStart);


    }

    function _completedSale(bytes32 productHash) public returns(FunctionSet.Item Listed){
        Listed = registry[productHash];

        if (msg.sender == Listed.owner) {
            CompleteSale[productHash][Listed.owner] = true;

        }
        if (msg.sender == Listed.buyer) {
            CompleteSale[productHash][Listed.buyer] = true;

        }

        var (Item ,balance) = FunctionSet.completedSale(Listed,CompleteSale[productHash][Listed.owner],CompleteSale[productHash][Listed.buyer],bidderBalance[Listed.buyer]);
        registry[productHash] = Item;
        bidderBalance[Item.buyer] = balance;
        if (keccak256(Item.state) == keccak256("Sale Completed")) {
            ItemSold(Item.productHash,Item.buyer,Item.TransacEnd);
        return Item;
        }
    }


}


