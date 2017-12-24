

var config = require('./config.js');
var web3 = require("web3");
var fs = require("fs");
var solc = require("solc");

web3 = new web3(new web3.providers.HttpProvider("http://localhost:8545"));
var compiledCode = solc.compile(fs.readFileSync('./contracts/library.sol', 'utf8'),1);
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

           





module.exports = {
    
    web3 ,
    source,
    source2,
    LibraryContract,
    TransactionContract
    

}