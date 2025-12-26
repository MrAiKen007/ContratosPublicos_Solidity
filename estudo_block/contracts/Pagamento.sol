pragma solidity ^0.8.19;

contract Pagamento {
    address public dono;
    
    mapping(address => uint256) public saldo;

    event Deposito(address indexed conta, uint256 valor);
    event Saque(address indexed conta, uint256 valor);
    event Transferir(address indexed de, address indexed para, uint256 valor);

    constructor() {
        dono = msg.sender;
    }

    function deposito() public payable {
        require(msg.value > 0,"Saldo insuficiente, tem que ser maior que 0");
        saldo[msg.sender] += msg.value;
        emit Deposito(msg.sender, msg.value);
    }

    function consultarSaldo() public view returns(uint256) {
        return saldo[msg.sender];
    }

    function sacar(uint256 _valor) public {
        require(saldo[msg.sender] >= _valor,"Saldo insuficiente");
        
        saldo[msg.sender] -= _valor;
        payable(msg.sender).transfer(_valor);

        emit Saque(msg.sender, _valor);
    }

    function transferencia(address _para, uint256 _valor) public {
        require(saldo[msg.sender] >= _valor, "Saldo insuficiente");
        require(msg.sender != address(0), "Endereco invalido");

        saldo[msg.sender] -= _valor;
        saldo[_para] += _valor;

        emit Transferir(msg.sender, _para, _valor);
    }

    receive() external payable {
        saldo[msg.sender] += msg.value;
        emit Deposito(msg.sender, msg.value);
    }
}