extends Node2D

export var size = Vector2(1024,1024)

onready var TOMATO_SCENES = [
	preload("res://TomatoYoung.tscn"),
	preload("res://TomatoGrowing.tscn"),
	preload("res://TomatoGrowing2.tscn"),
	preload("res://TomatoMature.tscn"),
	preload("res://TomatoHarvested.tscn")
]

onready var CARROT_SCENES = [
	preload("res://CarrotYoung.tscn"),
	preload("res://CarrotGrowing.tscn"),
	preload("res://CarrotGrowing2.tscn"),
	preload("res://CarrotMature.tscn"),
	preload("res://CarrotHarvested.tscn")
]

onready var POTATO_SCENES = [
	preload("res://PotatoYoung.tscn"),
	preload("res://PotatoGrowing.tscn"),
	preload("res://PotatoGrowing2.tscn"),
	preload("res://PotatoMature.tscn"),
	preload("res://PotatoHarvested.tscn")
]

onready var ARTICHOKE_SCENES = [
	preload("res://ArtichokeYoung.tscn"), 
	preload("res://ArtichokeGrowing.tscn"),
	preload("res://ArtichokeGrowing2.tscn"),
	preload("res://ArtichokeMature.tscn"),
	preload("res://ArtichokeHarvested.tscn")
]


onready var RED_PEPPER_SCENES = [
	preload("res://RedPepperYoung.tscn"), 
	preload("res://RedPepperGrowing.tscn"),
	preload("res://RedPepperGrowing2.tscn"),
	preload("res://RedPepperMature.tscn"),
	preload("res://RedPepperHarvested.tscn")
]


onready var ZUCCHINI_SCENES = [
	preload("res://ZucchiniYoung.tscn"), 
	preload("res://ZucchiniGrowing.tscn"),
	preload("res://ZucchiniGrowing2.tscn"),
	preload("res://ZucchiniMature.tscn"),
	preload("res://ZucchiniHarvested.tscn")
]

onready var CORN_SCENES = [
	preload("res://CornYoung.tscn"), 
	preload("res://CornGrowing.tscn"),
	preload("res://CornGrowing2.tscn"),
	preload("res://CornMature.tscn"),
	preload("res://CornHarvested.tscn")
]


onready var auto_plant = load("res://AutoPlant.gd")

func rand_size():
	return Vector2(max(96,randi()%int(size.x)), max (96,randi()%int(size.y)))

onready var plants = [
	auto_plant.new(rand_size(), ARTICHOKE_SCENES),
	auto_plant.new(rand_size(), POTATO_SCENES),
	auto_plant.new(rand_size(), CARROT_SCENES),
	auto_plant.new(rand_size(), TOMATO_SCENES),
	auto_plant.new(rand_size(), RED_PEPPER_SCENES),
	auto_plant.new(rand_size(), CORN_SCENES),
]

func _ready():
	var plot = plants[randi()%plants.size()]
	add_child(plot)
