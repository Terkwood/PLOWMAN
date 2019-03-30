extends ItemList

const ItemClass = preload("res://Item.gd")

const CORN_ICON = preload("res://CornIcon.tscn")
const POTATO_ICON = preload("res://PotatoIcon.tscn")
const ARTICHOKE_ICON = preload("res://ArtichokeIcon.tscn")
const CARROT_ICON = preload("res://CarrotIcon.tscn")
const TOMATO_ICON = preload("res://TomatoIcon.tscn")
const ZUCCHINI_ICON = preload("res://ZucchiniIcon.tscn")
const RED_PEPPER_ICON = preload("res://RedPepperIcon.tscn")

onready var item_lookup = {
	0: {
		"name": "Potato",
		"texture": POTATO_ICON.instance().texture,
		"count": 1,
	},
	1: {
		"name": "Corn",
		"texture": CORN_ICON.instance().texture,
		"count": 10,
	},
	2: {
		"name": "Tomato",
		"texture": TOMATO_ICON.instance().texture,
		"count": 3,
	},
	3: {
		"name": "Zucchini",
		"texture": ZUCCHINI_ICON.instance().texture,
		"count": 1,
	},
	4: {
		"name": "Red Pepper",
		"texture": RED_PEPPER_ICON.instance().texture,
		"count": 7,
	},
	5: {
		"name": "Artichoke",
		"texture": ARTICHOKE_ICON.instance().texture,
		"count": 2,
	},
}

var contents = Array()

var holding_item = null

func _ready():
	for item in item_lookup:
		print("item "+str(item))
		var item_name = item_lookup[item].name
		var item_texture = item_lookup[item].texture
		var item_count = item_lookup[item].count
		contents.push_back(ItemClass.new(item_name, item_texture, item_count))
		
	for i in contents:
		add_item("%4d" % i.item_count, i.texture)
