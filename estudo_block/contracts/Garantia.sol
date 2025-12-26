// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Garantia {
    enum Estado {Crieado, Pago, Entregue, Cancelado}

    struct Transacao {
        address comprador;
        address vendedor;
        uint256 valor;
        Estado estado;
    }

    mapping(uint256 => Transacao) transacos;
    uint256 public proximold =1;

    event TransacaoCriada(uint256 id, address comprador, address vendedor, uint256 valor);
    event PagamentoRealizado(uint256 id);
    event ItemEntregue(uint256 id);
    event TransacaoCancelada(uint256 id);

    function criarTransacao(address _vendedor) public payable returns(uint256){
        require(msg.value > 0, "Saldo insuficiente");
        require(_vendedor != address(0), "usuario invalido");

        uint256 id = proximold++;

        transacos[id] = Transacao({
            comprador: msg.sender,
            vendedor: _vendedor,
            valor: msg.value,
            estado: Estado.Pago
        });

        emit TransacaoCriada(id, msg.sender, _vendedor, msg.value);
        emit PagamentoRealizado(id);

        return id;
    }

    function confirmarEntrega(uint256 _id) public {
        Transacao storage t = transacos[_id];

        (bool success, ) = payable(t.vendedor).call{value: t.valor}("");
        require(success, "Falha ao enviar Ether");


        t.estado = Estado.Entregue;
        
        payable(t.vendedor).transfer(t.valor);

        emit ItemEntregue(_id);
    }

    function cancelarTransacao(uint256 _id) public {
        Transacao storage t = transacos[_id];
        require(msg.sender == t.comprador || msg.sender == t.vendedor, "Usario invalido");
        require(t.estado == Estado.Pago, "Nao pode cancelar");

        t.estado = Estado.Cancelado;
        
        (bool success, ) = payable(t.comprador).call{value: t.valor}("");
        require(success, "Falha ao enviar Ether");

        emit TransacaoCancelada(_id);
    }
}