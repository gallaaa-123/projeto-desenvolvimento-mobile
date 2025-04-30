if (!variable_global_exists("respondido")) {
    global.respondido = false;
    global.opcao_selecionada = -1;
    global.mensagem_alerta = "";
    global.alerta_visivel = false;
}

if (!variable_global_exists("pulos_restantes")) {
    global.pulos_restantes = 3; // Inicia com 3 pulos
}

if (!variable_global_exists("pulos_esgotados")) {
    global.pulos_esgotados = false; // Variável para verificar se os pulos foram esgotados
}

if (!variable_global_exists("ajuda_cartas_usada")) {
    global.ajuda_cartas_usada = false; // Variável para controlar o uso único das cartas
}

if (!variable_global_exists("carta_usada")) {
    global.carta_usada = 0; // Variável para armazenar qual carta foi usada (1, 2 ou 3)
}

// Inicializa as variáveis globais para controlar as tachadas das cartas
if (!variable_global_exists("tachadas_carta1")) global.tachadas_carta1 = array_create(4, false); // Assumindo 4 opções por pergunta
if (!variable_global_exists("tachadas_carta2")) global.tachadas_carta2 = array_create(4, false);
if (!variable_global_exists("tachadas_carta3")) global.tachadas_carta3 = array_create(4, false);

// Inicializa a variável global para controle do "Teste sua sorte"
if (!variable_global_exists("teste_sorte_usado")) {
    global.teste_sorte_usado = false;
}

// Inicializa a variável global de visibilidade do "Teste sua sorte"
if (!variable_global_exists("teste_sorte_visivel")) {
    global.teste_sorte_visivel = false;
}

// Inicializa a variável global para armazenar a carta de sorte selecionada
if (!variable_global_exists("carta_sorte_selecionada")) {
    global.carta_sorte_selecionada = -1;
}

// Iniciar a pergunta atual
if (!variable_instance_exists(self, "pergunta_atual")) {
    pergunta_atual = 0;
}

// Carregar as imagens das cartas (usando os nomes dos sprites diretamente)
carta1_sprite = carta1; // Obtenha o ID do sprite
carta2_sprite = carta2; // Obtenha o ID do sprite
carta3_sprite = carta3; // Obtenha o ID do sprite

// Criar o array de sprites das cartas para exibição no container
cartas_sprites = [carta1_sprite, carta1_sprite, carta2_sprite, carta3_sprite];

// Variável para armazenar a carta selecionada (índice do sprite) - não mais usada para tachar diretamente
carta_selecionada = -1; // -1 significa nenhuma carta selecionada
quadrado_selecionado = -1; // -1 significa nenhum quadrado selecionado

// Inicializa as variáveis de visibilidade dos containers
if (!variable_global_exists("cartas_visivel")) {
    global.cartas_visivel = false;
}
if (!variable_global_exists("convidados_visivel")) {
    global.convidados_visivel = false;
}

if (!variable_global_exists("probabilidades_convidados")) {
    global.probabilidades_convidados = [25, 25, 25, 25];
}
if (!variable_global_exists("ajuda_convidados_usada")) {
    global.ajuda_convidados_usada = false;
}

global.pode_abrir_charada = true;
global.ajuda_convidados_usada = false; // Garante que a ajuda pode ser usada novamente ao reiniciar