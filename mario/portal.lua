minetest.register_node("mario:portal", {
	description = "Portal",
	drawtype = "glasslike",
	tiles = {"mario_glass.png"},
	paramtype = "light",
	sunlight_propagates = true,
	alpha = 150,
	paramtype2 = "facedir",
	walkable = false,
	is_ground_content = false,
	groups = {cracky = 2,not_in_creative_inventory=1},
})
minetest.register_node("mario:portal_left", {
	description = "Portal Left",
	drawtype = "glasslike",
	tiles = {"mario_border.png"},
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	--walkable = false,
	is_ground_content = false,
	groups = {cracky = 2,not_in_creative_inventory=0},
})
minetest.register_node("mario:portal_right", {
	description = "Portal Right",
	drawtype = "glasslike",
	tiles = {"mario_border.png"},
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	--walkable = false,
	is_ground_content = false,
	groups = {cracky = 2,not_in_creative_inventory=0},
})
minetest.register_abm({
	nodenames = {"mario:portal"},
	interval = 0.5,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local objs = minetest.env:get_objects_inside_radius(pos, 1)
		for k, player in pairs(objs) do
			if player:get_player_name() then

				player:setpos({x=pos.x,y=pos.y+12,z=pos.z})
			end
		end
	end
})
