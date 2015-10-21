local pelletitems = {
	{"cherrys", "Cherrys","2"},
	{"apple", "Apple","3"},
	{"peach", "Peach","4"},
	{"strawberry", "Strawberry","2"},
	}
for i in ipairs (pelletitems) do
	local itm = pelletitems[i][1]
	local desc = pelletitems[i][1]
	local hlth = pelletitems[i][1]


minetest.register_craftitem("mypacman:"..itm,{
	description = desc,
	inventory_image = "mypacman_"..itm..".png",
	on_use = minetest.item_eat(2),
	groups = {not_in_creative_inventory = 1},
})
end
