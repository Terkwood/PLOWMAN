extends TextureRect

# Thanks to Oen44 for the example in
# https://github.com/Oen44/Godot-Inventory/blob/master/Item.gd
var item_name
var item_count
var picked = false

func _init(item_name, item_texture, item_count):
	name = item_name
	self.item_name = item_name
	self.item_count = item_count
	texture = item_texture
	hint_tooltip = "%s [%d]" % [item_name, item_count]
	mouse_filter = Control.MOUSE_FILTER_PASS
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func pick_item():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	picked = true
	
func put_item():
	rect_global_position = Vector2(0,0)
	mouse_filter = Control.MOUSE_FILTER_PASS
	picked = false
