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
const PGORC = artifacts.require('PGORC');
const PGO = artifacts.require('PGO');

contract('PGORC', accounts => {
  //Token for ether rate in reservation contract
  const RATE = new BigNumber(1400);
  //token contract instance placeholder
  let token;
  //crowdsale contract instance placeholder
  let crowdSale;
  //rc contract instance placeholder
  let rc;
  //creator account
  const creator = accounts[0];
  //buyer account
  const buyer = accounts[1];
  //wallet where funds will be transfered
  const wallet = accounts[9];

  //it's executed before each test!
  beforeEach(async function () {
    //deployed token instance
    token = await PGO.new({ from: creator }); 
    //deployed crowasale instance
    //require a wallet address and token instance address
    crowdSale = await PGOCrowdSale.new(wallet,token.address, { from: creator }); 
    //set crowdsale address on token contract
    await token.SetCrowdSaleAddress(crowdSale.address); 
    //deploy RC contract 
    rc = await PGORC.new(crowdSale.address);
    await crowdSale.addAddressToWhitelist(rc.address);
  });
  //check constant amount of reservation contract token supply
  it('has a deployed with correct crowdsale address', async function () {
    const crowdsaleAddress = await rc.crowdSale();
    //console.log(crowdsaleAddress);
    assert.equal(crowdsaleAddress,crowdSale.address);
  });

   //try to buy some tokens
   it('must buy 1400 token', async function () {
    const investmentAmount = ether(1);
    const expectedTokenAmount = RATE.mul(investmentAmount);

    //await increaseTimeTo(this.openingTime);
    await rc.buyTokens(buyer, { value: investmentAmount, from: buyer }).should.be.fulfilled;

    (await token.balanceOf(buyer)).should.be.bignumber.equal(expectedTokenAmount);
    //(await this.token.totalSupply()).should.be.bignumber.equal(expectedTokenAmount);
  });

});
