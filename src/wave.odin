package game

import "core:math"

Wave :: struct {
    number: f32,
    total_time: f32,
    enimies: [dynamic]^Entity,
    enemies_per_wave: int,
    spawn_interval: f32,
    time_since_last_spawn: f32,
    growth_factor: f32,
}


wave_update :: proc(gm: ^GameManager) {
    if gm.state != GameState.InWave {
        return
    }
    gm.wave.time_since_last_spawn += gm.delta_time
    if gm.wave.time_since_last_spawn >= gm.wave.spawn_interval && len(gm.wave.enimies) < gm.wave.enemies_per_wave {
        create_enemy(gm)
        gm.wave.time_since_last_spawn = 0
    }
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
    }
}