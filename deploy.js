var config = require('./config.js');
var web3 = require("web3");
var fs = require("fs");
var solc = require("solc");

web3 = new web3(new web3.providers.HttpProvider("http://localhost:8546"));
var compiledCode = solc.compile(fs.readFileSync('./test.sol', 'utf8'),1);
var source = compiledCode.contracts[":ListingContract"];
var source2 = compiledCode.contracts[":assetBid"];
var ListingContract = new  web3.eth.Contract(JSON.parse(source.interface));
var AssetBidContract = new  web3.eth.Contract(JSON.parse(source2.interface));

ListingContract.deploy({
    data: source.bytecode}).send({
        from: config.address, gas:1500000}).on('confirmation', function(confirmationNumber, receipt){ 
            console.log(confirmationNumber); ListingContract.options.address = receipt.contractAddress; }).on('receipt', function(receipt){
                console.log(receipt)
            });

AssetBidContract.deploy({
    data: source2.bytecode, arguments:[ ListingContract.options.address]}).send({
        from: config.address, gas:1500000}).on('confirmation', function(confirmationNumber, receipt){ 
            console.log(confirmationNumber); AssetBidContract.options.address = receipt.contractAddress; }).on('receipt', function(receipt){
                console.log(receipt)
            });


function ListItem(name,price) {
    var productHash;
    ListingContract.methods.listItem(name,price).send({
        from: config.address, gas:500000}).on('receipt',function(receipt){
        productHash = receipt.events.ListItem.returnValues.productHash;
        console.log("The Product Hash is: " + productHash);
        return productHash;

    })

}
function BidItem(productHash){
    AssetBidContract.methods.bid(productHash).send({
        from: config.address, gas:500000, value: 10000})


}


module.exports = {
    
    web3 ,
    source,
    source2,
    ListingContract,
    AssetBidContract,
    ListItem,
    BidItem
    

}