const Garantia = artifacts.require("Garantia");

module.exports = function(deployer) {
    deployer.deploy(Garantia);
};