



local button_form = "size[6,8;]"..
				"background[0,0;6,8;myhighscore_form_bg.png]"..
				"label[1,0.5;HIGH SCORES]"..
				"button[1,1;4,1;game;label]"..
				"button_exit[4,7;1,2;exit;Exit]"

--place holders
local game_name = "the game"
local game_player_name = "the player"
local game_player_score = "648138"

local function get_formspec_for_game(name)
	local def = myhighscore.registered_games[name]
	local scores = myhighscore.scores[name] or {}
	-- Obtain a comma separated list of scores to display
	local scorelist = ""
	for _,score in pairs(scores) do
		scorelist = scorelist .. minetest.formspec_escape(score.player) ..
			"\t\t\t\t " .. score.score ..","
	end

	return "size[6,8;]"..
		"background[0,0;6,8;myhighscore_form_bg.png]"..
		"label[1,0.5;HIGH SCORES FOR "..def.description.."]"..
		"label[1,1.5;PLAYER]"..
		"label[3.5,1.5;SCORE]"..
		"textlist[0.5,2;5,5;;"..scorelist.."]"..
		"button[2,7;1,2;back;Back]"..
		"button_exit[4,7;1,2;exit;Exit]"
end


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
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", button_form)
		meta:set_string("infotext", "High Scores")
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos)
		if fields['game'] then
			meta:set_string('formspec', get_formspec_for_game("pacmine"))
		elseif fields["back"] then
			meta:set_string('formspec', button_form)
		end
	end,
})
