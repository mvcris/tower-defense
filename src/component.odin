package game

PositionComponent :: [2]f32

CollisionComponent :: struct {
    width, height : f32,
    tag: string
}

RotationComponent :: f32

EnemyPathComponent :: [][2]f32

PlayerComponent :: struct {
    health: i32,
    points: int,
}

EnemyComponent :: struct {
    health: i32,
    current_path : int,
    speed: f32
}

BuildComponent :: struct {
    cost: f32,
    damage: f32,
    range: f32,
    fire_rate: f32,
    last_fire: f32,
    type: BuildType
}

ComponentData :: union {
    PositionComponent,
    CollisionComponent,
    PlayerComponent,
    EnemyComponent,
    EnemyPathComponent,
    RotationComponent,
    BuildComponent
}

Component :: struct {
    data: ComponentData
}