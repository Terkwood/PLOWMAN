use amethyst::ecs::prelude::{Component, VecStorage};


#[derive(Debug, Copy, Clone)]
pub enum CharacterMovement {
    Stopped,
    Walking,
}

impl Component for CharacterMovement {
    type Storage = VecStorage<Self,>
}