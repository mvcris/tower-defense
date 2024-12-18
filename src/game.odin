package game

import rl "vendor:raylib"
import "core:fmt"
import  ln "core:math/linalg"
import "core:math"
import "core:mem"

 WINDOW_WIDTH :: 800
 WINDOW_HEIGHT :: 640
 GRID_SIZE :: 32

Vec2 :: [2]f32

Game_Manager :: struct {
    ecs: ^Entity_Manager,
    delta_time: f32,
    textures: [2]rl.Texture,
    tiled_maps: [1]^TiledMap,
    wave: Wave
}

input :: proc(gm: ^Game_Manager) {}

update :: proc(gm: ^Game_Manager) {
    player := get_entity(gm.ecs, 1)
    position := get_component(player, PositionComponent)
    if position != nil {
        position.x = world_to_grid(rl.GetMousePosition())[0]
        position.y =  world_to_grid(rl.GetMousePosition())[1]
    }
    wave_update(gm)
    for &enemy in gm.wave.enimies {
        enemy_update(enemy, gm.delta_time)
    }
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
        draw_enimies(gm)
        
        when ODIN_DEBUG {
            //draw_debug_grid()
        }
        rl.EndDrawing()
}

main :: proc() {
    when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				for _, entry in track.allocation_map {
					fmt.eprintf("%v leaked %v bytes\n", entry.location, entry.size)
				}
			}
			if len(track.bad_free_array) > 0 {
				for entry in track.bad_free_array {
					fmt.eprintf("%v bad free at %v\n", entry.location, entry.memory)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Tower Defense")
    rl.SetTargetFPS(60)
    ecs := make_entity_manager()
    gm := Game_Manager{ecs = ecs, delta_time = 0}
    player_component := PlayerComponent{health =  100, points =  0}
    position_component := PositionComponent{0, 0}
    player_entity := create_entitiy(ecs, EntityType.Player)
    add_component(player_entity, player_component)
    add_component(player_entity, position_component)
    //TODO: Better textures loading and management
    tiled_texture := rl.LoadTexture("assets/tileset.png")
    enemy_texture := rl.LoadTexture("assets/enemy.png")
    tiled_map, ok := load_tilemap_file("assets/map.json")
    gm.textures[0] = tiled_texture
    gm.textures[1] = enemy_texture
    gm.tiled_maps[0] = &tiled_map
    gm.wave = create_wave(8,30,15,1.3)
    defer {
        destroy_entity_manager(ecs)
        cleanup_enemies(&gm)
    }
    for !rl.WindowShouldClose() {
        gm.delta_time = rl.GetFrameTime()
        input(&gm)
        update(&gm)
        draw(&gm)
    }
    rl.CloseWindow()
}