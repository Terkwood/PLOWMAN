extends Node2D

export var num_chunks = 1

const AutoChunk = preload("res://AutoChunk.gd")

func _ready():
	for i in range(num_chunks):
		var c = AutoChunk.new(i)
		add_child(c)