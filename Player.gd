extends KinematicBody2D

const WALK_SPEED = 150

var velocity = Vector2()

func _physics_process(_delta):
	var is_anim = false
	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
		$Sprite.get_node("WalkAnims").play("WalkLeft")
		is_anim = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
		$Sprite.get_node("WalkAnims").play("WalkRight")
		is_anim = true
	else:
		velocity.x = 0
		
	if Input.is_action_pressed("ui_up"):
		velocity.y = -WALK_SPEED
		if !is_anim:
			$Sprite.get_node("WalkAnims").play("WalkUp")
		is_anim = true
	elif Input.is_action_pressed("ui_down"):
		velocity.y =  WALK_SPEED
		if !is_anim:
			$Sprite.get_node("WalkAnims").play("WalkDown")
		is_anim = true
	else:
		velocity.y = 0
	
	if !is_anim:
		$Sprite.get_node("WalkAnims").stop()
	move_and_slide(velocity, Vector2(0, 0))
	set_z_order(self.position.y, $Sprite)
	
func set_z_order(y,N):
	var fix = y + $Sprite.region_rect.size.y
	#print("PLAYER: fix y " + str(fix))		 
	N.z_index=fix