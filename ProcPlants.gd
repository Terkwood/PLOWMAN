extends Node2D

export onready var size = Vector2(1024,1024)

onready var potato = preload("res://AutoPotato.gd")
onready var tomato = preload("res://AutoTomato.gd")
onready var carrot = preload("res://AutoCarrot.gd")

onready var POTATO_SCENES = [
	preload("res://PotatoYoung.tscn"),
	preload("res://PotatoGrowing.tscn"),
	preload("res://PotatoGrowing2.tscn"),
	preload("res://PotatoMature.tscn"),
	preload("res://PotatoHarvested.tscn")
]


onready var BROCCOLI_SCENES = [
	preload("res://CarrotYoung.tscn"), 
	preload("res://CarrotGrowing.tscn"),
	preload("res://CarrotGrowing2.tscn"),
	preload("res://CarrotMature.tscn"),
	preload("res://CarrotHarvested.tscn")
]


onready var auto_plant = load("res://AutoPlant.gd")

func rand_size():
	return Vector2(max(96,randi()%int(size.x)), max (96,randi()%int(size.y)))

onready var plants = [
	auto_plant.new(rand_size(), BROCCOLI_SCENES),
	auto_plant.new(rand_size(), POTATO_SCENES)
]#,potato, tomato, carrot ]

func _ready():
	var plot = plants[randi()%plants.size()]
	add_child(plot)
