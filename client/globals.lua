------------------------------------------------------------------------
-- This is the only place where global variables should be defined
-- Feel free to add anything here that is used often enough
------------------------------------------------------------------------

Class = require "lib.hump.class"

World = require "world"
PlayerManager = require "player_manager"
PlayerSpawner = require "player"
Player = PlayerSpawner()
Console = require "console"
Client = require "client"
Stars = require "stars"
utf8 = require "lib.lua-utf8-simple.utf8_simple"

Camera = require "lib.Camera"
camera = Camera()

CONFIG = {
    STARS_MAX = 1000,
    STAR_MIN_DISTANCE = 30
}
