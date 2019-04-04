extends Node2D

export var num_chunks = 4

const AutoChunk = preload("res://AutoChunk.gd")

func _ready():
	print("procchunks is %s" % self)
	for i in range(num_chunks):
		print("new chunk %d " % i)
		var c = AutoChunk.new(i)
		add_child(c)