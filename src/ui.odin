package game

import rl "vendor:raylib"
import "core:fmt"

draw_ui :: proc(gm: ^GameManager) {
    draw_ui_build_store(gm)
    draw_ui_health(gm)
    draw_ui_wave(gm)
    draw_ui_resources(gm)
    if gm.state == .MainMenu {
         rl.DrawTextPro(rl.GetFontDefault(), "PRESS ENTER TO START", grid_to_world(Vec2{8, 19}), {0,-10}, 0,14,5,rl.WHITE)
    }
    if gm.state == .PrepareBuilds {
        rl.DrawTextPro(rl.GetFontDefault(), "PRESS SPACE TO START NEXT WAVE", grid_to_world(Vec2{6, 19}), {0,-10}, 0,14,5,rl.WHITE)
    }
}

draw_ui_build_store :: proc(gm: ^GameManager) {
    rl.DrawTextPro(rl.GetFontDefault(), "BUILD STORE", grid_to_world(Vec2{1, 15}), {0,-10}, 0,24,2,rl.WHITE)
    initial_build_store_position := grid_to_world({1,17})
    build_offset: f32 = 0
    for i in 0..<4 {
        rl.DrawTexturePro(gm.builds_textures[i], {0,0,32,32},{initial_build_store_position.x + build_offset, initial_build_store_position.y, 32, 32}, {0,0}, 0, rl.WHITE)
        rl.DrawRectangleLinesEx({initial_build_store_position.x + build_offset, initial_build_store_position.y, 32, 32}, 1, rl.WHITE)
        if gm.state == .PrepareBuilds {
            if rl.CheckCollisionRecs({initial_build_store_position.x + build_offset, initial_build_store_position.y, 32, 32}, {rl.GetMousePosition().x, rl.GetMousePosition().y, 1, 1}) {
                rl.SetMouseCursor(.POINTING_HAND)
                if rl.IsMouseButtonPressed(.LEFT) {
                    gm.selected_build = true
                    gm.selected_build_type = BuildType(i)
                }
            }
        }
        initial_build_store_position.x += 32
        build_offset += 12
    }
}

draw_ui_health :: proc(gm: ^GameManager) {
    rl.DrawTextPro(rl.GetFontDefault(), "WAVE", grid_to_world(Vec2{8, 15}), {0,-10}, 0,24,2,rl.WHITE)
    rl.DrawTextPro(rl.GetFontDefault(), "1", grid_to_world(Vec2{8, 17}), {-32,0}, 0,32,1,rl.WHITE)

}

draw_ui_wave :: proc(gm: ^GameManager) {
    rl.DrawTextPro(rl.GetFontDefault(), "CORE HEALTH", grid_to_world(Vec2{12, 15}), {0,-10}, 0,24,2,rl.WHITE)
}

draw_ui_resources :: proc(gm: ^GameManager) {
    rl.DrawTextPro(rl.GetFontDefault(), "RESOURCES", grid_to_world(Vec2{19, 15}), {0,-10}, 0,24,2,rl.WHITE)
}
