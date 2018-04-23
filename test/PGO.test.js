import decodeLogs from './helpers/decodeLogs';
const PGO = artifacts.require('PGO');

contract('PGO', accounts => {
  let token;
  const creator = accounts[0];
  const buyer = accounts[1];

  beforeEach(async function () {
    token = await PGO.new({ from: creator });
  });

  it('has a name', async function () {
    const name = await token.name();
    assert.equal(name, 'ParkingGo');
  });

  it('has a symbol', async function () {
    const symbol = await token.symbol();
    assert.equal(symbol, 'PGO');
  });

  it('has 18 decimals', async function () {
    const decimals = await token.decimals();
    assert(decimals.eq(18));
  });

  it('assigns the initial ICO supply to the creator', async function () {
    const icoSupply = await token.ICO_SUPPLY();
    const creatorBalance = await token.balanceOf(creator);

    assert(creatorBalance.eq(icoSupply));

    const receipt = web3.eth.getTransactionReceipt(token.transactionHash);
    const logs = decodeLogs(receipt.logs, PGO, token.address);
    assert.equal(logs.length, 7);
    assert.equal(logs[6].event, 'Transfer');
    assert.equal(logs[6].args.from.valueOf(), 0x0);
    assert.equal(logs[6].args.to.valueOf(), creator);
    assert(logs[6].args.value.eq(icoSupply));
  });

  it('control that only creator can change crowdsale address', async function () {

    //await token.SetCrowdSaleAddress("0x8929207c7c0E8A9aB480040e305CDa3925E9F338",{from: buyer});
    await token.SetCrowdSaleAddress("0x8929207c7c0E8A9aB480040e305CDa3925E9F338",{from: creator});
    const receipt = web3.eth.getTransactionReceipt(token.transactionHash);
   
  });
});
