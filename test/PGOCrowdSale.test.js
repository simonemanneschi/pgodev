import ether from './helpers/ether';
import { advanceBlock } from './helpers/advanceToBlock';
import { increaseTimeTo, duration } from './helpers/increaseTime';
import latestTime from './helpers/latestTime';
import EVMRevert from './helpers/EVMRevert';
import decodeLogs from './helpers/decodeLogs';

const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(BigNumber))
  .should();


const PGOCrowdSale = artifacts.require('PGOCrowdSale');
const PGO = artifacts.require('PGO');

contract('PGO', accounts => {
  let token;
  let crowdSale;
  const creator = accounts[0];
  const buyer = accounts[1];
  const wallet = accounts[9];

  beforeEach(async function () {
    
    token = await PGO.new({ from: creator }); 
    crowdSale = await PGOCrowdSale.new(wallet,token.address, { from: creator }); 
    //set crowdsale address on token contract
    token.SetCrowdSaleAddress(crowdSale.address); 

  });

  it('has a deployed with 7M RC supply', async function () {
    const rcSupply = await crowdSale.RC_SUPPLY_TOKEN();
    const expectedSupply = new web3.BigNumber(7000000e18);
    assert(rcSupply.eq(expectedSupply));
  });

   it('give error because SetIcoClosed must be called by crowdsale', async function () {
     await token.SetIcoClosed(); 
   });

  it('must close ICO on token contract', async function () {
    let icoOpened = await token.IcoOpened();
    assert(icoOpened);
    await crowdSale.SetIcoClosed({ from: creator });
    icoOpened = await token.IcoOpened();
    assert(!icoOpened);
  });
  

});
