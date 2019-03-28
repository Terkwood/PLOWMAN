extends Node2D

export onready var size = Vector2(1024,1024)

onready var potato = preload("res://AutoPotato.gd")
onready var tomato = preload("res://AutoTomato.gd")
onready var carrot = preload("res://AutoCarrot.gd")

var BROCCOLI_RESOURCES = [
load("res://CarrotYoung.tscn"), 
load("res://CarrotGrowing.tscn"),
load("res://CarrotGrowing2.tscn"),
load("res://CarrotMature.tscn"),
load("res://CarrotHarvested.tscn")
]


onready var broccoli = load("res://AutoPlant.gd")

func rand_size():
	return Vector2(max(96,randi()%int(size.x)), max (96,randi()%int(size.y)))

onready var plants = [broccoli.new([rand_size(), BROCCOLI_RESOURCES])]#,potato, tomato, carrot ]

func _ready():
	var plot = plants[randi()%plants.size()]
	add_child(plot)
