var contaUsuario;

// Verifica a conexão Web3 e a conta do usuario
function verificaConta() {
    // Verifica o status da conexão 
    if (web3 && web3.isConnected()) {
        if (web3.eth.accounts[0] == undefined)  {
            console.info('Não esta conectado ao Metamask');
            $('#statusConexao').text('Desconectado');  
        }  else {
            console.info('Conectado. Qual versão da lib Web3 foi injetado pelo Metamask? ' + web3.version.api);
            contaUsuario = web3.eth.accounts[0];
            $('#statusConexao').text('Conectado a conta ' + contaUsuario);  
        }
    } else {
        $('#statusConexao').text('Desconectado');
    }
}

window.addEventListener('load', async (event) => {
    // Navegadores com novo Metamask    
    if (window.ethereum) {
        window.web3 = new Web3(ethereum);
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
        window.web3 = new Web3(web3.currentProvider)
    } else { // 
        alert('Para utilizar os nossos serviços você precisa instalar o Metamask. Por favor, visite: metamask.io');
    }
    verificaConta();
});
