extends ItemList

func add_samples():
	add_item("  12", $PotatoIcon.texture)
	add_item("   3", $CarrotIcon.texture)
	add_item("   4", $ArtichokeIcon.texture)
	add_item("    ", $TomatoIcon.texture)
	add_item("   2", $ZucchiniIcon.texture)
	add_item("    ", $CornIcon.texture)
	add_item(" 444", $RedPepperIcon.texture)
	add_item("    ", $PotatoIcon.texture)
	add_item("    ", $CarrotIcon.texture)
	add_item("    ", $ArtichokeIcon.texture)
	add_item("   2", $CornIcon.texture)
	add_item("  11", $RedPepperIcon.texture)

func _ready():
	add_samples()