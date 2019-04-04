# Generates a number of ponds, obeying
# proc zone placement
extends Node2D

export var num_ponds = 1
export var max_size = Vector2(128,128)

const AutoPond = preload("res://AutoPond.tscn")

func _ready():
	pass
