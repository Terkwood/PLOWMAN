extends Node

const TILE_SIZE = 32
export var world_width = 15    # in tiles
export var world_height = 15   # in tiles

func _ready():
	randomize()
