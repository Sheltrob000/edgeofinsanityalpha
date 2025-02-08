extends Node3D

const movementSpeed = 100
const gravity = 10
const dashspeed = 300


var verticalSpeed = 0
var isLeft = false
var isInAir = false
var isDashing = false

var canDash = true
var canDoubleJump = true

var movmentDirection = 0

func getMovmentDirection():
	movmentDirection = Input.get_axis("left", "right")
	if movmentDirection > 0:
		movmentDirection = 1
	elif movmentDirection < 0:
		movmentDirection = -1

func spriteDirection():
	if movmentDirection == -1:
		$CharacterBody3D/Sprite3D.flip_h = true
	elif movmentDirection == 1: $CharacterBody3D/Sprite3D.flip_h = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CharacterBody3D.move_and_slide()
	getMovmentDirection()
	spriteDirection()
	
	
	
	var xspeed = movementSpeed * movmentDirection * delta
	print(xspeed)
	$CharacterBody3D.velocity.x = xspeed
#	seeing is major changes will be seen
