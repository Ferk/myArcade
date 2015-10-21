--Save Table
function save_table()
	local data = mypacman
	local f, err = io.open(minetest.get_worldpath().."/mypacman_data", "w")
    if err then return err end
	f:write(minetest.serialize(data))
	f:close()
end
--Read Table
local function read_table()
	local f, err = io.open(minetest.get_worldpath().."/mypacman_data", "r")
	local data = minetest.deserialize(f:read("*a"))
	f:close()
	return data
end
local tmr = 0
--Save Table every 10 seconds
minetest.register_globalstep(function(dtime)
	tmr = tmr + dtime;
	if tmr >= 10 then
		tmr = 0
		save_table()
	end
end)

--removes the ghosts from the game
local function remove_ghosts()
	local pos = mypacman.start
	for index, object in ipairs(minetest.get_objects_inside_radius({x=pos.x+13,y=pos.y+0.5,z=pos.z+15},20)) do
		if object:is_player() ~= true then
		object:remove()
		end
	end
end

local function spawn_ghosts()
	local pos = mypacman.start
	minetest.after(2, function()
	minetest.add_entity({x=pos.x+13,y=pos.y+0.5,z=pos.z+19}, "mypacman:inky")
	end)
	minetest.after(12, function()
		minetest.add_entity({x=pos.x+15,y=pos.y+0.5,z=pos.z+19}, "mypacman:pinky")
	end)
	minetest.after(22, function()
		minetest.add_entity({x=pos.x+13,y=pos.y+0.5,z=pos.z+18}, "mypacman:blinky")
	end)
	minetest.after(32, function()
		minetest.add_entity({x=pos.x+15,y=pos.y+0.5,z=pos.z+18}, "mypacman:clyde")
	end)
end

--Check to see if table exists. Need to see if there is a better way
local f, err = io.open(minetest.get_worldpath().."/mypacman_data", "r")
if f == nil then
mypacman = {}
mypacman.start = {}
mypacman.pellet_count = 0
mypacman.level = 1
mypacman.spd = 2
mypacman.board_num = 1
else
mypacman = read_table().start
mypacman.start = read_table().start
mypacman.pellet_count = read_table().pellet_count
mypacman.level = read_table().level
mypacman.spd = read_table().spd
mypacman.board_num = read_table().board_num
end

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
		local name = digger:get_player_name()
		local pos = mypacman.start
		local schem = minetest.get_modpath("mypacman").."/schems/mypacman_3.mts"
		mypacman.pellet_count = mypacman.pellet_count + 1
		if mypacman.pellet_count >= 1 then --252
			remove_ghosts()
			minetest.chat_send_player(name, "You cleared the board!")
			mypacman.pellet_count = 0
			mypacman.level = mypacman.level + 1
			mypacman.spd = mypacman.level + 1
			minetest.after(3.0, function()
				local pos = mypacman.start
				digger:setpos({x=pos.x+13,y=pos.y+0.5,z=pos.z+15.5})
				minetest.chat_send_player(name, "Starting Level "..mypacman.level)
				minetest.sound_play("mypacman_beginning", {pos = pos,max_hear_distance = 40,gain = 10.0,})
				spawn_ghosts()
			end)
			minetest.place_schematic({x=pos.x,y=pos.y-1,z=pos.z-2},schem,0, "air", true)
		end
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
	on_destruct = function(pos)
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
local schem = minetest.get_modpath("mypacman").."/schems/mypacman_3.mts"
	minetest.place_schematic({x=pos.x,y=pos.y-1,z=pos.z-2},schem,0, "air", true)
	mypacman.start = {x=pos.x, y=pos.y, z=pos.z}
	mypacman.pellet_count = 0
	mypacman.level = 1
	mypacman.spd = 2
	remove_ghosts() 
	player:setpos({x=pos.x+14,y=pos.y+0.5,z=pos.z+16})
	mypacman.pellet_count = 0
		if mypacman.pellet_count >= 252 then
			remove_ghosts()
		end
	minetest.sound_play("mypacman_beginning", {pos = pos,max_hear_distance = 40,gain = 10.0,})
	
	minetest.after(2, function()
	minetest.add_entity({x=pos.x+13,y=pos.y+0.5,z=pos.z+19}, "mypacman:inky")
	end)
	minetest.after(12, function()
		minetest.add_entity({x=pos.x+15,y=pos.y+0.5,z=pos.z+19}, "mypacman:pinky")
	end)
	minetest.after(22, function()
		minetest.add_entity({x=pos.x+13,y=pos.y+0.5,z=pos.z+18}, "mypacman:blinky")
	end)
	minetest.after(32, function()
		minetest.add_entity({x=pos.x+15,y=pos.y+0.5,z=pos.z+18}, "mypacman:clyde")
	end)
end,
})


dofile(minetest.get_modpath("mypacman").."/craftitems.lua")
dofile(minetest.get_modpath("mypacman").."/ghost.lua")
dofile(minetest.get_modpath("mypacman").."/blocks.lua")
dofile(minetest.get_modpath("mypacman").."/portals.lua")









