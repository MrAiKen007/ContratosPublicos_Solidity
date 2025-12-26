const Pagamento = artifacts.require("Pagamento");

module.exports = function(deployer) {
    deployer.deploy(Pagamento);
};