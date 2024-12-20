package game

import "core:math"

Wave :: struct {
    number: f32,
    total_time: f32,
    enimies: [dynamic]^Entity,
    enemies_per_wave: int,
    enimies_spawned: int,
    spawn_interval: f32,
    time_since_last_spawn: f32,
    growth_factor: f32,
    projectiles: [dynamic]^Entity
}

wave_update :: proc(gm: ^GameManager) {
    if gm.state == .PrepareWave {
        gm.wave = create_wave(gm.wave.number + 1, 30, 10, 1.5)
        gm.state = .InWave
        return
    }
    if gm.state == .InWave {
        if gm.wave.enimies_spawned >= gm.wave.enemies_per_wave && len(gm.wave.enimies) == 0 {
            end_wave(gm)
            return
        }
        gm.wave.time_since_last_spawn += gm.delta_time
        if gm.wave.time_since_last_spawn >= gm.wave.spawn_interval && gm.wave.enimies_spawned < gm.wave.enemies_per_wave {
            create_enemy(gm)
            gm.wave.enimies_spawned += 1
            gm.wave.time_since_last_spawn = 0
        }
    }

    
}

end_wave :: proc(gm: ^GameManager) {
    free(&gm.wave.enimies)
    free(&gm.wave.projectiles)
    gm.state = .PrepareWave
}

create_wave :: proc(
    wave_number: f32,
    base_wave_time: f32,
    base_enimies: int,
    growth_factor: f32
) ->Wave {
    total_enimies := int(f32(base_enimies) * math.pow(growth_factor, f32(wave_number - 1)))
    total_wave_time := math.round(base_wave_time * math.pow(growth_factor, f32(wave_number - 1)))
    enimies_per_second: = f32(total_enimies) / total_wave_time
    spawn_interval := 1 / enimies_per_second * math.pow(0.85, f32(wave_number - 1))
    return Wave {
        number = wave_number,
        total_time = total_wave_time,
        enimies = make([dynamic]^Entity, 0),
        enemies_per_wave = total_enimies,
        spawn_interval = spawn_interval,
        time_since_last_spawn = 0,
        growth_factor = growth_factor,
        enimies_spawned = 0
    }
}