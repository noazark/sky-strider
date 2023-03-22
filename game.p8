pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
local player = {
  x = 64,
  y = 64,
  speed = 1,
  sprite = 1,
  yspeed = 0
}

local clouds = {}
local hoops = {}
local planes = {}

local score = 0
local ground_pos = 116


local game_over_flag = false


function _init()
  -- reset all global variables
  player = {
    x = 64,
    y = 64,
    speed = 1,
    sprite = 1,
    yspeed = 0
  }
  clouds = {}
  hoops = {}
  planes = {}
  score = 0
  game_over_flag = false
  
  -- add initial clouds
  for i=1,5 do
    add_cloud()
  end
  
  -- add initial hoop
  add_hoop()
  
  -- add initial plane
  add_plane()
end


function _update()
  if (btn(0)) then
    player.x -= player.speed
  end
  if (btn(1)) then
    player.x += player.speed
  end
  
  -- make the player fly up if up button is pressed
  if (btn(2)) then
    player.yspeed -= 0.2
  else
    player.yspeed += 0.2
  end
  
  player.y += player.yspeed
  
  -- don't let the player fall below the grass
  if (player.y > ground_pos) then
    game_over_flag = true
  end
  
  for cloud in all(clouds) do
    cloud.x -= cloud.speed
    if cloud.x < -16 then
      del(clouds, cloud)
      add_cloud()
    end
  end
  
  for hoop in all(hoops) do
    if collide(hoop, player) then
      sfx(0)
      add_score()
      del(hoops, hoop)
    end
  end
  
  for plane in all(planes) do
    if collide(plane, player) then
      game_over_flag = true
    end
    
    plane.x -= plane.speed
    
    if plane.x < -16 then
      del(planes, plane)
    end
  end
  
  for hoop in all(hoops) do
    hoop.x -= hoop.speed
    if hoop.x < -16 then
      del(hoops, hoop)
    end
  end
  
  if (#hoops == 0) then
    add_hoop()
  end
  
  if (#planes == 0) then
    add_plane()
  end
  
  for plane in all(planes) do
    plane.x -= plane.speed
    if plane.x < -16 then
      del(planes, plane)
    end
  end
end

function _draw()
  if (game_over_flag) then
    game_over()
  else
    -- draw sky
    rectfill(0, 0, 127, 127, 12)
    
    -- draw grass
		 	for y=ground_pos,127 do
 	  	 for x=0,127 do
   	 	  pset(x, y, 3)
  			 end
				end
    
    -- draw hoops
    for hoop in all(hoops) do
      spr(16, hoop.x, hoop.y)
    end
    
    -- draw planes
    for plane in all(planes) do
      spr(17, plane.x, plane.y)
    end
    
    -- draw clouds
    for cloud in all(clouds) do
      spr(2, cloud.x, cloud.y)
    end
    
    spr(player.sprite, player.x, player.y)
    
    -- draw score
    print("score: " .. score, 2, 2, 7)
  end
end



function add_cloud()
  add(clouds, {
    x = 128 + flr(rnd(64)),
    y = flr(rnd(64)),
    speed = rnd(2) + 1
  })
end

function add_hoop()
  add(hoops, {
    x = 128,
    y = flr(rnd(96)) + 16,
    speed = 2
  })
end

function add_plane()
  local min_y = 24
  local max_y = 96
  local y_range = max_y - min_y
  
  local new_plane_y = flr(rnd(y_range)) + min_y
  
  local new_plane = {
    x = 128,
    y = new_plane_y,
    speed = rnd(2) + 1  -- random speed between 1 and 3
  }
  
  -- don't spawn plane too close to the player
  while abs(new_plane.y - player.y) < 16 do
    new_plane_y = flr(rnd(y_range)) + min_y
    new_plane.y = new_plane_y
  end
  
  add(planes, new_plane)
end


function collide(a, b)
  local a_left = a.x
  local a_right = a.x + 7
  local a_top = a.y
  local a_bottom = a.y + 7
  
  local b_left = b.x
  local b_right = b.x + 15
  local b_top = b.y
  local b_bottom = b.y + 15
  
  if a_right >= b_left and
     a_left <= b_right and
     a_bottom >= b_top and
     a_top <= b_bottom then
    return true
  else
    return false
  end
end



function add_score()
  score += 1
end


function game_over()
  sfx(2)
  print("game over", 50, 50, 8)
  print("press ❎ to restart", 30, 60, 8)
  
  if (btn(5)) then
    _init()
  end
end

__gfx__
00000000055555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000050000666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700900097700677660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000990997796677676600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000999999996777777600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700006999966666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000666650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999a00555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
099a99a0000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09a009a0055800080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09a009a0855880880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09a009a0888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09a009a0288888200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
099a99a0522220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999a00055555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
