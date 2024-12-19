package game

import "core:fmt"
import rl "vendor:raylib"

BuildType :: enum {
    Basic,
    Medium,
    Heavy,
    Super
}

BuildPrice :: map[BuildType]int

load_build_textures :: proc(gm: ^GameManager) {
    gm.builds_textures[0] = rl.LoadTexture("./assets/build_01.png")
    gm.builds_textures[1] = rl.LoadTexture("./assets/build_02.png")
    gm.builds_textures[2] = rl.LoadTexture("./assets/build_03.png")
    gm.builds_textures[3] = rl.LoadTexture("./assets/build_04.png")
}

input_build :: proc(gm: ^GameManager) {
    if gm.state == .PrepareBuilds && rl.IsMouseButtonPressed(.LEFT) && gm.selected_build {
        build_price := gm.builds_price[gm.selected_build_type]
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
        }
    }
}

init_build :: proc(gm: ^GameManager) {
    placeable := create_placeable()
    gm.grid_placeable = placeable
    build_price := make(map[BuildType]int)
    build_price[.Basic] = 10
    build_price[.Medium] = 35
    build_price[.Heavy] = 60
    build_price[.Super] = 85
    gm.builds_price = build_price
    load_build_textures(gm)
}

create_build :: proc(
    build_type: BuildType,
    position: Vec2,
    gm: ^GameManager
) -> bool{
    cost, damage, range, fire_rate, last_fire: f32
    switch build_type {
        case .Basic:
            cost = 10
            damage = 10
            range = 10
            fire_rate = 10
            last_fire = 10
        case .Medium:
            cost = 20
            damage = 20
            range = 20
            fire_rate = 20
            last_fire = 20
        case .Heavy:
            cost = 30
            damage = 30
            range = 30
            fire_rate = 30
            last_fire = 30
        case .Super:
            cost = 40
            damage = 40
            range = 40
            fire_rate = 40
            last_fire = 40
    }
    world_position := world_to_grid(position)
    can_place := gm.grid_placeable[world_position]
    if !can_place {
        return false
    }
    build := BuildComponent{
        cost = cost,
        damage = damage,
        range = range,
        fire_rate = fire_rate,
        last_fire = last_fire,
        type = build_type
    }
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
    delete(gm.builds_price)
}