pragma solidity 0.4.25;

contract UsoDeImagem {
	
    string public nomeEmpresa;
    address agente;
    address artista;
	
    modifier somenteArtista() {
        require(msg.sender==artista, "Somente artista pode realizar essa operação");
        _;
    }

    constructor() public {
        nomeEmpresa = "Artista SuperPop Ltda";
        artista = msg.sender;
    }
	
    function definirNomeDaEmpresa(string qualNomeDaEmpresa) public {
        nomeEmpresa = qualNomeDaEmpresa;
    }

    function definirAgente(address qualAgente) public somenteArtista  {
        require(qualAgente != address(0), "Endereço de agente invalido");
        agente = qualAgente;
    }
	
    function receberPeloUso() public payable {
        require(msg.value >= 100 szabo, "Por favor pague o valor mínimo");
        if (agente != address(0)) {
            agente.transfer((msg.value * 10) / 100);
        }
    }
}
