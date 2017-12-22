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


function listItem(string name, uint price, uint nonce) public returns(Item storage Listed) {
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

    function bid(Item storage Listed, uint storage bidderBalance)  public returns(Item) {

       
      // Listed = registry(productHash);
       require(msg.value >= 0 && msg.value >= Listed.price && keccak256(Listed.state) == keccak256("For Sale"));
       bidderBalance += msg.value;
       Listed.state = "Bid Offered";
       Listed.TransacStart = now;
       Listed.buyer = msg.sender;
       return Listed;
       
       
       

    }

  /*  function completedSale(bytes32 productHash) public returns(TransactionData receipt) {
            require(TransactionRecords[productHash].TransacStart > 0 && (msg.sender == TransactionRecords[productHash].buyer || msg.sender == TransactionRecords[productHash].seller ));
            if (msg.sender == TransactionRecords[productHash].buyer) {
                CompleteSale[productHash][msg.sender] = true;
            }
            if (msg.sender == TransactionRecords[productHash].seller) {
                CompleteSale[productHash][msg.sender] = true;
            }
            if (CompleteSale[productHash][TransactionRecords[productHash].buyer] && CompleteSale[productHash][TransactionRecords[productHash].buyer] ) {
                bidderBalance[TransactionRecords[productHash].buyer] -= TransactionRecords[productHash].price;
                TransactionRecords[productHash].buyer.transfer(TransactionRecords[productHash].price);
                instance.editState(productHash,2);
                TransactionRecords[productHash].TransacEnd = now;
                return TransactionRecords[productHash];


            }
    } */

}