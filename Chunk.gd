extends Node

const TILE_SIZE = 32

export var num_tiles_x = 64    # in tiles
export var num_tiles_y = 64   # in tiles

var width = TILE_SIZE * num_tiles_x
var height = TILE_SIZE * num_tiles_y

func _ready():
	randomize()
