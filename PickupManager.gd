extends Node

export var target: NodePath

func say_their_name():
	print("PickupManager target is %s" % get_node(target).name)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
