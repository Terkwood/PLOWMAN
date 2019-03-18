extern crate amethyst;

mod animation_id;
mod config;
mod gameplay_state;
mod intro_state;
mod main_menu_state;

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

/// Loading data for one entity
#[derive(Debug, Clone, Serialize, Deserialize, PrefabData)]
pub struct BatPrefabData {
    /// Rendering position and orientation
    transform: Transform,
    /// Information for rendering a sprite
    sprite_render: SpriteRenderPrefab,
    /// Аll animations that can be run on the entity
    animation_set: AnimationSetPrefab<AnimationId, SpriteRender>,
}

fn main() -> amethyst::Result<()> {
    amethyst::start_logger(Default::default());

    let app_root = application_root_dir()?;
    let assets_directory = app_root.join("assets/");
    let display_conf_path = app_root.join("resources/display_config.ron");
    let game_conf_path = app_root.join("resources/config.ron");
    let display_config = DisplayConfig::load(display_conf_path);
    let intro_config = IntroConfig::load(game_conf_path);

    let pipe = Pipeline::build().with_stage(
        Stage::with_backbuffer()
            .clear_target([0.0, 0.0, 0.0, 1.0], 1.0)
            .with_pass(DrawFlat2D::new()),
    );

    let game_data = GameDataBuilder::default()
        .with(PrefabLoaderSystem::<BatPrefabData>::default(), "", &[])
        .with_bundle(TransformBundle::new())?
        .with_bundle(AnimationBundle::<AnimationId, SpriteRender>::new(
            "animation_control_system",
            "sampler_interpolation_system",
        ))?
        .with_bundle(RenderBundle::new(pipe, Some(display_config)).with_sprite_sheet_processor())?;

    let mut game = Application::build(assets_directory, IntroState::default())
        .expect("failed to initialize")
        .with_resource(intro_config)
        .build(game_data)?;

    game.run();

    Ok(())
}
