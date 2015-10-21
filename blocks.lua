local sbox =  {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0}
		}
	}
local cbox =  {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
		}
	}
local blocks = {
{"Floor",	"floor",			"floor","floor",0,true},
{"Wall",	"wall",				"wall","floor",11,true},
{"Wallc",	"wallc",			"wallc","floor",11,true},
{"Walle",	"walle",			"walle","floor",11,true},
{"Wall Walkthrough","walk_wall","wall","floor",11,false},
}
for i in ipairs(blocks) do
local des = blocks[i][1]
local itm = blocks[i][2]
local i1 = blocks[i][3]
local i2 = blocks[i][4]
local lit = blocks[i][5]
local tf = blocks[i][6]

minetest.register_node("mypacman:"..itm, {
	description = des,
	tiles = {
		"mypacman_"..i1..".png",
		"mypacman_"..i2..".png",
		"mypacman_walls.png",
		"mypacman_walls.png",
		"mypacman_walls.png",
		"mypacman_walls.png",
		},
	drawtype = "normal",
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = lit,
	walkable = tf,
	groups = {disable_jump = 1, not_in_creative_inventory = 1},
	selection_box = sbox,
	collision_box = cbox,

})
end
--Glass
minetest.register_node("mypacman:glass", {
	description = "glass",
	tiles = {"mypacman_glass.png"},
	drawtype = "glasslike",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky=3,not_in_creative_inventory = 1},
	selection_box = cbox,
	collision_box = cbox,

})
minetest.register_node("mypacman:glassw", {
	description = "glassw",
	tiles = {"mypacman_glass.png"},
	drawtype = "glasslike",
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	groups = {cracky=3,not_in_creative_inventory = 1},
	selection_box = cbox,
	colision_box = cbox,

})



