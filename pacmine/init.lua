
-- This variable will be exported to other mods when they "depend" on this mod
pacmine = {}

dofile(minetest.get_modpath("pacmine").."/fruit.lua")
dofile(minetest.get_modpath("pacmine").."/ghost.lua")
dofile(minetest.get_modpath("pacmine").."/blocks.lua")
dofile(minetest.get_modpath("pacmine").."/portals.lua")
dofile(minetest.get_modpath("pacmine").."/gamestate.lua")
dofile(minetest.get_modpath("pacmine").."/hud.lua")
--dofile(minetest.get_modpath("pacmine").."/aliases.lua")



--Yellow Pellets
minetest.register_node("pacmine:pellet_1", {
	description = "Pellet 1",
	tiles = {"wool_yellow.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	light_source = 11,
	drop = "",
	groups = {immortal = 1, not_in_creative_inventory = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.625, 0.25, -0.125, -0.375, 0.5, 0.125},
		}
	},
})

--Power Pellets. Need to make these do something
minetest.register_node("pacmine:pellet_2", {
	description = "Pellet 2",
	tiles = {{name="pacmine_powerpellet.png", animation={type="vertical_frames",aspect_w=16, aspect_h=16, length=0.8}},},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	light_source = 11,
	drop = {max_items = 1,items = {
		{items = {"pacmine:cherrys"},rarity = 4,},
		{items = {"pacmine:apple"},rarity = 4,},
		{items = {"pacmine:peach"},rarity = 4,},
		{items = {"pacmine:strawberry"},rarity = 4,},},
		},
	groups = {immortal = 1, not_in_creative_inventory = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.625,  -0.125,  -0.25,   -0.375,  0.125,  0.25},
			{-0.75,   -0.125,  -0.125,  -0.25,   0.125,  0.125},
			{-0.625,  -0.25,   -0.125,  -0.375,  0.25,   0.125},
			{-0.6875, -0.1875, -0.1875, -0.3125, 0.1875, 0.1875},
			}
		},
})

--The placer block
minetest.register_node("pacmine:block2",{
	description = "Pacman",
	inventory_image = "pacmine_1.png",
	tiles = {
		"pacmine_wallc.png",
		"pacmine_1.png",
		"pacmine_1.png",
		"pacmine_1.png",
		"pacmine_1.png",
		"pacmine_1.png",
		},
	drawtype = "normal",
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 8,
	groups = {cracky = 1},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		pacmine.game_start(pos, player)
	end,
})
