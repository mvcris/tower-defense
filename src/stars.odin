package game

import "core:math/rand"
import rl "vendor:raylib"


STAR_SPEED :: 1.5

Stars :: struct {
    x, y, z: f32
}

randf :: proc() -> f32 {
    return f32(rand.int_max(1000)) / 1000.0
}

create_stars :: proc(gm: ^GameManager) {
    stars: [STARS]Stars = [STARS]Stars{}
    for i in 0 ..<STARS { 
        stars[i].x = rand.float32_range(0, WINDOW_WIDTH);
        stars[i].y = rand.float32_range(0, WINDOW_HEIGHT);
        stars[i].z = randf();
    }
    gm.stars = stars
}

draw_stars :: proc(gm: ^GameManager) {
    for i in 0 ..<200  { 
        gm.stars[i].x -= 1 * (gm.stars[i].z / 1);
        if (gm.stars[i].x <= 0) { 
            gm.stars[i].x += WINDOW_WIDTH;
            gm.stars[i].y = rand.float32_range(0, WINDOW_HEIGHT);
        }
    }
    for i in 0 ..<STARS  { 
                x := gm.stars[i].x;
                y := gm.stars[i].y;
                rl.DrawPixel(i32(x), i32(y), {84,84,84,255});
        }
}