package game

import rl "vendor:raylib"

create_core :: proc(gm: ^GameManager) {
    core_component := CoreComponent{100}
    core_position := grid_to_world({11,8})
    core_collision := CollisionComponent{position = core_position, height = 96, width = 96, offset = {0,0}, tag = "Core"}
    core_entity := create_entitiy(gm.ecs, .Core)
    add_component(core_entity, core_component)
    add_component(core_entity, core_position)
    add_component(core_entity, core_collision)
    gm.core = core_entity
}

//TODO: Implement this function
game_over :: proc(gm: ^GameManager) {}

core_update :: proc(gm: ^GameManager) {
    core_component := get_component(gm.core, CoreComponent)
    if core_component.health <= 0 {
        gm.state = .MainMenu
    }
}

draw_core :: proc(gm: ^GameManager) {
    core_collision := get_component(gm.core, CollisionComponent)
}