extends TextureRect

# Thanks to Oen44 for the example in
# https://github.com/Oen44/Godot-Inventory/blob/master/Item.gd
var item_name
var item_count

func _init(item_name, item_texture, item_count = 1):
	name = item_name
	self.item_name = item_name
	self.item_count = item_count
	texture = item_texture
	hint_tooltip = "%s [%d]" % [item_name, item_count]
