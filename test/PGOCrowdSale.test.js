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
  //Token for ether rate
  const RATE = new BigNumber(1120);
  //token contract instance placeholder
  let token;
  //crowdsale contract instance placeholder
  let crowdSale;
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
    token.SetCrowdSaleAddress(crowdSale.address); 

  });
  //check constant amount of reservation contract token supply
  it('has a deployed with 7M RC supply', async function () {
    const rcSupply = await crowdSale.RC_SUPPLY_TOKEN();
    const expectedSupply = new web3.BigNumber(7000000e18);
    assert(rcSupply.eq(expectedSupply));
  });

   it('give error because SetIcoClosed must be called by crowdsale', async function () {
      await token.SetIcoClosed().should.be.rejected;
     
   });

  //check close switch invoked from crowdsale contract to token contract
  it('must close ICO on token contract', async function () {
    //when deployed icoOpened switch is true, setting crowdsalecontract address
    //switch icoOpened to true
    let icoOpened = await token.IcoOpened();
    assert(icoOpened);
    //set ico close from crowdsale unlock the token transfer function
    await crowdSale.SetIcoClosed({ from: creator });
    icoOpened = await token.IcoOpened();
    assert(!icoOpened);
  });


  //try to buy some tokens
  it('must buy 1120 token', async function () {
    const investmentAmount = ether(1);
    const expectedTokenAmount = RATE.mul(investmentAmount);

    //await increaseTimeTo(this.openingTime);
    await crowdSale.buyTokens(buyer, { value: investmentAmount, from: buyer }).should.be.fulfilled;

    (await token.balanceOf(buyer)).should.be.bignumber.equal(expectedTokenAmount);
    //(await this.token.totalSupply()).should.be.bignumber.equal(expectedTokenAmount);
  });
  

});
