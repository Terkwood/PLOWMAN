extends Node

export var target: NodePath

# WARNING! FIXME!
# This item name must match an
# entry in Inventory.gd,
# or it won't end up correctly
# linked to a TextureRect icon
# if it's drawn in the ActionBar
# See https://github.com/Terkwood/PLOWMAN/issues/46
export var item_name: String

func destroy_target():
	get_node(target).get_parent().remove_child(get_node(target))
