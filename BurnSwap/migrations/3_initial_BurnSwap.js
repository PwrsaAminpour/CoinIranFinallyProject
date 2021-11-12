const BurnSwap = artifacts.require("BurnSwap");

module.exports = function (deployer) {
  deployer.deploy(BurnSwap);
};
