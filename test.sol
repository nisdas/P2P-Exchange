pragma solidity ^0.4.16;

contract ListingContract {

mapping (bytes32 => Item) public registry;
mapping(address => uint) public nonce;

struct Item {
    string name;
    uint price;
    address owner;
    uint AccountNonce;
    bytes32 productHash;
    uint state;
} 



    function listItem(string name, uint price) public returns(bytes32 productHash) {

        Item memory Listed;
        nonce[msg.sender] += 1;
        Listed.AccountNonce = nonce[msg.sender];
        Listed.name = name;
        Listed.price = price;
        Listed.owner = msg.sender;
        productHash = keccak256(Listed.price, Listed.name, Listed.AccountNonce, Listed.owner, now);
        Listed.productHash = productHash;
        Listed.state = 0;
        assert(keccak256(Listed.name) == keccak256(name) && Listed.price == price && Listed.owner == msg.sender && Listed.AccountNonce == nonce[msg.sender] && Listed.state == 0);
        registry[productHash] = Listed;
        return productHash;
    }

    function registryGetter(bytes32 productHash) public view returns( uint price, address owner, uint state) {
        Item memory getter = registry[productHash];
        return (getter.price,getter.owner,getter.state);


    }
    function editState(bytes32 productHash, uint state) public {
        registry[productHash].state = state;
    }

    
}

contract assetBid {

mapping (address => uint) public bidderBalance;
mapping (address => uint) public fallbackBalance;
mapping(bytes32 => TransactionData) public TransactionRecords;
mapping(bytes32 => mapping (address => bool)) CompleteSale;
ListingContract instance ;

struct TransactionData {
         bytes32 productHash;
         uint TransacStart;
         uint TransacEnd;
         uint price;
         address seller;
         address buyer;
}

     function assetBid(address listingContract) public { 
        instance = ListingContract(listingContract);   
    }
     function () public payable {
        fallbackBalance[msg.sender] += msg.value;

     }
    
    function bid(bytes32 productHash) payable public {

       var (price,owner,state) = instance.registryGetter(productHash);
       require(msg.value >= 0 && msg.value >= price && state == 0);
       bidderBalance[msg.sender] += msg.value;
       instance.editState(productHash,1);
       TransactionData memory transaction;
       transaction.productHash = productHash;
       transaction.TransacStart = now;
       transaction.buyer = msg.sender;
       transaction.seller = owner;
       transaction.price = price;
       TransactionRecords[productHash] = transaction;

    }

    function completedSale(bytes32 productHash) public returns(TransactionData receipt) {
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
    }







}

  /* function stringToBytes32(string memory source) returns (bytes32 result) {
    bytes memory tempEmptyStringTest = bytes(source);
    if (tempEmptyStringTest.length == 0) {
        return 0x0;
    }

    assembly {
        result := mload(add(source, 32))
    }
    }*/