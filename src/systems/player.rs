use amethyst::core::timing::Time;
use amethyst::core::transform::Transform;
use amethyst::ecs::prelude::{Entities, Join, LazyUpdate, ReadExpect, System, WriteStorage};
use amethyst::input::InputHandler;

/// Moves the player and based on user-provided input.
pub struct PlayerSystem;

impl<'s> System<'s> for PlayerSystem {
    type SystemData = (
        Entities<'s>,
        ReadExpect<'s, InputHandler<String, String>>,
        ReadExpect<'s, LazyUpdate>,
    );

    fn run(&mut self, (entities, input, lazy_update): Self::SystemData) {
        () // TODO walk around and stop and whatnot
    }
}
