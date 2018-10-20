pragma  solidity 0.4.25;

contract Eleicao {

    struct Candidato {
        string nome;
        address conta;
        uint numeroVotos;
        bool existe;
    }

    mapping(address => Candidato) candidatos;

    function incluiCandidato(string nomeCandidato, address contaCandidato) public {
        Candidato memory novoCandidato = Candidato(nomeCandidato, contaCandidato, 0, true);
        candidatos[contaCandidato] = novoCandidato;
    }
    
    function pesquisarCandidato(address contaCandidato) public view returns (string, address, uint) {
        Candidato memory candidato = candidatos[contaCandidato];
        if (candidato.existe == true) {
            return (candidato.nome, candidato.conta, candidato.numeroVotos);
        } else {
            return ("", 0, 0);
        }
    }
}

//Deployed: https://rinkeby.etherscan.io/address/0x5b14487517c1684380fe0f74bc299f77b0a0a3d3#code