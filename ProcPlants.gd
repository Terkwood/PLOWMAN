extends Node2D

const MIN_SIZE = Vector2(96,96)
export var max_size = Vector2(1024,1024)

const TOMATO_SCENES = [
	preload("res://TomatoYoung.tscn"),
	preload("res://TomatoGrowing.tscn"),
	preload("res://TomatoGrowing2.tscn"),
	preload("res://TomatoMature.tscn"),
	preload("res://TomatoHarvested.tscn")
]

const CARROT_SCENES = [
	preload("res://CarrotYoung.tscn"),
	preload("res://CarrotGrowing.tscn"),
	preload("res://CarrotGrowing2.tscn"),
	preload("res://CarrotMature.tscn"),
	preload("res://CarrotHarvested.tscn")
]

const POTATO_SCENES = [
	preload("res://PotatoYoung.tscn"),
	preload("res://PotatoGrowing.tscn"),
	preload("res://PotatoGrowing2.tscn"),
	preload("res://PotatoMature.tscn"),
	preload("res://PotatoHarvested.tscn")
]

const ARTICHOKE_SCENES = [
	preload("res://ArtichokeYoung.tscn"), 
	preload("res://ArtichokeGrowing.tscn"),
	preload("res://ArtichokeGrowing2.tscn"),
	preload("res://ArtichokeMature.tscn"),
	preload("res://ArtichokeHarvested.tscn")
]

const RED_PEPPER_SCENES = [
	preload("res://RedPepperYoung.tscn"), 
	preload("res://RedPepperGrowing.tscn"),
	preload("res://RedPepperGrowing2.tscn"),
	preload("res://RedPepperMature.tscn"),
	preload("res://RedPepperHarvested.tscn")
]

const ZUCCHINI_SCENES = [
	preload("res://ZucchiniYoung.tscn"), 
	preload("res://ZucchiniGrowing.tscn"),
	preload("res://ZucchiniGrowing2.tscn"),
	preload("res://ZucchiniMature.tscn"),
	preload("res://ZucchiniHarvested.tscn")
]

const CORN_SCENES = [
	preload("res://CornYoung.tscn"), 
	preload("res://CornGrowing.tscn"),
	preload("res://CornGrowing2.tscn"),
	preload("res://CornMature.tscn"),
	preload("res://CornHarvested.tscn")
]

const AutoPlant = preload("res://AutoPlant.gd")

func rand_size():
	return Vector2(max(MIN_SIZE.x, randi()%int(max_size.x)),
					max(MIN_SIZE.y, randi()%int(max_size.y)))

onready var PLANT_SCENES = [
	ARTICHOKE_SCENES,
	POTATO_SCENES,
	CARROT_SCENES,
	TOMATO_SCENES,
	RED_PEPPER_SCENES,
	CORN_SCENES,
]

onready var plant_type_num = randi()%PLANT_SCENES.size()

const PLANT_TYPE_MANIFEST_KEY = "plant_type_num"
const SIZE_MANIFEST_KEY = "size"

onready var size = rand_size()
func manifest() -> Dictionary:
	return { PLANT_TYPE_MANIFEST_KEY: plant_type_num, SIZE_MANIFEST_KEY: size }

var _manifest = {}
func set_manifest(mfst: Dictionary):
	self._manifest = mfst

func _ready():
	if _manifest && !_manifest.empty():
		var man_entry = StorageManifest.find_entry(self, _manifest)
		if man_entry && !man_entry.empty() && man_entry.has(PLANT_TYPE_MANIFEST_KEY):
			plant_type_num = man_entry[PLANT_TYPE_MANIFEST_KEY]
			size = man_entry[SIZE_MANIFEST_KEY]

	var plot = AutoPlant.new(rand_size(),PLANT_SCENES[plant_type_num])
	add_child(plot, true)
	self._manifest = {}
