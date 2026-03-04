// 0. API base URL (ajuste aqui sem precisar caçar no código)
const API_BASE_URL = 'http://localhost:3000';

// 1. Ligar o JavaScript aos elementos do HTML
const formLogin = document.getElementById('form-login');
const inputIdentificacao = document.getElementById('identificacao');
const inputSenha = document.getElementById('senha');
const mensagemErro = document.getElementById('mensagem-erro');
const btnRevelar = document.getElementById('btn-revelar');
const iconeOlho = document.getElementById('icone-olho');
const capsAviso = document.getElementById('caps-aviso');
const btnEntrar = formLogin.querySelector('button[type="submit"]');

// 2. Lógica para Mostrar/Ocultar a Senha
btnRevelar.addEventListener('click', function() {
    if (inputSenha.type === 'password') {
        inputSenha.type = 'text'; 
        iconeOlho.innerHTML = `<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line>`;
    } else {
        inputSenha.type = 'password'; 
        iconeOlho.innerHTML = `<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle>`;
    }
});

// 3. Lógica para detetar o Caps Lock ativado
inputSenha.addEventListener('keyup', function(evento) {
    if (evento.getModifierState('CapsLock')) {
        capsAviso.style.display = 'block'; 
    } else {
        capsAviso.style.display = 'none'; 
    }
});

// Limpa a borda vermelha quando o usuário volta a digitar
function limparErroAoDigitar(input) {
    input.addEventListener('input', function() {
        this.classList.remove('erro-input');
        if (mensagemErro.textContent !== 'Verificando dados...') {
            mensagemErro.textContent = ''; 
        }
    });
}
limparErroAoDigitar(inputIdentificacao);
limparErroAoDigitar(inputSenha);

// Função para validar formato de e-mail (Refinamento)
const validarEmail = (email) => {
    return String(email)
        .toLowerCase()
        .match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/);
};

// 4. COMUNICAÇÃO COM O BACK-END AO CLICAR EM "ENTRAR"
formLogin.addEventListener('submit', async function(evento) {
    
    evento.preventDefault(); 
    
    // Reset visual
    mensagemErro.textContent = '';
    mensagemErro.style.color = '#ff4d4d'; 
    inputIdentificacao.classList.remove('erro-input');
    inputSenha.classList.remove('erro-input');

    const valorIdentificacao = inputIdentificacao.value.trim();
    const valorSenha = inputSenha.value; // Removido trim da senha (senhas podem ter espaços)

    // Validações locais
    if (valorIdentificacao === '') {
        mensagemErro.textContent = 'Por favor, informe seu e-mail.';
        inputIdentificacao.classList.add('erro-input');
        return; 
    }

    if (!validarEmail(valorIdentificacao)) {
        mensagemErro.textContent = 'Por favor, insira um e-mail válido.';
        inputIdentificacao.classList.add('erro-input');
        return;
    }

    if (valorSenha === '') {
        mensagemErro.textContent = 'Por favor, digite sua senha.';
        inputSenha.classList.add('erro-input');
        return; 
    }

    // Bloqueia o botão para evitar cliques múltiplos
    btnEntrar.disabled = true;
    const textoOriginalBotao = btnEntrar.innerText;
    btnEntrar.innerText = 'Verificando...';
    
    mensagemErro.style.color = 'var(--texto-suave)';
    mensagemErro.textContent = 'Verificando dados...';

    try {
        const respostaServidor = await fetch(`${API_BASE_URL}/login`, {
            method: 'POST', 
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                email: valorIdentificacao,
                password: valorSenha
            })
        });

        const dados = await respostaServidor.json();

        if (!respostaServidor.ok) {
            mensagemErro.style.color = '#ff4d4d';
            mensagemErro.textContent = dados.message || 'Erro ao fazer login.';
            inputIdentificacao.classList.add('erro-input');
            inputSenha.classList.add('erro-input');
            return;
        }

        // SUCESSO!
        mensagemErro.style.color = 'var(--fluxa-azul)'; 
        mensagemErro.innerHTML = `✅ <b>Acesso liberado!</b> Bem-vindo, ${dados.user.nome}`;
        
        // Salva os dados no navegador (Persistência)
        localStorage.setItem('fluxa_user', JSON.stringify(dados.user));
        
        inputIdentificacao.value = '';
        inputSenha.value = '';
        capsAviso.style.display = 'none';
        
        setTimeout(() => {
            console.log("Redirecionando usuário ID:", dados.user.id);
            // window.location.href = 'painel.html';
        }, 1500);

    } catch (erro) {
        mensagemErro.style.color = '#ff4d4d';
        mensagemErro.textContent = 'Erro de conexão. O servidor está ligado?';
        console.error("Erro no fetch:", erro);
    } finally {
        // Libera o botão novamente
        btnEntrar.disabled = false;
        btnEntrar.innerText = textoOriginalBotao;
    }
});