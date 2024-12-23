package game

PositionComponent :: [2]f32

CollisionComponent :: struct {
    width, height : f32,
    offset: [2]f32,
    position: Vec2,
    tag: string
}

AnimatorComponent :: struct {
    current_frame: i32,
    frame_count: i32,
    frame_width: i32,
    frame_height: i32,
    frame_speed: f32,
    last_frame: f32,
    triggered: bool,
}

RotationComponent :: f32

EnemyPathComponent :: [][2]f32

CoreComponent :: struct {
    health: i32,
}

EnemyComponent :: struct {
    health: i32,
    current_path : int,
    speed: f32
}

BuildComponent :: struct {
    damage: f32,
    range: f32,
    fire_rate: f32,
    last_fire: f32,
    type: BuildType,
    speed: f32,
    resource: int
}

ProjectileComponent :: struct {
    damage: f32,
    speed: f32,
    target: ^Entity,
    origin: Vec2,
}

ComponentData :: union {
    PositionComponent,
    CollisionComponent,
    EnemyComponent,
    EnemyPathComponent,
    RotationComponent,
    BuildComponent,
    ProjectileComponent,
    CoreComponent,
    AnimatorComponent
}

Component :: struct {
    data: ComponentData
}