use amethyst::{
    animation::AnimationSetPrefab,
    assets::{PrefabData, ProgressCounter},
    core::transform::Transform,
    derive::PrefabData,
    ecs::prelude::Entity,
    error::Error,
    renderer::{SpriteRender, SpriteRenderPrefab},
};
use serde::{Deserialize, Serialize};

use crate::animation_id::AnimationId;

#[derive(Debug, Clone, Serialize, Deserialize, PrefabData)]
pub struct PlayerPrefabData {
    /// Rendering position and orientation
    transform: Transform,
    /// Information for rendering a sprite
    sprite_render: SpriteRenderPrefab,
    /// Аll animations that can be run on the entity
    animation_set: AnimationSetPrefab<AnimationId, SpriteRender>,
}
