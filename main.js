var config = require('./config.js');
var web3 = require("web3");
var deploy = require('./deploy.js');

function ListItem(name,price,callback) {
    var productHash;
    var owner;
    price = price * 10**18;
    deploy.TransactionContract.methods._listItem(name,price).send({
        from: config.owner, gas:500000}).on('receipt',function(receipt){
        console.log("\n-------------Item being Listed---------------\nThe Transaction Hash is : " + receipt.transactionHash +"\nThe Gas Used in this transaction is : "+receipt.gasUsed);
        productHash = receipt.events.ItemListed.returnValues.productHash;
        owner = receipt.events.ItemListed.returnValues.owner;
        console.log("\nThe Product Hash is:"+productHash+"\nThe Owner is : "+owner+"\nName of the Product is : "+name+" \nThe price of the product is : "+(price/(10**18))+" Ether");
        callback && callback(productHash);
        })
        

}
function BidItem(productHash,price,callback){
    var buyer; 
    var TransacStart;
    price = price * 10**18 ; 
    deploy.TransactionContract.methods._bid(productHash).send({
        from: config.buyer, gas:500000, value: price}).on('receipt',function(receipt){
            console.log("\n-------------Item being bid------------------\nThe Transaction Hash is : " + receipt.transactionHash +"\nThe Gas Used in this transaction is : "+receipt.gasUsed);
            buyer = receipt.events.ItemBid.returnValues.buyer;
            TransacStart = Date(receipt.events.ItemBid.returnValues.TransacStart*1000);
            console.log("\nThe Product Hash is : "+ productHash+"\nThe Bidder is : "+ buyer+"\nPrice of the Product is : "+(price/(10**18))+" Ether"+"\nThe Time of the bid is : "+TransacStart);
            callback && callback(productHash);
    
        })
    


}

function CompleteSale(productHash,userAddress,callback){
    var buyer;
    var TransacEnd;
    var TransReceipt ;
    deploy.TransactionContract.methods._completedSale(productHash).send({
        from: userAddress, gas:500000}).on('receipt',function(receipt){
            console.log("\n-------------Item Sale being Confirmed-------\n\nSuccesful Sale Has been Logged!\nTransaction Hash is: "+receipt.transactionHash);
            TransReceipt = receipt;
        }
    ).then(function(){
        if (TransReceipt.events.ItemSold !== undefined) {
        buyer = TransReceipt.events.ItemSold.returnValues.buyer;
        TransacEnd = Date(TransReceipt.events.ItemSold.returnValues.TransacEnd*1000);
        console.log("\n-------------Item Sale has Concluded---------")
        console.log("\nThe Product Hash is : "+productHash+"\nThe Owner now is : "+buyer+"\nThe Sale Concluded at : "
        +TransacEnd+"\nThe Ether has been transferred from the contract to the Seller's Account");

        }
    
        callback && callback(productHash); 
    }
    )
}


function Registry(productHash){
    deploy.TransactionContract.methods.registry(productHash).call().then(function(result){
        console.log("\nProduct Hash: "+result.productHash+"\nProduct Name: "+result.name+"\nPrice: "+(result.price/(10**18))+" Ether"+"\nSeller: "+result.owner+"\nBuyer: "+result.buyer+
        "\nProduct State: "+result.state+"\nTransaction Start: "+Date(result.TransacStart*1000)+"\nTransaction End: "+Date(result.TransacEnd*1000));
        })
}

function ItemList(){
    deploy.TransactionContract.methods.arraySize().call().then(function(result){
        for(var i = 0 ; i < result; i++) {
            deploy.TransactionContract.methods.itemlist(i).call().then(function(result){
                Registry(result);
            });
           
        }  
    })
}

function test(price){
    ListItem("test",price,function callback(productHash){
        BidItem(productHash,price,function callback(productHash){
            CompleteSale(productHash,config.owner,function callback(productHash){
                CompleteSale(productHash,config.buyer);
            });  
        });
    });
}

module.exports = {
ListItem,
BidItem,
CompleteSale,
Registry,
ItemList,
test,
}