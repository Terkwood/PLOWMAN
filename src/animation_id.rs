use crate::components::character_movement::{CharacterMovement, Direction};
use serde::{Deserialize, Serialize};
/// Animation ids used in a AnimationSet
#[derive(Eq, PartialOrd, PartialEq, Hash, Debug, Copy, Clone, Deserialize, Serialize)]
pub enum AnimationId {
    EvokeUp,
    EvokeLeft,
    EvokeRight,
    EvokeDown,
    ThrustUp,
    ThrustLeft,
    ThrustRight,
    ThrustDown,
    WalkUp,
    WalkLeft,
    WalkRight,
    WalkDown,
}

impl AnimationId {
    pub fn maybe_from(cm: CharacterMovement) -> Option<AnimationId> {
        match cm {
            CharacterMovement::Walking(Direction::N) => Some(AnimationId::WalkUp),
            CharacterMovement::Walking(Direction::NE) => Some(AnimationId::WalkRight),
            CharacterMovement::Walking(Direction::E) => Some(AnimationId::WalkRight),
            CharacterMovement::Walking(Direction::SE) => Some(AnimationId::WalkDown),
            CharacterMovement::Walking(Direction::S) => Some(AnimationId::WalkDown),
            CharacterMovement::Walking(Direction::SW) => Some(AnimationId::WalkLeft),
            CharacterMovement::Walking(Direction::W) => Some(AnimationId::WalkLeft),
            CharacterMovement::Walking(Direction::NW) => Some(AnimationId::WalkUp),
            _ => None,
        }
    }
}
