extends Node

const TILE_SIZE = 32
export var world_width = 20    # in tiles
export var world_height = 20   # in tiles

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
