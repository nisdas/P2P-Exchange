var config = require('./config.js');
var web3 = require("web3");
var fs = require("fs");
var solc = require("solc");

web3 = new web3(new web3.providers.HttpProvider("http://localhost:8546"));
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

           

function ListItem(name,price) {
    var productHash;
    var owner;
    TransactionContract.methods._listItem(name,price).send({
        from: config.address, gas:500000}).on('receipt',function(receipt){
        console.log(receipt);
        productHash = receipt.events.ItemListed.returnValues.productHash;
        owner = receipt.events.ListItem.returnValues.owner;
        name = receipt.events.ListItem.returnValues.name;
        price = receipt.events.ListItem.returnValues.price;
        console.log("The Product Hash is: ${productHash}\nThe Owner is: ${owner}\nName of the Product is :${name}\nThe price of the product is${price} ");
        return productHash;

    })

}
function BidItem(productHash){
    var productHash;
    var buyer;
    var TransacStart;
    var price;
    TransactionContract.methods._bid(productHash).send({
        from: config.address, gas:500000, value: 10000}).on('receipt',function(receipt){
            productHash = receipt.events.ItemBid.returnValues.productHash;
            buyer = receipt.events.ItemBid.returnValues.buyer;
            TransacStart = receipt.events.ItemBid.returnValues.TransacStart;
            price = receipt.events.ItemBid.returnValues.price;
            console.log("The Product Hash is: ${productHash}\nThe Bidder is: ${buyer}\nPrice of the Product is :${price}\nThe Time of the bid is${TransacStart} ");
            return productHash;
    
        })
    


}

function CompleteSale(productHash){
    var productHash;
    var buyer;
    var TransacEnd;
    TransactionContract.methods._bid(productHash).send({
        from: config.address, gas:500000, value: 10000}).on('receipt',function(receipt){
            if(receipt.events != null){
            productHash = receipt.events.ItemSold.returnValues.productHash;
            buyer = receipt.events.ItemSold.returnValues.buyer;
            TransacStart = receipt.events.ItemSold.returnValues.TransacStart;
            price = receipt.events.ItemSold.returnValues.price;
            console.log("The Product Hash is: ${productHash}\nThe Bidder is: ${buyer}\nPrice of the Product is :${price}\nThe Time of the bid is${TransacStart} ");
            return productHash;
            }
        })
    


}


module.exports = {
    
    web3 ,
    source,
    source2,
    LibraryContract,
    TransactionContract,
    ListItem,
    BidItem
    

}