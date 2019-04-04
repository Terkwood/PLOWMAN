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
		return 0
	elif node is AutoChunk:
		return node.chunk_id
	else:
		return Chunk.id(get_parent())

func _ready():
	randomize()
