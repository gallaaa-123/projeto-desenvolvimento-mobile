// Inicializações (mantendo apenas as necessárias aqui)
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

// Charadas para cada pergunta
charadas = [
    "Ele se estende por 6992 km desde a cordilheira dos Andes, no Peru, até a sua foz, na ilha de Marajó, no litoral do estado brasileiro do Pará.",
    "Surgiu com a expansão do território e da influência da Capitania do Pará, que era uma unidade administrativa colonial portuguesa.",
    "É localizado no estado do Amazonas, com uma altitude de 2.995,3 metros acima do nível do mar."
];

// GUI base
var corFundo = #E80808;
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
    var tachado = false; // Variável para verificar se a opção está tachada

    // Verifica clique
    if (!global.respondido && hover && mouse_check_button_pressed(mb_left)) {
        // Só permite selecionar se não estiver tachado (após usar uma carta) ou se nenhuma carta foi usada
        var esta_tachado = false;
        if (global.ajuda_cartas_usada) {
            if (global.carta_usada == 1 && opcoes[i] != resposta_correta && global.tachadas_carta1[i]) esta_tachado = true;
            if (global.carta_usada == 2 && opcoes[i] != resposta_correta && global.tachadas_carta2[i]) esta_tachado = true;
            if (global.carta_usada == 3 && opcoes[i] != resposta_correta && global.tachadas_carta3[i]) esta_tachado = true;
        }
        if (!global.ajuda_cartas_usada || !esta_tachado) {
            global.opcao_selecionada = i;
            global.respondido = true;
            global.alerta_visivel = true;

            if (texto == resposta_correta) {
                global.mensagem_alerta = "Resposta correta!";
            } else {
                global.mensagem_alerta = "Resposta errada!";
            }
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
    if (!global.respondido && global.ajuda_cartas_usada) {
        draw_set_color(c_white);
        draw_set_font(Font_Large);
        var meio_altura = texto_y + altura / 2;
        if (global.carta_usada == 1 && global.tachadas_carta1[i]) {
            draw_line(texto_x, meio_altura, texto_x + largura, meio_altura);
        } else if (global.carta_usada == 2 && global.tachadas_carta2[i]) {
            draw_line(texto_x, meio_altura, texto_x + largura, meio_altura);
        } else if (global.carta_usada == 3 && global.tachadas_carta3[i]) {
            draw_line(texto_x, meio_altura, texto_x + largura, meio_altura);
        }
    }
}

// Botões laterais
var botoes = ["Cartas", "Teste sua sorte", "Charada", "Pular " + string(global.pulos_restantes) + "x"];
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

    // Define a cor do texto dos botões
    var cor_botao = hover ? c_black : c_white;
    var fonte_botao = hover ? Font_Large_Zoom : Font_Large;
    if ((botoes[i] == "Charada" && (global.ajuda_convidados_usada || !global.pode_abrir_charada)) || (botoes[i] == "Cartas" && global.ajuda_cartas_usada) || (botoes[i] == "Teste sua sorte" && global.teste_sorte_usado)) {
        cor_botao = c_gray;
        fonte_botao = Font_Large;
    }

    draw_set_color(cor_botao);
    draw_set_font(fonte_botao);
    draw_text(tx, ty, botoes[i]);

    // Verifica clique em "Cartas"
    if (!global.respondido && hover && mouse_check_button_pressed(mb_left) && botoes[i] == "Cartas" && !global.ajuda_cartas_usada) {
        global.cartas_visivel = !global.cartas_visivel;
        global.teste_sorte_visivel = false;
        global.convidados_visivel = false;
    }

    // Verifica clique em "Teste sua sorte"
    if (!global.respondido && hover && mouse_check_button_pressed(mb_left) && botoes[i] == "Teste sua sorte" && !global.teste_sorte_usado) {
        global.teste_sorte_visivel = !global.teste_sorte_visivel;
        global.cartas_visivel = false;
        global.convidados_visivel = false;
    }

    // Verifica clique em "Charada"
    if (!global.respondido && hover && mouse_check_button_pressed(mb_left) && botoes[i] == "Charada" && global.pode_abrir_charada && !global.ajuda_convidados_usada) {
        global.convidados_visivel = !global.convidados_visivel;
        global.teste_sorte_visivel = false;
        global.cartas_visivel = false;
        global.ajuda_convidados_usada = true;
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
    var cartasY = 20;
    var cartasLargura = 1300;
    var cartasAltura = 350;
    draw_set_color(corFundo);
    draw_roundrect(cartasX, cartasY, cartasX + cartasLargura, cartasY + cartasAltura, false);
    var quadradoLargura = 200;
    var espacamentoQuadrados = (cartasLargura - (quadradoLargura * 4)) / 5;
    var quadradoY = cartasY + (cartasAltura - quadradoLargura) / 2;
    var quadradoAltura = quadradoLargura; // Definindo quadradoAltura aqui também por segurança
    for (var i = 0; i < 4; i++) {
        var quadradoX = cartasX + espacamentoQuadrados + (i * (quadradoLargura + espacamentoQuadrados));
        draw_set_color(c_black);
        draw_roundrect(quadradoX, quadradoY, quadradoX + quadradoLargura, quadradoY + quadradoAltura, false);
        var carta_sprite_index = cartas_sprites[i]; // Usa o array de sprites
        if (!global.respondido && mouseX > quadradoX && mouseX < quadradoX + quadradoLargura && mouseY > quadradoY && mouseY < quadradoY + quadradoAltura && mouse_check_button_pressed(mb_left) && !global.ajuda_cartas_usada) {
            global.ajuda_cartas_usada = true;
            global.cartas_visivel = false;
            global.teste_sorte_visivel = false;
            global.convidados_visivel = false;

            var pergunta_data = perguntas[pergunta_atual];
            var resposta_correta = pergunta_data.resposta_correta;
            var opcoes = pergunta_data.opcoes;

            // Lógica para definir qual carta foi usada e quais opções tachar (SOMENTE AS INCORRETAS)
            if (i == 1) { // Segunda carta
                global.carta_usada = 1;
                global.tachadas_carta1 = array_create(array_length(opcoes), false);
                for (var j = 0; j < array_length(opcoes); j++) {
                    if (opcoes[j] != resposta_correta) {
                        global.tachadas_carta1[j] = true;
                    }
                }
            } else if (i == 2) { // Terceira carta
                global.carta_usada = 2;
                global.tachadas_carta2 = array_create(array_length(opcoes), false);
                for (var j = 0; j < array_length(opcoes); j++) {
                    if (opcoes[j] != resposta_correta) {
                        global.tachadas_carta2[j] = true;
                    }
                }
            } else if (i == 3) { // Quarta carta
                global.carta_usada = 3;
                global.tachadas_carta3 = array_create(array_length(opcoes), false);
                for (var j = 0; j < array_length(opcoes); j++) {
                    if (opcoes[j] != resposta_correta) {
                        global.tachadas_carta3[j] = true;
                    }
                }
            }
        }
        if (global.ajuda_cartas_usada) {
            draw_set_color(c_gray);
            draw_roundrect(quadradoX, quadradoY, quadradoX + quadradoLargura, quadradoY + quadradoAltura, false);
        }
        if (sprite_exists(carta_sprite_index)) {
            var scale = min(quadradoLargura / sprite_get_width(carta_sprite_index), quadradoAltura / sprite_get_height(carta_sprite_index));
            draw_sprite_ext(carta_sprite_index, 0, quadradoX + quadradoLargura / 2, quadradoY + quadradoAltura / 2, scale, scale, 0, c_white, 1);
        }
    }
}

// Desenha o container de "Teste sua sorte"
if (global.teste_sorte_visivel) {
    var cartasX = statusX;
    var cartasY = 20;
    var cartasLargura = 1300;
    var cartasAltura = 350;
    draw_set_color(corFundo);
    draw_roundrect(cartasX, cartasY, cartasX + cartasLargura, cartasY + cartasAltura, false);
    var quadradoLargura = 200;
    var espacamentoQuadrados = (cartasLargura - (quadradoLargura * 4)) / 5;
    var quadradoY = cartasY + (cartasAltura - quadradoLargura) / 2;
    // Definindo quadradoAltura AQUI!
    var quadradoAltura = quadradoLargura;
    for (var i = 0; i < 4; i++) {
        var quadradoX = cartasX + espacamentoQuadrados + (i * (quadradoLargura + espacamentoQuadrados));
        draw_set_color(c_black);
        draw_roundrect(quadradoX, quadradoY, quadradoX + quadradoLargura, quadradoY + quadradoAltura, false);
        var carta_sprite_index = cartas_sprites[i]; // Usa o mesmo array de sprites
        if (!global.respondido && mouseX > quadradoX && mouseX < quadradoX + quadradoLargura && mouseY > quadradoY && mouseY < quadradoY + quadradoAltura && mouse_check_button_pressed(mb_left) && !global.teste_sorte_usado) {
            global.teste_sorte_usado = true;
            global.teste_sorte_visivel = false;
            global.cartas_visivel = false;
            global.convidados_visivel = false;
            global.carta_sorte_selecionada = i; // Armazena a carta selecionada (índice)
            // (Lógica de ação da carta de sorte será adicionada posteriormente)
        }
        if (global.teste_sorte_usado) {
            draw_set_color(c_gray);
            draw_roundrect(quadradoX, quadradoY, quadradoX + quadradoLargura, quadradoY + quadradoAltura, false);
        }
        if (sprite_exists(carta_sprite_index)) {
            var scale = min(quadradoLargura / sprite_get_width(carta_sprite_index), quadradoAltura / sprite_get_height(carta_sprite_index));
            draw_sprite_ext(carta_sprite_index, 0, quadradoX + quadradoLargura / 2, quadradoY + quadradoAltura / 2, scale, scale, 0, c_white, 1);
        }
    }
}

// Desenha o container de Charadas
if (global.convidados_visivel) {
    var convidadosX = statusX;
    var convidadosY = 20;
    var convidadosLargura = 1300;
    var convidadosAltura = 350;
    draw_set_color(corFundo);
    draw_roundrect(convidadosX, convidadosY, convidadosX + convidadosLargura, convidadosY + convidadosAltura, false);

    var charada_padding = 20;
    var charada_x = convidadosX + charada_padding;
    var charada_y = convidadosY + charada_padding;
    var charada_largura = convidadosLargura - 2 * charada_padding;
    var charada_altura = convidadosAltura - 2 * charada_padding;

    draw_set_color(c_black);
    draw_set_font(Font_Medium);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_text_ext(charada_x, charada_y, charadas[pergunta_atual], charada_largura, charada_altura);
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

    // Verifica clique no botão "Próxima"
    if (btn_hover && mouse_check_button_pressed(mb_left)) {
        global.respondido = false;
        global.opcao_selecionada = -1;
        global.mensagem_alerta = "";
        global.alerta_visivel = false;
        global.ajuda_convidados_usada = false;
        global.pode_abrir_charada = true;
        global.ajuda_cartas_usada = false;
        global.teste_sorte_usado = false; // Reseta o uso do "Teste sua sorte"
        global.carta_usada = 0;
        global.carta_sorte_selecionada = -1; // Reseta a carta de sorte selecionada
        global.tachadas_carta1 = array_create(4, false); // Reseta as tachadas
        global.tachadas_carta2 = array_create(4, false);
        global.tachadas_carta3 = array_create(4, false);

        pergunta_atual++;
        if (pergunta_atual >= array_length(perguntas)) {
            pergunta_atual = 0;
        }
        quadrado_selecionado = -1;
        carta_selecionada = -1;
    }
}