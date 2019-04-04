extends Node

const TILE_SIZE = 32

export var num_tiles_x = 64    # in tiles
export var num_tiles_y = 64    # in tiles

func width(): return TILE_SIZE * num_tiles_x
func height(): return TILE_SIZE * num_tiles_y
func size(): return Vector2(width(), height())

const AutoChunk = preload("res://AutoChunk.gd")

func id(node: Node):
	if node == null || node is Viewport:
		print("root")
		return 0
	if node is AutoChunk:
		print("IS CHUNK")
		return node.chunk_id
	else:
		print("+ i am a %s" % node)
		print("+ my parent %s" % node.get_parent())
		var parent_chunk_id = Chunk.id(node.get_parent())
		return parent_chunk_id

func _ready():
	randomize()
