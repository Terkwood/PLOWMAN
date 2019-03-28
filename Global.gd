extends Node

const TILE_SIZE = 32
export var world_width = 40    # in tiles
export var world_height = 40   # in tiles

func _ready():
	randomize()
