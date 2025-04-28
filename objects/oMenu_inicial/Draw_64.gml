// === DESENHA A IMAGEM DE FUNDO ===
draw_set_alpha(1); // Fundo 100% opaco
draw_sprite_stretched(spr_background_menu, 0, 0, 0, display_get_gui_width(), display_get_gui_height());

// Camada escura semi-transparente por cima do fundo
draw_set_alpha(0.4);
draw_set_color(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

// === OBTÉM A POSIÇÃO DO MOUSE NA GUI ===
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

draw_set_font(fmenu_inicial);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// === DESENHA O TEXTO "ALEXANDRIA SYSTEM" COMO LOGO ===
draw_set_color(c_white); // Define a cor branca para a logo
var _wgui = display_get_gui_width();
var _hgui = display_get_gui_height();
var _hstr = string_height("I"); // Obtém altura da fonte

var logo_y_pos = (_hgui / 4); // Posição da logo no topo
draw_text(_wgui / 2, logo_y_pos, "ALEXANDRIA SYSTEM");

// === LOOP PARA DESENHAR OS ITENS DO MENU ===
var tam_menu = array_length(menu_inicial);
for (var i = 0; i < tam_menu; i++)
{
    var _wstr = string_width(menu_inicial[i]);
    
    var espacamento = _hstr * 1.5; // Ajuste do espaçamento
    var y_pos = (_hgui / 2) - ((tam_menu - 1) * espacamento / 2) + (i * espacamento);
    
    var x1 = _wgui / 2 - _wstr / 2;
    var y1 = y_pos - _hstr / 2;
    var x2 = _wgui / 2 + _wstr / 2;
    var y2 = y_pos + _hstr / 2;

    // === VERIFICA SE O MOUSE ESTÁ SOBRE O ITEM DO MENU ===
    if (point_in_rectangle(_mx, _my, x1, y1, x2, y2))
    {
        draw_set_color(c_white); // Texto branco quando o mouse está em cima
        esc[i] = lerp(esc[i], 1.4, 0.15); // Aumenta tamanho suavemente
        
        if (mouse_check_button_pressed(mb_left))
        {
            switch menu_inicial[i]
            {
                case menu_inicial[0]: // Jogar
                    room_goto_next();
                break;
                case menu_inicial[1]: // Opções
                    show_message("Tenho que configurar algumas coisas");
                break;
				case menu_inicial[2]: // Extras
				    show_message("Vejam nossas artworks");
				break;
                case menu_inicial[3]: // Sair
                    game_end();
                break;
            }
        }
    }
    else
    {
        draw_set_color(c_black); // Texto preto normalmente
        esc[i] = lerp(esc[i], 1, 0.15); // Retorna ao tamanho normal
    }
    
    // === DESENHA O TEXTO DO MENU COM TRANSFORMAÇÃO ===
    draw_text_transformed(_wgui / 2, y_pos, menu_inicial[i], esc[i], esc[i], 0);
}

// === RESETANDO CONFIGURAÇÕES ===
draw_set_halign(-1);
draw_set_valign(-1);
draw_set_font(-1);
