COIN QUEST - GODOT 4 PROJECT

FILES
- project.godot: project settings and main scene
- scenes/Main.tscn: main game scene
- scenes/Player.tscn: player scene
- scenes/Coin.tscn: collectible coin scene
- scenes/Enemy.tscn: enemy scene
- scripts/main.gd: score, lives, spawning, UI, pause, restart, save/load
- scripts/player.gd: player movement and drawing
- scripts/coin.gd: coin collision signal and drawing
- scripts/enemy.gd: enemy movement, collision signal and drawing
- scripts/threaded_loader.gd: optional example for the threaded loading exam task

HOW TO OPEN
1. Extract CoinQuest.zip to a folder.
2. Open Godot 4.7.2.
3. In Project Manager, click Import.
4. Select the extracted CoinQuest/project.godot file.
5. Click Import & Edit.
6. Press F6 or F5 to run the game. If asked to select a main scene, choose scenes/Main.tscn.

CONTROLS
- Move: WASD or arrow keys
- Pause/resume: Escape
- Collect all 10 coins and avoid red enemies.
- You have 3 lives. Press Play Again after winning or losing.
- Best score is saved in Godot's user data folder.

PRACTICAL EXAM NOTES
1. Scene instancing: main.gd uses preload() and instantiate() for Player, Coin, and Enemy scenes.
2. Game loop separation: _physics_process() handles movement; _process() is used by threaded_loader.gd for loading status.
3. Threaded resource loading: threaded_loader.gd demonstrates load_threaded_request() and status polling. It is an optional script and is not attached to Main by default.
4. Signals: coin.collected and enemy.player_hit notify main.gd when events happen.
5. Polling vs event-driven input: player.gd polls movement input; main.gd responds to Escape through _unhandled_input(event).
6. Memory cleanup: queue_free() removes collected coins and defeated enemies; restart reloads the scene.
7. Persistent save data: ConfigFile saves and loads the best score.

If Godot reports an error, check that all files and folder names match the paths above exactly.
