pragma solidity ^0.8.19;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns(bool);
    function transferFrom(address from, address to, uint256 amount) external returns(bool);
    function balanceOf(address account) external view returns(uint256);
}

contract PoolDeLiquidez {
    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public reservaA;
    uint256 public reservaB;

    uint256 public totalLPTokens;
    mapping(address => uint256) public lpBalance;

    uint256 public constant FEE = 3;
    uint256 public constant FEE_DENOMINATOR = 1000;

    event LiquidezAdicionada(address indexed provedor, uint256 quantidadeA, uint256 quantidadeB, uint256 lpToken);
    event LiquidezRemivida(address indexed provador, uint256 quantidadeA, uint256 quantidadeB, uint256 lpToken);
    event Swap(address indexed usuario, address tokenln, uint256 amountLn, uint256 amountOut);

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function addLiquidez(uint256 _quantidadeA, uint256 _quantidadeB) public returns(uint256) {
        require(_quantidadeA > 0 && _quantidadeB > 0, "Quantidade invalida");

        tokenA.transferFrom(msg.sender, address(this), _quantidadeA);
        tokenB.transferFrom(msg.sender, address(this), _quantidadeB);

        uint256 lpTokensMintados;

        if(lpTokensMintados == 0) {
            lpTokensMintados = sqrt(_quantidadeA * _quantidadeB);
        } else {
            uint256 lpA = sqrt(_quantidadeA * totalLPTokens) / reservaA;
            uint256 lpB = sqrt(_quantidadeB * totalLPTokens) / reservaB;

            lpTokensMintados = lpA < lpB ? lpA : lpB;
        }

        require(lpTokensMintados > 0, "LP Tokens insuficiente");

        lpBalance[msg.sender] += lpTokensMintados;
        totalLPTokens += lpTokensMintados;

        reservaA = _quantidadeA;
        reservaB = _quantidadeB;

        emit LiquidezAdicionada(msg.sender, _quantidadeA, _quantidadeB, lpTokensMintados);

        return lpTokensMintados;
    }

    function removerLiquidez(uint256 _lpTokens) public returns(uint256, uint256) {
        require(_lpTokens > 0 && lpBalance[msg.sender] >= _lpTokens, "Tokens insuficiente");

        uint256 quantidadeA = sqrt(_lpTokens * reservaA) / totalLPTokens;
        uint256 quantidadeB = sqrt(_lpTokens * reservaB) / totalLPTokens;

        lpBalance[msg.sender] -= _lpTokens;
        totalLPTokens -= _lpTokens;

        reservaA -= quantidadeA;
        reservaB -= quantidadeB;

        tokenA.transfer(msg.sender, quantidadeA);
        tokenB.transfer(msg.sender, quantidadeB);

        emit LiquidezRemivida(msg.sender, quantidadeA, quantidadeB, _lpTokens);

        return (quantidadeA, quantidadeB);
    }

    function swapAporB(uint256 _quantidadeA) public returns(uint256) {
        require(_quantidadeA > 0, "Valor insuficiente");

        uint256 quantidadeComTaxa = _quantidadeA * (FEE_DENOMINATOR - FEE);
        uint256 quantidadeB = (quantidadeComTaxa * reservaB) / (reservaA * FEE_DENOMINATOR + quantidadeComTaxa);

        require(quantidadeB > 0 && quantidadeB < reservaB, "Liquidez insuficiente");

        tokenA.transferFrom(msg.sender, address(this), _quantidadeA);
        tokenB.transfer(msg.sender, quantidadeB);

        reservaA += _quantidadeA;
        reservaB -= quantidadeB;

        emit Swap(msg.sender, address(tokenA), _quantidadeA, quantidadeB);

        return quantidadeB;
    }

    function swapBporA(uint256 _quantidadeB) public returns(uint256) {
        require(_quantidadeB > 0, "Valor insuficiente");

        uint256 quantidadeComTaxa = _quantidadeB * (FEE_DENOMINATOR - FEE);
        uint256 quantidadeA = (quantidadeComTaxa * reservaA) / (reservaA * FEE_DENOMINATOR + quantidadeComTaxa);

        require(quantidadeA > 0 && quantidadeA < reservaA, "Liquidez insuficiente");

        tokenA.transferFrom(msg.sender, address(this), _quantidadeB);
        tokenB.transfer(msg.sender, quantidadeA);

        reservaB += _quantidadeB;
        reservaA -= quantidadeA;

        emit Swap(msg.sender, address(tokenB), _quantidadeB, quantidadeA);

        return quantidadeA;
    }

    function obterPrecoA() public view returns(uint256) {
        require(reservaA > 0, "Pool vazio");
        return (reservaB * 1e18) / reservaA;
    }

    function obterPrecoB() public view returns(uint256) {
        require(reservaB > 0, "Pool vazio");
        return (reservaA * 1e18) / reservaB;
    }

    function sqrt(uint256 x) internal pure returns(uint256) {
        if (x == 0) return 0;

        uint256 z = (x + 1) / 2;
        uint256 y = x;

        while(z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }
}