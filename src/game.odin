package game

import rl "vendor:raylib"
import "core:fmt"
import  ln "core:math/linalg"
import "core:math"

 WINDOW_WIDTH :: 800
 WINDOW_HEIGHT :: 640
 GRID_SIZE :: 32

Vec2 :: [2]f32

Game_Manager :: struct {
    ecs: ^Entity_Manager,
    delta_time: f32,
    textures: [2]rl.Texture,
    tiled_maps: [1]^TiledMap,
    enimies: [dynamic]^Entity
}

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


input :: proc(gm: ^Game_Manager) {
    if rl.IsKeyPressed(.SPACE) {
        create_enemy(gm, .Left)
        create_enemy(gm, .Top)
        create_enemy(gm, .Right)
        create_enemy(gm, .Bottom)
    }
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

update :: proc(gm: ^Game_Manager) {
    player := get_entity(gm.ecs, 1)
    position := get_component(player, PositionComponent)
    if position != nil {
        position.x = world_to_grid(rl.GetMousePosition())[0]
        position.y =  world_to_grid(rl.GetMousePosition())[1]
    }
    for &enemy in gm.enimies {
        enemy_update(enemy, gm.delta_time)
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

create_enemy :: proc(gm: ^Game_Manager, start_at: EnemyStartPosition) -> ^Entity {
    enemy := EnemyComponent{health = 100, speed = 25}
    position := PositionComponent{0, 0}
    rotation: RotationComponent = 0
    enemy_path :[]Vec2
    switch start_at {
        case EnemyStartPosition.Left:
            enemy_path =  make([]Vec2, len(Enemy_Left_Path))
            copy(enemy_path, Enemy_Left_Path)  
        case EnemyStartPosition.Top:
            enemy_path =  make([]Vec2, len(Enemy_Top_Path))
            copy(enemy_path, Enemy_Top_Path)  
        case EnemyStartPosition.Right:
            enemy_path =  make([]Vec2, len(Enemy_Right_Path))
            copy(enemy_path, Enemy_Right_Path)  
        
        case EnemyStartPosition.Bottom:
            enemy_path =  make([]Vec2, len(Enemy_Bottom_Path))
            copy(enemy_path, Enemy_Bottom_Path)  
    }
    enemy_entity := create_entitiy(gm.ecs, EntityType.Enemey)
    position = grid_to_world(enemy_path[0])
    add_component(enemy_entity, enemy_path)
    add_component(enemy_entity, enemy)
    add_component(enemy_entity, position)
    add_component(enemy_entity, rotation)
    append(&gm.enimies, enemy_entity)
    return enemy_entity
}

draw :: proc(gm: ^Game_Manager) {
        rl.BeginDrawing()
        rl.ClearBackground({10, 10, 10, 255})
        render_tilemap(gm.tiled_maps[0], gm.textures[0])
        player := get_entity(gm.ecs, 1)
        position := get_component(player, PositionComponent)
        if position != nil {
            world_position := world_to_grid(Vec2{position.x, position.y})
            rl.DrawRectangle(i32(world_position[0]), i32(world_position[1]), 32, 32, rl.RED)
        }
        for &enemy in gm.enimies {
            enemy_position := get_component(enemy, PositionComponent)
            follow_path := get_component(enemy, EnemyPathComponent)
            rotation := get_component(enemy, RotationComponent)
            if enemy_position != nil {
                rl.DrawTexturePro(
                    gm.textures[1], 
                    {0,0,32,32},
                    {enemy_position.x + 16,enemy_position.y + 16, 32, 32},
                    {16,16},
                    rotation^,
                    rl.WHITE
                )
            }
        }
        //draw_debug_grid()
        rl.EndDrawing()
}

main :: proc() {
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Tower Defense")
   rl.SetTargetFPS(60)
    ecs := make_entity_manager()
    gm := Game_Manager{ecs = ecs, delta_time = 0}
    player_component := PlayerComponent{health =  100, points =  0}
    position_component := PositionComponent{0, 0}
    player_entity := create_entitiy(ecs, EntityType.Player)
    add_component(player_entity, player_component)
    add_component(player_entity, position_component)
    teste := new(EnemyPathComponent)
    tiled_texture := rl.LoadTexture("assets/tileset.png")
    enemy_texture := rl.LoadTexture("assets/enemy.png")
    tiled_map, ok := load_tilemap_file("assets/map.json")
    gm.textures[0] = tiled_texture
    gm.textures[1] = enemy_texture
    gm.tiled_maps[0] = &tiled_map
    for !rl.WindowShouldClose() {
        gm.delta_time = rl.GetFrameTime()
        input(&gm)
        update(&gm)
        draw(&gm)
    }
    rl.CloseWindow()
}