extends KinematicBody2D

const WALK_SPEED = 225

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

func _process(_delta):
	ZIndex.hack(self.position.y, $Sprite, $Sprite)
	