extends Node

var proc_zones = []

func add_proc_zones(zone: Rect2):
	proc_zones.push_front(zone)
	
func get_proc_zones():
	return proc_zones
