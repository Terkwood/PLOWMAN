extends Node2D

export var size = Vector2(3,3)

const AutoChunk = preload("res://AutoChunk.gd")

var active_chunks = {}
var stored_chunks = {}

func _ready():
	for x in range(size.x):
		for y in range(size.y):
			var i = Vector2(x,y)
			var c: AutoChunk = AutoChunk.new(i)
			active_chunks[i] = {
				"chunk": c,
				"storage_name": c.storage_name()
			}
			add_child(c)
