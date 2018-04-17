var pgoRC = artifacts.require("./PGORC.sol");
var pgo = artifacts.require("./PGO.sol");

module.exports = function(deployer) {
  //deployer.deploy(ConvertLib);
  //deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(pgo).then(function(){
    //console.log(pgo);
    deployer.deploy(pgoRC, "0x08902F0E5D7F04968dEbD7f1e1269939D349738A",pgo.address).then(function(){
      //console.log(pgoRC);
      //pgo.addAddressesToWhitelist(pgoRC.address);
    });
  });
  //deployer.deploy(pgoRC);
  //deployer.deploy(pgoCrowd);
};


// module.exports = function(deployer) {
//   //deployer.deploy(ConvertLib);
//   //deployer.link(ConvertLib, MetaCoin);
//   deployer.deploy(pgoRC,"0x82003a7adb887bee071741a5f51783f268dd141e","0x08902F0E5D7F04968dEbD7f1e1269939D349738A");
// };