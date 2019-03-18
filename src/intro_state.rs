use amethyst::{
    assets::{AssetStorage, Loader, ProgressCounter},
    core::transform::Transform,
    ecs::prelude::Entity,
    input::is_key_down,
    prelude::*,
    renderer::{
        Camera, PngFormat, Projection, ScreenDimensions, Texture, TextureHandle, TextureMetadata,
        VirtualKeyCode,
    },
};

use crate::config::IntroConfig;
use crate::main_menu_state::MainMenuState;

#[derive(Default)]
pub struct IntroState {
    /// Tracks loaded assets.
    progress_counter: Option<ProgressCounter>,
    /// Handle to an image.
    texture_handle: Option<TextureHandle>,
    texture_width: Option<f32>,
    texture_height: Option<f32>,
}

// no system, so use emptystate
impl SimpleState for IntroState {
    fn on_start(&mut self, data: StateData<'_, amethyst::GameData<'_, '_>>) {
        let StateData { world, .. } = data;

        // Creates a new camera
        initialise_camera(world);

        let config = world.read_resource::<IntroConfig>();
        let loader = world.read_resource::<Loader>();

        // Crates new progress counter
        self.progress_counter = Some(Default::default());

        let image = &config.image;
        let texture_handle = loader.load(
            image.to_string(),
            PngFormat,
            TextureMetadata::srgb(),
            self.progress_counter.as_mut().unwrap(),
            &world.read_resource::<AssetStorage<Texture>>(),
        );

        self.texture_handle = Some(texture_handle);
        self.texture_width = Some(config.width);
        self.texture_height = Some(config.height);
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

    fn update(&mut self, data: &mut StateData<'_, GameData<'_, '_>>) -> SimpleTrans {
        // Checks if we are still loading data
        if let Some(ref progress_counter) = self.progress_counter {
            // Checks progress
            if progress_counter.is_complete() {
                let StateData { world, .. } = data;
                let _image = init_image(
                    world,
                    &self.texture_handle.clone().unwrap(),
                    self.texture_width.unwrap_or(200.0),
                    self.texture_height.unwrap_or(400.0),
                );
            }
        }

        Trans::None
    }
}

fn init_image(
    world: &mut World,
    texture: &TextureHandle,
    image_width: f32,
    image_height: f32,
) -> Entity {
    let (screen_width, screen_height) = {
        let dim = world.read_resource::<ScreenDimensions>();
        (dim.width(), dim.height())
    };

    let mut transform = Transform::default();
    transform.set_translation_x((screen_width - image_width) / 2.0);
    transform.set_translation_y((screen_height - image_height) / 2.0);

    world
        .create_entity()
        .with(transform)
        .with(texture.clone())
        .build()
}

fn initialise_camera(world: &mut World) {
    let (width, height) = {
        let dim = world.read_resource::<ScreenDimensions>();
        (dim.width(), dim.height())
    };

    let mut camera_transform = Transform::default();
    camera_transform.set_translation_z(1.0);

    world
        .create_entity()
        .with(camera_transform)
        .with(Camera::from(Projection::orthographic(
            0.0, width, 0.0, height,
        )))
        .build();
}
