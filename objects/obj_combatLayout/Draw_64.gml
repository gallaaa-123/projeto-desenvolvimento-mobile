// Inicializações
if (!variable_global_exists("respondido")) {
    global.respondido = false;
    global.opcao_selecionada = -1;
    global.mensagem_alerta = "";
    global.alerta_visivel = false;
}
if (!variable_instance_exists(self, "pergunta_atual")) {
    pergunta_atual = 0;
}

// Perguntas
perguntas = [
  {
    pergunta: "Qual o maior rio da Amazônia?",
    opcoes: ["1) Rio Amazonas", "2) Rio Tietê", "3) Rio Paraná", "4) Rio São Francisco"],
    resposta_correta: "1) Rio Amazonas"
  },
  {
    pergunta: "Qual era o nome da província que deu origem ao estado do Pará?",
    opcoes: ["1) Província do Antigo Pará", "2) Belém", "3) Província do Parazinho", "4) Grão-Pará"],
    resposta_correta: "4) Grão-Pará"
  },
  {
    pergunta: "Qual é o ponto mais alto do Brasil?",
    opcoes: ["1) Pico da Neblina", "2) Pico do Jaraguá", "3) Pico das Agulhas Negras", "4) Monte Roraima"],
    resposta_correta: "1) Pico da Neblina"
  }
];

// Inicializa as variáveis
if (!variable_global_exists("cartas_visivel")) {
    global.cartas_visivel = false;
}

if (!variable_global_exists("pulos_restantes")) {
    global.pulos_restantes = 3;  // Inicializa o número de pulos restantes
}

// GUI base
var corFundo = make_color_rgb(230, 100, 20);
var padding = 32;

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

var statusLargura = gui_w * 0.69;
var actionLargura = gui_w * 0.25;
var painelAltura = 350;

var statusX = padding;
var statusY = gui_h - painelAltura - padding;

var actionX = gui_w - actionLargura - padding;
var actionY = gui_h - painelAltura - padding;

// Painéis
draw_set_color(corFundo);
draw_roundrect(statusX, statusY, statusX + statusLargura, statusY + painelAltura, false);
draw_roundrect(actionX, actionY, actionX + actionLargura, actionY + painelAltura, false);

// Número da pergunta
draw_set_color(c_white);
draw_set_font(Font_Large);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

var numero = string(pergunta_atual + 1);
if (string_length(numero) == 1) numero = "0" + numero;
var numeroPergunta = numero + " de " + string(array_length(perguntas));
draw_text(statusX + statusLargura / 2, statusY + 20, numeroPergunta);

// Dados da pergunta
var pergunta_data = perguntas[pergunta_atual];
var pergunta = pergunta_data.pergunta;
var opcoes = pergunta_data.opcoes;
var resposta_correta = pergunta_data.resposta_correta;

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(Font_Large_Zoom);

var perguntaX = statusX + 24;
var perguntaY = statusY + 60;
draw_text(perguntaX, perguntaY, pergunta);

// Opções
var mouseX = device_mouse_x(0);
var mouseY = device_mouse_y(0);
var espacamento = 45;
var inicioY = perguntaY + 100;

for (var i = 0; i < array_length(opcoes); i++) {
    var texto = opcoes[i];
    var texto_x = perguntaX;
    var texto_y = inicioY + i * espacamento;

    draw_set_font(Font_Large);
    var largura = string_width(texto);
    var altura = string_height(texto);

    var hover = mouseX > texto_x && mouseX < texto_x + largura && mouseY > texto_y && mouseY < texto_y + altura;

    // Verifica clique
    if (!global.respondido && hover && mouse_check_button_pressed(mb_left)) {
        global.opcao_selecionada = i;
        global.respondido = true;
        global.alerta_visivel = true;

        if (texto == resposta_correta) {
            global.mensagem_alerta = "Resposta correta!";
        } else {
            global.mensagem_alerta = "Resposta errada!";
        }
    }

    // Cores
    if (global.respondido) {
        if (texto == resposta_correta) {
            draw_set_color(c_lime);
        } else if (i == global.opcao_selecionada) {
            draw_set_color(c_red);
        } else {
            draw_set_color(c_white);
        }
    } else {
        draw_set_color(hover ? c_black : c_white);
        draw_set_font(hover ? Font_Large_Zoom : Font_Large);
    }

    draw_text(texto_x, texto_y, texto);
	
	// Lógica para tachar as alternativas erradas
    if (global.respondido == false && carta_selecionada != -1) {
        var resposta_errada_tachada = false;
        if (carta_selecionada == carta1_img) {
            // Tachar UMA alternativa errada
            for (var j = 0; j < array_length(opcoes); j++) {
                if (opcoes[j] != resposta_correta && !resposta_errada_tachada) {
                    draw_set_color(c_red);
                    draw_line(texto_x, texto_y + altura / 2, texto_x + largura, texto_y + altura / 2);
                    resposta_errada_tachada = true;
                    break; // Tacha apenas uma
                }
            }
        } else if (carta_selecionada == carta2_img) {
            // Tachar DUAS alternativas erradas
            var contador_tachadas = 0;
            for (var j = 0; j < array_length(opcoes); j++) {
                if (opcoes[j] != resposta_correta && contador_tachadas < 2) {
                    draw_set_color(c_red);
                    draw_line(texto_x, texto_y + altura / 2, texto_x + largura, texto_y + altura / 2);
                    contador_tachadas++;
                }
            }
        } else if (carta_selecionada == carta3_img) {
            // Tachar TRÊS alternativas erradas
            var contador_tachadas = 0;
            for (var j = 0; j < array_length(opcoes); j++) {
                if (opcoes[j] != resposta_correta && contador_tachadas < 3) {
                    draw_set_color(c_red);
                    draw_line(texto_x, texto_y + altura / 2, texto_x + largura, texto_y + altura / 2);
                    contador_tachadas++;
                }
            }
        }
    }
}

// Botões laterais
var botoes = ["Cartas", "Placas", "Convidados", "Pular " + string(global.pulos_restantes) + "x"];
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var esp = 60;
var y_total = (array_length(botoes) - 1) * esp;
var y_inicial = actionY + painelAltura / 2 - y_total / 2;

for (var i = 0; i < array_length(botoes); i++) {
    var tx = actionX + actionLargura / 2;
    var ty = y_inicial + i * esp;

    var largura = string_width(botoes[i]);
    var altura = string_height(botoes[i]);

    var hover = mouseX > tx - largura / 2 && mouseX < tx + largura / 2 && mouseY > ty - altura / 2 && mouseY < ty + altura / 2;

    draw_set_color(hover ? c_black : c_white);
    draw_set_font(hover ? Font_Large_Zoom : Font_Large);
    draw_text(tx, ty, botoes[i]);

    // Verifica clique em "Cartas"
    if (!global.respondido && hover && mouse_check_button_pressed(mb_left) && botoes[i] == "Cartas") {
        global.cartas_visivel = !global.cartas_visivel; // Alterna a visibilidade
    }

    // Verifica clique em "Pular"
    if (!global.respondido && hover && mouse_check_button_pressed(mb_left) && botoes[i] == "Pular " + string(global.pulos_restantes) + "x" && global.pulos_restantes > 0) {
        global.pulos_restantes--;
        global.respondido = true;
        global.alerta_visivel = true;
        global.mensagem_alerta = "Você pulou a pergunta!";
    }
}

// Desenha o container de Cartas
if (global.cartas_visivel) {
    var cartasX = statusX;
    var cartasY = statusY - 120; // Acima dos outros containers
    var cartasLargura = 1300;
    var cartasAltura = 100;

    draw_set_color(corFundo);
    draw_roundrect(cartasX, cartasY, cartasX + cartasLargura, cartasY + cartasAltura, false);
	
	// Desenha as imagens das cartas abaixo dos quadrados
    var cartaLargura = 60;
    var espacamentoCartas = espacamentoQuadrados; // Usando o mesmo espaçamento para consistência
    var cartaY = quadradoY + quadradoLargura + 10; // Abaixo dos quadrados

    for (var i = 0; i < array_length(cartas); i++) {
        var cartaX = cartasX + espacamentoQuadrados + (i * (cartaLargura + espacamentoCartas));
        draw_sprite(cartas[i], 0, cartaX + cartaLargura / 2, cartaY + cartaLargura / 2); // Desenha centralizado
    }

    // Desenha os 4 quadrados arredondados dentro do container de Cartas
    var quadradoLargura = 60;
    var espacamentoQuadrados = (cartasLargura - (quadradoLargura * 4)) / 5; // Espaço entre os quadrados
    var quadradoY = cartasY + (cartasAltura - quadradoLargura) / 2; // Centraliza verticalmente

    for (var i = 0; i < 4; i++) {
        var quadradoX = cartasX + espacamentoQuadrados + (i * (quadradoLargura + espacamentoQuadrados));
        draw_set_color(c_black);
        draw_roundrect(quadradoX, quadradoY, quadradoX + quadradoLargura, quadradoY + quadradoLargura, false); // Alterado para 'false' para preencher
    }
	
	// Detecta clique no quadrado
    if (global.cartas_visivel && !global.respondido && mouseX > quadradoX && mouseX < quadradoX + quadradoLargura && mouseY > quadradoY && mouseY < quadradoY + quadradoLargura && mouse_check_button_pressed(mb_left)) {
        if (quadrado_selecionado == -1) { // Permite selecionar apenas um quadrado por vez
            quadrado_selecionado = i;
            carta_selecionada = cartas[i];
            global.cartas_visivel = false; // Oculta as cartas após a seleção
        }
    }

    // Desenha algum indicador visual para o quadrado selecionado (opcional)
    if (quadrado_selecionado == i) {
        draw_set_color(c_yellow); // Exemplo: borda amarela
        draw_rectangle(quadradoX, quadradoY, quadradoX + quadradoLargura, quadradoY + quadradoLargura, true);
    }
}

// ALERTA de resposta
if (global.alerta_visivel) {
    var alerta_w = 400;
    var alerta_h = 200;
    var alerta_x = gui_w / 2 - alerta_w / 2;
    var alerta_y = gui_h / 2 - alerta_h / 2;

    draw_set_color(c_black);
    draw_roundrect(alerta_x, alerta_y, alerta_x + alerta_w, alerta_y + alerta_h, false);

    draw_set_color(c_white);
    draw_set_font(Font_Large_Zoom);
    draw_set_halign(fa_center);
    draw_text(alerta_x + alerta_w / 2, alerta_y + 40, global.mensagem_alerta);

    var btn_w = 180;
    var btn_h = 60;
    var btn_x = alerta_x + alerta_w / 2 - btn_w / 2;
    var btn_y = alerta_y + alerta_h - btn_h - 20;

    var btn_hover = mouseX > btn_x && mouseX < btn_x + btn_w && mouseY > btn_y && mouseY < btn_y + btn_h;

    draw_set_color(btn_hover ? c_lime : c_white);
    draw_roundrect(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, false);

    draw_set_color(c_black);
    draw_set_font(Font_Large);
    draw_set_valign(fa_middle);
    draw_text(btn_x + btn_w / 2, btn_y + btn_h / 2, "Próxima");

    // Verifica clique no botão
    if (btn_hover && mouse_check_button_pressed(mb_left)) {
        global.respondido = false;
        global.opcao_selecionada = -1;
        global.mensagem_alerta = "";
        global.alerta_visivel = false;

        pergunta_atual++;
        if (pergunta_atual >= array_length(perguntas)) {
            pergunta_atual = 0;
        }
    }
}
