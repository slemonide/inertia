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
states = {}
states.menu = {}
states.menu.main =     require "menu.main"
states.menu.single =   require "menu.single"
states.menu.online =   require "menu.online"
states.menu.settings = require "menu.settings"

states.game_over = require "game_over"
states.game =      require "game"
games = {
--    infection   = require "games.infection",
    stay_circle = require "games.stay_circle",
    sumo        = require "games.sumo"
}
current_game = nil

CONFIG = {
    STARS_MAX = 1000,
    STAR_MIN_DISTANCE = 30,
    MIN_UPDATE_DELAY = 0.1,
    STAY_CIRCLE_RADIUS = 777
}
