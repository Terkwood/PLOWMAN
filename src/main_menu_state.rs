use amethyst::prelude::*;

pub struct MainMenuState {}

// no system, so use emptystate
impl SimpleState for MainMenuState {
    fn on_start(&mut self, _data: StateData<'_, amethyst::GameData<'_, '_>>) {
        println!("Imagine a main menu here 📟");
    }
}
