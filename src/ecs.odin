package game

EntityId :: distinct u64

EntityType :: enum {
    Player,
    Enemey,
    Projecttile,
}

Entity :: struct {
    id: EntityId,
    type: EntityType,
    components: [dynamic]^Component,
}

Entity_Manager :: struct {
    entities: [dynamic]^Entity,
    next_id: EntityId,
}

make_entity_manager :: proc() ->^Entity_Manager {
    manager := new(Entity_Manager)
    manager.entities = make([dynamic]^Entity, 0)
    manager.next_id = 1
    return manager
}

create_entitiy :: proc(
    em: ^Entity_Manager,
    type: EntityType
) ->^Entity {
    entity := new(Entity)
    entity.id = em.next_id
    entity.type = type
    entity.components = make([dynamic]^Component, 0)
    append(&em.entities, entity)
    em.next_id += 1
    return entity
}

add_component :: proc(entity: ^Entity, component:ComponentData) -> ^Component {
    comp := new(Component)
    comp.data = component
    append(&entity.components, comp)
    return comp
}

get_component :: proc(entity: ^Entity, $T: typeid) -> (^T) {
    for &component in entity.components {
        if v, ok := component.data.(T); ok {
            return cast(^T)&component.data
        }
    }
    return nil
}

get_entity :: proc(em: ^Entity_Manager, id: EntityId) -> ^Entity {
    for &entity in em.entities {
        if entity.id == id {
            return entity
        }
    }
    return nil
}