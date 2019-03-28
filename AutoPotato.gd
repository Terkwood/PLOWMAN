extends Node2D

onready var young = preload("res://PotatoYoung.tscn")
onready var growing = preload("res://PotatoGrowing.tscn")
onready var growing2 = preload("res://PotatoGrowing2.tscn")
onready var mature = preload("res://PotatoMature.tscn")
onready var harvested = preload("res://PotatoHarvested.tscn")
onready var produce = preload("res://PotatoProduce.tscn")

onready var stages = [young, growing, growing2, mature, harvested, produce]

# Called when the node enters the scene tree for the first time.
func _ready():
	var stage = stages[randi()%stages.size()]
	add_child(stage.instance())
	
