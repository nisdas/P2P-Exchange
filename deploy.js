

var config = require('./config.js');
var web3 = require("web3");
var fs = require("fs");
var solc = require("solc");

web3 = new web3(new web3.providers.HttpProvider("http://localhost:8545"));
var compiledCode = solc.compile(fs.readFileSync('./library.sol', 'utf8'),1);
var source = compiledCode.contracts[":FunctionSet"];
var source2 = compiledCode.contracts[":Transaction"];
var LibraryContract = new  web3.eth.Contract(JSON.parse(source.interface));
var TransactionContract = new  web3.eth.Contract(JSON.parse(source2.interface));

LibraryContract.deploy({
    data: source.bytecode}).send({
        from: config.address, gas:1500000}).on('confirmation', function(confirmationNumber, receipt){ 
            console.log(confirmationNumber); LibraryContract.options.address = receipt.contractAddress; }).on('receipt', function(receipt){
                console.log(receipt);}).then(function(NxtDeploy){
                    source2.bytecode = solc.linkBytecode(source2.bytecode, { 'FunctionSet': LibraryContract.options.address });

                    TransactionContract.deploy({
                        data: source2.bytecode}).send({
                            from: config.address, gas:1500000}).on('confirmation', function(confirmationNumber, receipt){ 
                                console.log(confirmationNumber); TransactionContract.options.address = receipt.contractAddress; }).on('receipt', function(receipt){
                                        console.log(receipt)
                            });
                })

           

function ListItem(name,price,callback) {
    var productHash;
    var owner;
    TransactionContract.methods._listItem(name,price).send({
        from: config.owner, gas:500000}).on('receipt',function(receipt){
        console.log("\n-------------Item being Listed---------------\nThe Transaction Hash is : " + receipt.transactionHash +"\nThe Gas Used in this transaction is : "+receipt.gasUsed);
        productHash = receipt.events.ItemListed.returnValues.productHash;
        owner = receipt.events.ItemListed.returnValues.owner;
        console.log("\nThe Product Hash is:"+productHash+"\nThe Owner is : "+owner+"\nName of the Product is : "+name+" \nThe price of the product is : "+price);
        callback(productHash);
        })
        

}
function BidItem(productHash,price,callback){
    var buyer; 
    var TransacStart;
    TransactionContract.methods._bid(productHash).send({
        from: config.buyer, gas:500000, value: price}).on('receipt',function(receipt){
            console.log("\n-------------Item being bid------------------\nThe Transaction Hash is : " + receipt.transactionHash +"\nThe Gas Used in this transaction is : "+receipt.gasUsed);
            buyer = receipt.events.ItemBid.returnValues.buyer;
            TransacStart = receipt.events.ItemBid.returnValues.TransacStart;
            console.log("\nThe Product Hash is : "+ productHash+"\nThe Bidder is : "+ buyer+"\nPrice of the Product is : "+price+"\nThe Time of the bid is : "+TransacStart);
            callback(productHash);
    
        })
    


}

function CompleteSale(productHash,userAddress,callback){
    var buyer;
    var TransacEnd;
    var x = 0 ;
    TransactionContract.methods._completedSale(productHash).send({
        from: userAddress, gas:500000}).on('receipt',function(receipt){
            console.log("\n-------------Item Sale being Confirmed-------\n\nSuccesful Sale Has been Logged!\nTransaction Hash is: "+receipt.transactionHash);
            buyer = receipt.events.ItemSold ; 
            if (x == 0) {
            x++;
            buyer = receipt.events.ItemSold.returnValues.buyer;
            TransacEnd = receipt.events.ItemSold.returnValues.TransacEnd;
            price = receipt.events.ItemSold.returnValues.price;
            console.log("\nThe Product Hash is : "+productHash+"\n\nThe Bidder is : "+buyer+"\n\nPrice of the Product is : "+price+"\n\nThe End of the Sale is : "+TransacStart);
            }
            console.log(x);
            callback(productHash);
        })
    


}

function test(){
    ListItem("test",10000,function callback(productHash){
        BidItem(productHash,10000,function callback(productHash){
            CompleteSale(productHash,'0xf17f52151EbEF6C7334FAD080c5704D77216b732',function callback(productHash){
                CompleteSale(productHash,'0x627306090abaB3A6e1400e9345bC60c78a8BEf57',function callback(productHash){
                    TransactionContract.methods.registry(productHash).call().then(console.log);
                });
            });  
        });
    });
}



module.exports = {
    
    web3 ,
    source,
    source2,
    LibraryContract,
    TransactionContract,
    ListItem,
    BidItem,
    CompleteSale,
    test
    

}