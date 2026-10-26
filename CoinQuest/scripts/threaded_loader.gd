extends Node

const RESOURCE_PATH := "res://scenes/Enemy.tscn"
var loading_started := false

func _ready() -> void:
    var error := ResourceLoader.load_threaded_request(RESOURCE_PATH)
    if error == OK:
        loading_started = true
    else:
        push_error("Could not start threaded loading.")

func _process(_delta: float) -> void:
    if not loading_started:
        return
    var status := ResourceLoader.load_threaded_get_status(RESOURCE_PATH)
    if status == ResourceLoader.THREAD_LOAD_LOADED:
        var packed_scene := ResourceLoader.load_threaded_get(RESOURCE_PATH)
        if packed_scene is PackedScene:
            print("Enemy scene loaded in the background.")
        loading_started = false
        set_process(false)
    elif status == ResourceLoader.THREAD_LOAD_FAILED:
        push_error("Threaded loading failed.")
        loading_started = false
        set_process(false)
