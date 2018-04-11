var pgoRC = artifacts.require("./PGORC.sol");


module.exports = function(deployer) {
  deployer.deploy(pgoRC,"0x82003a7adb887bee071741a5f51783f268dd141e","0x08902F0E5D7F04968dEbD7f1e1269939D349738A");
};