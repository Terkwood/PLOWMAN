extends Node

const TILE_SIZE = 32

const num_tiles_x = 4    # in tiles
const num_tiles_y = 4    # in tiles

func width(): return TILE_SIZE * num_tiles_x
func height(): return TILE_SIZE * num_tiles_y
func size(): return Vector2(width(), height())

const AutoChunk = preload("res://AutoChunk.gd")

func id(node: Node):
	if node == null || node is Viewport:
		return Vector2(0,0)

	if node is AutoChunk:
		return node.chunk_id

	return Chunk.id(node.get_parent())

func _ready():
	randomize()
