
var async = require("async");
var config = require('./config.js');
var web3 = require("web3");
var fs = require("fs");
var solc = require("solc");

/*
'ECVerify.sol': fs.readFileSync('./contracts/SigLibrary/ECVerify.sol', 'utf8'),
'SafeMath.sol': fs.readFileSync('./contracts/math/SafeMath.sol', 'utf8'),
'AssetInterface.sol': fs.readFileSync('./contracts/AssetInterface.sol', 'utf8'),
*/

web3 = new web3(new web3.providers.HttpProvider("http://localhost:8545"));

function findImports (path) {
	if (path === 'math/SafeMath.sol')
        return { contents: fs.readFileSync('./contracts/math/SafeMath.sol', 'utf8') }
        
    else if (path === 'SigLibrary/ECVerify.sol')
    
    return { contents: fs.readFileSync('./contracts/SigLibrary/ECVerify.sol', 'utf8') }

    else if (path === 'AssetInterface.sol')

    return { contents: fs.readFileSync('./contracts/AssetInterface.sol', 'utf8') }

    else 
		return { error: 'File not found' }
}
var input = {
	'AssetExchange.sol': fs.readFileSync('./contracts/AssetExchange.sol', 'utf8')
}
var compiledCode = solc.compile({ sources: input },1, findImports);
var source = compiledCode.contracts["SigLibrary/ECVerify.sol:ECVerify"];
var source2 = compiledCode.contracts["math/SafeMath.sol:SafeMath"];
var source3 = compiledCode.contracts["AssetExchange.sol:AssetExchange"];
var ECVerifyLibrary = new  web3.eth.Contract(JSON.parse(source.interface));
var SafeMathLibrary = new  web3.eth.Contract(JSON.parse(source2.interface));
var AssetExchange = new  web3.eth.Contract(JSON.parse(source3.interface));

function deploySafeMath() {
    SafeMathLibrary.deploy({
        data: source2.bytecode}).send({
            from: config.address, gas:1500000}).on('confirmation', function(confirmationNumber, receipt){ 
                console.log(confirmationNumber); SafeMathLibrary.options.address = receipt.contractAddress; }).on('receipt', function(receipt){
                    console.log(receipt);})

}

function deployECVerify() {
    ECVerifyLibrary.deploy({
        data: source.bytecode}).send({
            from: config.address, gas:1500000}).on('confirmation', function(confirmationNumber, receipt){ 
                console.log(confirmationNumber); ECVerifyLibrary.options.address = receipt.contractAddress; }).on('receipt', function(receipt){
                    console.log(receipt);})

}

function deployAssetContract() {
    source3.bytecode = solc.linkBytecode(source3.bytecode, { 'SafeMath': SafeMathLibrary.options.address } );
    source3.bytecode = solc.linkBytecode(source3.bytecode, { 'ECVerify': ECVerifyLibrary.options.address } );
    


                    AssetExchange.deploy({
                        data: source3.bytecode}).send({
                            from: config.address, gas:1500000}).on('confirmation', function(confirmationNumber, receipt){ 
                                console.log(confirmationNumber); AssetExchange.options.address = receipt.contractAddress; }).on('receipt', function(receipt){
                                        console.log(receipt)
                            });

}

async.waterfall({
    deploySafeMath,
    deployECVerify,
    deployAssetContract
}, function(error,result){
    console.log(result);
})

           




module.exports = {
    
    web3 ,
    source,
    source2,
    source3,
    ECVerifyLibrary,
    SafeMathLibrary,
    AssetExchange
    

}