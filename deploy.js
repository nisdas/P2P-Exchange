var config = require('./config.js');
var web3 = require("web3");
var fs = require("fs");
var solc = require("solc");

web3 = new web3(new web3.providers.HttpProvider("http://localhost:8545"));
var compiledCode = solc.compile(fs.readFileSync('./test.sol', 'utf8'),1);
var source = compiledCode.contracts[":ListingContract"];
var source2 = compiledCode.contracts[":assetBid"];
var tokencontract = new  web3.eth.Contract(JSON.parse(source.interface));
var tokencontract2 = new  web3.eth.Contract(JSON.parse(source2.interface));
tokencontract.deploy({data: source.bytecode}).send({from: config.address, gas:1500000}).on('confirmation', function(confirmationNumber, receipt){ console.log(confirmationNumber); tokencontract.options.address = receipt.contractAddress; }).on('receipt', function(receipt){console.log(receipt)})
tokencontract2.deploy({data: source2.bytecode, arguments:[ tokencontract.options.address]}).send({from: config.address, gas:1500000}).on('confirmation', function(confirmationNumber, receipt){ console.log(confirmationNumber); tokencontract2.options.address = receipt.contractAddress; }).on('receipt', function(receipt){console.log(receipt)})


module.exports = {
    
    web3 ,
    source,
    tokencontract

}