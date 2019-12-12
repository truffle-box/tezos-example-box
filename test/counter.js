const Counter = artifacts.require("Counter");

contract('Counter', () => {
  let counterInstance;
  let storage;

  before(async() => {
    counterInstance = await Counter.deployed();
    storage = await counterInstance.storage();
    assert.equal(storage, 0, "Storage was not set as 0.")
  });

  it("...should increment storage by 5.", async() => {
    await counterInstance.increment(5);
    storage = await counterInstance.storage();
    assert.equal(storage, 5, "Storage was not incremented by 5.");
  });
  
  it("...should decrement storage by 2.", async() => {
    await counterInstance.decrement(2);
    storage = await counterInstance.storage();
    assert.equal(storage, 3, "Storage was not decremented by 2.");
  });
});
