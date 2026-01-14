const OracleSimples = artifacts.require("OracleSimples");

module.exports = function(deployer) {
    deployer.deploy(OracleSimples);
}