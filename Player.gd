extends KinematicBody2D

const WALK_SPEED = 225

var dir = Vector2()

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
	$ReachArea.update_reach_cone(dir)

func _process(_delta):
	ZIndex.hack(self.position.y, $Sprite, $Sprite)


var pickup_candidate_bodies = []

func _on_ReachArea_body_entered(body):
	print("Pickup area: %s" % body.name)
	var has_pickup_manager = body.has_node("PickupManager")
	if has_pickup_manager:
		print("Target has a PickupManager")
		pickup_candidate_bodies.push_front(body)

func _on_ReachArea_body_exited(body):
	for c in range(pickup_candidate_bodies.size()):
		if pickup_candidate_bodies[c].get_instance_id() == body.get_instance_id():
			pickup_candidate_bodies.remove(c)
			print("removed candidate body %s" % body.name)
