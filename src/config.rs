use serde::{Deserialize, Serialize};

#[derive(Debug, Default, Deserialize, Serialize)]
pub struct IntroConfig {
    pub image: String,
    pub width: f32,
    pub height: f32,
}
