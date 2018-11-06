var contaUsuario;

// Verifica a conexão Web3 e a conta do usuario
function verificaConta() {
    // Verifica o status da conexão 
    if (conexaoComEthereum && conexaoComEthereum.isConnected()) {
        if (conexaoComEthereum.eth.accounts[0] == undefined)  {
            console.info('Não esta conectado ao Metamask');
            $('#statusConexao').text('Desconectado');  
        }  else {
            console.info('Conectado. Qual versão da lib Web3 foi injetado pelo Metamask? ' + conexaoComEthereum.version.api);
            contaUsuario = conexaoComEthereum.eth.accounts[0];
            $('#statusConexao').text('Conectado a conta ' + contaUsuario);  
        }
    } else {
        $('#statusConexao').text('Desconectado');
    }
}

window.addEventListener('load', async (event) => {
    // Navegadores com novo Metamask    
    if (window.ethereum) {
        window.conexaoComEthereum = new Web3(ethereum);
        try {
            // Solicita acesso a carteira Ethereum se necessário
            await ethereum.enable()
            console.log("Usando nova versão");
            // Contas agora estão expostas                  
        } catch (error) { // Usuário ainda não deu permissão para acessar a carteira Ethereum        
            alert('Por favor, dê permissão para acessarmos a sua carteira Ethereum.');
            $('#statusConexao').text('Desconectado');
        }
    } else if (window.web3) { // Navegadores DApp antigos
        window.conexaoComEthereum = new Web3(web3.currentProvider)
    } else { // 
        alert('Para utilizar os nossos serviços você precisa instalar o Metamask. Por favor, visite: metamask.io');
    }
    verificaConta();
});
