
-- This variable will be exported to other mods when they "depend" on this mod
mypacman = {}


dofile(minetest.get_modpath("mypacman").."/craftitems.lua")
dofile(minetest.get_modpath("mypacman").."/ghost.lua")
dofile(minetest.get_modpath("mypacman").."/blocks.lua")
dofile(minetest.get_modpath("mypacman").."/portals.lua")
dofile(minetest.get_modpath("mypacman").."/gamestate.lua")


--Yellow Pellets
minetest.register_node("mypacman:pellet_1", {
	description = "Pellet 1",
	tiles = {"wool_yellow.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	light_source = 11,
	drop = "",
	groups = {dig_immediate = 3, not_in_creative_inventory = 0},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.625, 0.25, -0.125, -0.375, 0.5, 0.125},
		}
	},
	on_destruct = function(pos)
		minetest.sound_play("mypacman_chomp", {
			pos = pos,
			max_hear_distance = 100,
			gain = 10.0,
		})
	end,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		mypacman.on_player_got_pellet(digger)
	end,
})

--Power Pellets. Need to make these do something
minetest.register_node("mypacman:pellet_2", {
	description = "Pellet 2",
	tiles = {"wool_yellow.png^[colorize:white:140"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	light_source = 11,
	drop = {max_items = 1,items = {
		{items = {"mypacman:cherrys"},rarity = 4,},
		{items = {"mypacman:apple"},rarity = 4,},
		{items = {"mypacman:peach"},rarity = 4,},
		{items = {"mypacman:strawberry"},rarity = 4,},},
		},
	groups = {dig_immediate = 3, not_in_creative_inventory = 0},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.625,  -0.125,  -0.25,   -0.375,  0.125,  0.25},
			{-0.75,   -0.125,  -0.125,  -0.25,   0.125,  0.125},
			{-0.625,  -0.25,   -0.125,  -0.375,  0.25,   0.125},
			{-0.6875, -0.1875, -0.1875, -0.3125, 0.1875, 0.1875},
			}
		},
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		mypacman.on_player_got_power_pellet(digger)

		minetest.sound_play("mypacman_eatfruit", {
			pos = pos,
			max_hear_distance = 100,
			gain = 10.0,
		})
	end,
})

--The placer block
minetest.register_node("mypacman:block2",{
	description = "Pacman",
	inventory_image = "mypacman_1.png",
	tiles = {
		"mypacman_wallc.png",
		"mypacman_1.png",
		"mypacman_1.png",
		"mypacman_1.png",
		"mypacman_1.png",
		"mypacman_1.png",
		},
	drawtype = "normal",
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 8,
	groups = {cracky = 1},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		mypacman.game_start(pos, player)
	end,
})
