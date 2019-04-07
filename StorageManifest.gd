extends Node

const AutoPond = preload("res://AutoPond.gd")
const HouseThatchedRoof = preload("res://HouseThatchedRoof.gd")

## TODO TODO TODO
## Figure out how to deal with the scene tree
## in some recursive (and accurate) fashion

static func merge_dir(target, patch):
	for key in patch:
		if target.has(key):
			var tv = target[key]
			if typeof(tv) == TYPE_DICTIONARY:
				merge_dir(tv, patch[key])
			else:
				target[key] = patch[key]
		else:
		    target[key] = patch[key]

## Generate a storage manifest for a given type of node
## It should return a dictionary with reasonably-formatted
## information on the position of landmarks, etc.
static func generate(node: Node, accum: Dictionary = {}):
	var path = node.get_path()
	# position-only classes
	if node is HouseThatchedRoof:
		accum[path] = { "position": node.position }
	elif node is AutoPond:
		accum[path] = {
			"size": node.size,
			"position": node.position
		}
	#elif node.get_class() == "ProcFencedCow":
	#	return {}
	
	for c in node.get_children():
		var child_accum = generate(c, accum)
		merge_dir(accum, child_accum)
	
	return accum