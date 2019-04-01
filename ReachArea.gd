extends Area2D

enum REACH_CONE_ROTATION { Down = 0, Left = 90, Up = 180, Right = 270 }
# use rotation as key
const REACH_CONE_OFFSET = {
	0: Vector2(0,30),
	90: Vector2(-8, 15),
	180: Vector2(0,0),
	270: Vector2(8,15),
}

func update_reach_cone(d: Vector2):
	var pcr
	
	if d.x == -1:
		pcr = REACH_CONE_ROTATION.Left
	elif d.x == 1:
		pcr = REACH_CONE_ROTATION.Right
	elif d.y == -1:
		pcr = REACH_CONE_ROTATION.Up
	elif d.y == 1:
		pcr = REACH_CONE_ROTATION.Down

	if pcr != null:
		$ReachCone.rotation_degrees = pcr
		$ReachCone.position = REACH_CONE_OFFSET[pcr]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
