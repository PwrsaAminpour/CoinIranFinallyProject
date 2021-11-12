const AggregatorV3Interface = artifacts.require("AggregatorV3Interface");

module.exports = function (deployer) {
  deployer.deploy(AggregatorV3Interface);
};


