extends Node2D

var pickup_candidate_bodies = []

func _on_ReachArea_body_entered(body):
	print("Pickup area: %s" % body.name)
	var has_pickup_manager = body.has_node("PickupManager")
	if has_pickup_manager:
		print("Target has a PickupManager")
		pickup_candidate_bodies.push_front(body)

func _on_ReachArea_body_exited(body):
	for c in range(pickup_candidate_bodies.size()):
		if pickup_candidate_bodies[c].get_instance_id() == body.get_instance_id():
			pickup_candidate_bodies.remove(c)
			print("removed candidate body %s" % body.name)
