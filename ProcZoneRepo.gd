extends Node

var proc_zones = {}

func rand_pos(size: Vector2):
	return Vector2(
		randi()%int(max(1, Chunk.width() - size.x)),
		randi()%int(max(1, Chunk.height() - size.y)))

const FAIL_ASSIGN=1000
func assign_zone(size: Vector2, chunk_id: Vector2):
	var fail_count = 0
	var c = Rect2(rand_pos(size), size)
	while !try_add_proc_zone(c, chunk_id) && fail_count < FAIL_ASSIGN:
		c = Rect2(rand_pos(size), size)
		fail_count += 1
	if fail_count == FAIL_ASSIGN:
		print("failed to assign zone with size %s" % size)
	return c

func force_assign_zone(zone: Rect2, chunk_id: Vector2):
	if !proc_zones.has(chunk_id):
		proc_zones[chunk_id] = []
	proc_zones[chunk_id].push_front(zone)

func try_add_proc_zone(zone: Rect2, chunk_id: Vector2):
	if !contains(zone, chunk_id):
		force_assign_zone(zone, chunk_id)
		return true
	return false
	
func contains(zone: Rect2, chunk_id: Vector2):
	if proc_zones.has(chunk_id):
		for existing in proc_zones[chunk_id]:
			if existing.clip(zone):
				return true
	return false

func erase_chunk(chunk_id: Vector2):
	if proc_zones.has(chunk_id):
		proc_zones.erase(chunk_id)
