extends Node2D

export var zone_size: Vector2 = Vector2(128,128)
export var random_position = true

func _ready():
	if random_position:
		position = Vector2(randi()%Chunk.width(), randi()%Chunk.height())
	var collision_rect: RectangleShape2D = $Area2D/CollisionShape2D.shape
	collision_rect.extents = zone_size
