extends Node2D

onready var young = preload("res://TomatoYoung.tscn")
onready var growing = preload("res://TomatoGrowing.tscn")
onready var growing2 = preload("res://TomatoGrowing2.tscn")
onready var mature = preload("res://TomatoMature.tscn")
onready var harvested = preload("res://TomatoHarvested.tscn")

onready var stages = [young, growing, growing2, mature, harvested]

func _ready():
	var stage = stages[randi()%stages.size()]
	add_child(stage.instance())
	
