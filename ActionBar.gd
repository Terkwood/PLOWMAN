extends ItemList

const ItemClass = preload("res://Item.gd")

const POTATO_ICON = preload("res://PotatoIcon.tscn")

onready var item_lookup = {
	0: {
		"name": "Potato",
		"texture": POTATO_ICON.instance().texture,
		"count": 1,
	},
	1: {
		"name": "Potato Stack",
		"texture": POTATO_ICON.instance().texture,
		"count": 10,
	},
}

var contents = Array()

var holding_item = null

func add_samples():
	add_item("  12", $PotatoIcon.texture)
	add_item("   3", $CarrotIcon.texture)
	add_item("   4", $ArtichokeIcon.texture)
	add_item("    ", $TomatoIcon.texture)
	add_item("   2", $ZucchiniIcon.texture)
	add_item("    ", $CornIcon.texture)
	add_item(" 444", $RedPepperIcon.texture)
	add_item("    ", $PotatoIcon.texture)
	add_item("    ", $CarrotIcon.texture)
	add_item("    ", $ArtichokeIcon.texture)
	add_item("   2", $CornIcon.texture)
	add_item("  11", $RedPepperIcon.texture)


func _ready():
	for item in item_lookup:
		print("item "+str(item))
		var item_name = item_lookup[item].name
		var item_texture = item_lookup[item].texture
		var item_count = item_lookup[item].count
		contents.push_back(ItemClass.new(item_name, item_texture, item_count))
		
	for i in contents:
		add_item("%4d" % i.item_count, i.texture)
