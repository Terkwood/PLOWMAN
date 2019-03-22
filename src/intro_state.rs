use amethyst::{
    assets::{AssetStorage, Loader, ProgressCounter},
    core::transform::Transform,
    ecs::prelude::Entity,
    input::get_key,
    prelude::*,
    renderer::{Camera, PngFormat, Projection, ScreenDimensions, Texture, TextureMetadata},
};

use crate::config::IntroConfig;
use crate::gameplay_state::GameplayState;
use crate::image::Image;

#[derive(Default)]
pub struct IntroState {
    /// Tracks loaded assets.
    progress_counter: Option<ProgressCounter>,
    /// Handle to an image.
    image: Option<Image>,
    image_entity: Option<Entity>,
}

impl IntroState {
    fn image_is_loaded(&self) -> bool {
        self.image_entity.is_some()
    }
}

impl SimpleState for IntroState {
    fn on_start(&mut self, data: StateData<'_, amethyst::GameData<'_, '_>>) {
        let StateData { world, .. } = data;

        // Creates a new camera
        initialise_camera(world);

        let config = world.read_resource::<IntroConfig>();
        let loader = world.read_resource::<Loader>();

        self.progress_counter = Some(Default::default());

        let image = &config.image;
        let texture_handle = loader.load(
            image.to_string(),
            PngFormat,
            TextureMetadata::srgb(),
            self.progress_counter.as_mut().unwrap(),
            &world.read_resource::<AssetStorage<Texture>>(),
        );

        self.image = Some(Image {
            texture_handle,
            width: config.width,
            height: config.height,
        });
    }

    fn on_stop(&mut self, data: StateData<'_, amethyst::GameData<'_, '_>>) {
        if let Some(entity) = self.image_entity {
            let StateData { world, .. } = data;

            remove_image(world, entity);
        }
    }

    fn handle_event(
        &mut self,
        _data: StateData<'_, amethyst::GameData<'_, '_>>,
        event: StateEvent,
    ) -> SimpleTrans {
        if let StateEvent::Window(event) = &event {
            if let Some(_key) = get_key(&event) {
                return Trans::Switch(Box::new(GameplayState::default()));
            }
        }

        // No key pressed, so stay in this state
        Trans::None
    }

    fn update(&mut self, data: &mut StateData<'_, GameData<'_, '_>>) -> SimpleTrans {
        if let Some(ref progress_counter) = self.progress_counter {
            let img_loaded = !self.image_is_loaded();
            if let Some(image) = &mut self.image {
                if progress_counter.is_complete() && img_loaded {
                    let StateData { world, .. } = data;
                    let entity = init_image(world, &image);

                    self.image_entity = Some(entity);
                }
            }
        }

        Trans::None
    }
}

fn init_image(world: &mut World, image: &Image) -> Entity {
    let (screen_width, screen_height, hidpi) = {
        let dim = world.read_resource::<ScreenDimensions>();
        (dim.width(), dim.height(), dim.hidpi_factor())
    };

    let mut transform = Transform::default();

    let x_trans = screen_width / (2.0 * hidpi as f32);
    let y_trans = screen_height / (2.0 * hidpi as f32);

    transform.set_translation_x(x_trans);
    transform.set_translation_y(y_trans);

    world
        .create_entity()
        .with(transform)
        .with(image.texture_handle.clone())
        .build()
}

fn remove_image(world: &mut World, image_entity: Entity) {
    world
        .delete_entity(image_entity)
        .expect("failed to remove loader image")
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
