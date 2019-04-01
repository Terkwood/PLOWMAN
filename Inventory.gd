extends Node2D

const ItemClass = preload("res://Item.gd")


const CORN_ICON = preload("res://CornIcon.tscn")
const POTATO_ICON = preload("res://PotatoIcon.tscn")
const ARTICHOKE_ICON = preload("res://ArtichokeIcon.tscn")
const CARROT_ICON = preload("res://CarrotIcon.tscn")
const TOMATO_ICON = preload("res://TomatoIcon.tscn")
const ZUCCHINI_ICON = preload("res://ZucchiniIcon.tscn")
const RED_PEPPER_ICON = preload("res://RedPepperIcon.tscn")

onready var texture_lookup = {
	"Potato":  POTATO_ICON.instance().texture,
	"Corn": CORN_ICON.instance().texture,
	"Tomato": TOMATO_ICON.instance().texture,
	"Zucchini": ZUCCHINI_ICON.instance().texture,
	"Red Pepper": RED_PEPPER_ICON.instance().texture,
	"Artichoke": ARTICHOKE_ICON.instance().texture,
}


export var contents = Array()

signal item_added(item)

func add(item):
	emit_signal("item_added", item)

