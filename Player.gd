extends KinematicBody2D

const ItemClass = preload("res://Item.gd")

const WALK_SPEED = 1500 # 225

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
	ZIndex.hack($Sprite)

var pickup_candidate_bodies = []

func _on_ReachArea_body_entered(body):
	var has_pickup_manager = body.has_node("PickupManager")
	if has_pickup_manager:
		pickup_candidate_bodies.push_front(body)

func _on_ReachArea_body_exited(body):
	for pcb in pickup_candidate_bodies:
		if pcb.get_instance_id() == body.get_instance_id():
			pickup_candidate_bodies.erase(pcb)

onready var default_icon_texture = $Inventory.TOMATO_ICON.instance().texture
func icon_texture_for(name: String):
	return $Inventory.texture_lookup.get(name, default_icon_texture)
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("game_interact"):
		if !pickup_candidate_bodies.empty():
			var body_to_pickup = pickup_candidate_bodies.pop_front()
			var pickup = body_to_pickup.get_node("PickupManager")
			$Inventory.add(ItemClass.new(pickup.item_name, icon_texture_for(pickup.item_name), 1))
			pickup.destroy_target()
