use amethyst::{
    animation::{AnimationBundle, AnimationSetPrefab},
    assets::{PrefabData, PrefabLoaderSystem, ProgressCounter},
    config::Config,
    core::transform::{Transform, TransformBundle},
    derive::PrefabData,
    ecs::prelude::Entity,
    error::Error,
    renderer::{
        DisplayConfig, DrawFlat2D, Pipeline, RenderBundle, SpriteRender, SpriteRenderPrefab, Stage,
    },
    utils::application_root_dir,
    Application, GameDataBuilder,
};
use serde::{Deserialize, Serialize};

use crate::animation_id::AnimationId;
use crate::config::IntroConfig;
use crate::intro_state::IntroState;

#[derive(Debug, Clone, Serialize, Deserialize, PrefabData)]
pub struct PlayerPrefabData {
    /// Rendering position and orientation
    transform: Transform,
    /// Information for rendering a sprite
    sprite_render: SpriteRenderPrefab,
    /// Аll animations that can be run on the entity
    animation_set: AnimationSetPrefab<AnimationId, SpriteRender>,
}
