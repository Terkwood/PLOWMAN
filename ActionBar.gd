extends ItemList

onready var inventory: Node =(
	$"/root".find_node("Player", true, false).get_node("Inventory")
)

func _ready():
	inventory.connect("ready", self, "_on_inventory_ready")
	inventory.connect("item_added", self, "_on_inventory_item_added")
	
func _on_inventory_ready():
	var inv_size = inventory.get_contents().size()
	print("inv size %d" % inv_size)
	for i in range(inv_size):
		var item = inventory.get_contents()[i]
		print("actionbar ready")
		add_item("%4d" % item.item_count, item.texture)
		set_item_tooltip(i, item.hint_tooltip)

func _on_inventory_item_added(item):
	pass
