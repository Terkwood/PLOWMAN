extends KinematicBody2D

const WALK_SPEED = 225

enum REACH_CONE_ROTATION { Down = 0, Left = 90, Up = 180, Right = 270 }
# use rotation as key
const REACH_CONE_OFFSET = {
	0: Vector2(0,30),
	90: Vector2(-8, 15),
	180: Vector2(0,0),
	270: Vector2(8,15),
}

var dir = Vector2()

func mutate_reach_cone(d: Vector2):
	var pcr = []
	if d.x == -1:
		pcr = [REACH_CONE_ROTATION.Left]
	elif d.x == 1:
		pcr = [REACH_CONE_ROTATION.Right]
	elif d.y == -1:
		pcr = [REACH_CONE_ROTATION.Up]
	elif d.y == 1:
		pcr = [REACH_CONE_ROTATION.Down]

	for p in pcr:
		$ReachArea/ReachCone.rotation_degrees = p
		$ReachArea/ReachCone.position = REACH_CONE_OFFSET[p]


func _physics_process(_delta):
	var is_anim = false
	if Input.is_action_pressed("ui_left"):
		dir.x = -1
		$Sprite.get_node("WalkAnims").play("WalkLeft")
		is_anim = true
	elif Input.is_action_pressed("ui_right"):
		dir.x =  1
		$Sprite.get_node("WalkAnims").play("WalkRight")
		is_anim = true
	else:
		dir.x = 0

	if Input.is_action_pressed("ui_up"):
		dir.y = -1
		if !is_anim:
			$Sprite.get_node("WalkAnims").play("WalkUp")
		is_anim = true
	elif Input.is_action_pressed("ui_down"):
		dir.y =  1
		if !is_anim:
			$Sprite.get_node("WalkAnims").play("WalkDown")
		is_anim = true
	else:
		dir.y = 0

	if !is_anim:
		$Sprite.get_node("WalkAnims").stop()

	move_and_slide(dir.normalized() * WALK_SPEED, Vector2(0, 0))
	mutate_reach_cone(dir)

func _process(_delta):
	ZIndex.hack(self.position.y, $Sprite, $Sprite)
	
func _on_PickupArea_body_entered(body):
	print("Pickup area: %s" % body.name)