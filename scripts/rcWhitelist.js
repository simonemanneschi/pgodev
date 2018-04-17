var pgo = artifacts.require("./PGO.sol");
var pgoRC = artifacts.require("./PGORC.sol");

module.exports = function(callback) {
    // perform actions
    
        //console.log(instance);
        pgoInst = pgo.at("0x6b689d8f8906c84055c2959922775df1618c1505");
        pgoRCInst = pgoRC.at("0x1f94c1654d931f220489010a919186ac2262aafe");

        console.log(pgoInst);
        console.log(pgoRCInst);
        
        //pgoInst.addAddressesToWhitelist.call(pgoRCInst.address);

        const response = pgoInst.addAddressToWhitelist(pgoRCInst.address);
        response.then(res => console.log(res));
        // .then(function(rcInstance){
        //     console.log("address whitelisted");
        // });

    
}

  