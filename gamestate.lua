
-- Array to hold all the running game states
mypacman.games = {}

-- Store all the currently playing players
mypacman.players = {}

-- Duration of the power pellet effect (in seconds)
local power_pellet_duration = 10

---------------------------------------------------------
-- Public functions (these can be called from any other place)

-- Start the game from the spawn block at position "pos" activated by "player"
function mypacman.game_start(pos, player)
	-- create an id unique for the given position
	local id = minetest.pos_to_string(pos)

	-- make sure any previous game with the same id has ended
	if mypacman.games[id] then
		mypacman.game_end(id)
	end

	-- Create a new game state with that id and add it to the game list
	local gamestate = {
		id = id,
		player_name = player:get_player_name(),
		pos = pos,
		start = {x=pos.x+14,y=pos.y+0.5,z=pos.z+16},
		pellet_count = 0,
		level = 1,
		speed = 2,
		lives = 3,
		score = 0,
	}
 	mypacman.games[id] = gamestate
	mypacman.players[id] = player

	minetest.log("action","New pacman game started at " .. id .. " by " .. gamestate.player_name)

	-- place schematic
	local schem = minetest.get_modpath("mypacman").."/schems/mypacman_3.mts"
	minetest.place_schematic({x=pos.x,y=pos.y-1,z=pos.z-2},schem,0, "air", true)

	-- Set start positions
	mypacman.game_reset(id, player)
	minetest.sound_play("mypacman_beginning", {pos = pos,max_hear_distance = 40,gain = 10.0,})
end

-- Finish the game with the given id
function mypacman.game_end(id)
	mypacman.remove_ghosts(id)
	mypacman.remove_hud(mypacman.players[id], mypacman.games[id].player_name)
	-- Clear the data
	mypacman.games[id] = nil
	mypacman.players[id] = nil
end

-- Resets the game to the start positions
function mypacman.game_reset(id, player)
	local gamestate = mypacman.games[id]
	minetest.log("action", "resetting game " .. id)

	-- Save the time when the game was last resetted (to solve timing issues)
	local last_reset = os.time()

	gamestate.power_pellet = false
	gamestate.last_reset = last_reset

	-- Position the player
	local player = player or minetest.get_player_by_name(gamestate.player_name)
	player:setpos(gamestate.start)

	-- Spawn the ghosts and assign the game id to each ghost
	minetest.after(2, function()
		if mypacman.games[id] and last_reset == mypacman.games[id].last_reset then
			local pos = vector.add(gamestate.pos, {x=13,y=0.5,z=19})
			local ghost = minetest.add_entity(pos, "mypacman:inky")
			ghost:get_luaentity().gameid = id
		end
	end)
	minetest.after(12, function()
		if mypacman.games[id] and last_reset == mypacman.games[id].last_reset then
			local pos = vector.add(gamestate.pos, {x=15,y=0.5,z=19})
			local ghost = minetest.add_entity(pos, "mypacman:pinky")
			ghost:get_luaentity().gameid = id
		end
	end)
	minetest.after(22, function()
		if mypacman.games[id] and last_reset == mypacman.games[id].last_reset then
			local pos = vector.add(gamestate.pos, {x=13,y=0.5,z=18})
			local ghost = minetest.add_entity(pos, "mypacman:blinky")
			ghost:get_luaentity().gameid = id
		end
	end)
	minetest.after(32, function()
		if mypacman.games[id] and last_reset == mypacman.games[id].last_reset then
			local pos = vector.add(gamestate.pos, {x=15,y=0.5,z=18})
			local ghost = minetest.add_entity(pos, "mypacman:clyde")
			ghost:get_luaentity().gameid = id
		end
	end)
end

-- Remove all the ghosts from the board with the given id
function mypacman.remove_ghosts(id)
	local gamestate = mypacman.games[id]
	if not gamestate then return end

	-- Remove all non-players (ghosts!)
	local boardcenter = vector.add(gamestate.pos, {x=13,y=0.5,z=15})
	for index, object in ipairs(minetest.get_objects_inside_radius(boardcenter,20)) do
		if object:is_player() ~= true then
		object:remove()
		end
	end
end

-- A player got a pellet, update the state
function mypacman.on_player_got_pellet(player)
	local name = player:get_player_name()
	local gamestate = mypacman.get_game_by_player(name)
	if not gamestate then return end

	gamestate.pellet_count = gamestate.pellet_count + 1
	gamestate.score = gamestate.score + 10
	mypacman.update_hud(gamestate.id, player)

	if gamestate.pellet_count >= 252 then -- 252
		minetest.chat_send_player(name, "You cleared the board!")

		mypacman.remove_ghosts(gamestate.id)
		gamestate.pellet_count = 0
		gamestate.level = gamestate.level + 1
		gamestate.speed = gamestate.level + 1

		minetest.after(3.0, function()
			minetest.chat_send_player(name, "Starting Level "..gamestate.level)
			-- place schematic
			local schem = minetest.get_modpath("mypacman").."/schems/mypacman_3.mts"
			minetest.place_schematic(vector.add(gamestate.pos, {x=0,y=-1,z=-2}),schem,0, "air", true)

			-- Set start positions
			mypacman.game_reset(gamestate.id, player)
			minetest.sound_play("mypacman_beginning", {pos = pos,max_hear_distance = 40,gain = 10.0,})
		end)
	end
end

-- A player got a power pellet, update the state
function mypacman.on_player_got_power_pellet(player)
	local name = player:get_player_name()
	local gamestate = mypacman.get_game_by_player(name)
	if not gamestate then return end

	minetest.chat_send_player(name, "You got a POWER PELLET")
	gamestate.power_pellet = os.time() + power_pellet_duration
	gamestate.score = gamestate.score + 50
	mypacman.update_hud(gamestate.id, player)

	local boardcenter = vector.add(gamestate.pos, {x=13,y=0.5,z=15})
	local powersound = minetest.sound_play("mypacman_powerup", {pos = boardcenter,max_hear_distance = 20, object=player, loop=true})

	minetest.after(power_pellet_duration, function()
		if os.time() >= (gamestate.power_pellet or 0) then
			gamestate.power_pellet = false
			minetest.chat_send_player(name, "POWER PELLET wore off")
			minetest.sound_stop(powersound)
		end
	end)
end

-- Get the game that the given player is playing
function mypacman.get_game_by_player(player_name)
	for _,gamestate in pairs(mypacman.games) do
		if gamestate.player_name == player_name then
			return gamestate
		end
	end
end

---------------------------------------------------------
--- Private functions (only can be used inside this file)

-- Save Table
local function gamestate_save()
	local data = mypacman.games
	local f, err = io.open(minetest.get_worldpath().."/mypacman_data", "w")
    if err then return err end
	f:write(minetest.serialize(data))
	f:close()
end

--Read Table
local function gamestate_load()
	local f, err = io.open(minetest.get_worldpath().."/mypacman_data", "r")
	if f then
		local data = minetest.deserialize(f:read("*a"))
		f:close()
		return data
	else
		return nil
	end
end

-- Called every 0.5 seconds for each player that is currently playing pacman
local function on_player_gamestep(player, gameid)
	local player_pos = player:getpos()
	local positions = {
		{x=0.5,y=0.5,z=0.5},
		{x=-0.5,y=0.5,z=-0.5},
	}
	for _,pos in pairs(positions) do
		pos = vector.add(player_pos, pos)
		local node = minetest.get_node(pos)
		if node.name == "mypacman:pellet_1" then
			minetest.remove_node(pos)
			mypacman.on_player_got_pellet(player)
		elseif node.name == "mypacman:pellet_2" then
			minetest.remove_node(pos)
			mypacman.on_player_got_power_pellet(player)

			minetest.sound_play("mypacman_eatfruit", {
				pos = pos,
				max_hear_distance = 100,
				gain = 10.0,
			})
		end
	end
end

-------------------
--- Execution code

-- load the gamestate from disk
mypacman.games = gamestate_load() or {}

-- Time counters
local tmr_gamestep = 0
local tmr_savestep = 0
minetest.register_globalstep(function(dtime)
	tmr_gamestep = tmr_gamestep + dtime;
	if tmr_gamestep > 0.2 then
		for id,player in pairs(mypacman.players) do
			on_player_gamestep(player, id)
		end
		tmr_savestep = tmr_savestep + tmr_gamestep
		if tmr_savestep > 10 then
			gamestate_save()
			tmr_savestep = 0
		end
		tmr_gamestep = 0
	end
end)

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	for id,game in pairs(mypacman.games) do
		if game.player_name == name then
			mypacman.players[id] = player
			mypacman.update_hud(id, player)
		end
	end
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	for id,game in pairs(mypacman.games) do
		if game.player_name == name then
			mypacman.players[id] = nil
			mypacman.remove_hud(player, name)
		end
	end
end)

-- Chatcommand to end the game for the current player
minetest.register_chatcommand("mypacman_exit", {
	params = "",
	description = "Loads and saves all rooms",
	func = function(name, param)
		local gamestate = mypacman.get_game_by_player(name)
		if gamestate then
			mypacman.game_end(gamestate.id)
			minetest.get_player_by_name(name):moveto(vector.add(gamestate.pos,{x=0.5,y=0.5,z=-1.5}))
			minetest.chat_send_player(name, "You are no longer playing pacman")
		else
			minetest.chat_send_player(name, "You are not currently in a pacman game")
		end
	end
})
