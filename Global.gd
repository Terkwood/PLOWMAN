extends Node

const TILE_SIZE = 32
export var world_width = 22    # in tiles
export var world_height = 22   # in tiles

func _ready():
	randomize()
