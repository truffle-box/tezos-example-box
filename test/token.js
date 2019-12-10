const Token = artifacts.require("Token");

contract('Token', accounts => {
  it("...should store account address, token balance, & allowances", async() => {
    const tokenInstance = await Token.deployed();
    const storage = await tokenInstance.storage();
    const storedAccountInfo = await storage.accounts.get(accounts[0]);
    assert(storedAccountInfo);
    assert.deepStrictEqual(storedAccountInfo.allowances, {}); 
    assert(storedAccountInfo.balance.toString() === "100")
    });
});
