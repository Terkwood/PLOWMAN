extends Node

var proc_zones = []

func rand_pos(size: Vector2):
	return Vector2(randi()%int(max(1,Chunk.TILE_SIZE * Chunk.num_tiles_x - size.x)),
		randi()%int(max(1,Chunk.TILE_SIZE * Chunk.num_tiles_x - size.y)))

const FAIL_ASSIGN=1000
func assign_zone(size: Vector2):
	var fail_count = 0
	var c = Rect2(rand_pos(size),size)
	while !try_add_proc_zone(c) && fail_count < FAIL_ASSIGN:
		c = Rect2(rand_pos(size),size)
		fail_count += 1
	if fail_count == FAIL_ASSIGN:
		print("fail assign zone")
	return c

func try_add_proc_zone(zone: Rect2):
	if !contains(zone):
		proc_zones.push_front(zone)
		return true
	return false
	
func contains(zone: Rect2):
	for existing in proc_zones:
		if existing.clip(zone):
			return true
	return false
	
