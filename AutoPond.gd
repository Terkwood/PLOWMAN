extends Node2D

export var size = Vector2(128,128)

const NE_CORNER_TILE = "grass_water_edge_ne"
const SE_CORNER_TILE = "grass_water_edge_se"
const SW_CORNER_TILE = "grass_water_edge_sw"
const NW_CORNER_TILE = "grass_water_edge_nw"
const N_BORDER_TILE = "grass_water_edge_n"
const E_BORDER_TILE = "grass_water_edge_e"
const S_BORDER_TILE = "grass_water_edge_s"
const W_BORDER_TILE = "grass_water_edge_w"

var chunk_id = null

func rand_water_tile():
	var full_waters = [
		$TileMap.tile_set.find_tile_by_name("grass_water_full"),
		$TileMap.tile_set.find_tile_by_name("grass_water_full2"),
		$TileMap.tile_set.find_tile_by_name("grass_water_full3"),
	]

	return full_waters[randi()%full_waters.size()]

func set_cell_size():
	$TileMap.set_cell_size(Vector2(Chunk.TILE_SIZE, Chunk.TILE_SIZE))

# Obey chunk tile sizing
func snap_size():
	size = Vector2(floor(size.x / Chunk.TILE_SIZE) * Chunk.TILE_SIZE,
					floor(size.y / Chunk.TILE_SIZE) * Chunk.TILE_SIZE)

func place():
	chunk_id = Chunk.id(self)
	set_cell_size()
	snap_size()
	
	var zone: Rect2 = ProcZoneRepo.assign_zone(size, chunk_id)
	position = zone.position
	
	var tx = zone.size.x - int(ceil(zone.size.x)) % Chunk.TILE_SIZE
	var ty = zone.size.y - int(ceil(zone.size.y)) % Chunk.TILE_SIZE
	var trimmed_size = Vector2(tx, ty)
								 
	var num_tiles_x = int(max(0,trimmed_size.x / Chunk.TILE_SIZE) - 1)
	var num_tiles_y = int(max(0,trimmed_size.y / Chunk.TILE_SIZE) - 1)
	
	# Place corners
	$TileMap.set_cellv(Vector2(0, 0),
						$TileMap.tile_set.find_tile_by_name(NW_CORNER_TILE))

	$TileMap.set_cellv(Vector2(num_tiles_x , 0),
						$TileMap.tile_set.find_tile_by_name(NE_CORNER_TILE))
	
	$TileMap.set_cellv(Vector2(0, num_tiles_y ),
						$TileMap.tile_set.find_tile_by_name(SW_CORNER_TILE))
	
	$TileMap.set_cellv(Vector2(num_tiles_x , num_tiles_y ),
						$TileMap.tile_set.find_tile_by_name(SE_CORNER_TILE))

	var w_border = $TileMap.tile_set.find_tile_by_name(W_BORDER_TILE)
	var e_border = $TileMap.tile_set.find_tile_by_name(E_BORDER_TILE)
	var n_border = $TileMap.tile_set.find_tile_by_name(N_BORDER_TILE)
	var s_border = $TileMap.tile_set.find_tile_by_name(S_BORDER_TILE)
	
	for x in range(max(0, num_tiles_x - 1)):
		$TileMap.set_cellv(Vector2(x + 1, 0), n_border)
		$TileMap.set_cellv(Vector2(x + 1, num_tiles_y), s_border)

	for y in range(max(0, num_tiles_y - 1)):
		$TileMap.set_cellv(Vector2(0, y + 1), w_border)
		$TileMap.set_cellv(Vector2(num_tiles_x, y + 1), e_border)
	
	for x in range(max(0, num_tiles_x - 1)):
		for y in range(max(0, num_tiles_y - 1)):
			$TileMap.set_cellv(Vector2(x + 1,y + 1), rand_water_tile())

func manifest():
	return StorageManifest.size_position_manifest(self)

func set_manifest(mfst: Dictionary):
	print("pond set manifest")

func _ready():
	place()
