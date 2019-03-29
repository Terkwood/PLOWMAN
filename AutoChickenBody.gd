extends KinematicBody2D

func _ready():
	move_and_slide(Vector2(300,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_body_exited(body: KinematicBody2D):
	if body.get_instance_id() == get_instance_id():
		print("cluck "+str(get_instance_id()))