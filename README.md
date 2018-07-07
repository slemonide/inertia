# inertia
A game about rocket science

# Server
To start server, run `lua server.lua`

# Client
To start client, go to client and run `love .`

# Multiplayer
By default, client will connect to my server if internet is available

# IRC
There is an IRC channel `#inertia-game@freenode.net`. That's probably the best
place to message me if the server is down.

# Console
To use console, type `esc` button and then `/help` (depricated)

# Program Structure
.
├── client
│   ├── assets/ (sounds, graphics, fonts, etc.)
│   ├── build.sh (use this to create builds for different platforms)
│   ├── client.lua (client network code)
│   ├── conf.lua (LOVE configuration file)
│   ├── console.lua (in-game console, depricated)
│   ├── game.lua (game state)
│   ├── game_over.lua (game over state)
│   ├── games/ (this is where actual games are stored)
│   ├── globals.lua (global variables are to be defined here only)
│   ├── lib/ (third-party libraries that I didn't make)
│   ├── local_menu.lua (single player menu)
│   ├── main.lua (main file, this is where the program starts)
│   ├── menu.lua (main menu)
│   ├── online_menu.lua (multi player menu)
│   ├── player.lua (local and remote player state)
│   ├── player_manager.lua (manages remote players)
│   ├── settings_menu.lua (settings menu)
│   ├── stars.lua (stars background generator)
│   └── world.lua (world state)
│
└── server.lua (server-side code)

