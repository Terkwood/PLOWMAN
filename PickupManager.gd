extends Node

export var target: NodePath

func say_their_name():
	print("PickupManager target is %s" % get_node(target).name)

func destroy_target():
	get_node(target).get_parent().remove_child(get_node(target))
	print("TARGET DESTROYED")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
