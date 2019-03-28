extends Node2D

onready var potato = preload("res://AutoPotato.tscn")
onready var tomato = preload("res://AutoTomato.tscn")

onready var plants = [potato]#, tomato]

func _ready():
	var plant = plants[randi()%plants.size()]
	add_child(plant.instance())
	
