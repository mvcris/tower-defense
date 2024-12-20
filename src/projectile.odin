package game

import ln "core:math/linalg"
import rl "vendor:raylib"



create_projectile :: proc(damage: f32, speed: f32, target: ^Vec2, origin: Vec2, gm: ^GameManager) {
    projectile_componet := ProjectileComponent{
        damage,
        speed,
        target,
        origin
    }
    position_component := PositionComponent{origin.x + 16, origin.y + 16}
    projectile_entity := create_entitiy(gm.ecs, EntityType.Projectile)
    add_component(projectile_entity, projectile_componet)
    add_component(projectile_entity, position_component)
    append(&gm.wave.projectiles, projectile_entity)
}

draw_projectile :: proc(gm: ^GameManager) {
    for &projectile in gm.wave.projectiles {
        projectile_component := get_component(projectile, ProjectileComponent)
        position := get_component(projectile, PositionComponent)
        target := projectile_component.target
        raw_dir := target^ - position^
        raw_dir.x += 16
        raw_dir.y += 16
        direction := ln.normalize(raw_dir)
        position^.x += direction[0] * get_component(projectile, ProjectileComponent).speed * gm.delta_time
        position^.y += direction[1] * get_component(projectile, ProjectileComponent).speed * gm.delta_time
        rl.DrawCircle(i32(position^.x), i32(position^.y), 5, rl.RED)
    }
}

cleanup_projectiles :: proc(gm: ^GameManager) {
    delete(gm.wave.projectiles)
}