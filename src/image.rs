use amethyst::renderer::TextureHandle;

#[derive(Clone, Debug)]
pub struct Image {
    pub texture_handle: TextureHandle,
    pub width: f32,
    pub height: f32,
}
