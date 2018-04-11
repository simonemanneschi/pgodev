const Web3 = require('web3');

const TruffleConfig = require('../truffle');


var Migrations = artifacts.require("./Migrations.sol");

module.exports = function(deployer, network, accounts) {

  //console.log('>> network ' + network);
  //console.log('>> accounts ' + accounts);

  //const config = TruffleConfig.networks[network];

 
  //const web3 = new Web3(new Web3.providers.HttpProvider('http://' + config.host + ':' + config.port));

  //console.log('>> web3 ' + web3);
  //console.log('>> Unlocking account ' + config.from);
  //web3.personal.unlockAccount(config.from, "test123456", 36000);

  deployer.deploy(Migrations);
};
