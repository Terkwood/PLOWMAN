extends Node2D

onready var auto_fence = preload("res://AutoFence.tscn").new(Chunk.size())

func _ready():
	auto_fence._ready()