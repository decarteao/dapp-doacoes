// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/*
** Um simples Smart Contract para doações :)
** Onde apenas quem fez o deploy consegue fazer o saque
** dApps são demais+

## Made by HELIO3AO
*/

contract Doacoes{
    address[] private array_doadores;
    mapping(address => uint256) private lista_doadores;
    address public owner;

    constructor(){
        // adicionar o endereco de quem fazer o deploy
        owner = msg.sender;
    }

    modifier onlyDoador(){
        require(msg.sender != owner, "Apenas doadores podem doar");
        _;
    }
    modifier onlyOwner(){
        require(msg.sender == owner, "Apenas o dono do contrato pode levantar");
        require(address(this).balance > 0, "Tem saldo insuficiente");
        _;
    }

    // fazer a doacao
    function doar() public payable onlyDoador {
        lista_doadores[msg.sender] += msg.value / (10 ** 18); // salva o valor wei em ether
    }

    // lista apenas os enderecos dos doadores
    function listar_wallet_doadores() public view returns(address[] memory){
        return array_doadores;
    }

    // mostra o quanto um endereco doou :)
    function ver_saldo_doado_by_wallet(address _address) public view returns(uint256){
        return lista_doadores[_address];
    }

    // fazer o levantamento
    function levantar() public payable onlyOwner{
        // fazer o saque
            payable(msg.sender).transfer(address(this).balance);

            // zerar a lista de doadores dps do saque
            for(uint256 idx = 0; idx < array_doadores.length; idx++){
                delete lista_doadores[array_doadores[idx]];
            }
            delete array_doadores;
    }
}