// Parâmetros visuais
var corFundo = make_color_rgb(230, 100, 20); // Laranja
var borda = 8;
var padding = 32;

// Medidas da tela
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// Tamanhos dos painéis
var statusLargura = gui_w * 0.69;
var actionLargura = gui_w * 0.25;
var painelAltura = 350;

// Coordenadas do painel da esquerda (status + quiz)
var statusX = padding;
var statusY = gui_h - painelAltura - padding;

// Coordenadas do painel da direita (ações)
var actionX = gui_w - actionLargura - padding;
var actionY = gui_h - painelAltura - padding;

// --- Desenho dos painéis ---
draw_set_color(corFundo);
draw_roundrect(statusX, statusY, statusX + statusLargura, statusY + painelAltura, false);
draw_roundrect(actionX, actionY, actionX + actionLargura, actionY + painelAltura, false);

// --- Texto "01 de 25" centralizado ---
draw_set_color(c_white);
draw_set_font(Font_Large);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

var numeroPergunta = "01 de 25";
var numPergX = statusX + statusLargura / 2;
var numPergY = statusY + 20;
draw_text(numPergX, numPergY, numeroPergunta);

// --- Conteúdo específico para rooms de explicação ---
if (room == rm_resposta || room == rm_resposta_errada) {
    // Texto explicativo
    var textoExplicacao = 
    "A Província do Grão-Pará, que à época era comumente\n" +
    "chamada de Pará (do tupi-guarani, rio-mar ou rio grande),\n" +
    "foi uma unidade administrativa do final do período colonial\n" +
    "e do período imperial brasileiro, originada das capitanias\n" +
    "do Grão-Pará e do Rio Negro. Existiu de 1821 a 1889.";

    draw_set_font(Font_Medium);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var textX = statusX + 24;
    var textY = numPergY + 64;
    var larguraMax = statusLargura - 48;

    draw_text_ext(textX, textY, textoExplicacao, larguraMax, 6);

    // Texto "Resposta correta" ou "Resposta errada"
    var textoPainel = (room == rm_resposta) ? "Resposta correta" : "Resposta errada";

    draw_set_font(Font_Large);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(actionX + actionLargura / 2, actionY + painelAltura / 2, textoPainel);

    return; // Encerra o draw aqui para não exibir quiz ou ações
}

// --- Texto da pergunta e alternativas à esquerda ---
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var margem_interna = 24;
var perguntaX = statusX + margem_interna;
var perguntaY = numPergY + 40;

draw_set_font(Font_Large_Zoom);
var pergunta = "O Pará anteriormente era uma província.\nQual era o seu nome?";
draw_text(perguntaX, perguntaY, pergunta);

// --- Respostas abaixo da pergunta ---
var opcoes = [
    "1 - Provincia do Antigo Pará",
    "2 - Belém",
    "3 - Provincia do Parazinho",
    "4 - Grão-Pará"
];

var opcao_espacamento = 45;
var opcao_y_inicial = perguntaY + 100;

for (var i = 0; i < array_length(opcoes); i++) {
    var texto_y = opcao_y_inicial + i * opcao_espacamento;
    var texto_x = perguntaX;

    var mouseX = device_mouse_x(0);
    var mouseY = device_mouse_y(0);

    draw_set_font(Font_Large);
    var largura_texto = string_width(opcoes[i]);
    var altura_texto = string_height(opcoes[i]);

    var hoverX1 = texto_x;
    var hoverX2 = texto_x + largura_texto;
    var hoverY1 = texto_y;
    var hoverY2 = texto_y + altura_texto;

    var mouse_hover = (mouseX > hoverX1 && mouseX < hoverX2 && mouseY > hoverY1 && mouseY < hoverY2);

    if (mouse_hover) {
        draw_set_color(c_black);
        draw_set_font(Font_Large_Zoom);
    } else {
        draw_set_color(c_white);
        draw_set_font(Font_Large);
    }

    draw_text(texto_x, texto_y, opcoes[i]);
}

// --- Textos no painel da direita com hover ---
var textos_opcoes = ["Cartas", "Placas", "Convidados", "Pular 3x"];
var quantidade = array_length(textos_opcoes);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var texto_espacamento = 60;
var altura_total = (quantidade - 1) * texto_espacamento;
var texto_y_inicial = actionY + (painelAltura / 2) - (altura_total / 2);

for (var i = 0; i < quantidade; i++) {
    var texto_y = texto_y_inicial + i * texto_espacamento;
    var texto_x = actionX + actionLargura / 2;

    var mouseX = device_mouse_x(0);
    var mouseY = device_mouse_y(0);

    draw_set_font(Font_Large);
    var largura_texto = string_width(textos_opcoes[i]);
    var altura_texto = string_height(textos_opcoes[i]);

    var hoverX1 = texto_x - largura_texto / 2;
    var hoverX2 = texto_x + largura_texto / 2;
    var hoverY1 = texto_y - altura_texto / 2;
    var hoverY2 = texto_y + altura_texto / 2;

    var mouse_hover = (mouseX > hoverX1 && mouseX < hoverX2 && mouseY > hoverY1 && mouseY < hoverY2);

    if (mouse_hover) {
        draw_set_color(c_black);
        draw_set_font(Font_Large_Zoom);
    } else {
        draw_set_color(c_white);
        draw_set_font(Font_Large);
    }

    draw_text(texto_x, texto_y, textos_opcoes[i]);
}
