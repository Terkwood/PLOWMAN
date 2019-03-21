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
