use crate::animation_id::AnimationId;
use crate::entities::player::PlayerPrefabData;
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
    /// Player entity to animate after loading
    pub player: Option<Entity>,
}

impl SimpleState for GameplayState {
    fn on_start(&mut self, data: StateData<'_, GameData<'_, '_>>) {
        let StateData { world, .. } = data;
        // Crates new progress counter
        self.progress_counter = Some(Default::default());
        // Starts asset loading
        let prefab_handle = world.exec(|loader: PrefabLoader<'_, PlayerPrefabData>| {
            loader.load(
                "prefab/sprite_animation.ron",
                RonFormat,
                (),
                self.progress_counter.as_mut().unwrap(),
            )
        });
        // Creates a new entity with components from PrefabData
        self.player = Some(world.create_entity().with(prefab_handle).build());
    }

    fn update(&mut self, data: &mut StateData<'_, GameData<'_, '_>>) -> SimpleTrans {
        // Checks if we are still loading data
        if let Some(ref progress_counter) = self.progress_counter {
            // Checks progress
            if progress_counter.is_complete() {
                let StateData { world, .. } = data;

                let anim_id = AnimationId::WalkRight;
                // Gets an animation from AnimationSet
                let animation = world
                    .read_storage::<AnimationSet<AnimationId, SpriteRender>>()
                    .get(self.player.unwrap())
                    .and_then(|s| s.get(&anim_id).cloned())
                    .unwrap();
                // Creates a new AnimationControlSet for player entity
                let mut sets = world.write_storage();
                let control_set =
                    get_animation_set::<AnimationId, SpriteRender>(&mut sets, self.player.unwrap())
                        .unwrap();
                // Adds the animation to AnimationControlSet and loops infinitely
                control_set.add_animation(
                    anim_id,
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
