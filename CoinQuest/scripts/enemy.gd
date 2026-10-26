extends Area2D

signal player_hit

@export var speed: float = 90.0
var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
    add_to_group("enemies")
    body_entered.connect(_on_body_entered)
    queue_redraw()

func _physics_process(delta: float) -> void:
    position += direction * speed * delta

    var screen_size := get_viewport_rect().size
    if position.x < 20.0:
        position.x = 20.0
        direction.x = absf(direction.x)
    elif position.x > screen_size.x - 20.0:
        position.x = screen_size.x - 20.0
        direction.x = -absf(direction.x)

    if position.y < 55.0:
        position.y = 55.0
        direction.y = absf(direction.y)
    elif position.y > screen_size.y - 20.0:
        position.y = screen_size.y - 20.0
        direction.y = -absf(direction.y)

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        player_hit.emit()
        queue_free()

func _draw() -> void:
    draw_circle(Vector2.ZERO, 14.0, Color("#e74c3c"))
    draw_circle(Vector2(-4, -3), 2.5, Color.WHITE)
    draw_circle(Vector2(4, -3), 2.5, Color.WHITE)
    draw_line(Vector2(-5, 5), Vector2(5, 5), Color.BLACK, 2.0)
