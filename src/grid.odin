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
        grid_to_world({1,1})=true,
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
        grid_to_world({6,6})=true,
        grid_to_world({7,6})=true,
        grid_to_world({9,6})=true,
        grid_to_world({10,6})=true,
        grid_to_world({11,6})=true,
        grid_to_world({13,6})=true,
        grid_to_world({14,6})=true,
        grid_to_world({15,6})=true,
        grid_to_world({17,6})=true,
        grid_to_world({18,6})=true,
        grid_to_world({22,6})=true,
        grid_to_world({24,6})=true,
        grid_to_world({0,7})=true,
        grid_to_world({1,7})=true,
        grid_to_world({2,7})=true,
        grid_to_world({3,7})=true,
        grid_to_world({4,7})=true,
        grid_to_world({5,7})=true,
        grid_to_world({6,7})=true,
        grid_to_world({7,7})=true,
        grid_to_world({9,7})=true,
        grid_to_world({10,7})=true,
        grid_to_world({11,7})=true,
        grid_to_world({13,7})=true,
        grid_to_world({14,7})=true,
        grid_to_world({15,7})=true,
        grid_to_world({17,7})=true,
        grid_to_world({18,7})=true,
        grid_to_world({19,7})=true,
        grid_to_world({20,7})=true,
        grid_to_world({21,7})=true,
        grid_to_world({22,7})=true,
        grid_to_world({24,7})=true,
        grid_to_world({0,8})=true,
        grid_to_world({1,8})=true,
        grid_to_world({2,8})=true,
        grid_to_world({3,8})=true,
        grid_to_world({4,8})=true,
        grid_to_world({5,8})=true,
        grid_to_world({6,8})=true,
        grid_to_world({7,8})=true,
        grid_to_world({9,8})=true,
        grid_to_world({10,8})=true,
        grid_to_world({14,8})=true,
        grid_to_world({15,8})=true,
        grid_to_world({17,8})=true,
        grid_to_world({18,8})=true,
        grid_to_world({24,8})=true,
        grid_to_world({0,9})=true,
        grid_to_world({20,9})=true,
        grid_to_world({21,9})=true,
        grid_to_world({22,9})=true,
        grid_to_world({23,9})=true,
        grid_to_world({24,9})=true,
        grid_to_world({0,10})=true,
        grid_to_world({2,10})=true,
        grid_to_world({3,10})=true,
        grid_to_world({4,10})=true,
        grid_to_world({5,10})=true,
        grid_to_world({6,10})=true,
        grid_to_world({7,10})=true,
        grid_to_world({9,10})=true,
        grid_to_world({10,10})=true,
        grid_to_world({14,10})=true,
        grid_to_world({15,10})=true,
        grid_to_world({17,10})=true,
        grid_to_world({18,10})=true,
        grid_to_world({19,10})=true,
        grid_to_world({20,10})=true,
        grid_to_world({21,10})=true,
        grid_to_world({22,10})=true,
        grid_to_world({23,10})=true,
        grid_to_world({24,10})=true,
        grid_to_world({0,11})=true,
        grid_to_world({2,11})=true,
        grid_to_world({3,11})=true,
        grid_to_world({4,11})=true,
        grid_to_world({5,11})=true,
        grid_to_world({6,11})=true,
        grid_to_world({7,11})=true,
        grid_to_world({9,11})=true,
        grid_to_world({10,11})=true,
        grid_to_world({11,11})=true,
        grid_to_world({13,11})=true,
        grid_to_world({14,11})=true,
        grid_to_world({15,11})=true,
        grid_to_world({17,11})=true,
        grid_to_world({18,11})=true,
        grid_to_world({19,11})=true,
        grid_to_world({20,11})=true,
        grid_to_world({0,12})=true,
        grid_to_world({6,12})=true,
        grid_to_world({7,12})=true,
        grid_to_world({9,12})=true,
        grid_to_world({10,12})=true,
        grid_to_world({11,12})=true,
        grid_to_world({13,12})=true,
        grid_to_world({14,12})=true,
        grid_to_world({15,12})=true,
        grid_to_world({17,12})=true,
        grid_to_world({18,12})=true,
        grid_to_world({19,12})=true,
        grid_to_world({20,12})=true,
        grid_to_world({22,12})=true,
        grid_to_world({23,12})=true,
        grid_to_world({24,12})=true,
        grid_to_world({0,13})=true,
        grid_to_world({1,13})=true,
        grid_to_world({2,13})=true,
        grid_to_world({3,13})=true,
        grid_to_world({4,13})=true,
        grid_to_world({6,13})=true,
        grid_to_world({7,13})=true,
        grid_to_world({13,13})=true,
        grid_to_world({14,13})=true,
        grid_to_world({15,13})=true,
        grid_to_world({22,13})=true,
        grid_to_world({23,13})=true,
        grid_to_world({24,13})=true,
        grid_to_world({0,14})=true,
        grid_to_world({1,14})=true,
        grid_to_world({2,14})=true,
        grid_to_world({3,14})=true,
        grid_to_world({4,14})=true,
        grid_to_world({6,14})=true,
        grid_to_world({7,14})=true,
        grid_to_world({8,14})=true,
        grid_to_world({9,14})=true,
        grid_to_world({10,14})=true,
        grid_to_world({11,14})=true,
        grid_to_world({12,14})=true,
        grid_to_world({13,14})=true,
        grid_to_world({14,14})=true,
        grid_to_world({15,14})=true,
        grid_to_world({16,14})=true,
        grid_to_world({17,14})=true,
        grid_to_world({18,14})=true,
        grid_to_world({19,14})=true,
        grid_to_world({20,14})=true,
        grid_to_world({21,14})=true,
        grid_to_world({22,14})=true,
        grid_to_world({23,14})=true,
        grid_to_world({24,14})=true,
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