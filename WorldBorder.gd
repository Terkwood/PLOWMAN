extends Node2D

onready var auto_fence = preload("res://AutoFence.tscn")

func _ready():
	var fence = auto_fence.instance()
	fence.init(Chunk.size())
	add_child(fence)
	