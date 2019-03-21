use amethyst::core::bundle::SystemBundle;
use amethyst::ecs::prelude::DispatcherBuilder;

use crate::systems::player::PlayerSystem;

pub struct GameBundle;

impl<'a, 'b> SystemBundle<'a, 'b> for GameBundle {
    fn build(self, builder: &mut DispatcherBuilder<'a, 'b>) -> Result<(), amethyst::Error> {
        builder.add(PlayerSystem, "player_system", &["input_system"]);
        Ok(())
    }
}
