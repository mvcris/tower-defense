package game

import "core:fmt"
import rl "vendor:raylib"
import ln "core:math/linalg"

BuildType :: enum {
    Basic,
    Medium,
    Heavy,
    Super
}

BuildsConfig :: map[BuildType]BuildComponent

load_build_textures :: proc(gm: ^GameManager) {
    gm.builds_textures[0] = rl.LoadTexture("./assets/build_01.png")
    gm.builds_textures[1] = rl.LoadTexture("./assets/build_02.png")
    gm.builds_textures[2] = rl.LoadTexture("./assets/build_03.png")
    gm.builds_textures[3] = rl.LoadTexture("./assets/build_04.png")
}

update_build :: proc(gm: ^GameManager) {
    if gm.state == .InWave {
        for &build in gm.builds {
            build_component := get_component(build, BuildComponent)
            position := get_component(build, PositionComponent)
            build_component.last_fire += gm.delta_time
            if build_component.last_fire >= build_component.fire_rate {
                nearest_enemy: ^Entity = nil
                nearest_distance: f32 = build_component.range
                for &enemy in gm.wave.enimies {
                    enemy_position := get_component(enemy, PositionComponent)
                    distance := ln.distance(position^, enemy_position^)
                    if  distance <= build_component.range && (nearest_enemy == nil || distance < nearest_distance) {
                        nearest_enemy = enemy
                        nearest_distance = distance
                    }
                }
                if nearest_enemy != nil {
                    create_projectile(build_component.damage, build_component.speed, nearest_enemy, position^, gm)
                    build_component.last_fire = 0
                }
            }
        }
    }
}

input_build :: proc(gm: ^GameManager) {
    if gm.state == .PrepareBuilds && rl.IsMouseButtonPressed(.LEFT) && gm.selected_build {
        build_price := gm.build_config[gm.selected_build_type].resource
        if gm.resource >= build_price {
            if create_build(gm.selected_build_type, rl.GetMousePosition(), gm) {
                gm.selected_build = false
                gm.resource -= build_price
            } 
        }
    }
}

draw_build :: proc(gm: ^GameManager) {
    for &build in gm.builds {
        position := get_component(build, PositionComponent)
        build_component := get_component(build, BuildComponent)
        if position != nil {
            rl.DrawTextureEx(gm.builds_textures[build_component.type], position^, 0,1,rl.WHITE)
        }
    }
    if gm.state == .PrepareBuilds && gm.selected_build {
        position := world_to_grid(rl.GetMousePosition())
        if position.y / 32 < 15 {
            can_place := gm.grid_placeable[position]
            color: rl.Color = can_place ? {255,255,255,100} : {255,0,0,100}
            rl.DrawTexturePro(gm.builds_textures[gm.selected_build_type], {0,0,32,32}, {position.x, position.y, 32, 32}, {0,0}, 0, color)
            rl.DrawRectangleLines(i32(position.x), i32(position.y), 32, 32, can_place ? rl.WHITE : rl.RED)
            rl.DrawCircle(i32(position.x + 16), i32(position.y + 16),gm.build_config[gm.selected_build_type].range, {255,255,255,50})
        }
    }
}

init_build :: proc(gm: ^GameManager) {
    placeable := create_placeable()
    gm.grid_placeable = placeable
    build_config := make(BuildsConfig, 4)
    build_config[.Basic] = BuildComponent{1, 50, 2.5, 0, .Basic, 150, 15}
    build_config[.Medium] = BuildComponent{1, 75, 1.8, 0, .Medium, 210, 30}
    build_config[.Heavy] = BuildComponent{1, 115, 1.4, 0, .Heavy, 290, 60}
    build_config[.Super] = BuildComponent{1, 140, 1, 0, .Super, 330, 115}
    gm.build_config = build_config
    load_build_textures(gm)
}

create_build :: proc(
    build_type: BuildType,
    position: Vec2,
    gm: ^GameManager
) -> bool{
    world_position := world_to_grid(position)
    can_place := gm.grid_placeable[world_position]
    if !can_place {
        return false
    }
    build := gm.build_config[build_type]
    position := PositionComponent{world_position[0], world_position[1]}
    entity := create_entitiy(gm.ecs, EntityType.Build)
    gm.grid_placeable[world_position] = false
    add_component(entity, build)
    add_component(entity, position)
    append(&gm.builds, entity)
    return true
}

cleanup_builds :: proc(gm: ^GameManager) {
    delete(gm.builds)
    delete(gm.build_config)
}