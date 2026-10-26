extends Area2D

signal collected

func _ready() -> void:
    add_to_group("coins")
    body_entered.connect(_on_body_entered)
    queue_redraw()

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        collected.emit()
        queue_free()

func _draw() -> void:
    draw_circle(Vector2.ZERO, 12.0, Color("#f1c40f"))
    draw_circle(Vector2.ZERO, 7.0, Color("#ffdf4d"))
    draw_circle(Vector2.ZERO, 3.0, Color("#d68910"))
