

local nodes = {
	"wall", "floor", "wallc", "walle", "walk_wall","glass","glassw",
	"cherrys","apple","orange","strawberry",
	"pellet_1","pellet_2","block2",
}

for _,i in pairs(nodes) do
	minetest.register_alias("mypacman:"..itm, "pacmine:"..itm)
end
