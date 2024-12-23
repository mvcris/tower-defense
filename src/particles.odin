package game


import rl "vendor:raylib"
import "core:math"
import ln "core:math/linalg"
import "core:math/rand"

Particle :: struct {
    position: Vec2,
    velocity: Vec2,
    radius: f32,
    color: u8,
    alpha: u8,
    life: f32,
    size: f32,
}  

create_particle :: proc(gm: ^GameManager, position: Vec2, amount: int) {
    for i in 0..<50 {
        angle := f32(rand.int31_max(360)) * rl.DEG2RAD
        speed := f32(rand.float32_range(100,300) / 100) * 40
        particle := new(Particle)
        particle.position = position
        particle.velocity = Vec2{speed * math.cos(angle), speed * math.sin(angle)}
        particle.radius = rand.float32_range(1,2)
        particle.color = u8(rand.float32_range(29, 80))
        particle.life = 1.5
        particle.alpha = 255
        particle.size = rand.float32_range(3, 5)
        particle.size = 3
        append(&gm.wave.particles, particle)
    }
}

update_particles :: proc(gm: ^GameManager) {
    for &p, i in gm.wave.particles {
        if p.life <= 0 {
            free(p)
            ordered_remove(&gm.wave.particles, i)
            continue
        }
        p.position.x += p.velocity.x * gm.delta_time
        p.position.y += p.velocity.y * gm.delta_time
        p.alpha = u8(255.0 * (p.life / 1.5))
        p.size = (p.life / 1.5) * p.radius * 3.5
        p.life -= gm.delta_time
    }
}

draw_particles :: proc(gm: ^GameManager) {
    for &p in gm.wave.particles {
        rl.DrawCircleV(p.position, p.size, {p.color, p.color, p.color, p.alpha});
    }
}

cleanup_particles :: proc(gm: ^GameManager) {
    for &p in gm.wave.particles {
        free(p)
    }
    delete(gm.wave.particles)
}
