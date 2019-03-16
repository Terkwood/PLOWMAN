use amethyst::input::is_key_down;
use amethyst::prelude::*;
use amethyst::renderer::VirtualKeyCode;

use crate::main_menu_state::MainMenuState;

pub struct IntroState {}

// no system, so use emptystate
impl SimpleState for IntroState {
    fn on_start(&mut self, _data: StateData<'_, amethyst::GameData<'_, '_>>) {
        println!("Imagine some medieval text here 📜")
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
                return Trans::Push(Box::new(MainMenuState {}));
            }
        }

        // Space / Return isn't pressed, so we stay in this `State`.
        Trans::None
    }
}
