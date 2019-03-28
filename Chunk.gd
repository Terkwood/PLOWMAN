extends Node

const TILE_SIZE = 32

export var num_tiles_x = 64    # in tiles
export var num_tiles_y = 64   # in tiles

func width(): return TILE_SIZE * num_tiles_x
func height(): return TILE_SIZE * num_tiles_y
func size(): return Vector2(width(), height())

func _ready():
	randomize()
