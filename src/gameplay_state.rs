use crate::animation_id::AnimationId;
use crate::components::character_movement::CharacterMovement;
use crate::components::player::Player;
use crate::entities::player::PlayerPrefabData;

use amethyst::{
    animation::{get_animation_set, AnimationCommand, AnimationSet, EndControl},
    assets::{PrefabLoader, ProgressCounter, RonFormat},
    ecs::prelude::{Entity, ReadStorage},
    input::is_key_down,
    prelude::*,
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
    pub last_player_anim: Option<AnimationId>,
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
        // Creates a new player entity with components from PrefabData
        self.player = Some(
            world
                .create_entity()
                .with(CharacterMovement::Stopped)
                .with(Player)
                .with(prefab_handle)
                .build(),
        );
    }

    fn update(&mut self, data: &mut StateData<'_, GameData<'_, '_>>) -> SimpleTrans {
        data.data.update(data.world);
        Trans::None
    }

    fn fixed_update(&mut self, data: StateData<'_, GameData<'_, '_>>) -> SimpleTrans {
        // Add all player walk animations after the spritesheet is done loading
        if let Some(ref progress_counter) = self.progress_counter {
            if progress_counter.is_complete() {
                let StateData { world, .. } = data;

                let anim_ids = vec![
                    AnimationId::WalkUp,
                    AnimationId::WalkLeft,
                    AnimationId::WalkDown,
                    AnimationId::WalkRight,
                ];

                for anim_id in anim_ids {
                    // Gets an animation from AnimationSet
                    let animation = world
                        .read_storage::<AnimationSet<AnimationId, SpriteRender>>()
                        .get(self.player.unwrap())
                        .and_then(|s| s.get(&anim_id).cloned())
                        .unwrap();

                    // Creates a new AnimationControlSet for player entity
                    let mut sets = world.write_storage();
                    let control_set = get_animation_set::<AnimationId, SpriteRender>(
                        &mut sets,
                        self.player.unwrap(),
                    )
                    .unwrap();

                    // Adds the animation to AnimationControlSet and loops infinitely
                    control_set.add_animation(
                        anim_id,
                        &animation,
                        EndControl::Loop(None),
                        0.5,
                        AnimationCommand::Init,
                    );
                }

                // All data loaded
                self.progress_counter = None;
            }
        } else {
            // Spritesheet is already loaded --
            // Check state of player walk and draw the correct
            // animation if necessary

            if let Some(player_entity) = self.player {
                let mv_storage: ReadStorage<CharacterMovement> = data.world.read_storage();
                if let Some(player_movement) = mv_storage.get(player_entity) {
                    println!("player_movement {:?}", player_movement);
                    let mut sets = data.world.write_storage();
                    let control_set =
                        get_animation_set::<AnimationId, SpriteRender>(&mut sets, player_entity)
                            .unwrap();
                    let maybe_next_anim_id = AnimationId::maybe_from(*player_movement);
                    println!("maybe_next_anim_id {:?}", maybe_next_anim_id);
                    if maybe_next_anim_id != self.last_player_anim {
                        if let Some(last_anim_id) = self.last_player_anim {
                            if Some(last_anim_id) != maybe_next_anim_id {
                                println!("abort");
                                control_set.toggle(last_anim_id);
                            }
                        }
                    }
                    if let Some(next_anim_id) = maybe_next_anim_id {
                        println!("start {:?}", next_anim_id);
                        control_set.toggle(next_anim_id);
                    }

                    self.last_player_anim = maybe_next_anim_id;
                } else {
                    println!("storage returns None");
                }
            }
        }

        Trans::None
    }
}
