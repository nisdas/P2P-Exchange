var config = require('./config.js');
var deploy = require('./deploy.js');


   




function test(){
     deploy.ListItem("test",10000);
     setTimeout(deploy.BidItem('0x2887c2e109eb6b9bef16af0907e4ed5f4e316b441c247c9ffb332cbd56485541',10000),10000);
     setTimeout(deploy.CompleteSale('0x2887c2e109eb6b9bef16af0907e4ed5f4e316b441c247c9ffb332cbd56485541','0xf17f52151EbEF6C7334FAD080c5704D77216b732'),10000);
     setTimeout(deploy.CompleteSale('0x2887c2e109eb6b9bef16af0907e4ed5f4e316b441c247c9ffb332cbd56485541','0x627306090abaB3A6e1400e9345bC60c78a8BEf57'),10000);
     deploy.TransactionContract.methods.registry('0x2887c2e109eb6b9bef16af0907e4ed5f4e316b441c247c9ffb332cbd56485541').call().then(console.log)
}

     /*deploy.BidItem('10',10000);
     deploy.CompleteSale('10','0xf17f52151EbEF6C7334FAD080c5704D77216b732');
     deploy.CompleteSale('10','0x627306090abaB3A6e1400e9345bC60c78a8BEf57');
     deploy.TransactionContract.methods.registry('10').call().then(console.log)*/





