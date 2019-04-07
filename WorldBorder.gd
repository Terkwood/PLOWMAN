extends Node2D

const AutoFence = preload("res://AutoFence.tscn")

func _ready():
	var proc_chunks_parent = find_parent("ProcChunks")
	var size = Chunk.size()
	if proc_chunks_parent != null:
		size = size * proc_chunks_parent.size
	var fence = AutoFence.instance()
	fence.init(size)
	add_child(fence)
	