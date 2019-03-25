extends Node

const TILE_SIZE = 32
export var world_width = 100     # in tiles
export var world_height = 50     # in tiles

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
