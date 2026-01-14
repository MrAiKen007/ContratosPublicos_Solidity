pragma solidity ^0.8.19;

contract OracleSimples {
    address public oraculo;
    uint256 public precoBTC;
    uint256 public ultimaAtualizacao;

    event PrecoAtualizado(uint256 novoPreco, uint256 timestamp);

    constructor() {
        oraculo = msg.sender;
    }

    modifier apenasOraculo() {
        require(msg.sender == oraculo, "Apenas o oraculo pode atualizar");
        _;
    }

    function atualizarPreco(uint256 _novoPreco) public apenasOraculo() {
        precoBTC = _novoPreco;
        ultimaAtualizacao = block.timestamp;
        emit PrecoAtualizado(_novoPreco, block.timestamp);
    }

    function obeterPreco() public view returns(uint256, uint256) {
        return(precoBTC, ultimaAtualizacao);
    }

    function mudarOraculo(address _novoOraculo) public apenasOraculo {
        oraculo = _novoOraculo;
    }
}