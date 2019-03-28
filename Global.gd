extends Node

const TILE_SIZE = 32
export var world_width = 12    # in tiles
export var world_height = 12   # in tiles

func _ready():
	randomize()
