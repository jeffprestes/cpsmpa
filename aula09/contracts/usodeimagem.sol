pragma solidity 0.4.25;

contract UsoDeImagem {
	
	string public nomeEmpresa;
	
	constructor() public {
    	nomeEmpresa = "Artista SuperPop Ltda";
	}
	
	function definirNomeDaEmpresa(string qualNomeDaEmpresa) public {
    	nomeEmpresa = qualNomeDaEmpresa;
	}
	
	function receberPeloUso() public payable {
        require(msg.value >= 100 szabo, "Por favor pague o valor mínimo");
	}
	
}
