

local hud_table = {}

function mypacman.update_hud(id, player)
	local game = mypacman.games[id]
	player = player or minetest.get_player_by_name(game.player_name)
	if not player then
		return
	end
	local hudtext = "Score: " .. game.score
	local hud = hud_table[game.player_name]
	if not hud then
		hud = player:hud_add({
			hud_elem_type = "text",
			position = {x = 1, y = 0},
			offset = {x=-400, y = 75},
			scale = {x = 100, y = 100},
			number = 0xFFFFFF, --color
			text = hudtext
		})
		hud_table[game.player_name] = hud
	else
		player:hud_change(hud, "text", hudtext)
	end
end


function mypacman.remove_hud(player, playername)
	local name = playername or player:get_player_name()
	local hud = hud_table[name]
	if hud then
		player:hud_remove(hud)
	end
end
