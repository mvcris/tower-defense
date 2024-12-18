package game

EntityId :: distinct u64

EntityType :: enum {
    Player,
    Enemey,
    Projecttile,
    Build
}

Entity :: struct {
    id: EntityId,
    type: EntityType,
    components: [dynamic]^Component,
}

EntityManager :: struct {
    entities: [dynamic]^Entity,
    next_id: EntityId,
}

make_entity_manager :: proc() ->^EntityManager {
    manager := new(EntityManager)
    manager.entities = make([dynamic]^Entity, 0)
    manager.next_id = 1
    return manager
}

destroy_entity_manager :: proc(em: ^EntityManager) {
    for entity in em.entities {
        for component in entity.components {
              if enemy_path, ok := component.data.([]Vec2); ok {
                    delete(enemy_path)
                }
            free(component)
        }
        delete(entity.components)
        free(entity)
    }
    delete(em.entities)
    free(em)
}

create_entitiy :: proc(
    em: ^EntityManager,
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

destroy_entity :: proc(em: ^EntityManager, entity: ^Entity) {
    for &e, i in em.entities {
        if e == entity {
            for component in entity.components {
                if enemy_path, ok := component.data.([]Vec2); ok {
                    delete(enemy_path)
                }
                free(component)
            }
            if entity.components != nil {
                delete(entity.components)
            }
            free(entity)
        }
    }
}


add_component :: proc(entity: ^Entity, component:ComponentData) {
    comp := new(Component)
    comp.data = component
    append(&entity.components, comp)
}

get_component :: proc(entity: ^Entity, $T: typeid) -> (^T) {
    for &component in entity.components {
        if v, ok := component.data.(T); ok {
            return cast(^T)&component.data
        }
    }
    return nil
}

get_entity :: proc(em: ^EntityManager, id: EntityId) -> ^Entity {
    for &entity in em.entities {
        if entity.id == id {
            return entity
        }
    }
    return nil
}