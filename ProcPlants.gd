extends Node2D

onready var potato = preload("res://AutoPotato.gd")
onready var tomato = preload("res://AutoTomato.gd")

onready var plants = [potato]#, tomato]

export var size = Vector2(128,128)

func _ready():
	var plot = plants[randi()%plants.size()].new(size)
	add_child(plot)
	
