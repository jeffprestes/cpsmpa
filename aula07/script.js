function computarVoto() {
    var resumoVoto;
    resumoVoto = "O seu voto foi <br>";
    resumoVoto = resumoVoto + "cotas: " + document.formVotacao.nroCotas.value + "<br>";
    if (document.formVotacao.pauta1.value == "sim") {
        resumoVoto = resumoVoto + "Voce concordou com a Pauta1";
    } else {
        resumoVoto = resumoVoto + "Voce não concordou com a Pauta1";
    }    
    document.getElementById("seuVoto").innerHTML = resumoVoto;
}