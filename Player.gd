extends Area2D

signal hit

export (int) var SPEED
var CONTROLLER_NUMBER = 0
var LEFT_ANALOG_DEADZONE = 0.25

var screensize

func start(pos):
    position = pos
    show()
    $CollisionShape2D.disabled = false

func _ready():
    screensize = get_viewport_rect().size
    # hide()

func _process(delta):
    var velocity = Vector2(
        Input.get_joy_axis(CONTROLLER_NUMBER, JOY_AXIS_0), 
        Input.get_joy_axis(CONTROLLER_NUMBER, JOY_AXIS_1))

    if velocity.length() > LEFT_ANALOG_DEADZONE:
        velocity = velocity.normalized() * SPEED
        $AnimatedSprite.play()
    else:
        $AnimatedSprite.stop()

    position += velocity * delta
    position.x = clamp(position.x, 0, screensize.x)
    position.y = clamp(position.y, 0, screensize.y)
    
    if velocity.x != 0:
        $AnimatedSprite.animation = "right"
        $AnimatedSprite.flip_v = false
        $AnimatedSprite.flip_h = velocity.x < 0
    elif velocity.y != 0:
        $AnimatedSprite.animation = "up"
        $AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
    hide() # Player disappears after being hit
    emit_signal("hit")
    $CollisionShape2D.disabled = true
