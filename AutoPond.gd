extends Node2D

export var size = Vector2(128,128)
# Allows programmatic placement via explicit
# call to the place() function
export var delay_placement = true

const NE_CORNER_TILE = "grass_water_edge_ne"
const SE_CORNER_TILE = "grass_water_edge_se"
const SW_CORNER_TILE = "grass_water_edge_sw"
const NW_CORNER_TILE = "grass_water_edge_nw"
const N_BORDER_TILE = "grass_water_edge_n"
const E_BORDER_TILE = "grass_water_edge_e"
const S_BORDER_TILE = "grass_water_edge_s"
const W_BORDER_TILE = "grass_water_edge_w"

func place():
	var zone: Rect2 = ProcZoneRepo.assign_zone(size)
	var num_tiles_x = int(size.x / Chunk.TILE_SIZE)
	var num_tiles_y = int(size.y / Chunk.TILE_SIZE)
	# FIXME zone placement doesn't obey chunking
	var offset_x = int(zone.position.x / Chunk.TILE_SIZE)
	var offset_y = int(zone.position.y / Chunk.TILE_SIZE)
	
	# Place corners
	$TileMap.set_cellv(Vector2(offset_x, offset_y),
						null)

# Obey chunk tile sizing
func snap_size():
	size = Vector2(floor(size.x / Chunk.TILE_SIZE) * Chunk.TILE_SIZE,
					floor(size.y / Chunk.TILE_SIZE) * Chunk.TILE_SIZE)

func _ready():
	snap_size()
	if !delay_placement:
		place()
