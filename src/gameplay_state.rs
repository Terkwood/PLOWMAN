use crate::animation_id::AnimationId;
use crate::entities::player::PlayerPrefabData;
use amethyst::{
    animation::{get_animation_set, AnimationCommand, AnimationSet, EndControl},
    assets::{PrefabLoader, ProgressCounter, RonFormat},
    ecs::prelude::Entity,
    input::is_key_down,
    prelude::*,
    renderer::SpriteRender,
    winit::VirtualKeyCode,
    GameData, SimpleState, SimpleTrans, StateData, Trans,
};

/// Main state of gameplay
#[derive(Default)]
pub struct GameplayState {
    /// A progress tracker to check that assets are loaded
    pub progress_counter: Option<ProgressCounter>,
    /// Player entity to animate after loading
    pub player: Option<Entity>,
    pub anim_id: Option<AnimationId>,
}

impl GameplayState {
    fn loading_complete(&self) -> bool {
        self.progress_counter.is_none()
    }
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

    fn handle_event(
        &mut self,
        _: StateData<'_, GameData<'_, '_>>,
        event: StateEvent,
    ) -> SimpleTrans {
        if let StateEvent::Window(event) = event {
            if is_key_down(&event, VirtualKeyCode::Right)
                && self.anim_id.is_none()
                && self.loading_complete()
            {
                println!("Ok! :-)")
            }
        }
        Trans::None
    }

    fn fixed_update(&mut self, data: StateData<'_, GameData<'_, '_>>) -> SimpleTrans {
        // Force amethyst to run all systems
        // You can move this to the "update" method if
        // you need it called more than 60 times/sec 🔥
        data.data.update(data.world);

        // Checks if we are still loading data
        if let Some(ref progress_counter) = self.progress_counter {
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
                    0.5,
                    AnimationCommand::Start,
                );

                // Use this to stop the animation later
                self.anim_id = Some(anim_id);

                // All data loaded
                self.progress_counter = None;
            }
        }

        Trans::None
    }
}
