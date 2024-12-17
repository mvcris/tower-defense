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

ComponentData :: union {
    PositionComponent,
    CollisionComponent,
    PlayerComponent,
    EnemyComponent,
    EnemyPathComponent,
    RotationComponent
}

Component :: struct {
    data: ComponentData
}