package game

import rl "vendor:raylib"
import "core:fmt"

BLINK_TIME_ON :: 1.5
BLINK_TIME_OFF :: 0.5

last_blink: f64 = 0

draw_ui :: proc(gm: ^GameManager) {
    draw_ui_build_store(gm)
    draw_ui_health(gm)
    draw_ui_wave(gm)
    draw_ui_resources(gm)
    if gm.state == .PrepareBuilds {
        current_time := rl.GetTime()
        if last_blink == 0 || (current_time - last_blink) >= BLINK_TIME_ON + BLINK_TIME_OFF {
            last_blink = current_time
        }
        if (current_time - last_blink) < BLINK_TIME_ON {
            rl.DrawTextPro(rl.GetFontDefault(), "PRESS SPACE TO START NEXT WAVE", grid_to_world(Vec2{6, 19}), {0,-10}, 0,14,5,rl.WHITE)
        }    }
}

draw_ui_build_store :: proc(gm: ^GameManager) {
    rl.DrawTextPro(rl.GetFontDefault(), "BUILD STORE", grid_to_world(Vec2{1, 15}), {0,-10}, 0,24,2,rl.WHITE)
    initial_build_store_position := grid_to_world({1,17})
    build_offset: f32 = 0
    for i in 0..<4 {
        have_money := gm.resource >= gm.build_config[BuildType(i)].resource
        color := gm.state == .InWave || !have_money ? rl.GRAY : rl.WHITE
        rl.DrawTexturePro(gm.builds_textures[i], {0,0,32,32},{initial_build_store_position.x + build_offset, initial_build_store_position.y, 32, 32}, {0,0}, 0, color)
        rl.DrawRectangleLinesEx({initial_build_store_position.x + build_offset, initial_build_store_position.y, 32, 32}, 1, color)
        price := fmt.caprintf("$%v", gm.build_config[BuildType(i)].resource)
        rl.DrawTextEx(rl.GetFontDefault(), price, {initial_build_store_position.x + build_offset + 4, initial_build_store_position.y + 34}, 16, 2, color)
        delete(price)
        if !have_money {
            initial_build_store_position.x += 32
            build_offset += 12
            continue
        }
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
    position := grid_to_world({12,17})
    health_component := get_component(gm.core, CoreComponent)
    health := fmt.caprintf("%v/100", health_component.health)
    core_health_size := (health_component.health * 170) / 100
    rl.DrawRectangleRec({position.x, position.y, 170, 32}, {79, 31, 31, 255})
    rl.DrawRectangleRec({position.x, position.y, f32(core_health_size), 32}, rl.RED)
    rl.DrawTextPro(rl.GetFontDefault(), health, {position.x + 10, position.y + 8}, {0,0}, 0,16,2,rl.WHITE)
    delete(health)
}

draw_ui_wave :: proc(gm: ^GameManager) {
    wave_number := fmt.caprintf("%v", gm.wave.number)
    rl.DrawTextPro(rl.GetFontDefault(), "CORE HEALTH", grid_to_world(Vec2{12, 15}), {0,-10}, 0,24,2,rl.WHITE)
    rl.DrawTextPro(rl.GetFontDefault(), wave_number, grid_to_world(Vec2{8, 17}), {-32,0}, 0,32,1,rl.WHITE)
    delete(wave_number)
}

draw_ui_resources :: proc(gm: ^GameManager) {
    rl.DrawTextPro(rl.GetFontDefault(), "RESOURCES", grid_to_world(Vec2{19, 15}), {0,-10}, 0,24,2,rl.WHITE)
    resource := fmt.caprintf("$ %v", gm.resource)
    position := grid_to_world(Vec2{19, 17})
    rl.DrawTextPro(rl.GetFontDefault(), resource, {position.x + 10, position.y}, {-32,0}, 0,32,1,rl.WHITE)
    delete(resource)
}
