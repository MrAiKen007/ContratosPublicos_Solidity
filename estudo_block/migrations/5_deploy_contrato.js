const PoolDeLiquidez = artifacts.require("PoolDeLiquidez");

module.exports = function(deployer) {
    deployer.deploy(PoolDeLiquidez, "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000");
}