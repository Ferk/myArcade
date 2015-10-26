minetest.register_node("mario:platform",{
	description = "Platform",
	tiles = {
			"mario_blue.png",
			},
	drawtype = "normal",
	paramtype = "light",
	groups = {cracky = 3},
})
minetest.register_node("mario:grey",{
	description = "Grey",
	tiles = {
			"mario_grey.png",
			},
	drawtype = "normal",
	paramtype = "light",
	light_source = 14,
	groups = {cracky = 3},
})
minetest.register_node("mario:border",{
	description = "Border",
	tiles = {
			"mario_border.png",
			},
	drawtype = "normal",
	paramtype = "light",
	groups = {cracky = 3},
})
minetest.register_node("mario:brick",{
	description = "Brick",
	tiles = {
			"mario_brick.png",
			},
	drawtype = "normal",
	paramtype = "light",
	groups = {cracky = 3},
})
minetest.register_node("mario:glass", {
	description = "Glass",
	tiles = {"mario_grey.png","mario_glass.png"},
	drawtype = "glasslike_framed",
	paramtype = "light",
	groups = {cracky = 2},
})
minetest.register_node("mario:coin", {
	description = "Coin",
	tiles = {"mario_coin.png"},
	drawtype = "plantlike",
	paramtype = "light",
	walkable = false,
	groups = {cracky = 2},
})

local nbox = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.25, 0.25, -0.0625, 0.25},
			{-0.3125, -0.4375, -0.3125, 0.3125, 0.4375, 0.3125},
			{-0.375, -0.375, -0.375, 0.375, 0.375, 0.375},
			{-0.375, -0.1875, -0.4375, 0.375, 0.3125, 0.4375},
			{-0.4375, -0.1875, -0.5, 0.4375, 0.1875, 0.5},
			{-0.1875, 0.4375, -0.1875, 0.1875, 0.5, 0.1875},
			{-0.5, -0.1875, -0.4375, 0.5, 0.1875, 0.4375},
			{-0.4375, -0.1875, -0.375, 0.4375, 0.3125, 0.375},
		}
	}

minetest.register_node("mario:mushroom",{
	description = "Mushroom",
	tiles = {
			"mario_mushroom_top.png",
			"mario_mushroom_bottom.png",
			"mario_mushroom.png",
			"mario_mushroom.png",
			"mario_mushroom.png",
			"mario_mushroom.png",
			},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {cracky = 3},
	node_box = nbox,
})

minetest.register_node("mario:mushroom_green",{
	description = "Green Mushroom",
	tiles = {
			"mario_mushroom_top_g.png",
			"mario_mushroom_bottom.png",
			"mario_mushroom_g.png",
			"mario_mushroom_g.png",
			"mario_mushroom_g.png",
			"mario_mushroom_g.png",
			},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {cracky = 3},
	node_box = nbox,
})
