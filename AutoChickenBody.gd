extends KinematicBody2D

enum Direction { N, NE, E, SE, S, SW, W, NW }
enum Movement { STOP, GO }

var dir = Direction.E
var mv = Movement.STOP
var out_of_bounds = false

var timestamp = 0
const FREQ = 0.5

func opposite(d):
	return Direction.keys()[Direction.values()[(d + 4)%8]]

func _ready():
	move_and_collide(Vector2(300,0))

func move():
	print("chicken moves")
	
func _physics_process(delta):
	timestamp = timestamp + delta
	if timestamp > FREQ:
		move()
		timestamp = 0
		
func _process(_delta):
	ZIndex.hack(self.position.y, $Sprite, $Sprite)
		
func _on_Area2D_body_exited(body: KinematicBody2D):
	if body && body.get_instance_id() == get_instance_id():
		dir = opposite(dir)
		mv = Movement.GO
		out_of_bounds = true
		print("new dir " + str(dir))