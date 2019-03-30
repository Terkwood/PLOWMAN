extends ItemList

const ItemClass = preload("res://Item.gd")

const item_images = [
	preload("res://turkey.png"),
	preload("res://drolleries.png")
]

const item_lookup = {
	0: {
		"item_name": "Turkey",
		"item_icon": item_images[0]
	},
	1: {
		"item_name": "Scroll",
		"item_icon": item_images[1]
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
		var item_name = item_lookup[item].item_name
		var item_icon = item_lookup[item].item_icon
		#contents.append(