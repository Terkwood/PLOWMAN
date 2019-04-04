extends Node2D

export var size = Vector2(4,4)

const AutoChunk = preload("res://AutoChunk.gd")

func _ready():
	for x in range(size.x):
		for y in range(size.y):
			var c = AutoChunk.new(Vector2(x,y))
			add_child(c)