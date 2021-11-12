const BurnTokenFactory = artifacts.require("BurnTokenFactory");

module.exports = function (deployer) {
  deployer.deploy(BurnTokenFactory);
};
