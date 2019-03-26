extends Node

const TILE_SIZE = 32
export var world_width = 64    # in tiles
export var world_height = 64   # in tiles

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
