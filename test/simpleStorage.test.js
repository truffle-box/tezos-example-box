const SimpleStorage = artifacts.require("SimpleStorage");

contract('SimpleStorage', () => {
  it("...should store the integer 89.", async() => {
    const simpleStorageInstance = await SimpleStorage.deployed()
    await simpleStorageInstance.main(89);
    const storedInt = await simpleStorageInstance.storage();

    assert.equal(storedInt, 89, "The integer 89 was not stored.");
  });
});
