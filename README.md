# Contratos Públicos em Solidity

Este projeto reúne três contratos inteligentes desenvolvidos em Solidity, voltados para simular operações comuns em ambientes de blockchain, como criação de tokens, pagamentos e garantias em transações. O objetivo é servir de estudo e base para aplicações descentralizadas.

## Contratos

### 1. LuminarCoin
Um contrato de token simples, que implementa uma moeda digital chamada LuminarCoin (LMC). Permite a transferência de tokens entre contas e define um suprimento inicial.

### 2. Pagamento
Gerencia depósitos, saques e transferências entre contas. Usuários podem depositar Ether, consultar saldo, sacar e transferir valores para outros endereços.

### 3. Garantia
Simula um sistema de garantia para transações entre comprador e vendedor. Permite criar transações, registrar pagamentos, entrega de itens e cancelamentos, garantindo maior segurança nas operações.

## Como testar o projeto

Este projeto utiliza o framework [Truffle](https://trufflesuite.com/) para desenvolvimento, teste e deploy dos contratos.

### Pré-requisitos
- Node.js instalado
- Ganache (opcional, para blockchain local)
- Truffle (`npm install -g truffle`)

### Passos para rodar localmente

1. **Instale as dependências:**
	```bash
	npm install
	```

2. **Compile os contratos:**
	```bash
	truffle compile
	```

3. **Inicie o Ganache (ou use uma rede local):**
	- Abra o Ganache ou rode `ganache-cli` em outro terminal.

4. **Migre (faça o deploy) dos contratos:**
	```bash
	truffle migrate
	```

5. **Interaja com os contratos:**
	- Use o console do Truffle:
	  ```bash
	  truffle console
	  ```
	- Exemplos de comandos no console:
	  ```js
	  let instance = await LuminarCoin.deployed()
	  let pag = await Pagamento.deployed()
	  let gar = await Garantia.deployed()
	  ```

6. **Testes:**
	- Adicione seus testes na pasta `test/` e execute:
	  ```bash
	  truffle test
	  ```

---
Sinta-se à vontade para modificar e expandir os contratos para seus estudos!