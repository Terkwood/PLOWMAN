extends Node2D

export var zone_size: Vector2 = Vector2(128,128)

# chicken will remain inside
# this bounding box
func zone():
	return Rect2(position,zone_size)

func _ready():
	pass # Replace with function body.

