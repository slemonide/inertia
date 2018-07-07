------------------------------------------------------------------------
-- This is the only place where global variables should be defined
-- Feel free to add anything here that is used often enough
------------------------------------------------------------------------

-- Load third-party libraries
Class = require "lib.hump.class"
Gamestate = require "lib.hump.gamestate"
suit = require 'lib.suit'
utf8 = require "lib.lua-utf8-simple.utf8_simple"
Camera = require "lib.Camera"
camera = Camera()

-- Load global objects
World = require "world"
PlayerManager = require "player_manager"
PlayerSpawner = require "player"
Player = PlayerSpawner()
Console = require "console"
Client = require "client"
Stars = require "stars"
states = {
    menu = require "menu",
    local_menu = require "local_menu",
    online_menu = require "online_menu",
    settings_menu = require "settings_menu",
    game_over = require "game_over",
    game = require "game"
}
games = {
--    infection   = require "games.infection",
    stay_circle = require "games.stay_circle",
--    sumo        = require "games.sumo"
}
current_game = nil

CONFIG = {
    STARS_MAX = 1000,
    STAR_MIN_DISTANCE = 30,
    MIN_UPDATE_DELAY = 0.1,
    STAY_CIRCLE_RADIUS = 777
}
