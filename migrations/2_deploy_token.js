const Token = artifacts.require("Token");

module.exports = (deployer, network, accounts) => {
  const contractOriginator = accounts[0];
  deployer.deploy(Token, {
        totalSupply: "100",
        'accounts': {
            [`${contractOriginator}`]: {
                balance: '100',
                allowances: {}
            }
        }
    });
};
