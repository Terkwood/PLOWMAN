//! Bat sprite is from <https://opengameart.org/content/bat-32x32>.
use crate::animation_id::AnimationId;
use crate::BatPrefabData;
use amethyst::{
    animation::{get_animation_set, AnimationCommand, AnimationSet, EndControl},
    assets::{PrefabLoader, ProgressCounter, RonFormat},
    ecs::prelude::Entity,
    prelude::Builder,
    renderer::SpriteRender,
    GameData, SimpleState, SimpleTrans, StateData, Trans,
};

/// Main state of gameplay
#[derive(Default)]
pub struct GameplayState {
    /// A progress tracker to check that assets are loaded
    pub progress_counter: Option<ProgressCounter>,
    /// Bat entity to start animation after loading
    pub bat: Option<Entity>,
}

impl SimpleState for GameplayState {
    fn on_start(&mut self, data: StateData<'_, GameData<'_, '_>>) {
        let StateData { world, .. } = data;
        // Crates new progress counter
        self.progress_counter = Some(Default::default());
        // Starts asset loading
        let prefab_handle = world.exec(|loader: PrefabLoader<'_, BatPrefabData>| {
            loader.load(
                "prefab/sprite_animation.ron",
                RonFormat,
                (),
                self.progress_counter.as_mut().unwrap(),
            )
        });
        // Creates a new entity with components from PrefabData
        self.bat = Some(world.create_entity().with(prefab_handle).build());
    }

    fn update(&mut self, data: &mut StateData<'_, GameData<'_, '_>>) -> SimpleTrans {
        // Checks if we are still loading data
        if let Some(ref progress_counter) = self.progress_counter {
            // Checks progress
            if progress_counter.is_complete() {
                let StateData { world, .. } = data;
                // Gets the Fly animation from AnimationSet
                let animation = world
                    .read_storage::<AnimationSet<AnimationId, SpriteRender>>()
                    .get(self.bat.unwrap())
                    .and_then(|s| s.get(&AnimationId::Fly).cloned())
                    .unwrap();
                // Creates a new AnimationControlSet for bat entity
                let mut sets = world.write_storage();
                let control_set =
                    get_animation_set::<AnimationId, SpriteRender>(&mut sets, self.bat.unwrap())
                        .unwrap();
                // Adds the animation to AnimationControlSet and loops infinitely
                control_set.add_animation(
                    AnimationId::Fly,
                    &animation,
                    EndControl::Loop(None),
                    1.0,
                    AnimationCommand::Start,
                );
                // All data loaded
                self.progress_counter = None;
            }
        }
        Trans::None
    }
}
