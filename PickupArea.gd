extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "_on_PickupArea_body_entered")

func _on_PickupArea_body_entered(body: KinematicBody2D):
	if body:
		print("Welcome kinematic friend: %s" % body.name)
