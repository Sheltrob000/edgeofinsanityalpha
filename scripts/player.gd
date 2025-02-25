extends Node3D

const movementSpeed = 400
const gravity = 50
const dashspeed = 1500
const jumpSpeed = 1100
const maxVerticalSpeed = 20
const maxCameraSpeed = 300
const MaxCameraDistance = 20


var verticalSpeed := 0
var horozontalSpeed := 0
var isLeft := false
var isInAir := false
var isDashing := false

var canDash := true
var canDoubleJump := true
var movmentDirection := 0


func getMovmentDirection():
	movmentDirection = Input.get_axis("left", "right")
	if movmentDirection > 0:
		movmentDirection = 1
	elif movmentDirection < 0:
		movmentDirection = -1

func spriteDirection():
	if movmentDirection == -1:
		$CharacterBody3D/AnimatedSprite3D.flip_h = true
	elif movmentDirection == 1: $CharacterBody3D/AnimatedSprite3D.flip_h = false

func animation():
	if isDashing:
		$CharacterBody3D/AnimatedSprite3D.play("dashing")
	elif !$CharacterBody3D.is_on_floor():
		$CharacterBody3D/AnimatedSprite3D.play("still")
	elif horozontalSpeed != 0:
		$CharacterBody3D/AnimatedSprite3D.play("walking")

	else:
		$CharacterBody3D/AnimatedSprite3D.play("still")

func jump():
	if Input.is_action_just_pressed("jump"):
		#verticalSpeed = jumpSpeed
		if $CharacterBody3D.is_on_floor():
			verticalSpeed = jumpSpeed
		elif !$CharacterBody3D.is_on_floor() and canDoubleJump:
			verticalSpeed = jumpSpeed
			canDoubleJump = false
	if $CharacterBody3D.is_on_floor():
		canDoubleJump = true

func setVerticalSpeed():
	if $CharacterBody3D.is_on_ceiling():
		verticalSpeed = 0
	elif $CharacterBody3D.is_on_floor() and !Input.is_action_just_pressed("jump"):
		verticalSpeed = 0
	elif Input.is_action_just_released("jump") and canDoubleJump == true and verticalSpeed > 0:
		verticalSpeed = 0
	verticalSpeed -= gravity

func setHorozontalSpeed():
	if isDashing == true:
		horozontalSpeed = dashspeed * movmentDirection
		verticalSpeed = 0
	else:
		horozontalSpeed = movementSpeed * movmentDirection

func moveCamera():
	var camerax = $Camera3D.position.x
	var cameray = $Camera3D.position.y
	var playerx = $CharacterBody3D.position.x
	var playery = $CharacterBody3D.position.y
	var distancex = playerx - camerax
	
	if abs(playerx - camerax) > .3:
		$Camera3D.position.x += (playerx - camerax) * .1
		
	if abs(playery - cameray) > .5:
		$Camera3D.position.y += (playery - cameray) * .1
		


	#$Camera3D.position.x += (playerx - camerax) * .1

func dash():
	if Input.is_action_just_pressed("dash") and canDash:
		isDashing = true
		canDash = false
		$dashTimer.start()
		$canDashTimer.start()


func _on_dash_timer_timeout() -> void:
	isDashing = false

func _on_can_dash_timer_timeout() -> void:
	canDash = true



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spriteDirection()
	animation()



func _physics_process(delta: float) -> void:
	$CharacterBody3D.move_and_slide()
	getMovmentDirection()
	moveCamera()

	
	dash()
	setHorozontalSpeed()
	$CharacterBody3D.velocity.x = horozontalSpeed * delta
	
	
	jump()
	setVerticalSpeed()
	$CharacterBody3D.velocity.y = verticalSpeed * delta
