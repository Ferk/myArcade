
local ghosts_death_delay = 5


local ghosts = {
	{"pinky","Pinky"},
	{"inky","Inky"},
	{"blinky","Blinky"},
	{"clyde","Clyde"},
	}
for i in ipairs(ghosts) do
	local itm = ghosts[i][1]
	local desc = ghosts[i][2]

	minetest.register_entity("mypacman:"..itm, {
		hp_max = 1,
		physical = true,
		collide_with_objects = true,
		visual = "cube",
		visual_size = {x = 0.6, y = 1},
		textures = {
			"mypacman_"..itm.."s.png",
			"mypacman_"..itm.."s.png",
			"mypacman_"..itm.."s.png",
			"mypacman_"..itm.."s.png",
			"mypacman_"..itm.."f.png",
			"mypacman_"..itm.."s.png",
		},
		groups = {immortal = 1},
		velocity = {x=math.random(-1,1), y=0, z=math.random(-1,1)},
		collisionbox = {-0.25, -1.0, -0.25, 0.25, 0.48, 0.25},
		is_visible = true,
		automatic_rotate = true,
		automatic_face_movement_dir = -90, -- set yaw direction in degrees, false to disable
		makes_footstep_sound = false,

		set_velocity = function(self, v)
			if not v then v = 0 end
			local yaw = self.object:getyaw()
			self.object:setvelocity({x=math.sin(yaw) * -v, y=self.object:getvelocity().y, z=math.cos(yaw) * v})
		end,

		on_step = function(self, dtime)
			-- every 1 second
			self.timer = (self.timer or 0) + dtime
			if self.timer < 1 then return end
			self.timer = 0

			-- Do we have game state? if not just die
			local gamestate = mypacman.games[self.gameid]
			if not gamestate then
				minetest.log("action", "Removing pacman ghost from finished game " .. (self.gameid or ""))
				self.object:remove()
				return
			end

			-- Make sure we have a targetted player
			if not self.target then
				self.target = minetest.get_player_by_name(gamestate.player_name)
			end
			local player = self.target

			local s = self.object:getpos() -- ghost
			local p = player:getpos() -- player
			print(dump(gamestate))
			 -- find distance from ghost to player
			local distance = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
			if distance < 1.5 then
				-- player touches ghost!!

				if gamestate.power_pellet then
					-- Player eats ghost! move it to spawn
					local ghost_spawn = vector.add(gamestate.pos, {x=13,y=0.5,z=19})
					self.object:setpos(ghost_spawn)
					-- set the timer negative so it'll have to wait extra time
					self.timer = -ghosts_death_delay
					-- play sound and reward player
					minetest.sound_play("mypacman_eatfruit", {pos = p,
						max_hear_distance = 6, gain = 10.0,
					})
					player:get_inventory():add_item('main', 'mypacman:cherrys')
				else
					-- Ghost catches the player!
					gamestate.lives = gamestate.lives - 1
					if gamestate.lives < 1 then
						minetest.chat_send_player(gamestate.player_name,"Game Over")
						player:moveto(vector.add(gamestate.pos,{x=0.5,y=0.5,z=-1.5}))
						mypacman.game_end(self.gameid)

					elseif gamestate.lives == 1 then
						minetest.chat_send_player(gamestate.player_name,"This is your last life")
						mypacman.game_reset(self.gameid, player)
					else
						minetest.chat_send_player(gamestate.player_name,"You have ".. gamestate.lives .." lives left")
						mypacman.game_reset(self.gameid, player)
					end
				end

			else
				local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
				local yaw = (math.atan(vec.z/vec.x)+math.pi/2)
				if p.x > s.x then
					yaw = yaw + math.pi
				end
				-- face player and move backwards/forwards
				self.object:setyaw(yaw)
				if gamestate.power_pellet then
					self.set_velocity(self, -gamestate.speed) --negative velocity
				else
					self.set_velocity(self, gamestate.speed)
				end
			end
		end,

		-- This function should return the saved state of the entity in a string
		get_staticdata = function(self)
			return self.gameid or ""
		end,

		-- This function should load the saved state of the entity from a string
		on_activate = function(self, staticdata)
			if staticdata and staticdata ~= "" then
				self.gameid = staticdata
			end
		end
	})
end
