extends Node

func _ready():
    deep_ysort_everything(self)

func deep_ysort_everything(node):
    for N in node.get_children():
        if N.get_child_count() > 0:
            deep_ysort_everything(N)
        else:
            if N is Sprite:
                set_z_order(N)

func set_z_order(N):
	var g = N.get_global_transform().get_origin().y + N.region_rect.size.y / 2	 
	N.z_index=g
