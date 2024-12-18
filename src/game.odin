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

GameState :: enum {
    MainMenu,
    Pause,
    PrepareWave,
    InWave,
    PrepareBuilds,
}
GameManager :: struct {
    ecs: ^EntityManager,
    delta_time: f32,
    textures: [6]rl.Texture,
    tiled_maps: [1]^TiledMap,
    wave: Wave,
    state: GameState,
    grid_placeable: Placeable,
    builds_textures: [4]rl.Texture,
    builds: [dynamic]^Entity,
    selected_build: bool,
    selected_build_type: BuildType,

}

input :: proc(gm: ^GameManager) {
    if gm.state == .MainMenu && rl.IsKeyPressed(.ENTER) {
        gm.state = .PrepareBuilds
    }
    if gm.state == .PrepareBuilds && rl.IsKeyPressed(.SPACE) {
        gm.state = .PrepareWave
    }
    input_build(gm)
}

update :: proc(gm: ^GameManager) {
    wave_update(gm)
    for &enemy in gm.wave.enimies {
        enemy_update(enemy, gm.delta_time)
    }
}

draw :: proc(gm: ^GameManager) {
        rl.BeginDrawing()
        rl.SetMouseCursor(.DEFAULT)
        rl.ClearBackground({15, 15, 15, 255})
        render_tilemap(gm.tiled_maps[0], gm.textures[0])
        draw_build(gm)
        draw_enimies(gm)
        draw_ui(gm)
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
    gm := GameManager{ecs = ecs, delta_time = 0, state = GameState.MainMenu}
    //TODO: Better textures loading and management
    tiled_map, ok := load_tilemap_file("assets/map.json")
    gm.textures[0] = rl.LoadTexture("assets/tileset-export.png")
    gm.textures[1] = rl.LoadTexture("assets/enemy.png")
    gm.textures[2] = rl.LoadTexture("assets/build_01.png")
    gm.textures[3] = rl.LoadTexture("assets/build_02.png")
    gm.textures[4] = rl.LoadTexture("assets/build_03.png")
    gm.textures[5] = rl.LoadTexture("assets/build_04.png")
    gm.tiled_maps[0] = &tiled_map
    gm.wave = create_wave(1,30,10,1.4)
    init_build(&gm)
    defer {
        destroy_entity_manager(ecs)
        cleanup_enemies(&gm)
        cleanup_builds(&gm)
        delete(gm.grid_placeable)
    }
    for !rl.WindowShouldClose() {
        gm.delta_time = rl.GetFrameTime()
        input(&gm)
        update(&gm)
        draw(&gm)
    }
    rl.CloseWindow()
}