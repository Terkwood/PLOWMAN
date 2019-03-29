extends Node2D

export var zone_size: Vector2 = Vector2(128,128)

func _ready():
	var collision_rect: RectangleShape2D = $Area2D/CollisionShape2D.shape
	collision_rect.extents = zone_size
