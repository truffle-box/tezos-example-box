const SimpleStorage = artifacts.require("SimpleStorage");

module.exports = deployer => {
  deployer.deploy(SimpleStorage, 3);
};
