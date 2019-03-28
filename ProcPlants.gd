extends Node2D

onready var potato = preload("res://AutoPotato.gd")
onready var tomato = preload("res://AutoTomato.gd")
onready var carrot = preload("res://AutoCarrot.gd")

onready var plants = [potato, tomato, carrot]

export onready var size = Vector2(1024,1024)

func _ready():
	var rand_size = Vector2(max(96,randi()%int(size.x)), max (96,randi()%int(size.y)))
	var plot = plants[randi()%plants.size()].new(rand_size)
	add_child(plot)
	
