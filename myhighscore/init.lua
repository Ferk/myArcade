minetest.register_node("myhighscore:score_board", {
	description = "Score Board",
	tiles = {
			"myhighscore_top.png",
			"myhighscore_back.png",
			"myhighscore_side.png^[transformFX",
			"myhighscore_side.png",
			"myhighscore_back.png",
			"myhighscore_front.png",
			},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.5, 0.375, -0.1875, 0.5},
			{-0.375, -0.5, 0.1875, 0.375, 0.5, 0.5},
			{-0.1875, -0.5, -0.3125, -0.125, 0, -0.25},
			{-0.375, -0.5, 0, -0.3125, 0.5, 0.5},
			{0.3125, -0.5, 0, 0.375, 0.5, 0.5},
			{-0.375, 0.4375, 0, 0.375, 0.5, 0.5},
		}
	},

on_rightclick = function(pos, node, player, itemstack, pointed_thing)
end,

})
