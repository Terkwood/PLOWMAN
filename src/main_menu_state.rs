use amethyst::input::is_key_down;
use amethyst::prelude::*;
use amethyst::renderer::VirtualKeyCode;

use crate::gameplay_state::GameplayState;

pub struct MainMenuState {}

// no system, so use emptystate
impl SimpleState for MainMenuState {
    fn on_start(&mut self, _data: StateData<'_, amethyst::GameData<'_, '_>>) {
        println!("Imagine a main menu here 📟");
    }

    fn handle_event(
        &mut self,
        _data: StateData<'_, amethyst::GameData<'_, '_>>,
        event: StateEvent,
    ) -> SimpleTrans {
        if let StateEvent::Window(event) = &event {
            if is_key_down(&event, VirtualKeyCode::Return)
                || is_key_down(&event, VirtualKeyCode::Space)
            {
                return Trans::Push(Box::new(GameplayState::default()));
            }
        }

        // Space / Return isn't pressed, so we stay in this `State`.
        Trans::None
    }
}
