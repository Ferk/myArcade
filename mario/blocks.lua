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
