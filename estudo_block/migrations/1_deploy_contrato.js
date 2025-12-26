const LuminarCoin = artifacts.require("LuminarCoin");

module.exports = function(deployer) {
    deployer.deploy(LuminarCoin, 1000000);
};