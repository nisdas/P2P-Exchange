# Peer to Peer Exchange 

A peer to peer exchange platform that will enable users of the platform to list goods/services to be sold to other users.
This platform is built on top of the Ethereum blockchain and utilises smart contracts to interact with it. This offers a way to 
mitigate problems associated with p2p exchange such as a party reneging on the deal, non-payment of the item fees, sparse or zero record of
transaction history. By carrying out and recording the transactions on the blockchain you can solve most of these problems and make it a 
non-issue which makes for a more efficient and fair market.

## Getting Started

For best results Node.js 8.8.0 and above is recommended along with a geth\parity node connected to either the Mainnet or 
the other testnets. Other private blockchains such as testrpc will also work fine. Use the http port 8545 , for RPC calls to 
the blockchain.

In the config.js file, you can input the addresses that can be used by your node.
```
   address: '0x627306090abaB3A6e1400e9345bC60c78a8BEf57',
    owner : '0x627306090abaB3A6e1400e9345bC60c78a8BEf57',
    buyer: '0xf17f52151EbEF6C7334FAD080c5704D77216b732'
```
The owner and buyer addresses are the ones that you can use to test the platform with, to see how the platform works. 

## Installing

Once you have downloaded or cloned the repo, use `npm install` to download the `web3` and `solc` libraries in the cloned directory. 

### Deploying the contracts

cd into the main directory and start node REPL.Then type in
`.load run.js`

Make sure that your blockchain is connected and running and the http port is set to 8545.

This will intialise all the libraries and deploy the contracts for you. Upon succesfully deploying the contracts on the repl you
will get the transaction receipts for the deployed contracts. Now you are ready to use the platform !

## Using the Platform

### Listing an Item

If you want to list an item you will have to use this command :

`main.ListItem("name",price)`

Where name is the name of the item in a string and price is the price of the item in Ether

If the entry has been successful then you will receive this receipt:

```
-------------Item being Listed---------------
The Transaction Hash is : 0x85180569fdcbc0f13f362d7705aa32535b458fc760d05316968aa7a3a63c1278
The Gas Used in this transaction is : 206900

The Product Hash is:0x2aade6f635d8605dbe77948b41e3770cf96104993d92f3f3fcec9c503f443df5
The Owner is : 0x627306090abaB3A6e1400e9345bC60c78a8BEf57
Name of the Product is : test
The price of the product is : 1 Ether
```

### Bidding for an Item

If you want to bid for an item you will have to use this command :

`main.BidItem(productHash,price)`

Where productHash is the product hash of the item you want and price is the price of it. Over here 
ether  is transferred from your account to the contract.

If the entry has been successful then you will receive this receipt:

```
-------------Item being bid------------------
The Transaction Hash is : 0x4e6b7f5fb8722a5396e185660cd10d280f5ae21bc50f5371c8360131ed1784cc
The Gas Used in this transaction is : 138667

The Product Hash is : 0x2aade6f635d8605dbe77948b41e3770cf96104993d92f3f3fcec9c503f443df5
The Bidder is : 0xf17f52151EbEF6C7334FAD080c5704D77216b732
Price of the Product is : 1 Ether
The Time of the bid is : Sun Dec 24 2017 15:52:58 GMT+0800 (Malay Peninsula Standard Time)
```
### Confirming the Sale

If the buyer has received the product then he will call this function , and if the seller is certain that the product
has reached the buyer then he will confirm this function. Both the buyer and seller confirming this will conclude the sale and
release the relevant funds to the seller from the contract. This function is called through this command

`main.CompleteSale(productHash,address)`

Where producthash is the product hash of the item and address is the user's account address.

If the entry is successful this will be received :

```
-------------Item Sale being Confirmed-------

Succesful Sale Has been Logged!
Transaction Hash is: 0x3a9b7acb418b5a75a26883cc674fbc2e32465282220037461581642cd9a96a18
```

If the sale is conluded then this will be printed :

```
-------------Item Sale has Concluded---------

The Product Hash is : 0x2aade6f635d8605dbe77948b41e3770cf96104993d92f3f3fcec9c503f443df5
The Owner now is : 0xf17f52151EbEF6C7334FAD080c5704D77216b732
The Sale Concluded at : Sun Dec 24 2017 15:52:58 GMT+0800 (Malay Peninsula Standard Time)
The Ether has been transferred from the contract to the Seller's Account

```
### Looking up an Item

Type in
`main.Registry(productHash)`

and you will get :

```
Product Hash: 0xecce4565e91e18a3716e630d896eca1e86583baae9c39f39f5e8a13bfbf942cd
Product Name: test
Price: 7 Ether
Seller: 0x627306090abaB3A6e1400e9345bC60c78a8BEf57
Buyer: 0xf17f52151EbEF6C7334FAD080c5704D77216b732
Product State: Sale Completed
Transaction Start: Sun Dec 24 2017 17:46:33 GMT+0800 (Malay Peninsula Standard Time)
Transaction End: Sun Dec 24 2017 17:46:33 GMT+0800 (Malay Peninsula Standard Time)
```
### Looking at All the Items

If you want to know everything that has been listed on this platform then you can use:
`main.ItemList()`

You will then get all the different item entries :

```
Product Hash: 0x823ab2f11b693c20bedaa2e422bafad53e88a5f6aa82b24ef5c92c231b0eb5b5
Product Name: test
Price: 1 Ether
Seller: 0x627306090abaB3A6e1400e9345bC60c78a8BEf57
Buyer: 0xf17f52151EbEF6C7334FAD080c5704D77216b732
Product State: Sale Completed
Transaction Start: Sun Dec 24 2017 17:48:29 GMT+0800 (Malay Peninsula Standard Time)
Transaction End: Sun Dec 24 2017 17:48:29 GMT+0800 (Malay Peninsula Standard Time)

Product Hash: 0x49711312f1dfbae862749135fc9b53b61d84a2dbd207f50398fadd94b7293731
Product Name: test
Price: 3 Ether
Seller: 0x627306090abaB3A6e1400e9345bC60c78a8BEf57
Buyer: 0xf17f52151EbEF6C7334FAD080c5704D77216b732
Product State: Sale Completed
Transaction Start: Sun Dec 24 2017 17:48:29 GMT+0800 (Malay Peninsula Standard Time)
Transaction End: Sun Dec 24 2017 17:48:29 GMT+0800 (Malay Peninsula Standard Time)

Product Hash: 0xecce4565e91e18a3716e630d896eca1e86583baae9c39f39f5e8a13bfbf942cd
Product Name: test
Price: 7 Ether
Seller: 0x627306090abaB3A6e1400e9345bC60c78a8BEf57
Buyer: 0xf17f52151EbEF6C7334FAD080c5704D77216b732
Product State: Sale Completed
Transaction Start: Sun Dec 24 2017 17:48:29 GMT+0800 (Malay Peninsula Standard Time)
Transaction End: Sun Dec 24 2017 17:48:29 GMT+0800 (Malay Peninsula Standard Time)
```
## Future Features

- In the future the platform will most likely work under a time lock, where the item has to be delivered in a set amount of time, or
the seller will have their fee reduced depending on how late the buyer gets the item.

- Also in the future there will be a mandatory deposit that each seller will have to deposit so as to have the ability to list 
items on this platform. This is so as to disincetivize any malicious motivations by sellers. If they are also obligated to act in a
conducive manner which will benefit both parties this will ensure that transactions will be carried out smoothly.

- Also in the future the code will be made cleaner and more efficient as right now , it takes 150,000 gas per transaction which at the
current price of ether at a gas price of 10 Gwei, will be $1.05 usd per contract call. This imposes a rather high transactional cost,
which is not very beneficial to buyer or seller. The goal is to bring down the transaction fees as much as possible.






