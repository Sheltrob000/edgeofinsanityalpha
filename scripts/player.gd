extends Node3D

const movementSpeed = 400
const gravity = 2
const dashspeed = 600
const jumpSpeed = 30
const maxVerticalSpeed = 20
const maxCameraSpeed = 300
const MaxCameraDistance = 20


var verticalSpeed := 0
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

func jump():
	if Input.is_action_just_pressed("jump"):
		verticalSpeed = jumpSpeed

func setVerticalSpeed():
	if $CharacterBody3D.is_on_ceiling():
		verticalSpeed = 0
	elif $CharacterBody3D.is_on_floor() and !Input.is_action_just_pressed("jump"):
		verticalSpeed = 0
	elif Input.is_action_just_released("jump") and canDoubleJump == true:
		verticalSpeed = 0
	verticalSpeed -= gravity




func moveCamera():
	var camerax = $Camera3D.position.x
	var cameray = $Camera3D.position.y
	var playerx = $CharacterBody3D.position.x
	var playery = $CharacterBody3D.position.y
	var distancex = playerx - camerax
	
	if abs(playerx - camerax) > 1:
		$Camera3D.position.x += (playerx - camerax) * .1


	#$Camera3D.position.x += (playerx - camerax) * .1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spriteDirection()
	moveCamera()



func _physics_process(delta: float) -> void:
	$CharacterBody3D.move_and_slide()
	getMovmentDirection()
	
	var xspeed = movementSpeed * movmentDirection * delta
	$CharacterBody3D.velocity.x = xspeed
	
	
	jump()
	setVerticalSpeed()
	$CharacterBody3D.velocity.y = verticalSpeed
