use amethyst::core::timing::Time;
use amethyst::core::transform::Transform;
use amethyst::ecs::prelude::{Entities, Join, LazyUpdate, ReadExpect, System, WriteStorage};
use amethyst::input::InputHandler;

use crate::animation_id::AnimationId;

/// Moves the player and based on user-provided input.
pub struct PlayerSystem;

impl<'s> System<'s> for PlayerSystem {
    type SystemData = (
        Entities<'s>,
        ReadExpect<'s, InputHandler<String, String>>,
        ReadExpect<'s, LazyUpdate>,
    );

    fn run(&mut self, (entities, input, lazy_update): Self::SystemData) {
        // get the current 'joystick' reading
        let maybe_movement_x = input.axis_value("player_x");
        let maybe_movement_y = input.axis_value("player_y");

        let maybe_anim_id = walk_anim(maybe_movement_x, maybe_movement_y);
        () // TODO do some walking, or not
    }
}

fn walk_anim(movement_x: Option<f64>, movement_y: Option<f64>) -> Option<AnimationId> {
    let mut r = None;
    if let Some(y) = movement_y {
        if y < 0.0 {
            r = Some(AnimationId::WalkDown)
        } else if y > 0.0 {
            r = Some(AnimationId::WalkUp)
        }
    };
    if let Some(x) = movement_x {
        if x < 0.0 {
            r = Some(AnimationId::WalkLeft);
        } else if x > 0.0 {
            r = Some(AnimationId::WalkRight);
        }
    };
    r
}
