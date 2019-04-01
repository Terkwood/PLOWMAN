extends ItemList

onready var inventory: Node = $"../../../DeepZIndexHack/Player/Inventory"

func _ready():
	for i in range(inventory.contents.size()):
		var item = inventory.contents[i]
		add_item("%4d" % item.item_count, item.texture)
		set_item_tooltip(i, item.hint_tooltip)
