package game

import "core:math"
import rl "vendor:raylib"
import "core:fmt"

grid_to_world :: proc(position: Vec2) -> Vec2 {
    return Vec2{position[0] * GRID_SIZE, position[1] * GRID_SIZE}
}

world_to_grid :: proc(position: Vec2) -> Vec2 {
    return Vec2{math.floor(position[0] / GRID_SIZE) * GRID_SIZE, math.floor(position[1] / GRID_SIZE) * GRID_SIZE}
}


draw_debug_grid :: proc() {
    grid_width := WINDOW_WIDTH / GRID_SIZE
    grid_height := WINDOW_HEIGHT / GRID_SIZE
    for x in 0..<grid_width {
        for y in 0..<grid_height {
            world_position := grid_to_world({f32(x), f32(y)})
            rect := rl.Rectangle{
                height = 32,
                width = 32,
                x = world_position[0],
                y = world_position[1],
            }
            rl.DrawTextEx(rl.GetFontDefault(), fmt.caprintf("%v, %v", x, y), Vec2{rect.x + 4, rect.y + 4}, 10, 0, rl.WHITE)
            rl.DrawRectangleLinesEx(rect, 0.5, rl.GRAY)
        }
    }
}