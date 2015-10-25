local blocks = {
	{"floor","Floor"},
	{"dash","Dash"},
	{"side","Side"},
	{"corner","Corner"},
	}
for i in ipairs(blocks) do
	local itm = blocks[i][1]
	local des = blocks[i][2]

minetest.register_node("pong:"..itm,{
	description = des,
	tiles = {
			"pong_"..itm..".png",
			"pong_floor.png",
			"pong_floor.png",
			"pong_floor.png",
			"pong_side.png",
			"pong_floor.png",
			},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 3},
})
end
minetest.register_node("pong:doora", {
	description = "Pong Door",
	tiles = {
		"pong_floor.png",
		"pong_floor.png",
		"pong_floor.png",
		"pong_floor.png",
		"pong_door.png",
		"pong_door.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 3},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.4375, 0.5, 0.5, -0.3125}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.4375, 0.5, 1.5, -0.3125}
		}
	},

after_place_node = function(pos, placer, itemstack, pointed_thing)
	local node = minetest.get_node(pos)
	minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="pong:doorb",param2=node.param2})
end,

on_rightclick = function(pos, node, player, itemstack, pointed_thing)
	local timer = minetest.get_node_timer(pos)
	local par2 = node.param2 + 1
		if par2 == 4 then
			par2 = 0
		end
	minetest.set_node(pos,{name="pong:doora",param2 = par2})
	minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="pong:doorb",param2 = par2})
	timer:start(3)
end,
on_timer = function(pos, elapsed)
	local node = minetest.get_node(pos)
	local par2 = node.param2
		if par2 == 0 then
			par2 = 3
		else par2 = node.param2 -1
		end
	minetest.set_node(pos,{name="pong:doora",param2 = par2})
	minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="pong:doorb",param2 = par2})
end,
})
minetest.register_node("pong:doorb", {
	--description = "Pong Door",
	tiles = {
		"pong_floor.png",
		"pong_floor.png",
		"pong_floor.png",
		"pong_floor.png",
		"pong_door.png",
		"pong_door.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 3},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.4375, 0.5, 0.5, -0.3125}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0}
		}
	},
})
minetest.register_node("pong:block",{
	description = "Pong",
	--inventory_image = "pong_inv.png",
	tiles = {
		"pong_floor.png",
		"pong_floor.png",
		"pong_floor.png",
		"pong_floor.png",
		"pong_floor.png",
		"pong_dash.png",
		},
	drawtype = "normal",
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 8,
	groups = {cracky = 1},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local schem = minetest.get_modpath("pong").."/schems/pong.mts"
		minetest.place_schematic(pos,schem,0, "air", true)
	end,
})
