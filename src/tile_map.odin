package game

import vmem "core:mem/virtual"
import "core:os"
import "core:encoding/json"
import rl "vendor:raylib"

TiledMap :: struct {
    width: int,
    height: int,
    tilewidth: int,
    tiledheight: int,
    layers: []struct {
        name: string,
        data: []int,
        width: int,
        height: int,
    },
    arena: vmem.Arena
}

load_tilemap_file :: proc(file: string) -> (TiledMap, bool) {
    if data, ok := os.read_entire_file(file, context.temp_allocator); ok {
        tiled_map := TiledMap{}
        arena: vmem.Arena
        arena_allocator := vmem.arena_allocator(&arena)
        if json.unmarshal(data, &tiled_map, allocator = arena_allocator) == nil {
            return tiled_map, true
        }
    }
    return TiledMap{}, false
}

render_tilemap :: proc(map_data: ^TiledMap, texture: rl.Texture) {
	tile_size := map_data.tilewidth
	tileset_columns := int(texture.width) / tile_size
	for y in 0 ..< map_data.height {
		for x in 0 ..< map_data.width {
			tile_id := map_data.layers[0].data[y * map_data.width + x]
			if tile_id > 0 {
				tile_id -= 1
				source := rl.Rectangle {
					f32((tile_id % tileset_columns) * tile_size),
					f32((tile_id / tileset_columns) * tile_size),
					f32(tile_size),
					f32(tile_size),
				}
				dest := rl.Rectangle {
					f32(x * tile_size),
					f32(y * tile_size),
					f32(tile_size),
					f32(tile_size),
				}
				rl.DrawTexturePro(texture, source, dest, rl.Vector2{}, 0, rl.WHITE)
			}
		}
	}
}