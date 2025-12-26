//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract LuminarCoin {
    string public nome = "LuminarCoin";
    string public simbulo = "LMC";
    uint256 public total;

    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed de,address indexed para,uint256 valor);

    constructor(uint256 _total) {
        total = _total;
        balanceOf[msg.sender] = _total;
    }

    function transfer(address _para, uint256 _valor) public returns(bool) {
        require(balanceOf[msg.sender] >= _valor,"Valor insuficiente");
        balanceOf[msg.sender] -= _valor;
        balanceOf[_para] += _valor;

        emit Transfer(msg.sender, _para, _valor);
        return true;
    }
}