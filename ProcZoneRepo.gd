extends Node

var proc_zones = []

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
	
