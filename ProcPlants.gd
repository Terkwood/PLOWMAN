extends Node2D

onready var potato = preload("res://AutoPotato.tscn")
onready var tomato = preload("res://AutoTomato.tscn")

onready var plants = [potato]#, tomato]

export var size = Vector2(128,128)

func _ready():
	var plot = plants[randi()%plants.size()].instance()
	plot.init(size)
	add_child(plot)
	
