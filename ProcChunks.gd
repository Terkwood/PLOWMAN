extends Node2D

export var size = Vector2(4,4)

const AutoChunk = preload("res://AutoChunk.gd")

var chunks = {}

func _ready():
	for x in range(size.x):
		for y in range(size.y):
			var i = Vector2(x,y)
			var c = AutoChunk.new(i)
			chunks[i] = c
			add_child(c)
