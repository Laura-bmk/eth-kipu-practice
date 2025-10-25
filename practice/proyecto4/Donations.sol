/*
Enunciado del Contrato Inteligente "DonationsV2"

Objetivo: Crear un contrato inteligente para gestionar donaciones en Ethereum, 
permitiendo a los usuarios donar tanto en ETH como en USDC. El contrato también 
recompensará a los donantes con un NFT después de alcanzar un umbral de donaciones.

Características:

Propiedad: El contrato es propiedad de un único administrador que tiene el control 
sobre ciertas funciones críticas como el retiro de fondos y la actualización del oracle.

Donaciones:

Permite donaciones en ETH mediante la función doeETH(), que convierte la cantidad donada 
a su valor en USD utilizando un oracle de Chainlink.
Permite donaciones en USDC mediante la función doeUSDC(uint256 _usdcAmount).
Recompensas:

Los usuarios que donen más de un umbral establecido (1000 USDC) recibirán un NFT como 
recompensa si no poseen uno previamente.
Retiro de Fondos:

La función saque() permite al propietario retirar los fondos donados, ya sean en ETH o USDC.

Actualización del Oracle:

Permite al propietario actualizar la dirección del oracle de precios de Chainlink mediante la 
función setFeeds(address _feed).
Eventos:

Emite eventos para registrar cada donación, retiro de fondos y actualizaciones del oracle.
Seguridad:

Implementa manejo de errores y validaciones para asegurar la correcta ejecución de las donaciones y 
retiros, incluyendo la verificación de que el oracle no esté comprometido y que el precio no esté obsoleto.
*/

// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
//import {IOracle} from "./IOracle.sol";
import {GreatInvestor} from "./GreatInvestor.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract Donations is GreatInvestor {

    struct Balances {
        uint256 eth;
        uint256 usdc;
        uint256 total;
    }

    mapping (address => Balances) public balance;

    AggregatorV3Interface public dataFeed;

    IERC20 immutable public USDC;

    error InvalidContract();

    event FeedSet(address indexed addr, uint256 time);
    event Donated(string indexed usdcOrEth, uint256 amountDonated, uint256 amountInUSDC);
    event Extracted(address onwner, uint256 valuEth, uint256 valueUSDC);

    constructor(AggregatorV3Interface _oracle, IERC20 _usdc) GreatInvestor(msg.sender) {
        if(_oracle == AggregatorV3Interface(address(0)) || _usdc == IERC20(address(0))) revert InvalidContract();
        dataFeed = _oracle; //0x694AA1769357215DE4FAC081bf1f309aDC325306
        USDC = _usdc;
        emit FeedSet(address(_oracle), block.timestamp);
    }

    function setFeeds(address _feed) external onlyOwner {
        // comprobacion
        dataFeed = AggregatorV3Interface(_feed); //0x694AA1769357215DE4FAC081bf1f309aDC325306
        emit FeedSet(_feed, block.timestamp);
    }

    function doeETH() external payable {
        // msg.value == 0 => que sentido tiene todo el resto?
        int256 _latestAnswer = _getETHPrice();
        Balances storage _balance = balance[msg.sender];

        _balance.eth += msg.value;
        uint256 _donatedInUSDC = ((msg.value)*uint256(_latestAnswer));
        emit Donated("ETH", msg.value, _donatedInUSDC);
        _donatedInUSDC += _balance.total;
        _balance.total = _donatedInUSDC; 
        if (_donatedInUSDC > 1000*100000000* 1 ether && balanceOf(msg.sender) < 1) {
            safeMint(msg.sender, "url");
        }
    }

    function doeUSDC(uint256 _usdcAmount) external {
        // comprobar _usdcAmount
        USDC.transferFrom(msg.sender, address(this), _usdcAmount);
        balance[msg.sender].usdc += _usdcAmount;
        balance[msg.sender].total += _usdcAmount;

        if (balance[msg.sender].total > 1000*100000000* 1 ether) {
            if (balanceOf(msg.sender) < 1) {
                safeMint(msg.sender, "url");
            }
        }
        emit Donated("USDC", _usdcAmount, _usdcAmount);
    }

    function saque() external onlyOwner {
        // checkear que el balance exista
        uint256 _valuEth = address(this).balance;
        
        uint256 _valueUSDC = USDC.balanceOf(address(this));

        USDC.transfer(msg.sender, _valueUSDC);
        // saca eth
        (bool success,) = msg.sender.call{value:_valuEth}("");
        if(!success) revert(); // poner custom error
        emit Extracted(msg.sender, _valuEth, _valueUSDC);
    }

    function _getETHPrice() private view returns(int256 _latestAnswer) {
        //return _latestAnswer = dataFeed.latestAnswer();

        // prettier-ignore
        (
            /* uint80 roundId */,
            _latestAnswer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        // verificar respuessta de este contrato.
        return _latestAnswer;
    }
}