// Inicialização de variáveis globais
if (!variable_global_exists("respondido")) {
    global.respondido = false;
    global.opcao_selecionada = -1;
    global.mensagem_alerta = "";
    global.alerta_visivel = false;
}

if (!variable_global_exists("pulos_restantes")) {
    global.pulos_restantes = 3; // Inicia com 3 pulos
}

if (!variable_global_exists("pulosa_esgotados")) {
    global.pulos_esgotados = false; // Variável para verificar se os pulos foram esgotados
}

// Iniciar a pergunta atual
if (!variable_instance_exists(self, "pergunta_atual")) {
    pergunta_atual = 0;
}

// Carregar as imagens das cartas
carta1_img = object_get_sprite(0);
carta2_img = object_get_sprite(1);
carta3_img = object_get_sprite(2);

// Criar o array de cartas e embaralhar
cartas = [carta1_img, carta1_img, carta2_img, carta3_img];
//farray_shuffle(cartas);

// Variável para armazenar a carta selecionada
carta_selecionada = -1; // -1 significa nenhuma carta selecionada
quadrado_selecionado = -1; // -1 significa nenhum quadrado selecionado