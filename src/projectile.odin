package game

import ln "core:math/linalg"
import rl "vendor:raylib"

create_projectile :: proc(damage: f32, speed: f32, target: ^Entity, origin: Vec2, gm: ^GameManager) {
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

destroy_projectile :: proc(gm: ^GameManager, projectile: ^Entity, idx: int) {
    ordered_remove(&gm.wave.projectiles, idx)
    destroy_entity(gm.ecs, projectile)
}

update_projectile :: proc(gm: ^GameManager) {
    for &projectile, idx in gm.wave.projectiles {
        projectile_component := get_component(projectile, ProjectileComponent)
        position := get_component(projectile, PositionComponent)
        target := projectile_component.target
        target_entity := get_entity(gm.ecs, target.id)
        if target_entity == nil {
            destroy_projectile(gm, projectile, idx)
            continue
        }
        target_position := get_component(target, PositionComponent)
        if rl.CheckCollisionCircleRec(
            rl.Vector2{position^.x, position^.y},
            5,
            rl.Rectangle{target_position^.x, target_position^.y, 32, 32}
        ) {
            destroy_projectile(gm, projectile, idx)
            enemy := get_component(target, EnemyComponent)
            if enemy != nil {
                enemy.health -= i32(projectile_component.damage)
            }
            continue
        }
        raw_dir := target_position^ - position^
        raw_dir.x += 16
        raw_dir.y += 16
        direction := ln.normalize(raw_dir)
        position^.x += direction[0] * get_component(projectile, ProjectileComponent).speed * gm.delta_time
        position^.y += direction[1] * get_component(projectile, ProjectileComponent).speed * gm.delta_time
    }
}

draw_projectile :: proc(gm: ^GameManager) {
    for &projectile in gm.wave.projectiles {
        position := get_component(projectile, PositionComponent)
        if position != nil {
            rl.DrawCircle(i32(position^.x), i32(position^.y), 3.5, {161,161,255,255})
        }
    }
}

cleanup_projectiles :: proc(gm: ^GameManager) {
    delete(gm.wave.projectiles)
}