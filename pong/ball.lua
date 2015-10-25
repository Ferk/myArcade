



minetest.register_entity("pong:ball", {
	hp_max = 1,
	physical = false,
	collide_with_objects = false,
	visual = "cube",
	visual_size = {x = 0.25, y = 0.25},
	textures = {
		"default_cloud.png", "default_cloud.png", "default_cloud.png",
		"default_cloud.png", "default_cloud.png", "default_cloud.png",
	},
	velocity = {x=math.random(-1,1), y=0, z=math.random(-1,1)},
	direction = {x=1, y=0, z=1},
	collisionbox = {-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
	is_visible = true,
	automatic_rotate = false,
	makes_footstep_sound = false,
	speed = 4,

	update_velocity = function(self, direction)
		if not self.speed then self.speed = 0 end

		if not direction then
			local yaw = self.object:getyaw()
			self.direction = {x= -math.sin(yaw), y=0, z=math.cos(yaw)}
		else
			self.direction = direction
		end
		self.object:setvelocity(vector.multiply(self.direction, self.speed))
	end,


	on_player_collision = function(self, player)
		local yaw = self.object:getyaw()

		local pos = self.object:getpos()
		local playerpos = player:getpos()

		local playerdir = vector.direction(playerpos,pos)
		playerdir.y = 0

		local v = self.object:getvelocity()
		if v.x < 1 and v.z < 1 then
			self:update_velocity(playerdir)
			return
		end

		--[[
		if math.sign(playerdir.x) ~= math.sign(self.direction.x) then
			self.direction.x = -self.direction.x
			self:update_velocity(self.direction)
		else
			self.direction.z = -self.direction.z
			self:update_velocity(self.direction)
		end
		--]]

		if math.sign(playerdir.x) ~= math.sign(self.direction.x) then
			self.object:setyaw((yaw + 90)%360)
		elseif pos.z < playerpos.z then
			self.object:setyaw((yaw - 90)%360)
		end
		self:update_velocity()
	end,

	on_step = function(self, dtime)
		-- every 0.2 seconds
		self.timer = (self.timer or 0) + dtime
		if self.timer < 0.2 then return end
		self.timer = 0

		local pos = self.object:getpos()
		local p = vector.add(pos, self.direction)
		if p.x <= self.minp.x or p.x >= self.maxp.x then
			self.direction.x = -self.direction.x
			self:update_velocity(self.direction)
		elseif p.z <= self.minp.z or p.z >= self.maxp.z then
			self.direction.z = -self.direction.z
			self:update_velocity(self.direction)
		else
			for _,obj in pairs(minetest.get_objects_inside_radius(pos,1)) do
				if obj:is_player() == true then
					self:on_player_collision(obj)
					break
				end
			end
		end
	end,

	-- This function should return the saved state of the entity in a string
	get_staticdata = function(self)
		return minetest.serialize({minp = self.minp, maxp = self.maxp})
	end,

	-- This function should load the saved state of the entity from a string
	on_activate = function(self, staticdata)
		self.object:set_armor_groups({immortal=1})
		self.direction = vector.normalize(self.object:getvelocity())
		if staticdata and staticdata ~= "" then
			staticdata = minetest.deserialize(staticdata)
			self.minp = staticdata.minp
			self.maxp = staticdata.maxp
		end
	end
})
