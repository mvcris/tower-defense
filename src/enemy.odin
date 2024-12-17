package game

import rl "vendor:raylib"
import ln "core:math/linalg"
import "core:math"
import "core:slice"
EnemyStartPosition :: enum {
    Left,
    Top,
    Right,
    Bottom
}

Enemy_Left_Path :: []Vec2 {
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


Enemy_Top_Path :: []Vec2 {
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

Enemy_Right_Path :: []Vec2 {
        {24,11},
        {21,11},
        {21,13},
        {16,13},
        {15,5},
        {12,5},
        {12,7}
}

Enemy_Bottom_Path :: []Vec2 {
        {5,14},
        {5,12},
        {1,12},
        {1,9},
        {10,9}
}


enemy_update :: proc (enemy: ^Entity, delta_time :f32) {
    enemy_position := get_component(enemy, PositionComponent)
    follow_path := get_component(enemy, EnemyPathComponent)
    enemy_component := get_component(enemy, EnemyComponent)
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
            rotate_enemy(enemy, normalized_direc)
            enemy_position^ += normalized_direc * enemy_component.speed * delta_time
        }
        
    }
}

rotate_enemy :: proc(enemy: ^Entity, direction: Vec2) {
    rotation := get_component(enemy, RotationComponent)
    new_direction: f32
    if rotation == nil {
        return
    }
    if direction.x == 1 && direction.y == 0 {
        new_direction = 0
    } else if direction.x == -1 && direction.y == 0 {
        new_direction = 180
    } else if direction.x == 0 && direction.y == 1 {
        new_direction = 90
    } else if direction.x == 0 && direction.y == -1 {
        new_direction = 270
    }
    if new_direction != rotation^ {
        rotation^ = new_direction
    }
}

create_enemy :: proc(gm: ^Game_Manager, start_at: EnemyStartPosition) {
    enemy := EnemyComponent{health = 100, speed = 25}
    position := PositionComponent{0, 0}
    rotation: RotationComponent = 0
    enemy_path: []Vec2
    switch start_at {
        case EnemyStartPosition.Left:
            enemy_path = slice.clone(Enemy_Left_Path)
        case EnemyStartPosition.Top:
             enemy_path = slice.clone(Enemy_Top_Path)
        case EnemyStartPosition.Right:
             enemy_path = slice.clone(Enemy_Right_Path)
        case EnemyStartPosition.Bottom:
            enemy_path = slice.clone(Enemy_Bottom_Path)
    }
    enemy_entity := create_entitiy(gm.ecs, EntityType.Enemey)
    position = grid_to_world(enemy_path[0])
    add_component(enemy_entity, enemy_path)
    add_component(enemy_entity, enemy)
    add_component(enemy_entity, position)
    add_component(enemy_entity, rotation)
    append(&gm.enimies, enemy_entity)
}

cleanup_enemies :: proc(gm: ^Game_Manager) {
    delete(gm.enimies)
}