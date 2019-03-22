use amethyst::core::timing::Time;
use amethyst::core::transform::Transform;
use amethyst::ecs::prelude::{
    Entities, Join, LazyUpdate, ReadExpect, ReadStorage, System, WriteStorage,
};
use amethyst::input::InputHandler;

use crate::components::character_movement::{CharacterMovement, Direction};
use crate::components::player::Player;

/// Moves the player and based on user-provided input.
pub struct PlayerSystem;

impl<'s> System<'s> for PlayerSystem {
    type SystemData = (
        Entities<'s>,
        ReadExpect<'s, InputHandler<String, String>>,
        ReadStorage<'s, Player>,
        WriteStorage<'s, CharacterMovement>,
    );

    fn run(&mut self, (entities, input, _players, mut char_mv): Self::SystemData) {
        let mut update = None;
        for (player_entity, old_movement) in (&*entities, &mut char_mv).join() {
            // get the current 'joystick' reading
            let maybe_movement_x = input.axis_value("player_x");
            let maybe_movement_y = input.axis_value("player_y");

            let movement = mv_from_input(maybe_movement_x, maybe_movement_y);

            if old_movement != &movement {
                println!("Movement is {:?}", movement);
                update = Some((player_entity, movement));
            }
        }
        if let Some((player_entity, mv)) = update {
            // will overwrite
            char_mv.insert(player_entity, mv).unwrap();
        }
    }
}

fn mv_from_input(movement_x: Option<f64>, movement_y: Option<f64>) -> CharacterMovement {
    match (movement_x, movement_y) {
        (Some(x), Some(y)) if x > 0.0 && y > 0.0 => CharacterMovement::Walking(Direction::NE),
        (Some(x), Some(y)) if x < 0.0 && y < 0.0 => CharacterMovement::Walking(Direction::SW),
        (Some(x), Some(y)) if x > 0.0 && y < 0.0 => CharacterMovement::Walking(Direction::SE),
        (Some(x), Some(y)) if x < 0.0 && y > 0.0 => CharacterMovement::Walking(Direction::NW),
        (Some(x), _) if x > 0.0 => CharacterMovement::Walking(Direction::E),
        (Some(x), _) if x < 0.0 => CharacterMovement::Walking(Direction::W),
        (_, Some(y)) if y > 0.0 => CharacterMovement::Walking(Direction::N),
        (_, Some(y)) if y < 0.0 => CharacterMovement::Walking(Direction::S),
        _ => CharacterMovement::Stopped,
    }
}
