minetest.register_node("nibbles:floor",{
	description = "Floor",
	tiles = {"nibbles_floor.png"},
	paramtype = "light",
	groups = {cracky = 3, disable_jump = 1, not_in_creative_inventory = 0},
})

minetest.register_node("nibbles:wall",{
	description = "Floor",
	tiles = {
			"nibbles_wall.png",
			"nibbles_wall.png",
			"nibbles_wall_side.png",
			"nibbles_wall_side.png",
			"nibbles_wall_side.png",
			"nibbles_wall_side.png",
			},
	paramtype = "light",
	groups = {cracky = 3, not_in_creative_inventory = 0},
})
minetest.register_node("nibbles:placer",{
	description = "Nibbles",
	tiles = {"nibbles_wall_side.png^nibbles_button.png"},
	paramtype = "light",
	groups = {cracky = 3, not_in_creative_inventory = 0},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local schem = minetest.get_modpath("nibbles").."/schems/nibbles.mts"
		minetest.place_schematic({x=pos.x,y=pos.y-1,z=pos.z},schem,0, "air", true)
	end,
})
