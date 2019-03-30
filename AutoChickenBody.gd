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
	ZIndex.hack(self.position.y, $Sprite, $Sprite)
	move_and_slide(Vector2(300,0), Vector2())

func move():
	print("chicken moves")
	
func _physics_process(delta):
	timestamp = timestamp + delta
	if timestamp > FREQ:
		move()
		timestamp = 0

var last_position_y = self.position.y
func _process(_delta):
	if self.position.y != last_position_y:
		last_position_y = self.position.y
		ZIndex.hack(self.position.y, $Sprite, $Sprite)

func i_am(body: KinematicBody2D):
	return body && body.get_instance_id() == get_instance_id()
	
func _on_Area2D_body_exited(body: KinematicBody2D):
	if i_am(body):
		dir = opposite(dir)
		mv = Movement.GO
		out_of_bounds = true
		print("new dir " + str(dir))

func _on_Area2D_body_entered(body):
	if i_am(body):
		out_of_bounds = false
		
