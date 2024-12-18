package game

import "core:math"
import rl "vendor:raylib"
import "core:fmt"

Placeable :: map[Vec2]bool

grid_to_world :: proc(position: Vec2) -> Vec2 {
    return Vec2{position[0] * GRID_SIZE, position[1] * GRID_SIZE}
}

world_to_grid :: proc(position: Vec2) -> Vec2 {
    return Vec2{math.floor(position[0] / GRID_SIZE) * GRID_SIZE, math.floor(position[1] / GRID_SIZE) * GRID_SIZE}
}

create_placeable :: proc() -> Placeable {

    //Close your eyes for the next lines
    //TODO: Add placeable data to grid file and load it from there
    placeable := Placeable{
        grid_to_world({0,0})=true,grid_to_world({1,0})=true,grid_to_world({2,0})=true,
        grid_to_world({3,0})=true,
        grid_to_world({4,0})=true,
        grid_to_world({5,0})=true,
        grid_to_world({6,0})=true,
        grid_to_world({7,0})=true,
        grid_to_world({8,0})=true,
        grid_to_world({9,0})=true,
        grid_to_world({10,0})=true,
        grid_to_world({11,0})=true,
        grid_to_world({12,0})=true,
        grid_to_world({13,0})=true,
        grid_to_world({14,0})=true,
        grid_to_world({15,0})=true,
        grid_to_world({16,0})=true,
        grid_to_world({18,0})=true,
        grid_to_world({19,0})=true,
        grid_to_world({20,0})=true,
        grid_to_world({21,0})=true,
        grid_to_world({22,0})=true,
        grid_to_world({23,0})=true,
        grid_to_world({24,0})=true,
        grid_to_world({0,1})=true,
        grid_to_world({11,1})=true,
        grid_to_world({12,1})=true,
        grid_to_world({13,1})=true,
        grid_to_world({14,1})=true,
        grid_to_world({15,1})=true,
        grid_to_world({16,1})=true,
        grid_to_world({18,1})=true,
        grid_to_world({19,1})=true,
        grid_to_world({20,1})=true,
        grid_to_world({21,1})=true,
        grid_to_world({22,1})=true,
        grid_to_world({23,1})=true,
        grid_to_world({24,1})=true,
        grid_to_world({0,2})=true,
        grid_to_world({1,2})=true,
        grid_to_world({3,2})=true,
        grid_to_world({4,2})=true,
        grid_to_world({5,2})=true,
        grid_to_world({6,2})=true,
        grid_to_world({7,2})=true,
        grid_to_world({8,2})=true,
        grid_to_world({9,2})=true,
        grid_to_world({11,2})=true,
        grid_to_world({12,2})=true,
        grid_to_world({13,2})=true,
        grid_to_world({14,2})=true,
        grid_to_world({15,2})=true,
        grid_to_world({16,2})=true,
        grid_to_world({18,2})=true,
        grid_to_world({19,2})=true,
        grid_to_world({20,2})=true,
        grid_to_world({21,2})=true,
        grid_to_world({22,2})=true,
        grid_to_world({23,2})=true,
        grid_to_world({24,2})=true,
        grid_to_world({0,3})=true,
        grid_to_world({1,3})=true,
        grid_to_world({6,3})=true,
        grid_to_world({7,3})=true,
        grid_to_world({8,3})=true,
        grid_to_world({9,3})=true,
        grid_to_world({11,3})=true,
        grid_to_world({12,3})=true,
        grid_to_world({13,3})=true,
        grid_to_world({14,3})=true,
        grid_to_world({15,3})=true,
        grid_to_world({16,3})=true,
        grid_to_world({20,3})=true,
        grid_to_world({24,3})=true,
        grid_to_world({0,4})=true,
        grid_to_world({1,4})=true,
        grid_to_world({2,4})=true,
        grid_to_world({3,4})=true,
        grid_to_world({4,4})=true,
        grid_to_world({6,4})=true,
        grid_to_world({7,4})=true,
        grid_to_world({8,4})=true,
        grid_to_world({9,4})=true,
        grid_to_world({11,4})=true,
        grid_to_world({12,4})=true,
        grid_to_world({13,4})=true,
        grid_to_world({14,4})=true,
        grid_to_world({15,4})=true,
        grid_to_world({16,4})=true,
        grid_to_world({17,4})=true,
        grid_to_world({18,4})=true,
        grid_to_world({20,4})=true,
        grid_to_world({22,4})=true,
        grid_to_world({24,4})=true,
        grid_to_world({0,5})=true,
        grid_to_world({1,5})=true,
        grid_to_world({2,5})=true,
        grid_to_world({3,5})=true,
        grid_to_world({4,5})=true,
        grid_to_world({6,5})=true,
        grid_to_world({7,5})=true,
        grid_to_world({11,5})=true,
        grid_to_world({17,5})=true,
        grid_to_world({18,5})=true,
        grid_to_world({20,5})=true,
        grid_to_world({22,5})=true,
        grid_to_world({24,5})=true,
    }
    return placeable
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
            position_txt := cstring(fmt.caprintf("%v, %v", x, y))
            rl.DrawTextEx(rl.GetFontDefault(),position_txt , Vec2{rect.x + 4, rect.y + 4}, 10, 0, rl.WHITE)
            rl.DrawRectangleLinesEx(rect, 0.5, rl.GRAY)
            delete(position_txt)
        }
    }
}