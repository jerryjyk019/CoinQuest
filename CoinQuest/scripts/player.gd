extends CharacterBody2D

@export var speed: float = 250.0

func _ready() -> void:
    add_to_group("player")
    queue_redraw()

func _physics_process(_delta: float) -> void:
    var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

    if Input.is_key_pressed(KEY_A):
        direction.x -= 1.0
    if Input.is_key_pressed(KEY_D):
        direction.x += 1.0
    if Input.is_key_pressed(KEY_W):
        direction.y -= 1.0
    if Input.is_key_pressed(KEY_S):
        direction.y += 1.0

    velocity = direction.normalized() * speed
    move_and_slide()

    var screen_size := get_viewport_rect().size
    position.x = clampf(position.x, 16.0, screen_size.x - 16.0)
    position.y = clampf(position.y, 45.0, screen_size.y - 16.0)

func _draw() -> void:
    draw_circle(Vector2.ZERO, 14.0, Color("#3498db"))
    draw_circle(Vector2(-4, -3), 3.0, Color.WHITE)
    draw_circle(Vector2(4, -3), 3.0, Color.WHITE)
    draw_circle(Vector2(-4, -3), 1.5, Color.BLACK)
    draw_circle(Vector2(4, -3), 1.5, Color.BLACK)
