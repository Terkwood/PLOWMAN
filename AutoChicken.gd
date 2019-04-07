extends Node2D

# all chickens share the same zone_size, since the collision
# rect is copied among them.  you could create the collision
# rect on _ready, if you wanted each chicken to have a unique
# zone size
export var zone_size: Vector2 = Vector2(128,128)
export var random_position = true

func manifest():
	return StorageManifest.position_manifest(self)

func _ready():
	if random_position:
		position = Vector2(randi()%Chunk.width(), randi()%Chunk.height())
	var collision_rect: RectangleShape2D = $Area2D/CollisionShape2D.shape
	collision_rect.extents = zone_size
