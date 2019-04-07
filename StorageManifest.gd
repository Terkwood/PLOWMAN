extends Node

## Generate a storage manifest for a given type of node
## It should return a dictionary with reasonably-formatted
## information on the position of landmarks, etc.
func generate(node: Node):
	# position-only classes
	if node.get_class() in ["HouseThatchedRoof"]:
		return { "position": node.position }
	elif node.get_class() == "ProcFencedCow":
		return {}
	
	return {}