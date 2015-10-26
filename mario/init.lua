mario = {}

dofile(minetest.get_modpath("mario").."/pipes.lua")
dofile(minetest.get_modpath("mario").."/blocks.lua")
dofile(minetest.get_modpath("mario").."/portal.lua")
dofile(minetest.get_modpath("mario").."/turtle.lua")
dofile(minetest.get_modpath("mario").."/gamestate.lua")


minetest.register_node("mario:placer",{
	description = "Reset",
	tiles = {
			"mario_border.png",
			"mario_border.png",
			"mario_border.png",
			"mario_border.png",
			"mario_border.png",
			"mario_border.png^mario_m.png",
			},
	drawtype = "normal",
	paramtype = "light",
	groups = {cracky = 3},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local schem = minetest.get_modpath("mario").."/schems/mario.mts"
		minetest.place_schematic({x=pos.x-1,y=pos.y-2,z=pos.z-2},schem,0, "air", true)
		player:setpos({x=pos.x+16,y=pos.y+0.1,z=pos.z+1})
		print(name)
		player:set_physics_override(1,1,0.3,true,false)

		-- Left Turtle
		minetest.add_entity({x=pos.x+3,y=pos.y+12,z=pos.z+1}, "mario:turtle1")
		-- Right Turtle
		local turtler = minetest.add_entity({x=pos.x+30,y=pos.y+12,z=pos.z+1}, "mario:turtle1"):get_luaentity()
		turtler.direction = {x=-1,y=0,z=0}

		minetest.sound_play("mario-game-start", {pos = pos,max_hear_distance = 40,gain = 10.0,})
	end,
})
minetest.register_node("mario:placer2",{
	description = "Mario",
	tiles = {
			"mario_border.png",
			"mario_border.png",
			"mario_border.png",
			"mario_border.png",
			"mario_border.png",
			"mario_border.png^mario_m.png",
			},
	drawtype = "normal",
	paramtype = "light",
	groups = {cracky = 3},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local schem = minetest.get_modpath("mario").."/schems/mario.mts"
		minetest.place_schematic({x=pos.x-1,y=pos.y-1,z=pos.z-2},schem,0, "air", true)
	end,
})
minetest.register_node("mario:exit",{
	description = "Exit",
	tiles = {
			"mario_grey.png",
			"mario_grey.png",
			"mario_grey.png",
			"mario_grey.png",
			"mario_grey.png",
			"mario_grey.png^mario_exit.png",
			},
	drawtype = "normal",
	paramtype = "light",
	groups = {cracky = 3},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		player:setpos({x=pos.x-5,y=pos.y+0.1,z=pos.z-3})
		print(name)
		player:set_physics_override(1,1,1,true,false)
	end,
})
