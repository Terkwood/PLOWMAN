use amethyst::ecs::prelude::{Component, VecStorage};

#[derive(Debug, Copy, Clone, PartialEq)]
pub enum CharacterMovement {
    Stopped,
    Walking(Direction),
}

#[derive(Debug, Copy, Clone, PartialEq)]
pub enum Direction {
    N,
    NW,
    W,
    SW,
    S,
    SE,
    E,
    NE,
}

impl Component for CharacterMovement {
    type Storage = VecStorage<Self>;
}
