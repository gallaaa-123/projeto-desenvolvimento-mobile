// Coordenadas para detectar clique nas alternativas
var gui_w = display_get_gui_width();
var margem_interna = 24;
var perguntaX = 32 + margem_interna;
var perguntaY = display_get_gui_height() - 350 - 32 + 20 + 40;
var espacamento = 45;
var opcoes = [
    "1 - Provincia do Antigo Pará",
    "2 - Belém",
    "3 - Provincia do Parazinho",
    "4 - Grão-Pará"
];

// Detecta clique em cada alternativa
for (var i = 0; i < array_length(opcoes); i++) {
    var texto = opcoes[i];
    var _y = perguntaY + 100 + (i * espacamento);
    var w = string_width(texto);
    var h = string_height(texto);
    var mouseX = device_mouse_x(0);
    var mouseY = device_mouse_y(0);

    if (mouseX > perguntaX && mouseX < perguntaX + w && mouseY > y && mouseY < y + h) {
        if (i == 3) {
            room_goto(rm_resposta); // Certa
        } else {
            room_goto(rm_resposta_errada); // Errada
        }
    }
}
