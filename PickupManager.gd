extends Node

export var target: NodePath

func destroy_target():
	get_node(target).get_parent().remove_child(get_node(target))
