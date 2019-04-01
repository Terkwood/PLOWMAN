extends ItemList

onready var inventory: Node =(
	$"/root".find_node("Player", true, false).get_node("Inventory")
)

func _ready():
	inventory.connect("ready", self, "_on_inventory_ready")
	inventory.connect("item_added", self, "_on_inventory_item_added")

var bar = {}

func _on_inventory_ready():
	var inv_size = inventory.contents.size()
	print("inv size %d" % inv_size)
	for i in range(inv_size):
		var item = inventory.contents[i]
		print("actionbar ready")
		bar[i] = {
			"name": item.item_name,
			"count": item.item_count
		}
		add_item("%4d" % item.item_count, item.texture)
		set_item_tooltip(i, item.hint_tooltip)

func _on_inventory_item_added(item):
	# have we already drawn this item?
	var new_item = false
	for bar_idx in bar:
		pass
		
	if !new_item:
		add_item("%4d" % item.item_count, item.texture)
		var idx = get_item_count() - 1
		print("set item tooltip %d %s" % [idx, item.hint_tooltip])
		set_item_tooltip(idx, item.hint_tooltip)
	
