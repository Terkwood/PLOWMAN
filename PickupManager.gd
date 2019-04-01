extends Node

export var target: NodePath

export var item_name: String

func destroy_target():
	get_node(target).get_parent().remove_child(get_node(target))
