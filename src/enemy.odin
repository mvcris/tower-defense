package game

import rl "vendor:raylib"
import ln "core:math/linalg"
import "core:math"
import "core:slice"
import "core:math/rand"
import "core:fmt"

EnemyStartPosition :: enum {
    Left,
    Top,
    Right,
    Bottom
}

EnemyLeftPath :: []Vec2 {
        {0,6},
        {5,6},
        {5,3},
        {2,3},
        {2,1},
        {10,1},
        {10,5},
        {8,5},
        {8,13},
        {12,13},
        {12,11},
}


EnemyTopPath :: []Vec2 {
        {17,0},
        {17,3},
        {19,3},
        {19,6},
        {21,6},
        {21,3},
        {23,3},
        {23,8},
        {19,8},
        {19,9},
        {14,9},
}

EnemyRightPath :: []Vec2 {
        {24,11},
        {21,11},
        {21,13},
        {16,13},
        {16,5},
        {12,5},
        {12,7}
}

EnemyBottomPath :: []Vec2 {
        {5,14},
        {5,12},
        {1,12},
        {1,9},
        {10,9}
}

enemy_update :: proc (enemy: ^Entity, gm: ^GameManager) {
    delta_time := gm.delta_time
    enemy_position := get_component(enemy, PositionComponent)
    follow_path := get_component(enemy, EnemyPathComponent)
    enemy_component := get_component(enemy, EnemyComponent)
    collision_componet := get_component(enemy, CollisionComponent)
    if enemy_component != nil {
        if enemy_component.health <= 0 {
            create_particle(gm, {enemy_position.x + 16, enemy_position.y + 16}, 50)
            delete_enemy(gm, enemy)
            gm.resource += 3
            return
        }
    }
    if enemy_position != nil {
        if enemy_component.current_path < len(follow_path) - 1 {
            next_point_world_position := grid_to_world(Vec2{follow_path[enemy_component.current_path + 1].x, follow_path[enemy_component.current_path + 1].y})
            direction := ln.Vector2f32(next_point_world_position) - ln.Vector2f32({enemy_position[0], enemy_position[1]})
            normalized_direc := ln.vector_normalize0(direction)
            normalized_direc.x = math.round(normalized_direc.x)
            normalized_direc.y = math.round(normalized_direc.y)
            if ln.vector_length(direction) < 1 {
                enemy_component.current_path += 1
            }
            enemy_position^ += normalized_direc * enemy_component.speed * delta_time
            collision_componet.position = {enemy_position.x, enemy_position.y}
            rotate_enemy(enemy, normalized_direc)
        }
    }
    core_collision := get_component(gm.core, CollisionComponent)
    core_component := get_component(gm.core, CoreComponent)
    collision_core_rec: rl.Rectangle = {collision_componet.position.x, collision_componet.position.y, collision_componet.width, collision_componet.height}
    collision_enemy_rec: rl.Rectangle = {core_collision.position.x, core_collision.position.y, core_collision.width + 6, core_collision.height + 6}
    if rl.CheckCollisionRecs(collision_core_rec, collision_enemy_rec) {
        core_component.health -= 5
        delete_enemy(gm, enemy)
    }
}

delete_enemy :: proc(gm: ^GameManager, enemy: ^Entity) {
    for &e, i in gm.wave.enimies {
        if e == enemy {
            ordered_remove(&gm.wave.enimies, i)
            destroy_entity(gm.ecs, enemy)
        }
    }
}

rotate_enemy :: proc(enemy: ^Entity, direction: Vec2) {
    rotation := get_component(enemy, RotationComponent)
    collision := get_component(enemy, CollisionComponent)
    original_width: f32 = 30
    original_height: f32 = 15
    new_direction: f32
    if rotation == nil {
        return
    }
    if direction.x == 1 && direction.y == 0 {
        new_direction = 0
        collision.width = original_width
        collision.height = original_height
        collision.position = {collision.position.x + collision.offset.x, collision.position.y + collision.offset.y}
    } else if direction.x == -1 && direction.y == 0 {
        new_direction = 180
        collision.width = original_width
        collision.height = original_height
        collision.position = {collision.position.x + collision.offset.x, collision.position.y + collision.offset.y}
    } else if direction.x == 0 && direction.y == 1 {
        new_direction = 90  
        collision.width = original_height
        collision.height = original_width
        collision.position = {collision.position.x + collision.offset.y, collision.position.y + collision.offset.x}

    } else if direction.x == 0 && direction.y == -1 {
        new_direction = 270
        collision.width = original_height
        collision.height = original_width
        collision.position = {collision.position.x + collision.offset.y, collision.position.y + collision.offset.x}
    }
    if new_direction != rotation^ {
        rotation^ = new_direction
    }
}

create_enemy :: proc(gm: ^GameManager) {
    enemy := EnemyComponent{health = 3, speed = 25}
    position := PositionComponent{0, 0}
    rotation: RotationComponent = 0
    enemy_path: []Vec2
    direction: EnemyStartPosition = .Left

    direction = EnemyStartPosition.Left

    if gm.wave.number >= 2 {
        rand := rand.int31_max(2)
        direction = EnemyStartPosition(rand)
    }
    if gm.wave.number >= 4 {
        rand := rand.int31_max(3)
        direction = EnemyStartPosition(rand)
    }
    if gm.wave.number >= 6 {
        rand := rand.int31_max(4)
        direction = EnemyStartPosition(rand)
    }

    collision := CollisionComponent{28,14, {0,8}, {0,0}, "enemy"}

    switch direction {
        case EnemyStartPosition.Left:
            enemy_path = slice.clone(EnemyLeftPath)
        case EnemyStartPosition.Top:
             enemy_path = slice.clone(EnemyTopPath)
        case EnemyStartPosition.Right:
             enemy_path = slice.clone(EnemyRightPath)
        case EnemyStartPosition.Bottom:
            enemy_path = slice.clone(EnemyBottomPath)
    }
    enemy_entity := create_entitiy(gm.ecs, EntityType.Enemey)
    position = grid_to_world(enemy_path[0])
    switch direction {
        case EnemyStartPosition.Left:
            position.x -= 16
        case EnemyStartPosition.Top:
             position.y -= 16
        case EnemyStartPosition.Right:
             position.x += 16
        case EnemyStartPosition.Bottom:
           position.y += 16
    }
    
    add_component(enemy_entity, enemy_path)
    add_component(enemy_entity, enemy)
    add_component(enemy_entity, position)
    add_component(enemy_entity, rotation)
    add_component(enemy_entity, collision)
    gm.wave.time_since_last_spawn = 0
    append(&gm.wave.enimies, enemy_entity)
}

draw_enimies :: proc(gm: ^GameManager) {
    for &enemy in gm.wave.enimies {
        enemy_position := get_component(enemy, PositionComponent)
        follow_path := get_component(enemy, EnemyPathComponent)
        rotation := get_component(enemy, RotationComponent)
        collision := get_component(enemy, CollisionComponent)
        if enemy_position != nil {
            rl.DrawTexturePro(
                gm.textures[1], 
                {0,0,32,32},
                {enemy_position.x + 16,enemy_position.y + 16, 32, 32},
                {16,16},
                rotation^,
                rl.WHITE
            )
            // rl.DrawRectangleLinesEx(
            //     {collision.position.x, collision.position.y, collision.width, collision.height}, 1, rl.RED
            // )
        }
    }
}

cleanup_enemies :: proc(gm: ^GameManager) {
    delete(gm.wave.enimies)
}