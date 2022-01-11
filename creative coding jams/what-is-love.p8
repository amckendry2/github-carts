pico-8 cartridge // http://www.pico-8.com
version 32
__lua__



angle = 90
seesaw_len = 90

p1_pos=-10
p2_pos=10

p1_on_seesaw = true
p2_on_seesaw = true

p1_dead = false
p2_dead = false


p1x = 0
p1y = 0
p2x = 0
p2y = 0

p1v = 0
p2v = 0

p_spd = .025

grav = .04

tilt_damp = .01

sx_o = 0
sy_o = 0

bullet_rate = 40
t = 0

bullet_grav = .5
bullet_sz = 3

bullets = {}

score = 0
score_rate = 5

function _init()
music(0)
end


function _update60()
	t += 1;

	if not (p1_dead or p2_dead) and t%score_rate == 0 then
		score += 1
	end

	if t % bullet_rate == 0 then
		add(bullets,{x=rnd()*128, y=0})
	end

	for b in all(bullets) do
		b.y += bullet_grav
		if(b.y > 128)del(bullets, b)
	end

	local p1bal = p1_dead and 0 or p1_pos 
	local p2bal = p2_dead and 0 or p2_pos
	angle -= (p1bal + p2bal) * tilt_damp
	angle = mid(30, angle, 150)
	local a = angle / 360

	if p2_on_seesaw then
		if(btn(4))p2v += p_spd
		if(btn(5))p2v -= p_spd
	end
	if p1_on_seesaw then
		if(btn(0))p1v += p_spd
		if(btn(1))p1v -= p_spd
	end

	g_force = cos(a) * grav 

	p1v += g_force
	p2v += g_force

	p1_pos += p1v
	p2_pos += p2v

	p1_on_seesaw = mid(-seesaw_len/2, p1_pos, seesaw_len/2) == p1_pos
	p2_on_seesaw = mid(-seesaw_len/2, p2_pos, seesaw_len/2) == p2_pos

	local x_offset = sin(a)
	local y_offset = cos(-a)
	sx_o, sy_o = x_offset * seesaw_len / 2, y_offset * seesaw_len / 2

	if p1_on_seesaw then
		local p1_fract = p1_pos / (seesaw_len / 2)
		local p1x_o, p1y_o = p1_fract * sx_o, p1_fract * sy_o
		p1x, p1y = 64 + p1x_o, 72 + p1y_o
	else
		p1x -= sgn(p1_pos) * 1
		p1y += 2
	end

	if p2_on_seesaw then
		local p2_fract = p2_pos / (seesaw_len / 2)
		local p2x_o, p2y_o = p2_fract * sx_o, p2_fract * sy_o
		p2x, p2y = 64 + p2x_o, 72 + p2y_o
	else
		p2x -= sgn(p2_pos) * 1
		p2y += 2
	end

	for b in all(bullets) do
		if getCollision(p1x-4, p1y, p1x+4, p1y+8, b.x, b.y, b.x + bullet_sz, b.y + bullet_sz) then
			p1_dead = true
		end
		if getCollision(p2x-4, p2y, p2x+4, p2y+8, b.x, b.y, b.x + bullet_sz, b.y + bullet_sz) then
			p2_dead = true
		end
	end

	if(not p1_dead)p1_dead = mid(0, p1x, 128) ~= p1x
	if(not p1_dead)p1_dead = mid(0, p1y, 128) ~= p1y
	if(not p2_dead)p2_dead = mid(0, p2x, 128) ~= p2x
	if(not p2_dead)p2_dead = mid(0, p2y, 128) ~= p2y

	if(p1_dead or p2_dead) and btn(2) then
		run()
	end

end

function getCollision(ax1, ay1, ax2, ay2, bx1, by1, bx2, by2)
	return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

function _draw()
	cls()
	
	for b in all(bullets) do
		rectfill(b.x,b.y,b.x+bullet_sz, b.y+bullet_sz, 14)
	end

	line(64 - sx_o, 80 - sy_o, 64 + sx_o, 80 + sy_o, 4)
	circfill(64, 84, 3, 4)

	if not p1_dead then
		spr(1, p1x-4, p1y)
		if t < 240 and t % 40 < 30 then
			print("⬅️/➡️",p1x-5, p1y+10,12)
		end
	end
	if not p2_dead then
		spr(2, p2x-4, p2y)
		if t < 240 and t % 40 < 30 then
			print("z/x", p2x-2, p2y+10, 8)
		end
	end

	if(p1_dead or p2_dead) then
		print("game over", 48, 30, 7)
		print("press ⬆️ to restart", 30, 40, 7)
	end

	print("score: " .. score, 0, 0, 7)
end






__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000cc00cc00880088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700cccccccc8888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000cccccccc8888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000cccccccc8888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000cccccc00888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000cccc000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000cc0000008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
07700770077077707770000000007770777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70007000707070707000070000007000707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77707000707077007700000000007770707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00707000707070707000070000000070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77000770770070707770000000007770777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeee0000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeee0000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeee0000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeee0000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeee0000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeee0000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000eeeeee0000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000eeeeee0000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000eeeeee0000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000eeeeee0000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000eeeeee0000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000eeeeee0000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000eeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000eeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000eeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000eeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000eeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000eeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000044000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000044000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeeee0000000000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeeee0000000000000000044000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeeee0000000000000000000440000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeeee0000000000000000000004400000000880088000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeeee0000000000000000000000044000008888888800000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeeee0000000000000000000000000440008888888800000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000004408888888800000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000040888888000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000004488880000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000048800000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000440000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000004400000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000044000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000440000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004400000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000044444000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000444440440000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000004444444004400000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000004444444000044000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000004444444000000440000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000044444ee00000004000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000444eee00000000440000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000eeeeee00000000004400000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000eeeeee00000000000044000000000cc00cc000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000eeeeee0000000000000044000000cccccccc00000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000eeeeee0000000000000000440000cccccccc00000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000004400cccccccc00000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000440cccccc000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044cccc0000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004cc00000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000440000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004400000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000440000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000eeeeee000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000eeeeee000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000eeeeee000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000eeeeee000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000eeeeee000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000eeeeee000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__sfx__
010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
411a00000e5151151513515005050050500505005050e5150f5150e51511515005050e515005050050500505005050e51511515005050e515005050050500505005050e5150c5150050500505005050050500505
__music__
03 01424344

