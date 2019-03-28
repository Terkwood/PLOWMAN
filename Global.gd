extends Node

const TILE_SIZE = 32
export var world_width = 64    # in tiles
export var world_height = 64   # in tiles

func _ready():
	randomize()
