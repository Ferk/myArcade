--The code used for the ghosts was made by Tenplus1

local myghosts = {}
local deathcount = 0
local gravity = -10

clear_ghosts = function()
	local pos = mypacman.start
	
	for index, object in ipairs(minetest.get_objects_inside_radius({x=pos.x+13,y=pos.y+0.5,z=pos.z+15},20)) do
		--local obj = object:get_luaentity()
		if object:is_player() ~= true then
		object:moveto({x=pos.x+13,y=pos.y+0.5,z=pos.z+19})
		end
	end
	--minetest.add_entity({x=pos.x+13,y=pos.y+0.5,z=pos.z+19}, "mypacman:inky")
	--minetest.add_entity({x=pos.x+15,y=pos.y+0.5,z=pos.z+19}, "mypacman:pinky")
	--minetest.add_entity({x=pos.x+13,y=pos.y+0.5,z=pos.z+18}, "mypacman:blinky")
	--minetest.add_entity({x=pos.x+15,y=pos.y+0.5,z=pos.z+18}, "mypacman:clyde")
	
end

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
       textures = 
		{"mypacman_"..itm.."s.png",
		"mypacman_"..itm.."s.png",
		"mypacman_"..itm.."s.png",
		"mypacman_"..itm.."s.png",
		"mypacman_"..itm.."f.png",
		"mypacman_"..itm.."s.png",
		},
       velocity = {x=math.random(-1,1), y=0, z=math.random(-1,1)},
       collisionbox = {-0.25, -1.0, -0.25, 0.25, 0.48, 0.25},
       weight = 5, -- ??
       is_visible = true,
       automatic_rotate = true,
       automatic_face_movement_dir = -90, -- set yaw direction in degrees, false to disable
       stepheight = 1.1,
       makes_footstep_sound = false,
       floats = 1,
       view_range = 40,
       speed = mypacman.spd,
       jump_height = 0,

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

          -- make sure object floats (or not) when in water
          if minetest.get_item_group(minetest.get_node(self.object:getpos()).name, "water") ~= 0 then
             if self.floats == 1 then
                self.object:setacceleration({x = self.object:getacceleration().x, y = 1.5, z = self.object:getacceleration().z})
             end
          else
             self.object:setacceleration({x = self.object:getacceleration().x, y = gravity, z = self.object:getacceleration().z})
          end

          local s, p, dist, nod
          -- find player to follow
          for _,player in pairs(minetest.get_connected_players()) do
             s = self.object:getpos()
             p = player:getpos()

             -- find distance
             dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
             if dist < self.view_range then
                local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
                local yaw = (math.atan(vec.z/vec.x)+math.pi/2)
                if p.x > s.x then
                   yaw = yaw + math.pi
                end
                -- face player
                self.object:setyaw(yaw)

                -- find direction and show node facing
                self.direction = {x = math.sin(yaw)*-1, y = 0, z = math.cos(yaw)}
                nod = minetest.get_node_or_nil({x=s.x + self.direction.x,y=s.y+1,z=s.z + self.direction.z})

                -- more than 2 nodes ahead then follow, otherwise stop
                if dist > 0 then
                   if self.jump_height > 0 and self.object:getvelocity().y == 0 then
                      local v = self.object:getvelocity()
                      v.y = self.jump_height
                      self.object:setvelocity(v)
                   end
                   
                   self.set_velocity(self, self.speed)
                else
                   self.set_velocity(self, 0)
                end


                -- break look after player found
                break
             end
          end
                          
                          -- if touches player then death
                local s = self.object:getpos()
				local obs = {}
				for _,oir in ipairs(minetest.get_objects_inside_radius(s, 1.5)) do
					local obj = oir:get_luaentity()
					if oir:is_player() then
					local player = oir
					local pos = mypacman.start
					local name = player:get_player_name()
						if deathcount == 0 then
							player:moveto({x=pos.x+13,y=pos.y+0.5,z=pos.z+15.5})
							minetest.chat_send_player(name,"You have 1 more life after this")
							deathcount = 1
							clear_ghosts()
						elseif deathcount == 1 then
							player:moveto({x=pos.x+13,y=pos.y+0.5,z=pos.z+15.5})
							minetest.chat_send_player(name,"This is your last life")
							deathcount = 2
							clear_ghosts()
						elseif deathcount == 2 then
					        player:moveto({x=pos.x+0.5,y=pos.y+0.5,z=pos.z-1.5})
							minetest.chat_send_player(name,"Game Over")
							deathcount = 0
					   end
					end
				end
       end,
    })
end
