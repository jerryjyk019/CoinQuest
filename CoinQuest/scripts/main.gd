extends Node2D

const PLAYER_SCENE: PackedScene = preload("res://scenes/Player.tscn")
const COIN_SCENE: PackedScene = preload("res://scenes/Coin.tscn")
const ENEMY_SCENE: PackedScene = preload("res://scenes/Enemy.tscn")
const TOTAL_COINS: int = 10
const SAVE_PATH := "user://coin_quest.cfg"

var score: int = 0
var lives: int = 3
var best_score: int = 0
var paused: bool = false
var game_over: bool = false
var player: CharacterBody2D
var score_label: Label
var message_label: Label
var pause_label: Label
var restart_button: Button

func _ready() -> void:
    randomize()
    load_game()
    setup_ui()
    start_game()
    queue_redraw()

func _draw() -> void:
    var size := get_viewport_rect().size
    draw_rect(Rect2(Vector2.ZERO, size), Color("#214d36"))
    for x in range(0, int(size.x), 40):
        for y in range(40, int(size.y), 40):
            draw_rect(Rect2(Vector2(x, y), Vector2(38, 38)), Color("#285a3e"))

func setup_ui() -> void:
    var ui := CanvasLayer.new()
    add_child(ui)

    score_label = Label.new()
    score_label.position = Vector2(20, 10)
    score_label.add_theme_font_size_override("font_size", 18)
    score_label.add_theme_color_override("font_color", Color.WHITE)
    ui.add_child(score_label)

    message_label = Label.new()
    message_label.position = Vector2(150, 220)
    message_label.size = Vector2(500, 100)
    message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    message_label.add_theme_font_size_override("font_size", 30)
    message_label.add_theme_color_override("font_color", Color("#ffe66d"))
    ui.add_child(message_label)

    pause_label = Label.new()
    pause_label.position = Vector2(250, 170)
    pause_label.size = Vector2(300, 50)
    pause_label.text = "PAUSED"
    pause_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    pause_label.add_theme_font_size_override("font_size", 32)
    pause_label.add_theme_color_override("font_color", Color.WHITE)
    pause_label.visible = false
    ui.add_child(pause_label)

    restart_button = Button.new()
    restart_button.text = "Play Again"
    restart_button.position = Vector2(330, 330)
    restart_button.size = Vector2(140, 45)
    restart_button.visible = false
    restart_button.process_mode = Node.PROCESS_MODE_ALWAYS
    restart_button.pressed.connect(_on_restart_pressed)
    ui.add_child(restart_button)
    update_ui()

func start_game() -> void:
    score = 0
    lives = 3
    paused = false
    game_over = false
    get_tree().paused = false
    message_label.text = ""
    pause_label.visible = false
    restart_button.visible = false

    player = PLAYER_SCENE.instantiate() as CharacterBody2D
    player.position = Vector2(400, 300)
    add_child(player)

    for i in range(TOTAL_COINS):
        var coin = COIN_SCENE.instantiate()
        coin.position = random_position()
        coin.collected.connect(_on_coin_collected)
        add_child(coin)

    for i in range(3):
        var enemy = ENEMY_SCENE.instantiate()
        enemy.position = Vector2(150 + i * 220, 150 + i * 80)
        enemy.player_hit.connect(_on_player_hit)
        add_child(enemy)
    update_ui()

func random_position() -> Vector2:
    var size := get_viewport_rect().size
    return Vector2(randf_range(35.0, size.x - 35.0), randf_range(65.0, size.y - 35.0))

func _on_coin_collected() -> void:
    if game_over:
        return
    score += 1
    if score > best_score:
        best_score = score
        save_game()
    update_ui()
    if score >= TOTAL_COINS:
        finish_game(true)

func _on_player_hit() -> void:
    if game_over:
        return
    lives -= 1
    update_ui()
    if lives <= 0:
        finish_game(false)

func update_ui() -> void:
    if is_instance_valid(score_label):
        score_label.text = "Coins: %d / %d    Lives: %d    Best: %d    [ESC] Pause" % [score, TOTAL_COINS, lives, best_score]

func finish_game(won: bool) -> void:
    game_over = true
    paused = false
    get_tree().paused = false
    message_label.text = "YOU WIN!\nAll coins collected!" if won else "GAME OVER!\nTry again!"
    restart_button.visible = true
    if is_instance_valid(player):
        player.queue_free()
    for node in get_tree().get_nodes_in_group("coins"):
        node.queue_free()
    for node in get_tree().get_nodes_in_group("enemies"):
        node.queue_free()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel") and not game_over:
        paused = not paused
        get_tree().paused = paused
        pause_label.visible = paused
        get_viewport().set_input_as_handled()

func _on_restart_pressed() -> void:
    get_tree().paused = false
    get_tree().reload_current_scene()

func save_game() -> void:
    var config := ConfigFile.new()
    config.set_value("player", "best_score", best_score)
    var error := config.save(SAVE_PATH)
    if error != OK:
        push_warning("Could not save the best score.")

func load_game() -> void:
    var config := ConfigFile.new()
    if config.load(SAVE_PATH) == OK:
        best_score = int(config.get_value("player", "best_score", 0))
