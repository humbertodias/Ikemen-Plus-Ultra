--;===========================================================
--; INITIAL ACTIONS
--;===========================================================
math.randomseed(os.time())

--Debug stuff
loadDebugFont('font/14x14.fnt')
setDebugScript('script/debug.lua')

--Load Common stuff (shared with pause.lua)
require('script.common')

--Assign Lifebar
loadLifebar(data.lifebar) --path to lifebar stored in 'save/data_sav.lua', also adjustable from options

--;===========================================================
--; LOAD ADDITIONAL SCRIPTS
--;===========================================================
assert(loadfile('script/start.lua'))()
require('script.options')
require('script.select')
require('script.statistics')
require('script.missions')
require('script.events')
require('script.story')
--require('script.adventure')

local file = io.open("save/config.ssz","r")
s_configSSZ = file:read("*all")
file:close()
resolutionWidth = tonumber(s_configSSZ:match('const int Width%s*=%s*(%d+)'))
resolutionHeight = tonumber(s_configSSZ:match('const int Height%s*=%s*(%d+)'))

--f_drawQuickText(txt_testVar, font3, 0, 0, 'hi', 163.5, 168) --Delete me when your test finish
--;===========================================================
--; UNLOCKS CHECK DEFINITION
--;===========================================================
function f_unlocksCheck()
	assert(loadfile('save/stats_sav.lua'))()
	if data.arcadeClear == true then --Verify if you comply with this condition and then..
		t_selStages[t_stageDef["stages/mountainside temple/hidden path.def"]].unlock = 1 --modify the original value in the table to unlock!
	end
	if data.story1_1Unlock == true then
		t_selStages[t_stageDef["stages/mountainside temple/lobby 2 night.def"]].unlock = 1
	end
	if data.story1_4AUnlock == true then
		t_selChars[t_charAdd["suave dude"]+1].unlock = 1
	end
	if data.mission1Status == 1 then
		t_selStages[t_stageDef["stages/mountainside temple/dark corridor.def"]].unlock = 1
	end
	if data.event1Status == 1 then
		t_selStages[t_stageDef["stages/mountainside temple/winter.def"]].unlock = 1
	end
	if data.trainingTime > 2000 then
		t_selStages[t_stageDef["stages/training room 2.def"]].unlock = 1
	end
	f_updateLogs()
end

--;===========================================================
--; MAIN MENU SCREENPACK
--;===========================================================
--[[Quick reference]
animSetScale(a, x, y): Sets the scale of an anim
animSetPos(a, x  y): Sets the screen position of an anim, relative to the top left corner
animAddPos(a, x, y): Adjusts an anim's current position
animSetWindow(a, x1, y1, x2, y2): Sets the drawing window for an anim
animSetTile(a, x, y): Sets whether to tile (repeat) an anim across the given axes
animSetAlpha(a, as, ad): Sets the alpha blending of an anim
animUpdate(a): Advances the anim frame by 1 tick
animDraw(a): Draws an anim to the screen
]]

--Buttons Background
titleBG0 = animNew(sysSff, [[
5,1, 0,145, -1
]])
animAddPos(titleBG0, 160, 0)
animSetTile(titleBG0, 1, 1)
animSetWindow(titleBG0, 0, 145, 320, 78)
--[[parallax is not supported yet
type  = parallax
width = 400, 1200
yscalestart = 100
yscaledelta = 1
]]

--Buttons Background (fade)
titleBG1 = animNew(sysSff, [[
5,2, -160,145, -1, 0, s
]])
animAddPos(titleBG1, 160, 0)
animUpdate(titleBG1)

--Background Top
titleBG2 = animNew(sysSff, [[
5,0, 0,10, -1
]])
animAddPos(titleBG2, 160, 0)
animSetTile(titleBG2, 1, 2)

--Hardcore Background Top
titleHardBG2 = animNew(sysSff, [[
6,0, 0,10, -1
]])
animAddPos(titleHardBG2, 160, 0)
animSetTile(titleHardBG2, 1, 2)

--Logo
titleBG3 = animNew(sysSff, [[
0,0, 0,40, -1, 0, a
]])
animAddPos(titleBG3, 160, 0)
animUpdate(titleBG3)

--Background Middle (black text cover)
titleBG4 = animNew(sysSff, [[
5,1, 0,145, -1
]])
animAddPos(titleBG4, 160, 0)
animSetTile(titleBG4, 1, 1)
animSetWindow(titleBG4, 0, 138, 320, 7)
animSetAlpha(titleBG4, 0, 0)
animUpdate(titleBG4)

--Hardcore Background Middle (black text cover)
titleHardBG4 = animNew(sysSff, [[
6,1, 0,145, -1
]])
animAddPos(titleHardBG4, 160, 0)
animSetTile(titleHardBG4, 1, 1)
animSetWindow(titleHardBG4, 0, 138, 320, 7)
animSetAlpha(titleHardBG4, 0, 0)
animUpdate(titleHardBG4)

--Background Bottom (black text cover)
titleBG5 = animNew(sysSff, [[
5,1, 0,145, -1
]])
animAddPos(titleBG5, 160, 0)
animSetTile(titleBG5, 1, 1)
animSetWindow(titleBG5, 0, 223, 320, 20)
animSetAlpha(titleBG5, 0, 0)
animUpdate(titleBG5)

--Hardcore Background Bottom (black text cover)
titleHardBG5 = animNew(sysSff, [[
6,1, 0,145, -1
]])
animAddPos(titleHardBG5, 160, 0)
animSetTile(titleHardBG5, 1, 1)
animSetWindow(titleHardBG5, 0, 223, 320, 20)
animSetAlpha(titleHardBG5, 0, 0)
animUpdate(titleHardBG5)

--Background Footer
titleBG6 = animNew(sysSff, [[
300,0, 0,233, -1
]])
animAddPos(titleBG6, 160, 0)
animSetTile(titleBG6, 1, 0)
animUpdate(titleBG6)

--Cursor Box
cursorBox = animNew(sysSff, [[
100,1, 0,0, -1
]])
animSetTile(cursorBox, 1, 1)

--Optimized Cursor Box
--cursorBox = animNew(sysSff, [[
--3,1, 0,0, -1
--]])
--animSetPos(cursorBox, 80, 20)
--animSetAlpha(cursorBox, 20, 100)
--animUpdate(cursorBox)

--Message Fade BG
fadeWindowBG = animNew(sysSff, [[
3,0, 0,0, -1, 0, AS256D102
]])
animSetPos(fadeWindowBG, -54, 0)
animSetScale(fadeWindowBG, 427, 240)
animUpdate(fadeWindowBG)

--Up Menu Arrow
arrowsU = animNew(sysSff, [[
225,0, 0,0, 10
225,1, 0,0, 10
225,2, 0,0, 10
225,3, 0,0, 10
225,3, 0,0, 10
225,2, 0,0, 10
225,1, 0,0, 10
225,0, 0,0, 10
]])
animAddPos(arrowsU, 153.5, 136)
animUpdate(arrowsU)
animSetScale(arrowsU, 0.5, 0.5)

--Down Menu Arrow
arrowsD = animNew(sysSff, [[
226,0, 0,0, 10
226,1, 0,0, 10
226,2, 0,0, 10
226,3, 0,0, 10
226,3, 0,0, 10
226,2, 0,0, 10
226,1, 0,0, 10
226,0, 0,0, 10
]])
animAddPos(arrowsD, 153.5, 224)
animUpdate(arrowsD)
animSetScale(arrowsD, 0.5, 0.5)

--;===========================================================
--; CLOCK AND DATE FEATURES
--;===========================================================
function f_sysTime()
	--local http = require("socket.http") -- import the socket.http module
	--local body, httpcode, headers = http.request("http://www.google.com") --("time.windows.com")
	--local date = headers.date -- LuaSocket makes all header names lowercase
	--print(date) --> "Mon, 18 Feb 2013 09:03:13 GMT"
	sysTime = tonumber(os.date("%H")) --Assigns the current hour to a variable based on the system clock. Used for day/night features.
	sysTime2 = tonumber(os.date("%d")) --Assigns the current day to a variable based on date. Used for daily events features.
	--sysTime3 = tonumber(os.date("%m"))
	--4:3
	if (resolutionHeight / 3 * 4) == resolutionWidth then
		--Clock
		if data.clock == 'Standard' then
			txt_titleClock = createTextImg(font12, 0, -1, (os.date("%I:%M%p")), 314, 8)
		elseif data.clock == 'Full Standard' then
			txt_titleClock = createTextImg(font12, 0, -1, (os.date("%I:%M%p:%S")), 314, 8)
		elseif data.clock == 'Military' then
			txt_titleClock = createTextImg(font12, 0, -1, (os.date("%H:%M")), 314, 8)
		elseif data.clock == 'Full Military' then
			txt_titleClock = createTextImg(font12, 0, -1, (os.date("%X")), 314, 8)
		end
		--Date
		if data.date == 'Type A' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%m-%d-%y")), 8, 8)
		elseif data.date == 'Type B' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%d-%m-%Y")), 8, 8)
		elseif data.date == 'Type C' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%a %d.%b.%Y")), 8, 8)
		elseif data.date == 'Type D' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%A")), 8, 8)
		elseif data.date == 'Type E' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%B.%Y")), 8, 8)
		end
	--16:10
	elseif (resolutionHeight / 10 * 16) == resolutionWidth then
		if data.clock == 'Standard' then
			txt_titleClock = createTextImg(font12, 0, -1, (os.date("%I:%M%p")), 345, 8)
		elseif data.clock == 'Full Standard' then
			txt_titleClock = createTextImg(font12, 0, -1, (os.date("%I:%M%p:%S")), 345, 8)
		elseif data.clock == 'Military' then
			txt_titleClock = createTextImg(font12, 0, -1, (os.date("%H:%M")), 345, 8)
		elseif data.clock == 'Full Military' then
			txt_titleClock = createTextImg(font12, 0, -1, (os.date("%X")), 345, 8)
		end
		if data.date == 'Type A' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%m-%d-%y")), -25, 8)
		elseif data.date == 'Type B' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%d-%m-%Y")), -25, 8)
		elseif data.date == 'Type C' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%a %d.%b.%Y")), -25, 8)
		elseif data.date == 'Type D' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%A")), -25, 8)
		elseif data.date == 'Type E' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%B.%Y")), -25, 8)
		end
	--16:9
	elseif (math.floor((resolutionHeight / 9 * 16) + 0.5)) == resolutionWidth then
		if data.clock == 'Standard' then
			txt_titleClock = createTextImg(font12, 0, -1, (os.date("%I:%M%p")), 365, 8)
		elseif data.clock == 'Full Standard' then
			txt_titleClock = createTextImg(font12, 0, -1, (os.date("%I:%M%p:%S")), 365, 8)
		elseif data.clock == 'Military' then
			txt_titleClock = createTextImg(font12, 0, -1, (os.date("%H:%M")), 365, 8)
		elseif data.clock == 'Full Military' then
			txt_titleClock = createTextImg(font12, 0, -1, (os.date("%X")), 365, 8)
		end
		if data.date == 'Type A' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%m-%d-%y")), -45, 8)
		elseif data.date == 'Type B' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%d-%m-%Y")), -45, 8)
		elseif data.date == 'Type C' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%a %d.%b.%Y")), -45, 8)
		elseif data.date == 'Type D' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%A")), -45, 8)
		elseif data.date == 'Type E' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%B.%Y")), -45, 8)
		end
	--Extra
	else
		if data.clock == 'Standard' then
			txt_titleClock = createTextImg(font12, 0, -1, (os.date("%I:%M%p")), 345, 8)
		elseif data.clock == 'Full Standard' then
			txt_titleClock = createTextImg(font12, 0, -1, (os.date("%I:%M%p:%S")), 345, 8)
		elseif data.clock == 'Military' then
			txt_titleClock = createTextImg(font12, 0, -1, (os.date("%H:%M")), 345, 8)
		elseif data.clock == 'Full Military' then
			txt_titleClock = createTextImg(font12, 0, -1, (os.date("%X")), 345, 8)
		end
		if data.date == 'Type A' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%m-%d-%y")), -25, 8)
		elseif data.date == 'Type B' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%d-%m-%Y")), -25, 8)
		elseif data.date == 'Type C' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%a %d.%b.%Y")), -25, 8)
		elseif data.date == 'Type D' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%A")), -25, 8)
		elseif data.date == 'Type E' then
			txt_titleDate = createTextImg(font12, 0, 1, (os.date("%B.%Y")), -25, 8)
		end
	end
	textImgDraw(txt_titleClock) --Draw Clock
	textImgDraw(txt_titleDate) --Draw Date
end

--;===========================================================
--; F1 INFOBOX MESSAGE
--;===========================================================
infoboxCfg = createTextImg(font1, 0, 1, '', 0, 0)
txt_infobox = [[

















This is an unofficial version of S-SIZE Ikemen Engine maintained by CD2.

* This is a public development release, for testing purposes.
* This build may contain bugs and incomplete features.
* Your help and cooperation are appreciated!
* Ikemen GO engine is the lastest and supported version by original developers.
* Original repo source code: https://osdn.net/users/supersuehiro/
 ]]

function f_infoboxMenu()
	cmdInput()
	--Draw Fade BG
	animDraw(fadeWindowBG)
	--Draw Info Text
	f_textRender(infoboxCfg, txt_infobox, 0, 2, 10, 8.8, 0, -1)
	--Actions
	if esc() or btnPalNo(p1Cmd) > 0 or commandGetState(p1Cmd, 'e') or commandGetState(p1Cmd, 'u') or commandGetState(p1Cmd, 'd') or commandGetState(p1Cmd, 'l') or commandGetState(p1Cmd, 'r') then
		--sndPlay(sysSnd, 100, 2)
		f_infoboxReset()
	end
	cmdInput()
end

function f_infoboxReset()
	infoboxScreen = false
end

--;===========================================================
--; SIDE SELECT SCREEN
--;===========================================================
txt_sideTitle = createTextImg(font14, 0, 0, "SIDE SELECT", 157, 8, 0.9, 0.9)

--Gamepad Icon
gamepadIcon = animNew(sysSff, [[20,0, 0,0,]])

--Left Arrows
L_arrow = animNew(sysSff, [[
223,0, 0,0, 10
223,1, 0,0, 10
223,2, 0,0, 10
223,3, 0,0, 10
223,3, 0,0, 10
223,2, 0,0, 10
223,1, 0,0, 10
223,0, 0,0, 10
]])

--Right Arrows
R_arrow = animNew(sysSff, [[
224,0, 0,0, 10
224,1, 0,0, 10
224,2, 0,0, 10
224,3, 0,0, 10
224,3, 0,0, 10
224,2, 0,0, 10
224,1, 0,0, 10
224,0, 0,0, 10
]])

function f_sideSelect()
	--controller icon config
	local p1gamepadPosY = 86.5
	local p2gamepadPosY = 150
	local gamepadScale = 0.10
	--text config
	local p1txtPosY = 88
	local p2txtPosY = 152
	local txtScale = 0.7
	local txtFont = font13
	local txtP1name = "PLAYER 1"
	local txtP2name = "PLAYER 2"
	local txtP1color = 0
	local txtP2color = 1
	--arrows confg
	local p1arrowPosY = 107.5
	local p2arrowPosY = 167.5
	local arrowScale = 0.5
	--Center X Position
	local gamepadPosXcenter = 122
	local txtPosXcenter = 159
	local arrowLposXcenter = 104
	local arrowRposXcenter = 205
	--Left X Position
	local gamepadPosXleft = 5
	local txtPosXleft = 42
	--local arrowRposXleft = 
	--Right X Position
	local gamepadPosXright = 240
	local txtPosXright = 277
	--local arrowLposXright = 
	cmdInput() --Read Inputs
	data.p2In = 2 --Activate Player 2 Control
	--P1 Cursor Position
	if commandGetState(p1Cmd, 'l') then
		if p1Side > -1 then
			sndPlay(sysSnd, 100, 0)
			p1Side = p1Side - 1
		end
	elseif commandGetState(p1Cmd, 'r') then
		if p1Side < 1 then
			sndPlay(sysSnd, 100, 0)
			p1Side = p1Side + 1
		end
	end
	--P2 Cursor Position
	if commandGetState(p2Cmd, 'l') then
		if p2Side > -1 then
			sndPlay(sysSnd, 100, 0)
			p2Side = p2Side - 1
		end
	elseif commandGetState(p2Cmd, 'r') then
		if p2Side < 1 then
			sndPlay(sysSnd, 100, 0)
			p2Side = p2Side + 1
		end
	end
	--Draw Fade BG
	animDraw(fadeWindowBG)
	--Draw Screen Title
	textImgDraw(txt_sideTitle)
	--Draw Side Texts
	f_drawQuickText(txt_sideInfo, font6, 0, 0, "LEFT SIDE", 42, 38, 0.9, 0.9)
	f_drawQuickText(txt_sideInfo, font6, 0, 0, "RIGHT SIDE", 277, 38, 0.9, 0.9)
	--Draw P1 Assets
	if p1Side == 0 then --Draw in Middle
		f_drawQuickSpr(gamepadIcon, gamepadPosXcenter, p1gamepadPosY, gamepadScale, gamepadScale) --Gamepad
		f_drawQuickSpr(L_arrow, arrowLposXcenter, p1arrowPosY, arrowScale, arrowScale) --Left Arrow
		f_drawQuickSpr(R_arrow, arrowRposXcenter, p1arrowPosY, arrowScale, arrowScale) --Right Arrow
		f_drawQuickText(txt_sidePNo, txtFont, txtP1color, 0, txtP1name, txtPosXcenter, p1txtPosY, txtScale, txtScale) --Player ID
	elseif p1Side == -1 then --Draw in Left
		f_drawQuickSpr(gamepadIcon, gamepadPosXleft, p1gamepadPosY, gamepadScale, gamepadScale) --Gamepad
		--f_drawQuickSpr(R_arrow, arrowRposXleft, p1arrowPosY, arrowScale, arrowScale) --Right Arrow
		f_drawQuickText(txt_sidePNo, txtFont, txtP1color, 0, txtP1name, txtPosXleft, p1txtPosY, txtScale, txtScale) --Player ID
	elseif p1Side == 1 then --Draw in Right
		f_drawQuickSpr(gamepadIcon, gamepadPosXright, p1gamepadPosY, gamepadScale, gamepadScale) --Gamepad
		--f_drawQuickSpr(L_arrow, arrowLposXright, p1arrowPosY, arrowScale, arrowScale) --Left Arrow
		f_drawQuickText(txt_sidePNo, txtFont, txtP1color, 0, txtP1name, txtPosXright, p1txtPosY, txtScale, txtScale) --Player ID
	end
	--Draw P2 Assets
	if p2Side == 0 then
		f_drawQuickSpr(gamepadIcon, gamepadPosXcenter, p2gamepadPosY, gamepadScale, gamepadScale)
		f_drawQuickSpr(L_arrow, arrowLposXcenter, p2arrowPosY, arrowScale, arrowScale)
		f_drawQuickSpr(R_arrow, arrowRposXcenter, p2arrowPosY, arrowScale, arrowScale)
		f_drawQuickText(txt_sidePNo, txtFont, txtP2color, 0, txtP2name, txtPosXcenter, p2txtPosY, txtScale, txtScale)
	elseif p2Side == -1 then
		f_drawQuickSpr(gamepadIcon, gamepadPosXleft, p2gamepadPosY, gamepadScale, gamepadScale)
		--f_drawQuickSpr(R_arrow, arrowRposXleft, p2arrowPosY, arrowScale, arrowScale)
		f_drawQuickText(txt_sidePNo, txtFont, txtP2color, 0, txtP2name, txtPosXleft, p2txtPosY, txtScale, txtScale)
	elseif p2Side == 1 then
		f_drawQuickSpr(gamepadIcon, gamepadPosXright, p2gamepadPosY, gamepadScale, gamepadScale)
		--f_drawQuickSpr(L_arrow, arrowLposXright, p2arrowPosY, arrowScale, arrowScale)
		f_drawQuickText(txt_sidePNo, txtFont, txtP2color, 0, txtP2name, txtPosXright, p2txtPosY, txtScale, txtScale)
	end
	--Actions
	if esc() or commandGetState(p1Cmd, 'e') or commandGetState(p2Cmd, 'e') then
		sndPlay(sysSnd, 100, 2)
		f_sideReset()
	elseif btnPalNo(p1Cmd) > 0 or btnPalNo(p2Cmd) > 0 then
		--Reference: -1 (Left Side), 0 (No Side), 1 (Right Side)
		--CPU VS CPU
		if p1Side == 0 and p2Side == 0 then
			sndPlay(sysSnd, 100, 1)
			
		end
		--P1 & P2 VS CPU
		if p1Side == -1 and p2Side == -1 then
			sndPlay(sysSnd, 100, 1)
			
		end
		--CPU VS P1 & P2
		if p1Side == 1 and p2Side == 1 then
			sndPlay(sysSnd, 100, 5) --Not available yet
		end
		--P1 VS CPU
		if p1Side == -1 and p2Side == 0 then
			sndPlay(sysSnd, 100, 1)
			
		end
		--P2 VS CPU
		if p2Side == -1 and p1Side == 0 then
			sndPlay(sysSnd, 100, 1)
			
		end
		--CPU VS P1
		if p2Side == 0 and p1Side == 1 then
			sndPlay(sysSnd, 100, 1)
			
		end
		--CPU VS P2
		if p1Side == 0 and p2Side == 1 then
			sndPlay(sysSnd, 100, 1)
			
		end
		--P1 VS P2
		if p1Side == -1 and p2Side == 1 then
			sndPlay(sysSnd, 100, 1)
			
		end
		--P2 VS P1
		if p2Side == -1 and p1Side == 1 then
			sndPlay(sysSnd, 100, 1)
			
		end
		f_sideReset()
	end
	cmdInput()
end

function f_sideReset()
	sideScreen = false
	p1Side = 0 --P1 Cursor pos in Middle
	p2Side = 0 --P2 Cursor pos in Middle
end

--;===========================================================
--; LOGOS SCREEN
--;===========================================================
function f_mainLogos()
	data.fadeTitle = f_fadeAnim(32, 'fadein', 'black', fadeSff)
	f_storyboard('data/screenpack/logo.def')
	playBGM(bgmIntro)
	f_storyboard('data/screenpack/intro.def')
end

--;===========================================================
--; OK MESSAGE
--;===========================================================
txt_infoTitle = createTextImg(font5, 0, 0, 'INFORMATION', 157, 111)
txt_ok = createTextImg(jgFnt, 5, 0, 'OK', 159, 151)

--Info Window BG
infoWindowBG = animNew(sysSff, [[
230,1, 0,0,
]])
animSetPos(infoWindowBG, 83.5, 97)
animUpdate(infoWindowBG)
animSetScale(infoWindowBG, 1, 1)

function f_infoMenu()
	cmdInput()
	--Draw Fade BG
	animDraw(fadeWindowBG)
	--Draw Menu BG
	animDraw(infoWindowBG)
	animUpdate(infoWindowBG)
	--Draw Info Text
	if charsInfo == true then
		txt_info = createTextImg(jgFnt, 0, 0, '', 0, 0,0.56,0.56)
		f_textRender(txt_info, 'NO CHARACTERS FOUND IN SELECT.DEF', 0, 160, 125, 10, 0, 25)
	elseif stagesInfo == true then
		txt_info = createTextImg(jgFnt, 0, 0, '', 0, 0,0.6,0.6)
		f_textRender(txt_info, 'NO STAGES FOUND IN SELECT.DEF', 0, 160, 125, 10, 0, 25)
	elseif bossInfo == true then
		txt_info = createTextImg(jgFnt, 0, 0, '', 0, 0,0.6,0.6)
		f_textRender(txt_info, 'NO BOSSES FOUND IN SELECT.DEF', 0, 160, 125, 10, 0, 25)
	elseif bonusInfo == true then
		txt_info = createTextImg(jgFnt, 0, 0, '', 0, 0,0.6,0.6)
		f_textRender(txt_info, 'NO BONUSES FOUND IN SELECT.DEF', 0, 160, 125, 10, 0, 25)
	elseif resolutionInfo == true then
		txt_info = createTextImg(jgFnt, 0, 0, '', 0, 0,0.56,0.56)
		f_textRender(txt_info, 'SET A 16:9 RESOLUTION TO AVOID DESYNC', 0, 160, 125, 10, 0, 25)
	elseif firstRunInfo == true then
		txt_info = createTextImg(jgFnt, 0, 0, '', 0, 0,0.50,0.50)
		f_textRender(txt_info, 'WELCOME TO IKEMEN PLUS ULTRA ENGINE! PRESS F1 TO SEE MORE INFORMATION.', 0, 160, 125, 8.8, 0, 36)
	end
	--Draw Ok Text
	textImgDraw(txt_ok)
	--Draw Cursor
	animSetWindow(cursorBox, 87,141, 144,13)
	f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
	animDraw(f_animVelocity(cursorBox, -1, -1))
	--Draw Info Title Text
	textImgDraw(txt_infoTitle)
	--Actions
	if btnPalNo(p1Cmd) > 0 then
		sndPlay(sysSnd, 100, 2)
		if firstRunInfo and data.firstRun == true then
			data.firstRun = false
			f_saveProgress()
		end
		f_infoReset()
	end
	cmdInput()
end

function f_infoReset()
	infoScreen = false
	charsInfo = false
	stagesInfo = false
	bossInfo = false
	bonusInfo = false
	resolutionInfo = false
end

--;===========================================================
--; CONFIRM MESSAGE
--;===========================================================
txt_confirmQuestion = createTextImg(jgFnt, 1, 0, 'ARE YOU SURE?', 160, 110)

--Confirm Window BG
confirmWindowBG = animNew(sysSff, [[
230,1, 0,0,
]])
animSetPos(confirmWindowBG, 83.5, 97)
animUpdate(confirmWindowBG)
animSetScale(confirmWindowBG, 1, 1)

t_confirmMenu = {
	{id = textImgNew(), text = 'YES'},
	{id = textImgNew(), text = 'NO'},
}

function f_confirmMenu()
	cmdInput()
	--Cursor Position
	if commandGetState(p1Cmd, 'u') then
		sndPlay(sysSnd, 100, 0)
		confirmMenu = confirmMenu - 1
	elseif commandGetState(p1Cmd, 'd') then
		sndPlay(sysSnd, 100, 0)
		confirmMenu = confirmMenu + 1
	end
	if confirmMenu < 1 then
		confirmMenu = #t_confirmMenu
		if #t_confirmMenu > 4 then
			cursorPosYConfirm = 4
		else
			cursorPosYConfirm = #t_confirmMenu-1
		end
	elseif confirmMenu > #t_confirmMenu then
		confirmMenu = 1
		cursorPosYConfirm = 0
	elseif commandGetState(p1Cmd, 'u') and cursorPosYConfirm > 0 then
		cursorPosYConfirm = cursorPosYConfirm - 1
	elseif commandGetState(p1Cmd, 'd') and cursorPosYConfirm < 4 then
		cursorPosYConfirm = cursorPosYConfirm + 1
	end
	if cursorPosYConfirm == 4 then
		moveTxtConfirm = (confirmMenu - 5) * 13
	elseif cursorPosYConfirm == 0 then
		moveTxtConfirm = (confirmMenu - 1) * 13
	end
	--Draw Fade BG
	animDraw(fadeWindowBG)
	--Draw Menu BG
	animDraw(confirmWindowBG)
	animUpdate(confirmWindowBG)
	--Draw Title
	textImgDraw(txt_confirmQuestion)
	--Draw Table Text
	for i=1, #t_confirmMenu do
		if i == confirmMenu then
			bank = 5
		else
			bank = 0
		end
		textImgDraw(f_updateTextImg(t_confirmMenu[i].id, jgFnt, bank, 0, t_confirmMenu[i].text, 159, 120+i*13-moveTxtConfirm))
	end
	--Draw Cursor
	animSetWindow(cursorBox, 87,123+cursorPosYConfirm*13, 144,13)
	f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
	animDraw(f_animVelocity(cursorBox, -1, -1))
	--Actions
	if esc() or commandGetState(p1Cmd, 'e') then
		sndPlay(sysSnd, 100, 2)
		f_confirmReset()
	elseif btnPalNo(p1Cmd) > 0 then
		--YES
		if confirmMenu == 1 then
			sndPlay(sysSnd, 100, 1)
			--DELETE HOST DATA
			if crudHostOption == 1 then
				f_crudHostReset()
				host_rooms.IP[hostRoomName] = nil
				t_tmp = {}
				for i = 1, #t_hostList do
					if i ~= hostList then
					t_tmp[#t_tmp + 1] = t_hostList[i]
					end
				end
				t_hostList = t_tmp
				local file = io.open("save/host_rooms.json","w+")
				file:write(json.encode(host_rooms, {indent = true}))
				file:close()
				f_hostTable() --Refresh
			--DELETE REPLAY
			else
				deleteReplay = true
			end
		--NO
		else
			crudHostOption = 0
			sndPlay(sysSnd, 100, 2)
		end
		f_confirmReset()
	end
	cmdInput()
end

function f_confirmReset()
	confirmScreen = false
	moveTxtConfirm = 0
	--Cursor pos in NO
	cursorPosYConfirm = 1
	confirmMenu = 2
end

--;===========================================================
--; MENU START
--;===========================================================
function f_mainStart()
	setDiscordState("In Logos")
	gameTime = (os.clock()/1000)
	data.tempBack = false
	data.replayDone = false
	f_saveTemp() --Save Temp Default Values to Prevent Issues
	f_unlocksCheck() --Check For Unlocked Content
	f_mainLogos()
	data.fadeTitle = f_fadeAnim(30, 'fadein', 'black', fadeSff) --global variable so we can set it also from within select.lua
	f_infoReset() --Allow select options below if the Engine detects characters or stages
	if #t_selChars == 0 then --If the Engine not detect Characters
		charsInfo = true
		infoScreen = true
		f_exitMenu()
	elseif #t_selStages == 0 then --If the Engine not detect Stages
		stagesInfo = true
		infoScreen = true
		f_exitMenu()
	elseif #t_selChars or #t_selStages ~= 0 then
		if data.attractMode == true then
			coinSystem = false
			--data.attractCoins = 0 --Enable for Restart Credits for Attract Mode
			--f_saveProgress() --Enable for Restart Credits for Attract Mode
			setDiscordState("In Attract Mode")
			f_mainAttract()
		else
			data.continueCount = 0 --Disable to avoid Restart Times Continue in Arcade
			f_saveProgress() --Disable to avoid Restart Times Continue in Arcade
			setDiscordState("In Main Menu")
			f_mainTitle()
		end
	end
end

function f_titleText()
	if data.vault == 'Ultra' then txt_subTitle = createTextImg(font3, 0, 0, 'PLUS ULTRA', 159, 120) --Cool fonts: 3, 5, 6, 9, 10, 11, 12, 20, 21
	elseif data.vault == 'Zen' then txt_subTitle = createTextImg(font3, 0, 0, 'PLUS ZEN', 159, 120)
	elseif data.vault == 'SSZ' then txt_subTitle = createTextImg(font3, 0, 0, 'SSZ', 159, 120) end
	textImgDraw(txt_subTitle)
end

--;===========================================================
--; ATTRACT MODE MENU
--;===========================================================
txt_coinTitle = createTextImg(jgFnt, 0, 0, '-- INSERT COIN --', 159, 190)
function f_attractCredits()
	txt_credits = createTextImg(font1, 0, -1, 'Credits: '..data.attractCoins..'', 181.5, 235)
	textImgDraw(txt_credits)
end

function f_mainAttract()
	cmdInput()
	local t = 0
	attractSeconds = data.attractTime
	attractTimer = attractSeconds*gameTick --Set time for Attract Title Screen
	local demoTimer = 0
	playBGM(bgmTitle)
	f_attractExitItem()
	while true do
		--INSERT COIN
		if commandGetState(p1Cmd, 'a') or commandGetState(p1Cmd, 'b') or commandGetState(p1Cmd, 'c') or commandGetState(p1Cmd, 'x') or commandGetState(p1Cmd, 'y') or commandGetState(p1Cmd, 'z') then
		   sndPlay(sysSnd, 200, 0)
		   demoTimer = 0
		   data.attractCoins = data.attractCoins + 1
		   f_saveProgress()
		   attractTimer = attractSeconds*gameTick --Reset Timer
		--START GAME MODE
		elseif (commandGetState(p1Cmd, 'w') or attractTimer == 0) and data.attractCoins > 0 then
		   --playVideo(videoHowToPlay)
		   data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
		   sndPlay(sysSnd, 100, 1)
		   data.attractCoins = data.attractCoins - 1
		   f_saveProgress()
		   attractTimer = attractSeconds*gameTick
		   f_default()
		   --data.p1TeamMenu = {mode = 0, chars = 1}
		   --data.p2TeamMenu = {mode = 0, chars = 1}
		   data.p2In = 1
		   data.p2SelectMenu = false
		   data.serviceScreen = true
		   --data.stageMenu = true
		   setGameMode('arcade')
		   data.gameMode = 'arcade'
		   data.rosterMode = 'arcade'
		   textImgSetText(txt_mainSelect, 'ARCADE')
		   setDiscordState("In Arcade Mode")
		   script.select.f_selectAdvance()
		   setDiscordState("In Attract Mode")
		--START DEMO MODE
		elseif demoTimer == 350 then
		   cmdInput()
		   setGameType(1)
		   setGameMode('demo')
		   data.fadeTitle = f_fadeAnim(32, 'fadein', 'black', fadeSff)
		   script.select.randomMode()
		   f_mainLogos()
		   playBGM(bgmTitle)
		   demoTimer = 0
		   attractTimer = attractSeconds*gameTick
		--EXIT
		elseif esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			attractTimer = attractSeconds*gameTick
			f_exitMenu()
			--attractSeconds = data.attractTime --Load New Attract Time settings in case that you modify them
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		animSetWindow(cursorBox, 0, 180, 290, 13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		f_titleText()
		f_attractCredits()
		--txt_attractTimer = createTextImg(font1, 0, 0, ''..attractTimer/gameTick..'', 302, 235) --Original Decimal Timer
		attractTimeNumber = attractTimer/gameTick --Convert Ticks to Seconds
		nodecimalAttractTime = string.format("%.0f",attractTimeNumber) --Delete Decimals
		txt_attractTimer = createTextImg(font1, 0, 0, nodecimalAttractTime, 302, 235)
		if attractTimer > 0 and data.attractCoins > 0 then
			attractTimer = attractTimer - 0.5 --Activate Title Screen Timer
			textImgDraw(txt_attractTimer)
		else --when attractTimer <= 0
			demoTimer = demoTimer + 1
		end
		f_sysTime()
		if t%60 < 30 then
			if data.attractCoins > 0 then
				textImgDraw(txt_mainTitle)
			else
				textImgDraw(txt_coinTitle)
			end
		end
		t = t >= 60 and 0 or t + 1
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; EXIT MENU
--;===========================================================
t_exitMenu = {
	{id = textImgNew(), text = 'CLOSE ENGINE'},
	{id = textImgNew(), text = 'RESTART ENGINE'},
	{id = textImgNew(), text = 'BACK TO MAIN MENU'},
}
function f_attractExitItem()
	if data.attractMode == true and infoScreen == false then
		table.insert(t_exitMenu,1,{id = textImgNew(), text = 'OPTIONS'})
	end
end

function f_exitMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local exitMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	f_exitReset()
	while true do
		if exitScreen == false and infoScreen == false then
			if commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
				sndPlay(sysSnd, 100, 0)
				exitMenu = exitMenu - 1
			elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
				sndPlay(sysSnd, 100, 0)
				exitMenu = exitMenu + 1
			end
			if exitMenu < 1 then
				exitMenu = #t_exitMenu
				if #t_exitMenu > 4 then
					cursorPosY = 4
				else
					cursorPosY = #t_exitMenu-1
				end
			elseif exitMenu > #t_exitMenu then
				exitMenu = 1
				cursorPosY = 0
			elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
				cursorPosY = cursorPosY - 1
			elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 4 then
				cursorPosY = cursorPosY + 1
			end
			if cursorPosY == 4 then
				moveTxt = (exitMenu - 5) * 13
			elseif cursorPosY == 0 then
				moveTxt = (exitMenu - 1) * 13
			end
			if btnPalNo(p1Cmd) > 0 then
				restartEngine = false
				--EXIT FOR ATTRACT MODE (NO CONTENT)
				if exitMenu == 1 and data.attractMode == true and #t_selChars == 0 then
					sndPlay(sysSnd, 100, 1)
					exitScreen = true
				elseif exitMenu == 1 and data.attractMode == true and #t_selStages == 0 then
					sndPlay(sysSnd, 100, 1)
					exitScreen = true
				--RESTART FOR ATTRACT MODE (NO CONTENT)
				elseif exitMenu == 2 and data.attractMode == true and #t_selChars == 0 then
					sndPlay(sysSnd, 100, 1)
					restartEngine = true
					exitScreen = true
				elseif exitMenu == 2 and data.attractMode == true and #t_selStages == 0 then
					sndPlay(sysSnd, 100, 1)
					restartEngine = true
					exitScreen = true
				--OPTIONS FOR ATTRACT MODE
				elseif exitMenu == 1 and data.attractMode == true and #t_selChars ~= 0 and #t_selStages ~= 0 then
					sndPlay(sysSnd, 100, 1)
					onlinegame = false
					assert(loadfile('save/data_sav.lua'))()
					setDiscordState("In Options")
					script.options.f_mainCfg()
					setDiscordState("In Attract Mode")
				--EXIT FOR ATTRACT MODE
				elseif exitMenu == 2 and data.attractMode == true and #t_selChars ~= 0 and #t_selStages ~= 0 then
					sndPlay(sysSnd, 100, 1)
					exitScreen = true
				--RESTART FOR ATTRACT MODE
				elseif exitMenu == 3 and data.attractMode == true then
					sndPlay(sysSnd, 100, 1)
					restartEngine = true
					exitScreen = true
				--NORMAL EXIT
				elseif exitMenu == 1 and data.attractMode == false then
					sndPlay(sysSnd, 100, 1)
					exitScreen = true
				--NORMAL RESTART
				elseif exitMenu == 2 and data.attractMode == false then
					sndPlay(sysSnd, 100, 1)
					restartEngine = true
					exitScreen = true
				--BACK
				else
					sndPlay(sysSnd, 100, 2)
					break
				end
			end
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_exitMenu do
			if i == exitMenu then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_exitMenu[i].id, jgFnt, bank, 0, t_exitMenu[i].text, 159, 165+i*13-moveTxt))
		end
		if infoScreen == true then
			table.remove(t_exitMenu,3) --Remove Option 3 in table if characters or stages are not detected
		end
		if exitScreen == false and infoScreen == false then
			animSetWindow(cursorBox, 0,168+cursorPosY*13, 316,13)
			f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
			animDraw(f_animVelocity(cursorBox, -1, -1))
		end
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_titleFt)
		if exitScreen == false and infoScreen == false then	textImgSetText(txt_titleFt, 'CLOSE OR RESTART ENGINE') end
		f_sysTime()
		if exitScreen == true then f_closeMenu() end --Show Exit Screen Message
		if infoScreen == true then f_infoMenu() end --Show Info Screen Message
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; CLOSE/RESTART MESSAGE
--;===========================================================
txt_question = createTextImg(jgFnt, 1, 0, 'ARE YOU SURE?', 160, 110)

--Exit Window BG
exitWindowBG = animNew(sysSff, [[
230,1, 0,0,
]])
animSetPos(exitWindowBG, 83.5, 97)
animUpdate(exitWindowBG)
animSetScale(exitWindowBG, 1, 1)

t_closeMenu = {
	{id = textImgNew(), text = 'YES'},
	{id = textImgNew(), text = 'NO'},
}

function f_closeMenu()
	cmdInput()
	--Cursor Position
	if commandGetState(p1Cmd, 'u') then
		sndPlay(sysSnd, 100, 0)
		closeMenu = closeMenu - 1
	elseif commandGetState(p1Cmd, 'd') then
		sndPlay(sysSnd, 100, 0)
		closeMenu = closeMenu + 1
	end
	if closeMenu < 1 then
		closeMenu = #t_closeMenu
		if #t_closeMenu > 4 then
			cursorPosYExit = 4
		else
			cursorPosYExit = #t_closeMenu-1
		end
	elseif closeMenu > #t_closeMenu then
		closeMenu = 1
		cursorPosYExit = 0
	elseif commandGetState(p1Cmd, 'u') and cursorPosYExit > 0 then
		cursorPosYExit = cursorPosYExit - 1
	elseif commandGetState(p1Cmd, 'd') and cursorPosYExit < 4 then
		cursorPosYExit = cursorPosYExit + 1
	end
	if cursorPosYExit == 4 then
		moveTxtExit = (closeMenu - 5) * 13
	elseif cursorPosYExit == 0 then
		moveTxtExit = (closeMenu - 1) * 13
	end
	--Draw Fade BG
	animDraw(fadeWindowBG)
	--Draw Menu BG
	animDraw(exitWindowBG)
	animUpdate(exitWindowBG)
	--Draw Title
	textImgDraw(txt_question)
	--Draw Table Text
	for i=1, #t_closeMenu do
		if i == closeMenu then
			bank = 5
		else
			bank = 0
		end
		textImgDraw(f_updateTextImg(t_closeMenu[i].id, jgFnt, bank, 0, t_closeMenu[i].text, 159, 120+i*13-moveTxtExit))
	end
	--Draw Cursor
	animSetWindow(cursorBox, 87,123+cursorPosYExit*13, 144,13)
	f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
	animDraw(f_animVelocity(cursorBox, -1, -1))
	--Draw Bottom Text
	textImgDraw(txt_titleFt)
	if restartEngine == true then
		textImgSetText(txt_titleFt, 'THE ENGINE WILL BE RESTARTED')
	else
		textImgSetText(txt_titleFt, 'THE ENGINE WILL BE CLOSED')
	end
	--Actions
	if esc() or commandGetState(p1Cmd, 'e') then
		sndPlay(sysSnd, 100, 2)
		f_exitReset()
	elseif btnPalNo(p1Cmd) > 0 then
		--YES
		if closeMenu == 1 then
		    f_playTime()
			if restartEngine == true then
				sszReload()
			end
			os.exit()
		--NO
		else
			sndPlay(sysSnd, 100, 2)
		end
		f_exitReset()
	end
	cmdInput()
end

function f_exitReset()
	exitScreen = false
	moveTxtExit = 0
	--Cursor pos in YES
	cursorPosYExit = 0
	closeMenu = 1
end

--;===========================================================
--; TITLE SCREEN MENU
--;===========================================================
txt_mainTitle = createTextImg(jgFnt, 5, 0, '-- PRESS START --', 159, 190)
--txt_version = createTextImg(font1, 0, -1, 'v1.?.0', 319, 240)
txt_version = createTextImg(font1, 0, -1, 'Dev. Build', 319, 240)
txt_titleFt = createTextImg(font5, 0, 0, '', 156, 240)

function f_mainTitle()
	cmdInput()
	local i = 0
	local t = 0
	playBGM(bgmTitle)
	--fadeInBGM(20)	
	while true do
		if i == 500 then
			i = 0
			f_mainLogos()
			playBGM(bgmTitle)
			--[[
			setGameType(1)
			setGameMode('demo')
			data.fadeTitle = f_fadeAnim(32, 'fadein', 'black', fadeSff)
			script.select.randomMode()
			]]
		elseif btnPalNo(p1Cmd) > 0 then
			sndPlay(sysSnd, 100, 1) --Play SFX from .snd file
			i = 0
			f_mainMenu()
		elseif esc() or commandGetState(p1Cmd, 'e') then
			i = 0
			sndPlay(sysSnd, 100, 2)
			f_exitMenu()
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		animSetWindow(cursorBox, 0, 180, 290, 13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_titleFt)
		textImgSetText(txt_titleFt, 'WELCOME TO SUEHIRO IKEMEN ENGINE')
		f_sysTime()
		if t%60 < 30 then
			textImgDraw(txt_mainTitle)
		end
		t = t >= 60 and 0 or t + 1
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		i = i + 1
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; MAIN MENU
--;===========================================================
txt_gameFt = createTextImg(font5, 0, 1, '', 2, 240) --Text to identify the game mode in menus
txt_mainSelect = createTextImg(jgFnt, 0, 0, '', 159, 13) --Text that appears in character select with the name of the game mode

t_mainMenu = {
	{id = textImgNew(), text = 'STORY'},
	{id = textImgNew(), text = 'ARCADE'},
	{id = textImgNew(), text = 'VERSUS'},
	{id = textImgNew(), text = 'NETPLAY'},
	{id = textImgNew(), text = 'PRACTICE'},
	{id = textImgNew(), text = 'CHALLENGES'},
	{id = textImgNew(), text = 'EXTRAS'},
	{id = textImgNew(), text = 'WATCH'},
	{id = textImgNew(), text = 'OPTIONS'},
	{id = textImgNew(), text = 'EXIT'},
	{id = textImgNew(), text = 'CHECK UPDATES'},
}

function f_mainMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local mainMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	closeText = 1
	f_menuMusic()
	f_infoReset()
	f_infoboxReset()
	while true do
		if infoScreen == false and infoboxScreen == false then
			--First Run Msg
			if data.firstRun == true then
				firstRunInfo = true
				infoScreen = true
			end
			if f1Key() then infoboxScreen = true end --Show Classic Mugen Info Screen
			if esc() or commandGetState(p1Cmd, 'e') then
				sndPlay(sysSnd, 100, 2)
				playBGM(bgmTitle)
				return
			elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
				sndPlay(sysSnd, 100, 0)
				mainMenu = mainMenu - 1
			elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
				sndPlay(sysSnd, 100, 0)
				mainMenu = mainMenu + 1
			end
			--mode titles/cursor position calculation
			if mainMenu < 1 then
				mainMenu = #t_mainMenu
				if #t_mainMenu > 5 then
					cursorPosY = 5
				else
					cursorPosY = #t_mainMenu-1
				end
			elseif mainMenu > #t_mainMenu then
				mainMenu = 1
				cursorPosY = 0
			elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
				cursorPosY = cursorPosY - 1
			elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
				cursorPosY = cursorPosY + 1
			end
			if cursorPosY == 5 then
				moveTxt = (mainMenu - 6) * 13
			elseif cursorPosY == 0 then
				moveTxt = (mainMenu - 1) * 13
			end
			if #t_mainMenu <= 5 then
				maxMainMenu = #t_mainMenu
			elseif mainMenu - cursorPosY > 0 then
				maxMainMenu = mainMenu + 5 - cursorPosY
			else
				maxMainMenu = 5
			end
			--COMMON ACTIONS
			if btnPalNo(p1Cmd) > 0 then
				f_default() --Load f_default function defined in common.lua
				sndPlay(sysSnd, 100, 1)
				--STORY (follow customizable story arcs designed for this engine)
				if mainMenu == 1 then
					setDiscordState("In Story Mode") --update discord rich presence user state with the text introduced
					--script.story.f_storyMenu()
					setDiscordState("In Main Menu")
				--ARCADE (play a customizable arcade ladder)
				elseif mainMenu == 2 then
					f_arcadeMenu()
				--VERSUS (face specific opponents)
				elseif mainMenu == 3 then
					f_vsMenu()
				--NETPLAY (play online)
				elseif mainMenu == 4 then
					--if (resolutionHeight / 3 * 4) ~= resolutionWidth then --To play online you need to set a 4:3 Resolution to avoid desync
					--if (resolutionHeight / 10 * 16) ~= resolutionWidth then --To play online you need to set a 16:10 Resolution to avoid desync
					if (math.floor((resolutionHeight / 9 * 16) + 0.5)) ~= resolutionWidth then --To play online you need to set a 16:9 Resolution to avoid desync
						resolutionInfo = true
						infoScreen = true
					else
						f_mainNetplay()
					end
				--PRACTICE (improve your skills)
				elseif mainMenu == 5 then
					f_practiceMenu()		
				--CHALLENGES (play advanced game modes)
				elseif mainMenu == 6 then
					f_challengeMenu()
				--EXTRAS (play custom game modes)
				elseif mainMenu == 7 then
					assert(loadfile('save/stats_sav.lua'))()
					if data.arcadeClear == true then
						f_extrasMenu()
					else
						f_secret()
					end
				--WATCH (watch replays, rankings, player data, cutscenes and more)
				elseif mainMenu == 8 then
					f_watchMenu()
				--OPTIONS (adjust game settings)
				elseif mainMenu == 9 then
					onlinegame = false --only for identify purposes
					assert(loadfile('save/data_sav.lua'))()
					setDiscordState("In Options")
					script.options.f_mainCfg() --start f_mainCfg() function from script/options.lua
					setDiscordState("In Main Menu")
				--EXIT
				elseif mainMenu == 10 then
					f_exitMenu()
				--CHECK ENGINE UPDATES
				else
					webOpen("https://github.com/CableDorado2/Ikemen-Plus-Ultra") --added via script.ssz
				end
			end
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_mainMenu do
			if i == mainMenu then
				bank = 5 --Text Color (0=Nothing, 1=Red, 2=Green, 3=Blue, 4=Nothing, 5=Yellow, 6=Pink, 7=Shadow, 8=Black, 9=¿?)
			else
				bank = 0
			end
			if not infoboxScreen then
				textImgDraw(f_updateTextImg(t_mainMenu[i].id, jgFnt, bank, 0, t_mainMenu[i].text, 159, 142+i*13-moveTxt)) --Text Position
			end
		end
		if infoScreen == false and infoboxScreen == false then
			animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13) --Position and Size of the selection cursor
			f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
			animDraw(f_animVelocity(cursorBox, -1, -1)) --Blink rate
		end
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		f_sysTime()
		if not infoboxScreen then
			textImgDraw(txt_gameFt)
			textImgSetText(txt_gameFt, 'MAIN MENU')
			textImgDraw(txt_version)
			if maxMainMenu > 6 then
				animDraw(arrowsU)
				animUpdate(arrowsU)
			end
			if #t_mainMenu > 6 and maxMainMenu < #t_mainMenu then
				animDraw(arrowsD)
				animUpdate(arrowsD)
			end
		end
		if infoScreen == true then f_infoMenu() end
		if infoboxScreen == true then f_infoboxMenu() end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; ARCADE MENU
--;===========================================================
t_arcadeMenu = {
	{id = textImgNew(), text = 'P1 VS CPU'},
	{id = textImgNew(), text = 'CPU VS P1'},
	{id = textImgNew(), text = 'P1&P2 VS CPU'},
	{id = textImgNew(), text = 'CPU VS CPU'},
}
	
function f_arcadeMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local arcadeMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			arcadeMenu = arcadeMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			arcadeMenu = arcadeMenu + 1
		end
		if arcadeMenu < 1 then
			arcadeMenu = #t_arcadeMenu
			if #t_arcadeMenu > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_arcadeMenu-1
			end
		elseif arcadeMenu > #t_arcadeMenu then
			arcadeMenu = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (arcadeMenu - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (arcadeMenu - 1) * 13
		end
		if #t_arcadeMenu <= 5 then
			maxArcadeMenu = #t_arcadeMenu
		elseif arcadeMenu - cursorPosY > 0 then
			maxArcadeMenu = arcadeMenu + 5 - cursorPosY
		else
			maxArcadeMenu = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			setDiscordState("In Arcade Mode")
			setGameMode('arcade')
			data.gameMode = 'arcade' --mode recognized in select screen as 'arcade'
			data.rosterMode = 'arcade' --to record statistics
			data.serviceScreen = true --Enable Service Screen if you lose and continue
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 1)
			--SINGLE MODE [LEFT SIDE] (fight against CPU controlled opponents in a customizable arcade ladder)
			if arcadeMenu == 1 then
				data.p2In = 1 --P1 controls P2 side of the select screen
				data.p2SelectMenu = false --P2 character selection disabled
				textImgSetText(txt_mainSelect, 'ARCADE') --message displayed on top of select screen
				script.select.f_selectAdvance() --start f_selectAdvance() function from script/select.lua
				setDiscordState("In Main Menu")
			--SINGLE MODE [RIGHT SIDE] (fight against CPU controlled opponents in a customizable arcade ladder)
			elseif arcadeMenu == 2 then
				remapInput(1, 2) --P1 controls p2 side
				remapInput(2, 1) --P2 controls p1 side
				setCom(2, 0) --Not computer is controlling P2 side, only the human
				setPlayerSide('p1right')
				data.p1In = 2
				data.p2In = 2
				data.p1SelectMenu = false --P1 character selection disabled
				textImgSetText(txt_mainSelect, 'ARCADE')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			--CO-OP MODE (team up with another player against CPU controlled opponents in a customizable arcade ladder)
			elseif arcadeMenu == 3 then
				data.p2In = 2
				data.p2Faces = true
				data.coop = true --P2 fighting on P1 side enabled
				setGameMode('arcadecoop') --to avoid challenger screen
				textImgSetText(txt_mainSelect, 'ARCADE COOPERATIVE')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			--CPU MODE (watch CPU fight in a customizable arcade ladder)
			elseif arcadeMenu == 4 then
				data.p2In = 1
				data.p2SelectMenu = false
				data.aiFight = true --AI = data.difficulty for all characters enabled
				setGameMode('arcadecpu') --to avoid challenger screen
				data.rosterMode = 'cpu' --to avoid record stats
				textImgSetText(txt_mainSelect, 'WATCH ARCADE')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			end
		end	
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_arcadeMenu do
			if i == arcadeMenu then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_arcadeMenu[i].id, jgFnt, bank, 0, t_arcadeMenu[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)		
		textImgSetText(txt_gameFt, 'ARCADE MODE')
		textImgDraw(txt_version)
		f_sysTime()
		if maxArcadeMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_arcadeMenu > 6 and maxArcadeMenu < #t_arcadeMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; VERSUS MENU
--;===========================================================
t_vsMenu = {
	{id = textImgNew(), text = 'QUICK MATCH'},
	{id = textImgNew(), text = 'FREE BATTLE'},
}
	
function f_vsMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local vsMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	f_sideReset()
	while true do
		if not sideScreen then
			if esc() or commandGetState(p1Cmd, 'e') then
				sndPlay(sysSnd, 100, 2)
				break
			elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
				sndPlay(sysSnd, 100, 0)
				vsMenu = vsMenu - 1
			elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
				sndPlay(sysSnd, 100, 0)
				vsMenu = vsMenu + 1
			end
			if vsMenu < 1 then
				vsMenu = #t_vsMenu
				if #t_vsMenu > 5 then
					cursorPosY = 5
				else
					cursorPosY = #t_vsMenu-1
				end
			elseif vsMenu > #t_vsMenu then
				vsMenu = 1
				cursorPosY = 0
			elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
				cursorPosY = cursorPosY - 1
			elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
				cursorPosY = cursorPosY + 1
			end
			if cursorPosY == 5 then
				moveTxt = (vsMenu - 6) * 13
			elseif cursorPosY == 0 then
				moveTxt = (vsMenu - 1) * 13
			end
			if #t_vsMenu <= 5 then
				maxVSMenu = #t_vsMenu
			elseif vsMenu - cursorPosY > 0 then
				maxVSMenu = vsMenu + 5 - cursorPosY
			else
				maxVSMenu = 5
			end
			if btnPalNo(p1Cmd) > 0 then
				f_default()
				sndPlay(sysSnd, 100, 1)
				--QUICK VERSUS (play a random fight)
				if vsMenu == 1 then
					--if data.sideSelect == true then
						sideScreen = true
					--else
						--f_randomMenu()
					--end
				--FREE BATTLE (play fights with your own rules)
				elseif vsMenu == 2 then
					f_freeMenu()
				end
			end
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_vsMenu do
			if i == vsMenu then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_vsMenu[i].id, jgFnt, bank, 0, t_vsMenu[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'VERSUS MODE')
		textImgDraw(txt_version)
		f_sysTime()
		if maxVSMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_vsMenu > 6 and maxVSMenu < #t_vsMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if sideScreen then f_sideSelect() end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; QUICK/RANDOM MATCH MENU
--;===========================================================
t_randomMenu = {
	{id = textImgNew(), text = 'P1 VS CPU'},
	{id = textImgNew(), text = 'CPU VS P1'},
	{id = textImgNew(), text = 'P1 VS P2'},
	{id = textImgNew(), text = 'P2 VS P1'},
	{id = textImgNew(), text = 'P1&P2 VS CPU'},
	{id = textImgNew(), text = 'CPU VS CPU'},
}

function f_randomMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local randomMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			randomMenu = randomMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			randomMenu = randomMenu + 1
		end
		if randomMenu < 1 then
			randomMenu = #t_randomMenu
			if #t_randomMenu > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_randomMenu-1
			end
		elseif randomMenu > #t_randomMenu then
			randomMenu = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (randomMenu - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (randomMenu - 1) * 13
		end
		if #t_randomMenu <= 5 then
			maxRandomMenu = #t_randomMenu
		elseif randomMenu - cursorPosY > 0 then
			maxRandomMenu = randomMenu + 5 - cursorPosY
		else
			maxRandomMenu = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			setDiscordState("In Quick Match")
			setGameMode('random')
			data.gameMode = 'quick match'
			data.rosterMode = 'versus'
			data.p1TeamMenu = {mode = 0, chars = 1}
			data.p2TeamMenu = {mode = 0, chars = 1}
			data.p1Char = {t_randomChars[math.random(#t_randomChars)]} --Pick Random Char
			data.p2Char = {t_randomChars[math.random(#t_randomChars)]} --Pick Random Char
			data.fadeTitle = f_fadeAnim(30, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 1)
			--P1 VS CPU (defeat from left side a random CPU controlled opponent)
			if randomMenu == 1 then
				script.select.f_selectSimple()
				setDiscordState("In Main Menu")
			--CPU VS P1 (defeat from right side a random CPU controlled opponent of your choice)
			elseif randomMenu == 2 then
				remapInput(1, 2)
				remapInput(2, 1)
				setCom(2, 0)
				setPlayerSide('p1right')
				data.p1In = 2
				data.p2In = 2
				script.select.f_selectSimple()
				setDiscordState("In Main Menu")
			--P1 VS P2 (fight from left side to defeat a random human opponent)
			elseif randomMenu == 3 then
				setHomeTeam(1)
				data.p2In = 2
				script.select.f_selectSimple()
				setDiscordState("In Main Menu")
			--P2 VS P1 (fight from right side to defeat a random human opponent)
			elseif randomMenu == 4 then
				setHomeTeam(2)
				remapInput(1, 2)
				remapInput(2, 1)
				setCom(2, 0)
				setPlayerSide('p1right')
				data.p2In = 2
				script.select.f_selectSimple()
				resetRemapInput() --P1 get control of menus again
				setDiscordState("In Main Menu")
			--P1 & P2 VS CPU (team up with another player to defeat random CPU controlled opponents)
			elseif randomMenu == 5 then
				--script.select.f_selectSimple()
				f_comingSoon()
				setDiscordState("In Main Menu")
			--CPU MATCH (watch random CPU controlled match)
			elseif randomMenu == 6 then
				data.aiFight = true
				data.rosterMode = 'cpu'
				script.select.f_selectSimple()
				setDiscordState("In Main Menu")
			end
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_randomMenu do
			if i == randomMenu then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_randomMenu[i].id, jgFnt, bank, 0, t_randomMenu[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'RANDOM MODE')
		textImgDraw(txt_version)
		f_sysTime()
		if maxRandomMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_randomMenu > 6 and maxRandomMenu < #t_randomMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; FREE BATTLE MENU
--;===========================================================
t_freeMenu = {
	{id = textImgNew(), text = 'P1 VS CPU'},
	{id = textImgNew(), text = 'CPU VS P1'},
	{id = textImgNew(), text = 'P1 VS P2'},
	{id = textImgNew(), text = 'P2 VS P1'},
	{id = textImgNew(), text = 'P1&P3 VS P2&P4'},
	{id = textImgNew(), text = 'P1&P2 VS CPU'},
	{id = textImgNew(), text = 'CPU VS CPU'},
}
	
function f_freeMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local freeMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			freeMenu = freeMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			freeMenu = freeMenu + 1
		end
		if freeMenu < 1 then
			freeMenu = #t_freeMenu
			if #t_freeMenu > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_freeMenu-1
			end
		elseif freeMenu > #t_freeMenu then
			freeMenu = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (freeMenu - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (freeMenu - 1) * 13
		end
		if #t_freeMenu <= 5 then
			maxfreeMenu = #t_freeMenu
		elseif freeMenu - cursorPosY > 0 then
			maxfreeMenu = freeMenu + 5 - cursorPosY
		else
			maxfreeMenu = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			setDiscordState("In Free Battle")
			setGameMode('vs')
			data.gameMode = 'versus'
			data.rosterMode = 'versus'
			data.stageMenu = true --stage selection enabled
			data.p2Faces = true --additional window with P2 select screen small portraits (faces) enabled
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 1)
			--P1 VS CPU (choose a fighter to defeat from left side a CPU controlled opponent of your choice)
			if freeMenu == 1 then
				data.p2In = 1
				textImgSetText(txt_mainSelect, 'FREE VERSUS')
				script.select.f_selectSimple() --start f_selectSimple() function from script/select.lua
				setDiscordState("In Main Menu")
			--CPU VS P1 (choose a fighter to defeat from right side a CPU controlled opponent of your choice)
			elseif freeMenu == 2 then
				remapInput(1, 2) --P1 controls p2 side
				remapInput(2, 1) --P2 controls p1 side
				setCom(2, 0) --Not computer is controlling P2 side, only the human
				setPlayerSide('p1right') --set Pause Controls if P1 is in Right Side
				data.p1In = 2
				data.p2In = 2
				textImgSetText(txt_mainSelect, 'FREE VERSUS')
				script.select.f_selectSimple()
				setDiscordState("In Main Menu")
			--P1 VS P2 (choose a fighter from left side to defeat a human opponent)
			elseif freeMenu == 3 then
				setHomeTeam(1) --P1 side considered the home team
				data.p2In = 2 --P2 controls P2 side of the select screen
				textImgSetText(txt_mainSelect, 'VERSUS MODE')
				script.select.f_selectSimple()
				setDiscordState("In Main Menu")
			--P2 VS P1 (choose a fighter from right side to defeat a human opponent)
			elseif freeMenu == 4 then
				setHomeTeam(2)
				remapInput(1, 2)
				remapInput(2, 1)
				setCom(2, 0)
				setPlayerSide('p1right')
				data.p2In = 2
				textImgSetText(txt_mainSelect, 'VERSUS MODE')
				script.select.f_selectSimple()
				resetRemapInput()
				setDiscordState("In Main Menu")
			--P1 & P3 VS P2 & P4 (team up with another player to defeat co-op team of human opponents)
			elseif freeMenu == 5 then
				f_comingSoon()
				--setHomeTeam(1)
				--data.p2In = 2
				--data.coop = true
				--textImgSetText(txt_mainSelect, 'FREE VERSUS TEAM COOPERATIVE')
				--script.select.f_selectSimple()
				setDiscordState("In Main Menu")
			--P1 & P2 VS CPU (team up with another player to defeat CPU controlled opponents of your choice)
			elseif freeMenu == 6 then
				--f_comingSoon()
				setHomeTeam(1)
				data.p2In = 2
				data.stageMenu = false
				data.stage = {t_stageDef['stages/training room.def']}
				data.coop = true
				textImgSetText(txt_mainSelect, 'FREE VERSUS COOPERATIVE')
				script.select.f_selectSimple()
				setDiscordState("In Main Menu")
			--CPU MATCH (watch CPU controlled match of your choice)
			elseif freeMenu == 7 then
				data.p2In = 1
				data.aiFight = true
				data.rosterMode = 'cpu'
				textImgSetText(txt_mainSelect, 'WATCH VERSUS')
				script.select.f_selectSimple()
				setDiscordState("In Main Menu")
			end
		end	
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_freeMenu do
			if i == freeMenu then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_freeMenu[i].id, jgFnt, bank, 0, t_freeMenu[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'FREE MATCH')
		textImgDraw(txt_version)
		f_sysTime()
		if maxfreeMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_freeMenu > 6 and maxfreeMenu < #t_freeMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; PRACTICE MENU
--;===========================================================
t_practiceMenu = {
	{id = textImgNew(), text = 'P1 VS CPU'},
	{id = textImgNew(), text = 'P1 VS P2'},	
	{id = textImgNew(), text = 'P1&P2 VS CPU'},		
}

function f_practiceMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local practiceMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			practiceMenu = practiceMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			practiceMenu = practiceMenu + 1
		end
		if practiceMenu < 1 then
			practiceMenu = #t_practiceMenu
			if #t_practiceMenu > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_practiceMenu-1
			end
		elseif practiceMenu > #t_practiceMenu then
			practiceMenu = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (practiceMenu - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (practiceMenu - 1) * 13
		end
		if #t_practiceMenu <= 5 then
			maxPracticeMenu = #t_practiceMenu
		elseif practiceMenu - cursorPosY > 0 then
			maxPracticeMenu = practiceMenu + 5 - cursorPosY
		else
			maxPracticeMenu = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			setDiscordState("Training")
			setGameMode('practice')
			setGameType(2)
			data.gameMode = 'training'
			data.rosterMode = 'training'
			setRoundTime(-1) --round time disabled
			data.versusScreen = false --versus screen disabled
			data.stageMenu = true
			data.p1TeamMenu = {mode = 0, chars = 1} --predefined P1 team mode as Single, 1 Character				
			data.p2TeamMenu = {mode = 0, chars = 1} --predefined P2 team mode as Single, 1 Character
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 1)
			--SINGLE MODE (practice special attacks and combos with training dummy character(s) of your choice)
			if practiceMenu == 1 then
				if data.training == 'Free' then
					--data.p2In = 3 --A fusion between data.p2In = 1 and data.p2In = 2 for use only in single free training mode (the enemy can be controlled by Player 2)
					data.p2In = 1
					data.p2Faces = true
				elseif data.training == 'Fixed' then
					data.p2In = 2
					data.p2Char = {t_charAdd['training']} --predefined P2 training char
				end
				textImgSetText(txt_mainSelect, 'TRAINING MODE')
				script.select.f_selectSimple()
				setDiscordState("In Main Menu")
			--MULTIPLAYER MODE (practice special attacks and combos with a human opponent)
			elseif practiceMenu == 2 then
				data.p2In = 2
				data.p2Faces = true
				textImgSetText(txt_mainSelect, 'MULTIPLAYER TRAINING')
				script.select.f_selectSimple()
				setDiscordState("In Main Menu")
			--CO-OP MODE (team up with another player to practice special attacks and combos with a training dummy character(s) of your choice)
			elseif practiceMenu == 3 then
				f_comingSoon()
				--data.p2In = 2
				--data.p2Faces = true
				--data.coop = true
				--data.p2TeamMenu = {mode = 0, chars = 1}
				--data.p2Char = {t_charAdd['training']}
				--textImgSetText(txt_mainSelect, 'COOPERATIVE TRAINING')
				--script.select.f_selectSimple()			
				setDiscordState("In Main Menu")
			end
		end	
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_practiceMenu do
			if i == practiceMenu then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_practiceMenu[i].id, jgFnt, bank, 0, t_practiceMenu[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'TRAINING MODE')
		textImgDraw(txt_version)
		f_sysTime()
		if maxPracticeMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_practiceMenu > 6 and maxPracticeMenu < #t_practiceMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; CHALLENGES MENU
--;===========================================================
t_challengeMenu = {
	{id = textImgNew(), text = 'SURVIVAL'},
	{id = textImgNew(), text = 'MISSIONS'},
	{id = textImgNew(), text = 'BOSS FIGHT'},
	{id = textImgNew(), text = 'BONUS GAMES'},
	{id = textImgNew(), text = 'TIME ATTACK'},
	{id = textImgNew(), text = 'SCORE ATTACK'},
	{id = textImgNew(), text = 'SUDDEN DEATH'},
}	
	
function f_challengeMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local challengeMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	f_infoReset()
	while true do
		if infoScreen == false then
			if esc() or commandGetState(p1Cmd, 'e') then
				sndPlay(sysSnd, 100, 2)
				break
			elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
				sndPlay(sysSnd, 100, 0)
				challengeMenu = challengeMenu - 1
			elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
				sndPlay(sysSnd, 100, 0)
				challengeMenu = challengeMenu + 1
			end
			if challengeMenu < 1 then
				challengeMenu = #t_challengeMenu
				if #t_challengeMenu > 5 then
					cursorPosY = 5
				else
					cursorPosY = #t_challengeMenu-1
				end
			elseif challengeMenu > #t_challengeMenu then
				challengeMenu = 1
				cursorPosY = 0
			elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
				cursorPosY = cursorPosY - 1
			elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
				cursorPosY = cursorPosY + 1
			end
			if cursorPosY == 5 then
				moveTxt = (challengeMenu - 6) * 13
			elseif cursorPosY == 0 then
				moveTxt = (challengeMenu - 1) * 13
			end
			if #t_challengeMenu <= 5 then
				maxChallengeMenu = #t_challengeMenu
			elseif challengeMenu - cursorPosY > 0 then
				maxChallengeMenu = challengeMenu + 5 - cursorPosY
			else
				maxChallengeMenu = 5
			end
			if btnPalNo(p1Cmd) > 0 then
				f_default()
				sndPlay(sysSnd, 100, 1)
				--SURVIVAL (defeat opponents with a single health meter)
				if challengeMenu == 1 then
					f_survivalMenu()
				--MISSIONS/TRIALS (complete missions or combos trial challenges)
				elseif challengeMenu == 2 then
					setDiscordState("In Missions")
					script.missions.f_missionMenu()
					setDiscordState("In Main Menu")
				--BOSS FIGHT (defeat boss characters)
				elseif challengeMenu == 3 then
					if #t_bossChars ~= 0 then
						f_bossMenu()
					else
						bossInfo = true
						infoScreen = true
					end
				--BONUS GAMES (play bonus games)
				elseif challengeMenu == 4 then
					if #t_bonusChars ~= 0 then
						f_bonusMenu()
					else
						bonusInfo = true
						infoScreen = true
					end
				--TIME ATTACK (defeat opponents as quickly as possible)
				elseif challengeMenu == 5 then
					f_timeMenu()
				--SCORE ATTACK (defeat opponents getting high score as possible)
				elseif challengeMenu == 6 then
					f_comingSoon()
				--SUDDEN DEATH (defeat opponents with 1 hit)
				elseif challengeMenu == 7 then
					f_suddenMenu()
				end
			end
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_challengeMenu do
			if i == challengeMenu then
				bank = 1
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_challengeMenu[i].id, jgFnt, bank, 0, t_challengeMenu[i].text, 159, 142+i*13-moveTxt))
		end
		if infoScreen == false then
			animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
			f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
			animDraw(f_animVelocity(cursorBox, -1, -1))
		end
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'CHALLENGES MODES')
		textImgDraw(txt_version)
		f_sysTime()
		if maxChallengeMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_challengeMenu > 6 and maxChallengeMenu < #t_challengeMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if infoScreen == true then f_infoMenu() end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; SURVIVAL MENU
--;===========================================================
t_survivalMenu = {
	{id = textImgNew(), text = 'P1 VS CPU'},
	{id = textImgNew(), text = 'CPU VS P1'},
	{id = textImgNew(), text = 'P1&P2 VS CPU'},
	{id = textImgNew(), text = 'CPU VS CPU'},
}	
	
function f_survivalMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local survivalMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			survivalMenu = survivalMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			survivalMenu = survivalMenu + 1
		end
		if survivalMenu < 1 then
			survivalMenu = #t_survivalMenu
			if #t_survivalMenu > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_survivalMenu-1
			end
		elseif survivalMenu > #t_survivalMenu then
			survivalMenu = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (survivalMenu - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (survivalMenu - 1) * 13
		end
		if #t_survivalMenu <= 5 then
			maxSurvivalMenu = #t_survivalMenu
		elseif survivalMenu - cursorPosY > 0 then
			maxSurvivalMenu = survivalMenu + 5 - cursorPosY
		else
			maxSurvivalMenu = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			setDiscordState("In Survival")
			data.gameMode = 'survival'
			data.rosterMode = 'survival'
			data.stageMenu = true
			setRoundsToWin(1)
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 1)
			--SINGLE MODE [LEFT SIDE] (defeat as many opponents as you can with a single Health Meter)
			if survivalMenu == 1 then
				data.p2In = 1
				data.p2SelectMenu = false
				textImgSetText(txt_mainSelect, 'SURVIVAL')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			--SINGLE MODE [RIGHT SIDE] (defeat as many opponents as you can with a single Health Meter)
			elseif survivalMenu == 2 then
				remapInput(1, 2)
				remapInput(2, 1)
				setCom(2, 0)
				setPlayerSide('p1right')
				data.p1In = 2
				data.p2In = 2
				data.p1SelectMenu = false
				textImgSetText(txt_mainSelect, 'SURVIVAL')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			--CO-OP MODE (team up with another player to defeat as many opponents as you can with a single Health Meter)
			elseif survivalMenu == 3 then
				data.p2In = 2
				data.p2Faces = true
				data.coop = true
				textImgSetText(txt_mainSelect, 'SURVIVAL COOPERATIVE')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			--CPU MODE (watch CPU defeat as many opponents as it can with a single Health Meter)
			elseif survivalMenu == 4 then
				data.p2In = 1
				data.p2SelectMenu = false
				data.aiFight = true
				data.rosterMode = 'cpu'
				textImgSetText(txt_mainSelect, 'WATCH SURVIVAL')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			end
		end	
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_survivalMenu do
			if i == survivalMenu then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_survivalMenu[i].id, jgFnt, bank, 0, t_survivalMenu[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'SURVIVAL MODE')
		textImgDraw(txt_version)
		f_sysTime()
		if maxSurvivalMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_survivalMenu > 6 and maxSurvivalMenu < #t_survivalMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; BOSS FIGHT MENU
--;===========================================================
t_bossMenu = {
	{id = textImgNew(), text = 'VS SINGLE BOSS'},
	{id = textImgNew(), text = 'BOSS RUSH'},
}	
	
function f_bossMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local bossMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			bossMenu = bossMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			bossMenu = bossMenu + 1
		end
		if bossMenu < 1 then
			bossMenu = #t_bossMenu
			if #t_bossMenu > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_bossMenu-1
			end
		elseif bossMenu > #t_bossMenu then
			bossMenu = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (bossMenu - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (bossMenu - 1) * 13
		end
		if #t_bossMenu <= 5 then
			maxBossMenu = #t_bossMenu
		elseif bossMenu - cursorPosY > 0 then
			maxBossMenu = bossMenu + 5 - cursorPosY
		else
			maxBossMenu = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			sndPlay(sysSnd, 100, 1)
			--SINGLE BOSS
			if bossMenu == 1 then
				f_rushTables() --From start.lua
				f_bossChars()
			--BOSS RUSH
			elseif bossMenu == 2 then
				f_bossrushMenu()
			end
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_bossMenu do
			if i == bossMenu then
				bank = 1
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_bossMenu[i].id, jgFnt, bank, 0, t_bossMenu[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'BOSS FIGHT MODES')
		textImgDraw(txt_version)
		f_sysTime()
		if maxBossMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_bossMenu > 6 and maxBossMenu < #t_bossMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; SINGLE BOSS MENU
--;===========================================================
function f_bossChars()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local bossChars = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			bossChars = bossChars - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			bossChars = bossChars + 1
		end
		if bossChars < 1 then
			bossChars = #t_bossSingle
			if #t_bossSingle > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_bossSingle-1
			end
		elseif bossChars > #t_bossSingle then
			bossChars = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (bossChars - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (bossChars - 1) * 13
		end
		if #t_bossSingle <= 5 then
			maxBossChars = #t_bossSingle
		elseif bossChars - cursorPosY > 0 then
			maxBossChars = bossChars + 5 - cursorPosY
		else
			maxBossChars = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			if bossChars < #t_bossSingle then --This table refers to the one at the end of the start.lua script
			--BOSS CHAR NAME (defeat 1 selected boss character)
				setDiscordState("In Boss Fight")
				data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
				sndPlay(sysSnd, 100, 1)
				data.p2TeamMenu = {mode = 0, chars = 1}
				data.p2Char = {t_bossChars[bossChars]}
				--data.stageMenu = true
				data.gameMode = 'singleboss'
				data.rosterMode = 'boss'
				textImgSetText(txt_mainSelect, t_selChars[t_bossChars[bossChars]+1].displayname)
				script.select.f_selectSimple()
				setDiscordState("In Main Menu")
			--BACK
			else
				sndPlay(sysSnd, 100, 2)
				break
			end
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_bossSingle do
			if i == bossChars then
				bank = 1
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_bossSingle[i].id, jgFnt, bank, 0, t_bossSingle[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'BOSS FIGHT')
		textImgDraw(txt_version)
		f_sysTime()
		if maxBossChars > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_bossSingle > 6 and maxBossChars < #t_bossSingle then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; BOSS RUSH MENU
--;===========================================================
t_bossrushMenu = {
	{id = textImgNew(), text = 'P1 VS CPU'},
	{id = textImgNew(), text = 'CPU VS P1'},
	{id = textImgNew(), text = 'P1&P2 VS CPU'},
	{id = textImgNew(), text = 'CPU VS CPU'},
}	
	
function f_bossrushMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local bossrushMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			bossrushMenu = bossrushMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			bossrushMenu = bossrushMenu + 1
		end
		if bossrushMenu < 1 then
			bossrushMenu = #t_bossrushMenu
			if #t_bossrushMenu > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_bossrushMenu-1
			end
		elseif bossrushMenu > #t_bossrushMenu then
			bossrushMenu = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (bossrushMenu - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (bossrushMenu - 1) * 13
		end
		if #t_bossrushMenu <= 5 then
			maxBossRushMenu = #t_bossrushMenu
		elseif bossrushMenu - cursorPosY > 0 then
			maxBossRushMenu = bossrushMenu + 5 - cursorPosY
		else
			maxBossRushMenu = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			setDiscordState("In Boss Rush")
			data.gameMode = 'bossrush'
			data.rosterMode = 'boss'
			--data.stageMenu = true
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 1)
			--SINGLE MODE [LEFT SIDE] (defeat all bosses in a row)
			if bossrushMenu == 1 then		
				if #t_bossChars ~= 0 then
					data.p2In = 1
					data.p2SelectMenu = false
					textImgSetText(txt_mainSelect, 'BOSS RUSH')					
					script.select.f_selectAdvance()
					setDiscordState("In Main Menu")
				end
			--SINGLE MODE [RIGHT SIDE] (defeat all bosses in a row)
			elseif bossrushMenu == 2 then
				if #t_bossChars ~= 0 then
					remapInput(1, 2)
					remapInput(2, 1)
					setCom(2, 0)
					setPlayerSide('p1right')
					data.p1In = 2
					data.p2In = 2
					data.p1SelectMenu = false
					textImgSetText(txt_mainSelect, 'BOSS RUSH')					
					script.select.f_selectAdvance()
					setDiscordState("In Main Menu")
				end
			--CO-OP MODE (team up with another player to defeat all bosses in a row)
			elseif bossrushMenu == 3 then
				if #t_bossChars ~= 0 then
					data.p2In = 2
					data.p2Faces = true
					data.coop = true
					textImgSetText(txt_mainSelect, 'BOSS RUSH COOPERATIVE')					
					script.select.f_selectAdvance()
					setDiscordState("In Main Menu")
				end
			--CPU MODE (watch CPU defeat all bosses in a row)
			elseif bossrushMenu == 4 then
				if #t_bossChars ~= 0 then
					data.p2In = 1
					data.p2SelectMenu = false
					data.aiFight = true
					data.rosterMode = 'cpu'
					textImgSetText(txt_mainSelect, 'WATCH BOSS RUSH')
					script.select.f_selectAdvance()
					setDiscordState("In Main Menu")
				end
			end
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_bossrushMenu do
			if i == bossrushMenu then
				bank = 1
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_bossrushMenu[i].id, jgFnt, bank, 0, t_bossrushMenu[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'BOSS RUSH MODE')
		textImgDraw(txt_version)
		f_sysTime()
		if maxBossRushMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_bossrushMenu > 6 and maxBossRushMenu < #t_bossrushMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; BONUS GAMES MENU
--;===========================================================
t_bonusMenu = {
	{id = textImgNew(), text = 'SINGLE MODE'},
	{id = textImgNew(), text = 'BONUS RUSH'},
}
	
function f_bonusMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local bonusMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			bonusMenu = bonusMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			bonusMenu = bonusMenu + 1
		end
		if bonusMenu < 1 then
			bonusMenu = #t_bonusMenu
			if #t_bonusMenu > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_bonusMenu-1
			end
		elseif bonusMenu > #t_bonusMenu then
			bonusMenu = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (bonusMenu - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (bonusMenu - 1) * 13
		end
		if #t_bonusMenu <= 5 then
			maxBonusMenu = #t_bonusMenu
		elseif bonusMenu - cursorPosY > 0 then
			maxBonusMenu = bonusMenu + 5 - cursorPosY
		else
			maxBonusMenu = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			sndPlay(sysSnd, 100, 1)
			--SINGLE BONUS
			if bonusMenu == 1 then
				f_rushTables()
				f_bonusExtras()
			--BONUS RUSH
			elseif bonusMenu == 2 then
				f_bonusrushMenu()
			end
		end	
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_bonusMenu do
			if i == bonusMenu then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_bonusMenu[i].id, jgFnt, bank, 0, t_bonusMenu[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'MINI-GAMES')
		textImgDraw(txt_version)
		f_sysTime()
		if maxBonusMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_bonusMenu > 6 and maxBonusMenu < #t_bonusMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; SINGLE BONUS GAMES MENU
--;===========================================================
function f_bonusExtras()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local bonusExtras = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			bonusExtras = bonusExtras - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			bonusExtras = bonusExtras + 1
		end
		if bonusExtras < 1 then
			bonusExtras = #t_bonusExtras
			if #t_bonusExtras > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_bonusExtras-1
			end
		elseif bonusExtras > #t_bonusExtras then
			bonusExtras = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (bonusExtras - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (bonusExtras - 1) * 13
		end
		if #t_bonusExtras <= 5 then
			maxBonusExtras = #t_bonusExtras
		elseif bonusExtras - cursorPosY > 0 then
			maxBonusExtras = bonusExtras + 5 - cursorPosY
		else
			maxBonusExtras = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			if bonusExtras < #t_bonusExtras then --This table refers to the one at the end of the start.lua script
			--BONUS CHAR NAME (clear 1 selected bonus game)
				setDiscordState("In Bonus Games")
				data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
				sndPlay(sysSnd, 100, 1)
				data.p2TeamMenu = {mode = 0, chars = 1}
				data.p2Char = {t_bonusChars[bonusExtras]}
				--data.stageMenu = true
				data.versusScreen = false
				data.gameMode = 'singlebonus'
				data.rosterMode = 'bonus'
				setRoundsToWin(1)
				textImgSetText(txt_mainSelect, t_selChars[t_bonusChars[bonusExtras]+1].displayname)
				script.select.f_selectSimple()
				setDiscordState("In Main Menu")
			--BACK
			else
				sndPlay(sysSnd, 100, 2)
				break
			end
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_bonusExtras do
			if i == bonusExtras then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_bonusExtras[i].id, jgFnt, bank, 0, t_bonusExtras[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'BONUS STAGES')
		textImgDraw(txt_version)
		f_sysTime()
		if maxBonusExtras > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_bonusExtras > 6 and maxBonusExtras < #t_bonusExtras then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; BONUS RUSH MENU
--;===========================================================
t_bonusrushMenu = {
	{id = textImgNew(), text = 'P1 VS CPU'},
	{id = textImgNew(), text = 'CPU VS P1'},
	{id = textImgNew(), text = 'P1&P2 VS CPU'},
}	
	
function f_bonusrushMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local bonusrushMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			bonusrushMenu = bonusrushMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			bonusrushMenu = bonusrushMenu + 1
		end
		if bonusrushMenu < 1 then
			bonusrushMenu = #t_bonusrushMenu
			if #t_bonusrushMenu > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_bonusrushMenu-1
			end
		elseif bonusrushMenu > #t_bonusrushMenu then
			bonusrushMenu = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (bonusrushMenu - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (bonusrushMenu - 1) * 13
		end
		if #t_bonusrushMenu <= 5 then
			maxBonusRushMenu = #t_bonusrushMenu
		elseif bonusrushMenu - cursorPosY > 0 then
			maxBonusRushMenu = bonusrushMenu + 5 - cursorPosY
		else
			maxBonusRushMenu = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			setDiscordState("In Bonus Rush")
			data.gameMode = 'bonusrush'
			data.rosterMode = 'bonus'
			setRoundsToWin(1)
			--data.stageMenu = true
			data.versusScreen = false
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)			
			sndPlay(sysSnd, 100, 1)
			--SINGLE MODE [LEFT SIDE] (clear all bonus games in a row)
			if bonusrushMenu == 1 then
				if #t_bonusChars ~= 0 then
					data.p2In = 1
					data.p2SelectMenu = false
					data.p2TeamMenu = {mode = 0, chars = 1}
					textImgSetText(txt_mainSelect, 'BONUS RUSH')
					script.select.f_selectAdvance()
					setDiscordState("In Main Menu")
				end
			--SINGLE MODE [RIGHT SIDE] (clear all bonus games in a row)
			elseif bonusrushMenu == 2 then
				if #t_bonusChars ~= 0 then
					remapInput(1, 2)
					remapInput(2, 1)
					setCom(2, 0)
					setPlayerSide('p1right')
					data.p1In = 2
					data.p2In = 2
					data.p1SelectMenu = false
					data.p1TeamMenu = {mode = 0, chars = 1}
					textImgSetText(txt_mainSelect, 'BONUS RUSH')
					script.select.f_selectAdvance()
					setDiscordState("In Main Menu")
				end
			--CO-OP MODE (team up with another player to clear all bonus games in a row)
			elseif bonusrushMenu == 3 then
				if #t_bonusChars ~= 0 then
					data.p2In = 2
					data.p2Faces = true
					data.coop = true
					textImgSetText(txt_mainSelect, 'BONUS RUSH COOPERATIVE')
					script.select.f_selectAdvance()
					setDiscordState("In Main Menu")
				end
			end
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_bonusrushMenu do
			if i == bonusrushMenu then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_bonusrushMenu[i].id, jgFnt, bank, 0, t_bonusrushMenu[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'BONUS RUSH MODE')
		textImgDraw(txt_version)
		f_sysTime()
		if maxBonusRushMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_bonusrushMenu > 6 and maxBonusRushMenu < #t_bonusrushMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; TIME ATTACK MENU
--;===========================================================
t_timeMenu = {
	{id = textImgNew(), text = 'P1 VS CPU'},
	{id = textImgNew(), text = 'CPU VS P1'},
	{id = textImgNew(), text = 'P1&P2 VS CPU'},
	{id = textImgNew(), text = 'CPU VS CPU'},
}	
	
function f_timeMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local timeMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			timeMenu = timeMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			timeMenu = timeMenu + 1
		end
		if timeMenu < 1 then
			timeMenu = #t_timeMenu
			if #t_timeMenu > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_timeMenu-1
			end
		elseif timeMenu > #t_timeMenu then
			timeMenu = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (timeMenu - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (timeMenu - 1) * 13
		end
		if #t_timeMenu <= 5 then
			maxTimeMenu = #t_timeMenu
		elseif timeMenu - cursorPosY > 0 then
			maxTimeMenu = timeMenu + 5 - cursorPosY
		else
			maxTimeMenu = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			setDiscordState("In Time Attack")
			data.gameMode = 'allroster'
			data.rosterMode = 'timeattack'
			--data.stageMenu = true
			setRoundTime(3600)
			setRoundsToWin(1)
			setLifeMul(2) --overwrite players life
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 1)
			--SINGLE MODE [LEFT SIDE] (defeat all character roster as quickly as possible, beating previous time records)
			if timeMenu == 1 then
				data.p2In = 1
				data.p2SelectMenu = false
				textImgSetText(txt_mainSelect, 'TIME ATTACK')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			--SINGLE MODE [RIGHT SIDE] (defeat all character roster as quickly as possible, beating previous time records)
			elseif timeMenu == 2 then
				remapInput(1, 2)
				remapInput(2, 1)
				setCom(2, 0)
				setPlayerSide('p1right')
				data.p1In = 2
				data.p2In = 2
				data.p1SelectMenu = false
				textImgSetText(txt_mainSelect, 'TIME ATTACK')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			--CO-OP MODE (team up with another player to defeat all character roster as quickly as possible, beating previous time records)
			elseif timeMenu == 3 then
				data.p2In = 2
				data.p2Faces = true
				data.coop = true
				textImgSetText(txt_mainSelect, 'TIME ATTACK COOPERATIVE')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			--CPU MODE (watch CPU defeat all character roster as quickly as possible, beating previous time records)
			elseif timeMenu == 4 then
				data.p2In = 1
				data.p2SelectMenu = false
				data.aiFight = true
				data.rosterMode = 'cpu'
				textImgSetText(txt_mainSelect, 'WATCH TIME ATTACK')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			end
		end	
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_timeMenu do
			if i == timeMenu then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_timeMenu[i].id, jgFnt, bank, 0, t_timeMenu[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'TIME ATTACK MODE')
		textImgDraw(txt_version)
		f_sysTime()
		if maxTimeMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_timeMenu > 6 and maxTimeMenu < #t_timeMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; SUDDEN DEATH MENU
--;===========================================================
t_suddenMenu = {
	{id = textImgNew(), text = 'P1 VS CPU'},
	{id = textImgNew(), text = 'CPU VS P1'},
	{id = textImgNew(), text = 'P1&P2 VS CPU'},
	{id = textImgNew(), text = 'CPU VS CPU'},
}	
	
function f_suddenMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local suddenMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			suddenMenu = suddenMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			suddenMenu = suddenMenu + 1
		end
		if suddenMenu < 1 then
			suddenMenu = #t_suddenMenu
			if #t_suddenMenu > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_suddenMenu-1
			end
		elseif suddenMenu > #t_suddenMenu then
			suddenMenu = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (suddenMenu - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (suddenMenu - 1) * 13
		end
		if #t_suddenMenu <= 5 then
			maxSuddenMenu = #t_suddenMenu
		elseif suddenMenu - cursorPosY > 0 then
			maxSuddenMenu = suddenMenu + 5 - cursorPosY
		else
			maxSuddenMenu = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			setDiscordState("In Sudden Death")
			data.gameMode = 'allroster'
			data.rosterMode = 'suddendeath'
			--data.stageMenu = true
			setRoundTime(1000)
			setRoundsToWin(1)
			setLifeMul(0)
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 1)
			--SINGLE MODE [LEFT SIDE] (see how many characters out of all roster you can take down with 1 Hit)
			if suddenMenu == 1 then
				data.p2In = 1
				data.p2SelectMenu = false
				textImgSetText(txt_mainSelect, 'SUDDEN DEATH')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			--SINGLE MODE [RIGHT SIDE] (see how many characters out of all roster you can take down with 1 Hit)
			elseif suddenMenu == 2 then
				remapInput(1, 2)
				remapInput(2, 1)
				setCom(2, 0)
				setPlayerSide('p1right')
				data.p1In = 2
				data.p2In = 2
				data.p1SelectMenu = false
				textImgSetText(txt_mainSelect, 'SUDDEN DEATH')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			--CO-OP MODE (team up with another player to see how many characters out of all roster you can take down with 1 Hit)
			elseif suddenMenu == 3 then
				data.p2In = 2
				data.p2Faces = true
				data.coop = true
				textImgSetText(txt_mainSelect, 'SUDDEN DEATH COOPERATIVE')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			--CPU MODE (see how many characters out of all roster the CPU can take down with 1 Hit)
			elseif suddenMenu == 4 then
				data.p2In = 1
				data.p2SelectMenu = false
				data.aiFight = true
				data.rosterMode = 'cpu'
				textImgSetText(txt_mainSelect, 'WATCH SUDDEN DEATH')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			end
		end	
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_suddenMenu do
			if i == suddenMenu then
				bank = 1
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_suddenMenu[i].id, jgFnt, bank, 0, t_suddenMenu[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'SUDDEN DEATH MODE')
		textImgDraw(txt_version)
		f_sysTime()
		if maxSuddenMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_suddenMenu > 6 and maxSuddenMenu < #t_suddenMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; EXTRAS MENU
--;===========================================================
t_extrasMenu = {
	{id = textImgNew(), text = 'ENDLESS'},
	{id = textImgNew(), text = 'EVENTS'},
	{id = textImgNew(), text = 'TOWER'},
	{id = textImgNew(), text = 'LEGION'},
	{id = textImgNew(), text = 'TOURNEY'},
	{id = textImgNew(), text = 'ADVENTURE'},
	{id = textImgNew(), text = 'THE VAULT'},
}	
	
function f_extrasMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local extrasMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			extrasMenu = extrasMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			extrasMenu = extrasMenu + 1
		end
		if extrasMenu < 1 then
			extrasMenu = #t_extrasMenu
			if #t_extrasMenu > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_extrasMenu-1
			end
		elseif extrasMenu > #t_extrasMenu then
			extrasMenu = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (extrasMenu - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (extrasMenu - 1) * 13
		end
		if #t_extrasMenu <= 5 then
			maxExtrasMenu = #t_extrasMenu
		elseif extrasMenu - cursorPosY > 0 then
			maxExtrasMenu = extrasMenu + 5 - cursorPosY
		else
			maxExtrasMenu = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			sndPlay(sysSnd, 100, 1)
			--ENDLESS MODE (fight in endless battles)
			if extrasMenu == 1 then
				f_allcharsMenu()
			--EVENTS MODE (complete events at certain hours, days, weeks, months or years)
			elseif extrasMenu == 2 then
				setDiscordState("In Events")
				script.events.f_eventMenu()
				setDiscordState("In Main Menu")
			--TOWER MODE (fight against enemy forces in customizable tower sizes)
			elseif extrasMenu == 3 then
				textImgSetText(txt_mainSelect, 'TOWER MODE')
				script.select.f_selectTower()
				setDiscordState("In Main Menu")
			--LEGION MODE (raise your own army to fight several enemy forces and conquer customizable maps)
			elseif extrasMenu == 4 then
				textImgSetText(txt_mainSelect, 'LEGION MODE')
				script.select.f_selectLegion()
				setDiscordState("In Main Menu")
			--TOURNEY MODE (participate in customizable single-elimination tournaments)
			elseif extrasMenu == 5 then
				f_tourneyMenu()
				setDiscordState("In Main Menu")
			--ADVENTURE MODE (explore a custom map with goals and level up your characters)
			elseif extrasMenu == 6 then
				script.select.f_selectAdventure() --script.adventure.f_mainAdventure()
				setDiscordState("In Main Menu")
			--THE VAULT MODE (insert secret codes to unlock things)
			elseif extrasMenu == 7 then
				setDiscordState("In Secret Room")
				f_theVault()
				setDiscordState("In Main Menu")
			end
		end	
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_extrasMenu do
			if i == extrasMenu then
				bank = 2
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_extrasMenu[i].id, jgFnt, bank, 0, t_extrasMenu[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'EXTRAS UNLOCKED')
		textImgDraw(txt_version)
		f_sysTime()
		if maxExtrasMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_extrasMenu > 6 and maxExtrasMenu < #t_extrasMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; ENDLESS MENU
--;===========================================================
t_allcharsMenu = {
	{id = textImgNew(), text = 'P1 VS CPU'},
	{id = textImgNew(), text = 'CPU VS P1'},
	{id = textImgNew(), text = 'P1&P2 VS CPU'},
	{id = textImgNew(), text = 'CPU VS CPU'},
}	
	
function f_allcharsMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local allcharsMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			allcharsMenu = allcharsMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			allcharsMenu = allcharsMenu + 1
		end
		if allcharsMenu < 1 then
			allcharsMenu = #t_allcharsMenu
			if #t_allcharsMenu > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_allcharsMenu-1
			end
		elseif allcharsMenu > #t_allcharsMenu then
			allcharsMenu = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (allcharsMenu - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (allcharsMenu - 1) * 13
		end
		if #t_allcharsMenu <= 5 then
			maxAllCharsMenu = #t_allcharsMenu
		elseif allcharsMenu - cursorPosY > 0 then
			maxAllCharsMenu = allcharsMenu + 5 - cursorPosY
		else
			maxAllCharsMenu = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			setDiscordState("In Endless Mode")
			data.gameMode = 'endless'
			data.rosterMode = 'endless'
			data.stageMenu = true
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 1)
			--SINGLE MODE [LEFT SIDE] (choose a fighter to defeat endless CPU controlled opponents)
			if allcharsMenu == 1 then
				data.p2In = 1
				data.p2SelectMenu = false
				textImgSetText(txt_mainSelect, 'ENDLESS MODE')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			--SINGLE MODE [RIGHT SIDE] (choose a fighter to defeat endless CPU controlled opponents)
			elseif allcharsMenu == 2 then
				remapInput(1, 2)
				remapInput(2, 1)
				setCom(2, 0)
				setPlayerSide('p1right')
				data.p1In = 2
				data.p2In = 2
				data.p1SelectMenu = false
				textImgSetText(txt_mainSelect, 'ENDLESS MODE')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			--CO-OP MODE (team up with another player to defeat endless CPU controlled opponents)
			elseif allcharsMenu == 3 then
				data.p2In = 2
				data.p2Faces = true
				data.coop = true
				textImgSetText(txt_mainSelect, 'ENDLESS COOPERATIVE')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			--CPU MODE (choose a fighter to watch endless CPU fights)
			elseif allcharsMenu == 4 then
				data.p2In = 1
				data.p2SelectMenu = false
				data.aiFight = true
				data.rosterMode = 'cpu'
				textImgSetText(txt_mainSelect, 'WATCH ENDLESS')
				script.select.f_selectAdvance()
				setDiscordState("In Main Menu")
			end
		end	
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_allcharsMenu do
			if i == allcharsMenu then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_allcharsMenu[i].id, jgFnt, bank, 0, t_allcharsMenu[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'INFINITE MODE')
		textImgDraw(txt_version)
		f_sysTime()
		if maxAllCharsMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_allcharsMenu > 6 and maxAllCharsMenu < #t_allcharsMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; TOURNAMENT MENU (WIP)
--;===========================================================
t_tourneyMenu = {
	{id = textImgNew(), text = 'ROUND OF 16'},
	{id = textImgNew(), text = 'ROUND OF 8'},
	{id = textImgNew(), text = 'ROUND OF 4'},
}

function f_tourneyMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local tourneyMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			tourneyMenu = tourneyMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			tourneyMenu = tourneyMenu + 1
		end
		if tourneyMenu < 1 then
			tourneyMenu = #t_tourneyMenu
			if #t_tourneyMenu > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_tourneyMenu-1
			end
		elseif tourneyMenu > #t_tourneyMenu then
			tourneyMenu = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (tourneyMenu - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (tourneyMenu - 1) * 13
		end
		if #t_tourneyMenu <= 5 then
			maxTourneyMenu = #t_tourneyMenu
		elseif tourneyMenu - cursorPosY > 0 then
			maxTourneyMenu = tourneyMenu + 5 - cursorPosY
		else
			maxTourneyMenu = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			--setDiscordState("In Tourney Mode")
			--data.rosterMode = 'tourney'
			--data.stageMenu = true
			--data.p2In = 1
			--data.p2SelectMenu = false
			--data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 1)
			--ROUND OF 16 (participate in a customizable single-elimination tournament starting from Round of 16)
			if tourneyMenu == 1 then
				data.gameMode = 'tourney16'
				textImgSetText(txt_mainSelect, 'TOURNAMENT MODE')
				script.select.f_selectTourney()
				--setDiscordState("In Main Menu")
			--QUARTERFINALS (participate in a customizable single-elimination tournament starting from Quarterfinals)
			elseif tourneyMenu == 2 then
				data.gameMode = 'tourney8'
				textImgSetText(txt_mainSelect, 'TOURNAMENT - QUARTERFINALS')
				script.select.f_selectTourney()
				--setDiscordState("In Main Menu")
			--SEMIFINALS (participate in a customizable single-elimination tournament starting from Semifinals)
			elseif tourneyMenu == 3 then
				data.gameMode = 'tourney4'
				textImgSetText(txt_mainSelect, 'TOURNAMENT - SEMIFINALS')
				script.select.f_selectTourney()
				--setDiscordState("In Main Menu")
			end
		end	
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_tourneyMenu do
			if i == tourneyMenu then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_tourneyMenu[i].id, jgFnt, bank, 0, t_tourneyMenu[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'TOURNAMENT MODE')
		textImgDraw(txt_version)
		f_sysTime()
		if maxTourneyMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_tourneyMenu > 6 and maxTourneyMenu < #t_tourneyMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; WATCH MENU
--;===========================================================
t_watchMenu = {
	{id = textImgNew(), text = 'REPLAYS'},
	{id = textImgNew(), text = 'STAGE VIEWER'},
	{id = textImgNew(), text = 'LEADERBOARDS'},
	{id = textImgNew(), text = 'ACHIEVEMENTS'},
	{id = textImgNew(), text = 'PLAYER RECORDS'},
	{id = textImgNew(), text = 'STORYBOARDS'},
	{id = textImgNew(), text = 'CUTSCENES'},
	{id = textImgNew(), text = 'SOUND TEST'},
	{id = textImgNew(), text = 'SCREENSHOTS'},
	{id = textImgNew(), text = 'GALLERY'},
	{id = textImgNew(), text = 'CREDITS'},
}	
	
function f_watchMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local watchMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			watchMenu = watchMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			watchMenu = watchMenu + 1
		end
		if watchMenu < 1 then
			watchMenu = #t_watchMenu
			if #t_watchMenu > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_watchMenu-1
			end
		elseif watchMenu > #t_watchMenu then
			watchMenu = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (watchMenu - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (watchMenu - 1) * 13
		end
		if #t_watchMenu <= 5 then
			maxWatchMenu = #t_watchMenu
		elseif watchMenu - cursorPosY > 0 then
			maxWatchMenu = watchMenu + 5 - cursorPosY
		else
			maxWatchMenu = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			sndPlay(sysSnd, 100, 1)
			--REPLAYS (watch recorded battles)
			if watchMenu == 1 then
				f_replayMenu()
			--STAGE VIEWER (watch a selected stage without fight)
			elseif watchMenu == 2 then
				data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
				setRoundTime(-1)
				data.p2In = 2
				data.stageMenu = true
				data.versusScreen = false
				data.p1TeamMenu = {mode = 0, chars = 1}			
				data.p2TeamMenu = {mode = 0, chars = 1}
				data.p1Char = {t_charAdd['stage viewer']}
				data.p2Char = {t_charAdd['stage viewer']}
				data.gameMode = 'stage viewer'
				setGameMode('stageviewer')
				setDiscordState("Watching Stages")
				textImgSetText(txt_mainSelect, 'STAGE VIEWER')
				script.select.f_selectSimple()
				setDiscordState("In Main Menu")
			--LEADERBOARDS (display rankings data)
			elseif watchMenu == 3 then
				f_comingSoon()
			--ACHIEVEMENTS (display achievements data)
			elseif watchMenu == 4 then
				f_comingSoon()
			--STATISTICS (display overall player data)
			elseif watchMenu == 5 then
				--assert(loadfile('save/stats_sav.lua'))()
				script.statistics.f_statsMenu()
			--STORYBOARDS (play storyboards)
			elseif watchMenu == 6 then
				setDiscordState("In Storyboards")
				f_storyboardMenu()
				setDiscordState("In Main Menu")
			--CUTSCENES (play video cutscenes)
			elseif watchMenu == 7 then
				setDiscordState("In Cutscenes")
				f_videoMenu()
				setDiscordState("In Main Menu")
			--SOUND TEST (listen sounds)
			elseif watchMenu == 8 then
				setDiscordState("In Sound Test")
				soundTest = true
				f_songMenu()
				setDiscordState("In Main Menu")
			--SCREENSHOTS (watch screenshots taken)
			elseif watchMenu == 9 then
				sszOpen("screenshots", "") --added via script.ssz
			--GALLERY (watch illustrations)
			elseif watchMenu == 10 then
				setDiscordState("Gallery Theater")
				f_galleryMenu()
				setDiscordState("In Main Menu")
			--CREDITS (play credits)
			elseif watchMenu == 11 then
				setDiscordState("In Credits")
				playBGM("sound/system/credits.mp3")
				f_playCredits()
				setDiscordState("In Main Menu")
			end
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_watchMenu do
			if i == watchMenu then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_watchMenu[i].id, jgFnt, bank, 0, t_watchMenu[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'WATCH CONTENT')
		textImgDraw(txt_version)
		f_sysTime()
		if maxWatchMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_watchMenu > 6 and maxWatchMenu < #t_watchMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; REPLAY MENU
--;===========================================================
t_replayMenu = {
	{id = textImgNew(), text = 'ONLINE REPLAYS'},
	{id = textImgNew(), text = 'LOCAL REPLAYS'},
}

function f_replayMenu()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local replayMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	f_infoReset()
	while true do
		if infoScreen == false then
			if esc() or commandGetState(p1Cmd, 'e') then
				sndPlay(sysSnd, 100, 2)
				break
			elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
				sndPlay(sysSnd, 100, 0)
				replayMenu = replayMenu - 1
			elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
				sndPlay(sysSnd, 100, 0)
				replayMenu = replayMenu + 1
			end
			if replayMenu < 1 then
				replayMenu = #t_replayMenu
				if #t_replayMenu > 5 then
					cursorPosY = 5
				else
					cursorPosY = #t_replayMenu-1
				end
			elseif replayMenu > #t_replayMenu then
				replayMenu = 1
				cursorPosY = 0
			elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
				cursorPosY = cursorPosY - 1
			elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
				cursorPosY = cursorPosY + 1
			end
			if cursorPosY == 5 then
				moveTxt = (replayMenu - 6) * 13
			elseif cursorPosY == 0 then
				moveTxt = (replayMenu - 1) * 13
			end
			if #t_replayMenu <= 5 then
				maxreplayMenu = #t_replayMenu
			elseif replayMenu - cursorPosY > 0 then
				maxreplayMenu = replayMenu + 5 - cursorPosY
			else
				maxreplayMenu = 5
			end
			if btnPalNo(p1Cmd) > 0 then
				sndPlay(sysSnd, 100, 1)
				--ONLINE REPLAYS (watch saved replays of your online matches)
				if replayMenu == 1 then
					--if (resolutionHeight / 3 * 4) ~= resolutionWidth then --To watch an online replay you need to set a 4:3 Resolution to avoid desync
					--if (resolutionHeight / 10 * 16) ~= resolutionWidth then --To watch an online replay you need to set a 16:10 Resolution to avoid desync
					if (math.floor((resolutionHeight / 9 * 16) + 0.5)) ~= resolutionWidth then --To watch an online replay you need to set a 16:9 Resolution to avoid desync
						resolutionInfo = true
						infoScreen = true
					else
						data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
						setDiscordState("Online Replays")
						f_mainReplay()
						setDiscordState("In Main Menu")
					end
				--LOCAL REPLAYS (watch saved replays of your local matches)
				elseif replayMenu == 2 then
					f_comingSoon()
				end
			end
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_replayMenu do
			if i == replayMenu then
				bank = 2
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_replayMenu[i].id, jgFnt, bank, 0, t_replayMenu[i].text, 159, 142+i*13-moveTxt))
		end
		if infoScreen == false then
			animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
			f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
			animDraw(f_animVelocity(cursorBox, -1, -1))
		end
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'REPLAY MODE')
		textImgDraw(txt_version)
		f_sysTime()
		if maxreplayMenu > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_replayMenu > 6 and maxreplayMenu < #t_replayMenu then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if infoScreen == true then f_infoMenu() end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; GALLERY SCREENPACK
--;===========================================================
--Left Page Arrow
arrowsGL = animNew(sysSff, [[
223,0, 0,0, 10
223,1, 0,0, 10
223,2, 0,0, 10
223,3, 0,0, 10
223,3, 0,0, 10
223,2, 0,0, 10
223,1, 0,0, 10
223,0, 0,0, 10
]])
animAddPos(arrowsGL, 264, 220.5)
animUpdate(arrowsGL)
animSetScale(arrowsGL, 0.5, 0.5)

--Right Page Arrow
arrowsGR = animNew(sysSff, [[
224,0, 0,0, 10
224,1, 0,0, 10
224,2, 0,0, 10
224,3, 0,0, 10
224,3, 0,0, 10
224,2, 0,0, 10
224,1, 0,0, 10
224,0, 0,0, 10
]])
animAddPos(arrowsGR, 312, 220.5)
animUpdate(arrowsGR)
animSetScale(arrowsGR, 0.5, 0.5)

--;===========================================================
--; GALLERY MENU
--;===========================================================
function f_gallery()
	gallery = ''
	gallery = '0,' .. galleryList-1 .. ', 0,0, 0'
	gallery = animNew(gallerySff, gallery)
	animSetScale(gallery, 0.30, 0.305)
	animSetPos(gallery, 160, 119)
	animUpdate(gallery)
	animDraw(gallery)
	txt_artNumber = createTextImg(font14, 0, 0, ' ' .. galleryList .. '/10', 290, 230) --draw gallery limit numbers text
	textImgDraw(txt_artNumber)
	return gallery
end

function f_galleryMenu()
	data.fadeTitle = f_fadeAnim(30, 'fadein', 'black', fadeSff)
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	local moveArt = 1 --Start in image 0,0
	galleryList = 0 --Important to avoid errors when read
	cmdInput()
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			data.fadeTitle = f_fadeAnim(30, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 2)
			break
		elseif (commandGetState(p1Cmd, 'r') or commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) or (commandGetState(p1Cmd, 'holdr') and bufr >= 30)) and moveArt <= 9 then --moveArt <= Number of your Gallery Limit
			data.fadeTitle = f_fadeAnim(50, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 3)
			moveArt = moveArt + 1
		elseif (commandGetState(p1Cmd, 'l') or commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) or (commandGetState(p1Cmd, 'holdl') and bufl >= 30)) and moveArt > 1 then --Keep in image 0,0 when press left until finish
			data.fadeTitle = f_fadeAnim(50, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 3)
			moveArt = moveArt - 1
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		elseif commandGetState(p1Cmd, 'holdr') then
			bufl = 0
			bufr = bufr + 1
		elseif commandGetState(p1Cmd, 'holdl') then
			bufr = 0
			bufl = bufl + 1
		else
			bufu = 0
			bufd = 0
			bufr = 0
			bufl = 0
		end
		galleryList = moveArt --Use menu position to show image in these order
		f_gallery()
		if moveArt > 1 then
			animDraw(arrowsGL)
			animUpdate(arrowsGL)
		end
		if moveArt <= 9 then
			animDraw(arrowsGR)
			animUpdate(arrowsGR)
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; SOUND TEST SCREENPACK
--;===========================================================
txt_song = createTextImg(jgFnt, 0, 0, '', 159, 13)

--Scrolling background
songBG0 = animNew(sysSff, [[
100,0, 0,0, -1
]])
animAddPos(songBG0, 160, 0)
animSetTile(songBG0, 1, 1)
animSetColorKey(songBG0, -1)

--Transparent background
songBG1 = animNew(sysSff, [[
3,0, 0,0, -1
]])
animSetPos(songBG1, 20, 20)
animSetAlpha(songBG1, 20, 100)
animUpdate(songBG1)

--Up Arrow
songUpArrow = animNew(sysSff, [[
225,0, 0,0, 10
225,1, 0,0, 10
225,2, 0,0, 10
225,3, 0,0, 10
225,3, 0,0, 10
225,2, 0,0, 10
225,1, 0,0, 10
225,0, 0,0, 10
]])
animAddPos(songUpArrow, 228, 11)
animUpdate(songUpArrow)
animSetScale(songUpArrow, 0.5, 0.5)

--Down Page Arrow
songDownArrow = animNew(sysSff, [[
226,0, 0,0, 10
226,1, 0,0, 10
226,2, 0,0, 10
226,3, 0,0, 10
226,3, 0,0, 10
226,2, 0,0, 10
226,1, 0,0, 10
226,0, 0,0, 10
]])
animAddPos(songDownArrow, 228, 231)
animUpdate(songDownArrow)
animSetScale(songDownArrow, 0.5, 0.5)

--Left Page Arrow
songLeftArrow = animNew(sysSff, [[
223,0, 0,0, 10
223,1, 0,0, 10
223,2, 0,0, 10
223,3, 0,0, 10
223,3, 0,0, 10
223,2, 0,0, 10
223,1, 0,0, 10
223,0, 0,0, 10
]])
animAddPos(songLeftArrow, 69, 112)
animUpdate(songLeftArrow)
animSetScale(songLeftArrow, 0.5, 0.5)

--Right Page Arrow
songRightArrow = animNew(sysSff, [[
224,0, 0,0, 10
224,1, 0,0, 10
224,2, 0,0, 10
224,3, 0,0, 10
224,3, 0,0, 10
224,2, 0,0, 10
224,1, 0,0, 10
224,0, 0,0, 10
]])
animAddPos(songRightArrow, 242, 112)
animUpdate(songRightArrow)
animSetScale(songRightArrow, 0.5, 0.5)

--;===========================================================
--; CONFIRM SONG MESSAGE
--;===========================================================
txt_confirmSong = createTextImg(jgFnt, 0, 0, 'USE THIS SONG?', 160, 108, 0.63, 0.63)

--Confirm Window BG
confirmSongWindowBG = animNew(sysSff, [[
230,1, 0,0,
]])
animSetPos(confirmSongWindowBG, 83.5, 97)
animUpdate(confirmSongWindowBG)
animSetScale(confirmSongWindowBG, 1, 1)

t_confirmSongMenu = {
	{id = textImgNew(), text = 'YES'},
	{id = textImgNew(), text = 'NO'},
}

function f_confirmSongMenu()
	cmdInput()
	--Cursor Position
	if commandGetState(p1Cmd, 'u') then
		sndPlay(sysSnd, 100, 0)
		confirmSongMenu = confirmSongMenu - 1
	elseif commandGetState(p1Cmd, 'd') then
		sndPlay(sysSnd, 100, 0)
		confirmSongMenu = confirmSongMenu + 1
	end
	if confirmSongMenu < 1 then
		confirmSongMenu = #t_confirmSongMenu
		if #t_confirmSongMenu > 4 then
			cursorPosYSongConfirm = 4
		else
			cursorPosYSongConfirm = #t_confirmSongMenu-1
		end
	elseif confirmSongMenu > #t_confirmSongMenu then
		confirmSongMenu = 1
		cursorPosYSongConfirm = 0
	elseif commandGetState(p1Cmd, 'u') and cursorPosYSongConfirm > 0 then
		cursorPosYSongConfirm = cursorPosYSongConfirm - 1
	elseif commandGetState(p1Cmd, 'd') and cursorPosYSongConfirm < 4 then
		cursorPosYSongConfirm = cursorPosYSongConfirm + 1
	end
	if cursorPosYSongConfirm == 4 then
		moveTxtSongConfirm = (confirmSongMenu - 5) * 13
	elseif cursorPosYSongConfirm == 0 then
		moveTxtSongConfirm = (confirmSongMenu - 1) * 13
	end
	--Draw Fade BG
	animDraw(fadeWindowBG)
	--Draw Menu BG
	animDraw(confirmSongWindowBG)
	animUpdate(confirmSongWindowBG)
	--Draw Title
	textImgDraw(txt_confirmSong)
	--Draw Select content
	f_drawQuickText(txt_songSelected, font6, 0, 0, selectedSongName, 160, 120, 0.68, 0.68)
	--Draw Table Text
	for i=1, #t_confirmSongMenu do
		if i == confirmSongMenu then
			bank = 5
		else
			bank = 0
		end
		textImgDraw(f_updateTextImg(t_confirmSongMenu[i].id, jgFnt, bank, 0, t_confirmSongMenu[i].text, 159, 120+i*13-moveTxtSongConfirm))
	end
	--Draw Cursor
	animSetWindow(cursorBox, 87,123+cursorPosYSongConfirm*13, 144,13)
	f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
	animDraw(f_animVelocity(cursorBox, -1, -1))
	--Actions
	if btnPalNo(p1Cmd) > 0 then
		--YES
		if confirmSongMenu == 1 then
			--sndPlay(sysSnd, 100, 1)
		--NO
		else
			selectedSong = nil
		end
		backSongConfirm = true
		f_confirmSongReset()
	end
	cmdInput()
end

function f_confirmSongReset()
	confirmSong = false
	moveTxtSongConfirm = 0
	--Cursor pos in NO
	cursorPosYSongConfirm = 1
	confirmSongMenu = 2
end

--;===========================================================
--; SOUND TEST MENU
--;===========================================================
function f_songMenu()
	playBGM(bgmNothing)
	data.fadeTitle = f_fadeAnim(20, 'fadein', 'black', fadeSff)
	cmdInput()
	f_confirmSongReset()
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	local cursorPosY = 1
	local moveTxt = 0
	songMenu = 1 --Not local because will be used in other menus
	songFolder = 1
	selectedSong = nil
	songChanged = false
	f_soundtrack() --Loaded from common.lua
	local randomTrack = ''
	while true do
		if backSongConfirm == true then
			data.fadeTitle = f_fadeAnim(20, 'fadein', 'black', fadeSff)
			script.options.f_setCfgSong() --SAVE AND BACK SONG FOR OPTIONS MENU
			f_menuMusic()
			sndPlay(sysSnd, 100, 2)
			backSongConfirm = false
			soundTest = false
			break
		end
		if confirmSong == false then
			if esc() or commandGetState(p1Cmd, 'e') then
				if soundTest == true or songChanged == false then --Another damn check just to know in what menu where are and if you select something..
					backSongConfirm = true
				else --IF YOU ARE IN SYSTEM SONGS SETTINGS
					confirmSong = true
				end
			elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
				sndPlay(sysSnd, 100, 0)
				songMenu = songMenu - 1
			elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
				sndPlay(sysSnd, 100, 0)
				songMenu = songMenu + 1
			elseif commandGetState(p1Cmd, 'l') or (commandGetState(p1Cmd, 'holdl') and bufl >= 30) then
				sndPlay(sysSnd, 100, 0)
				songFolder = songFolder - 1
				songMenu = 1 --Restart Cursor Values to prevent nil values issues
				cursorPosY = 1 --Restart Cursor Values to prevent nil values issues
			elseif commandGetState(p1Cmd, 'r') or (commandGetState(p1Cmd, 'holdr') and bufr >= 30) then
				sndPlay(sysSnd, 100, 0)
				songFolder = songFolder + 1
				songMenu = 1 --Restart Cursor Values to prevent nil values issues
				cursorPosY = 1 --Restart Cursor Values to prevent nil values issues
			elseif btnPalNo(p1Cmd) > 0 then
				if songMenu == #t_songList[songFolder] then
					--BACK
					if soundTest == true or songChanged == false then --Same esc logic
						backSongConfirm = true
					else
						confirmSong = true
					end
				else
					--Play Song
					if not soundTest then
						sndPlay(sysSnd, 100, 1)
						songChanged = true
					end
					selectedSong = t_songList[songFolder][songMenu].path
					selectedSongName = t_songList[songFolder][songMenu].name
					playBGM(selectedSong)
					--if songFolder == 1 then
						--randomTrack = math.random(1, #t_songList[1])
						--randomTrack = math.random(1, #t_songList[1][randomTrack].path)
						--playBGM(randomTrack)
					--end
				end
			end
			--Folder Select Logic
			if songFolder < 1 then
				songFolder = #t_songList
			elseif songFolder > #t_songList then
				songFolder = 1
			end
			--Cursor position calculation
			if songMenu < 1 then
				songMenu = #t_songList[songFolder]
				if #t_songList[songFolder] > 14 then
					cursorPosY = 14
				else
					cursorPosY = #t_songList[songFolder]
				end
			elseif songMenu > #t_songList[songFolder] then
				songMenu = 1
				cursorPosY = 1
			elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 1 then
				cursorPosY = cursorPosY - 1
			elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 14 then
				cursorPosY = cursorPosY + 1
			end
			if cursorPosY == 14 then
				moveTxt = (songMenu - 14) * 15
			elseif cursorPosY == 1 then
				moveTxt = (songMenu - 1) * 15
			end	
			if #t_songList[songFolder] <= 14 then
				maxSongs = #t_songList[songFolder]
			elseif songMenu - cursorPosY > 0 then
				maxSongs = songMenu + 14 - cursorPosY
			else
				maxSongs = 14
			end
		end
		--Draw Menu BG
		animDraw(f_animVelocity(songBG0, -1, -1))
		--Draw Transparent Table BG
		animSetScale(songBG1, 220, maxSongs*15)
		animSetWindow(songBG1, 80,20, 160,210)
		animDraw(songBG1)
		--Draw Title Menu
		textImgSetText(txt_song, 'SONG SELECT '..'['..t_songList[songFolder][songMenu].folder..']')
		textImgDraw(txt_song)
		if confirmSong == false then
			--Draw Hint Text
			f_drawQuickText(txt_songHint, font1, 0, 0, 'PRESS ANY CONFIRM BUTTON TO SELECT A SONG', 159, 239, 0.8, 0.8)
			--Draw Table Cursor
			animSetWindow(cursorBox, 80,5+cursorPosY*15, 160,15)
			f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
			animDraw(f_animVelocity(cursorBox, -1, -1))
		end
		--Draw Text for Table
		for i=1, maxSongs do
			if t_songList[songFolder][i].name:len() > 28 then --If name is too long, shortcut with ...
				songText = string.sub(t_songList[songFolder][i].name, 1, 24)
				songText = tostring(songText .. '...')
			else
				songText = t_songList[songFolder][i].name
			end
			if i > songMenu - cursorPosY then
				t_songList[songFolder][i].id = createTextImg(font2, 0, 1, songText, 85, 15+i*15-moveTxt)
				textImgDraw(t_songList[songFolder][i].id)
			end
		end
		--Draw Up Animated Cursor
		if maxSongs > 14 then
			animDraw(songUpArrow)
			animUpdate(songUpArrow)
		end
		--Draw Down Animated Cursor
		if #t_songList[songFolder] > 14 and maxSongs < #t_songList[songFolder] then
			animDraw(songDownArrow)
			animUpdate(songDownArrow)
		end
		--Draw Left Animated Cursor
		if songFolder > 1 then
			animDraw(songLeftArrow)
			animUpdate(songLeftArrow)
		end
		--Draw Right Animated Cursor
		if songFolder < #t_songList then
			animDraw(songRightArrow)
			animUpdate(songRightArrow)
		end
		if confirmSong == true then f_confirmSongMenu() end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		elseif commandGetState(p1Cmd, 'holdr') then
			bufl = 0
			bufr = bufr + 1
		elseif commandGetState(p1Cmd, 'holdl') then
			bufr = 0
			bufl = bufl + 1
		else
			bufu = 0
			bufd = 0
			bufr = 0
			bufl = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; CUTSCENES SCREENPACK
--;===========================================================
txt_video = createTextImg(jgFnt, 0, 0, 'CUTSCENE SELECT', 159, 13)

--Scrolling background
videoBG0 = animNew(sysSff, [[
100,0, 0,0, -1
]])
animAddPos(videoBG0, 160, 0)
animSetTile(videoBG0, 1, 1)
animSetColorKey(videoBG0, -1)

--Transparent background
videoBG1 = animNew(sysSff, [[
3,0, 0,0, -1
]])
animSetPos(videoBG1, 20, 20)
animSetAlpha(videoBG1, 20, 100)
animUpdate(videoBG1)

--Up Arrow
videoUpArrow = animNew(sysSff, [[
225,0, 0,0, 10
225,1, 0,0, 10
225,2, 0,0, 10
225,3, 0,0, 10
225,3, 0,0, 10
225,2, 0,0, 10
225,1, 0,0, 10
225,0, 0,0, 10
]])
animAddPos(videoUpArrow, 228, 11)
animUpdate(videoUpArrow)
animSetScale(videoUpArrow, 0.5, 0.5)

--Down Arrow
videoDownArrow = animNew(sysSff, [[
226,0, 0,0, 10
226,1, 0,0, 10
226,2, 0,0, 10
226,3, 0,0, 10
226,3, 0,0, 10
226,2, 0,0, 10
226,1, 0,0, 10
226,0, 0,0, 10
]])
animAddPos(videoDownArrow, 228, 231)
animUpdate(videoDownArrow)
animSetScale(videoDownArrow, 0.5, 0.5)

--;===========================================================
--; CUTSCENES MENU
--;===========================================================
function f_videoMenu()
	data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
	cmdInput()
	local cursorPosY = 1
	local moveTxt = 0
	local videoMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	t_videoList = {}
	for file in lfs.dir[[.\\movie\\]] do
		if file:match('^.*(%.)wmv$') then
			row = #t_videoList+1
			t_videoList[row] = {}
			t_videoList[row]['id'] = ''
			t_videoList[row]['name'] = file:gsub('^(.*)[%.]wmv$', '%1')
			t_videoList[row]['path'] = 'movie/'..file
		elseif file:match('^.*(%.)WMV$') then
			row = #t_videoList+1
			t_videoList[row] = {}
			t_videoList[row]['id'] = ''
			t_videoList[row]['name'] = file:gsub('^(.*)[%.]WMV$', '%1')
			t_videoList[row]['path'] = 'movie/'..file
		end
	end
	t_videoList[#t_videoList+1] = {id = '', name = '          BACK'}
	if data.debugLog then f_printTable(t_videoList, "save/debug/t_videoList.txt") end
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			videoMenu = videoMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			videoMenu = videoMenu + 1
		elseif btnPalNo(p1Cmd) > 0 then
			if videoMenu == #t_videoList then
				data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
				sndPlay(sysSnd, 100, 2)
				break
			else
				playVideo(t_videoList[videoMenu].path)
				data.fadeTitle = f_fadeAnim(50, 'fadein', 'black', fadeSff)
				f_menuMusic()
			end
		end
		if videoMenu < 1 then
			videoMenu = #t_videoList
			if #t_videoList > 14 then
				cursorPosY = 14
			else
				cursorPosY = #t_videoList
			end
		elseif videoMenu > #t_videoList then
			videoMenu = 1
			cursorPosY = 1
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 1 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 14 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 14 then
			moveTxt = (videoMenu - 14) * 15
		elseif cursorPosY == 1 then
			moveTxt = (videoMenu - 1) * 15
		end	
		if #t_videoList <= 14 then
			maxVideos = #t_videoList
		elseif videoMenu - cursorPosY > 0 then
			maxVideos = videoMenu + 14 - cursorPosY
		else
			maxVideos = 14
		end
		animDraw(f_animVelocity(videoBG0, -1, -1))
		animSetScale(videoBG1, 220, maxVideos*15)
		animSetWindow(videoBG1, 80,20, 160,210)
		animDraw(videoBG1)
		textImgDraw(txt_video)
		animSetWindow(cursorBox, 80,5+cursorPosY*15, 160,15)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		for i=1, maxVideos do
			if t_videoList[i].name:len() > 28 then
				VideoText = string.sub(t_videoList[i].name, 1, 24)
				VideoText = tostring(VideoText .. '...')
			else
				VideoText = t_videoList[i].name
			end
			if i > videoMenu - cursorPosY then
				t_videoList[i].id = createTextImg(font2, 0, 1, VideoText, 85, 15+i*15-moveTxt)
				textImgDraw(t_videoList[i].id)
			end
		end
		if maxVideos > 14 then
			animDraw(videoUpArrow)
			animUpdate(videoUpArrow)
		end
		if #t_videoList > 14 and maxVideos < #t_videoList then
			animDraw(videoDownArrow)
			animUpdate(videoDownArrow)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; STORYBOARDS SCREENPACK
--;===========================================================
txt_storyboard = createTextImg(jgFnt, 0, 0, 'STORYBOARD SELECT', 159, 13)

--Scrolling background
storyboardBG0 = animNew(sysSff, [[
100,0, 0,0, -1
]])
animAddPos(storyboardBG0, 160, 0)
animSetTile(storyboardBG0, 1, 1)
animSetColorKey(storyboardBG0, -1)

--Transparent background
storyboardBG1 = animNew(sysSff, [[
3,0, 0,0, -1
]])
animSetPos(storyboardBG1, 20, 20)
animSetAlpha(storyboardBG1, 20, 100)
animUpdate(storyboardBG1)

--Up Arrow
storyboardUpArrow = animNew(sysSff, [[
225,0, 0,0, 10
225,1, 0,0, 10
225,2, 0,0, 10
225,3, 0,0, 10
225,3, 0,0, 10
225,2, 0,0, 10
225,1, 0,0, 10
225,0, 0,0, 10
]])
animAddPos(storyboardUpArrow, 228, 11)
animUpdate(storyboardUpArrow)
animSetScale(storyboardUpArrow, 0.5, 0.5)

--Down Arrow
storyboardDownArrow = animNew(sysSff, [[
226,0, 0,0, 10
226,1, 0,0, 10
226,2, 0,0, 10
226,3, 0,0, 10
226,3, 0,0, 10
226,2, 0,0, 10
226,1, 0,0, 10
226,0, 0,0, 10
]])
animAddPos(storyboardDownArrow, 228, 231)
animUpdate(storyboardDownArrow)
animSetScale(storyboardDownArrow, 0.5, 0.5)

--;===========================================================
--; STORYBOARDS MENU
--;===========================================================
function f_storyboardMenu()
	data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
	cmdInput()
	local cursorPosY = 1
	local moveTxt = 0
	local storyboardMenu = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	t_storyboardList = {}
	for file in lfs.dir[[.\\storyboard\\]] do
		if file:match('^.*(%.)def$') then
			row = #t_storyboardList+1
			t_storyboardList[row] = {}
			t_storyboardList[row]['id'] = ''
			t_storyboardList[row]['name'] = file:gsub('^(.*)[%.]def$', '%1')
			t_storyboardList[row]['path'] = 'storyboard/'..file
		elseif file:match('^.*(%.)DEF$') then
			row = #t_storyboardList+1
			t_storyboardList[row] = {}
			t_storyboardList[row]['id'] = ''
			t_storyboardList[row]['name'] = file:gsub('^(.*)[%.]DEF$', '%1')
			t_storyboardList[row]['path'] = 'storyboard/'..file
		end
	end
	t_storyboardList[#t_storyboardList+1] = {id = '', name = '          BACK'}
	if data.debugLog then f_printTable(t_storyboardList, "save/debug/t_storyboardList.txt") end
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 2)
			break
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			storyboardMenu = storyboardMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			storyboardMenu = storyboardMenu + 1
		elseif btnPalNo(p1Cmd) > 0 then
			if storyboardMenu == #t_storyboardList then
				data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
				sndPlay(sysSnd, 100, 2)
				break
			else
				storyboardFile = (t_storyboardList[storyboardMenu].path)
				cmdInput()
				f_storyboard(storyboardFile)
				data.fadeTitle = f_fadeAnim(50, 'fadein', 'black', fadeSff)
				f_menuMusic()
				while true do
					if esc() or commandGetState(p1Cmd, 'e') then
						sndPlay(sysSnd, 100, 2)
						f_menuMusic()
						break
					elseif btnPalNo(p1Cmd) or (commandGetState(p1Cmd, 'holds') > 0) then
						f_default()
						sndPlay(sysSnd, 100, 2)
						f_menuMusic()
						break
					end
				end				
			end
		end
		if storyboardMenu < 1 then
			storyboardMenu = #t_storyboardList
			if #t_storyboardList > 14 then
				cursorPosY = 14
			else
				cursorPosY = #t_storyboardList
			end
		elseif storyboardMenu > #t_storyboardList then
			storyboardMenu = 1
			cursorPosY = 1
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 1 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 14 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 14 then
			moveTxt = (storyboardMenu - 14) * 15
		elseif cursorPosY == 1 then
			moveTxt = (storyboardMenu - 1) * 15
		end	
		if #t_storyboardList <= 14 then
			maxStoryboards = #t_storyboardList
		elseif storyboardMenu - cursorPosY > 0 then
			maxStoryboards = storyboardMenu + 14 - cursorPosY
		else
			maxStoryboards = 14
		end
		animDraw(f_animVelocity(storyboardBG0, -1, -1))
		animSetScale(storyboardBG1, 220, maxStoryboards*15)
		animSetWindow(storyboardBG1, 80,20, 160,210)
		animDraw(storyboardBG1)
		textImgDraw(txt_storyboard)
		animSetWindow(cursorBox, 80,5+cursorPosY*15, 160,15)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))		
		for i=1, maxStoryboards do
			if t_storyboardList[i].name:len() > 28 then
				storyboardText = string.sub(t_storyboardList[i].name, 1, 24)
				storyboardText = tostring(storyboardText .. '...')
			else
				storyboardText = t_storyboardList[i].name
			end
			if i > storyboardMenu - cursorPosY then
				t_storyboardList[i].id = createTextImg(font2, 0, 1, storyboardText, 85, 15+i*15-moveTxt)
				textImgDraw(t_storyboardList[i].id)
			end
		end
		if maxStoryboards > 14 then
			animDraw(storyboardUpArrow)
			animUpdate(storyboardUpArrow)
		end
		if #t_storyboardList > 14 and maxStoryboards < #t_storyboardList then
			animDraw(storyboardDownArrow)
			animUpdate(storyboardDownArrow)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; REPLAY SCREENPACK
--;===========================================================
txt_replay = createTextImg(jgFnt, 0, 0, 'REPLAY SELECT', 159, 13)
txt_replayData = createTextImg(jgFnt, 0, 0, 'REPLAY OPTIONS', 159, 72)

--Scrolling background
replayBG0 = animNew(sysSff, [[
100,0, 0,0, -1
]])
animAddPos(replayBG0, 160, 0)
animSetTile(replayBG0, 1, 1)
animSetColorKey(replayBG0, -1)

--Transparent background
replayBG1 = animNew(sysSff, [[
3,0, 0,0, -1
]])
animSetPos(replayBG1, 20, 20)
animSetAlpha(replayBG1, 20, 100)
animUpdate(replayBG1)

--Up Arrow
replayUpArrow = animNew(sysSff, [[
225,0, 0,0, 10
225,1, 0,0, 10
225,2, 0,0, 10
225,3, 0,0, 10
225,3, 0,0, 10
225,2, 0,0, 10
225,1, 0,0, 10
225,0, 0,0, 10
]])
animAddPos(replayUpArrow, 228, 11)
animUpdate(replayUpArrow)
animSetScale(replayUpArrow, 0.5, 0.5)

--Down Arrow
replayDownArrow = animNew(sysSff, [[
226,0, 0,0, 10
226,1, 0,0, 10
226,2, 0,0, 10
226,3, 0,0, 10
226,3, 0,0, 10
226,2, 0,0, 10
226,1, 0,0, 10
226,0, 0,0, 10
]])
animAddPos(replayDownArrow, 228, 231)
animUpdate(replayDownArrow)
animSetScale(replayDownArrow, 0.5, 0.5)

--Replay Title Transparent background
replayMenuBG = animNew(sysSff, [[
3,0, 0,0, -1
]])
animSetPos(replayMenuBG, 0, 5)
animSetAlpha(replayMenuBG, 20, 100)
animUpdate(replayMenuBG)

--Replay Option background
replayMenuBG2 = animNew(sysSff, [[
250,0, 0,0,
]])
animSetPos(replayMenuBG2, -13, 77)
animUpdate(replayMenuBG2)
animSetScale(replayMenuBG2, 0.9, 0.9)

--;===========================================================
--; ONLINE REPLAYS MENU
--;===========================================================
t_replayOption = {
	{id = '', text = 'DELETE'}, {id = '', text = 'WATCH'}, {id = '', text = 'RETURN'},
}
for i=1, #t_replayOption do
	t_replayOption[i].id = createTextImg(jgFnt, 0, 0, t_replayOption[i].text, -80+i*120, 172)
end

function f_replayTable()
	t_replayList = {}
	for file in lfs.dir[[.\\replays\\]] do
		if file:match('^.*(%.)replay$') and not file:match('^data.replay$') then
			row = #t_replayList+1
			t_replayList[row] = {}
			t_replayList[row]['id'] = ''
			t_replayList[row]['name'] = file:gsub('^(.*)[%.]replay$', '%1')
			t_replayList[row]['path'] = 'replays/'..file
		elseif file:match('^.*(%.)REPLAY$') and not file:match('^data.replay$') then
			row = #t_replayList+1
			t_replayList[row] = {}
			t_replayList[row]['id'] = ''
			t_replayList[row]['name'] = file:gsub('^(.*)[%.]REPLAY$', '%1')
			t_replayList[row]['path'] = 'replays/'..file
		end
	end
	t_replayList[#t_replayList+1] = {id = '', name = '          BACK'}
	if data.debugLog then f_printTable(t_replayList, "save/debug/t_replayList.txt") end
end

function f_mainReplay()
	data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
	cmdInput()
	local cursorPosY = 1
	local moveTxt = 0
	local mainReplay = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	local exitReplayMenu = false
	netPlayer = 'Host'
	coinSystem = false
	f_replayTable() --Load table
	while true do
		if exitReplayMenu == true then
			onlinegame = false --only for identify purposes
			replaygame = false
			coinSystem = true
			--netPlayer = '' Bloquea el acceso al menu de online en offline dejarlo comentado solo para devs
			assert(loadfile('save/data_sav.lua'))()
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 2)
			break
		end
		if esc() or commandGetState(p1Cmd, 'e') then exitReplayMenu = true
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			mainReplay = mainReplay - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			mainReplay = mainReplay + 1
		elseif btnPalNo(p1Cmd) > 0 then
		--BACK
			if mainReplay == #t_replayList then exitReplayMenu = true
		--OPEN REPLAY CONTROL MENU
			else
				sndPlay(sysSnd, 100, 1)
				txt_replayName = createTextImg(font2, 0, 0, ''.. t_replayList[mainReplay].name ..'', 159.5, 16)--Show Replay Selected Name
				local fileSize = lfs.attributes(t_replayList[mainReplay].path).size --Size Logic
				if fileSize > 1048576 then
					local replaySize = (math.floor(((fileSize/1048576)+0.50)))--Conversion from Bytes to Megabytes
					txt_replaySize = createTextImg(font2, 0, 0, ''..replaySize..'MB', 159.5, 27)
				else
					local replaySize = (math.floor(((fileSize/1024)+0.50)))--Conversion from Bytes to Kilobytes
					txt_replaySize = createTextImg(font2, 0, 0, ''..replaySize..'KB', 159.5, 27)
				end
				local replayOption = 2
				f_confirmReset()
				cmdInput()
				while true do
					if confirmScreen == false then
						if esc() or commandGetState(p1Cmd, 'e') then
							sndPlay(sysSnd, 100, 2)
							break
						elseif commandGetState(p1Cmd, 'r') then
							sndPlay(sysSnd, 100, 0)
							replayOption = replayOption + 1
						elseif commandGetState(p1Cmd, 'l') then
							sndPlay(sysSnd, 100, 0)
							replayOption = replayOption - 1
						end
						if replayOption < 1 then replayOption = 3 elseif replayOption > 3 then replayOption = 1 end
					end
					if btnPalNo(p1Cmd) > 0 then
					--OPEN CONFIRM DELETE REPLAY WINDOW
						if replayOption == 1 then
							sndPlay(sysSnd, 100, 1)
							confirmScreen = true
					--WATCH SELECTED REPLAY
						elseif replayOption == 2 then
							onlinegame = true --only for identify purposes
							replaygame = true
							data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
							sndPlay(sysSnd, 100, 1)
							--Set Default values to prevent desync.
							script.options.f_onlineDefault()
							script.options.f_netsaveCfg()
							enterReplay(t_replayList[mainReplay].path)
							synchronize()
							math.randomseed(sszRandom())
							script.options.f_onlineCfg()
							exitNetPlay()
							exitReplay()
							commandBufReset(p1Cmd, 1)
					--RETURN TO REPLAY SELECT MENU
						elseif replayOption == 3 then
							sndPlay(sysSnd, 100, 2)
							break
						end
					end
					animDraw(f_animVelocity(replayBG0, -1, -1))
				--Draw Replay Title
					animSetScale(replayMenuBG, 324, 74)
					animSetWindow(replayMenuBG, 0,5, 324,27)
					animDraw(replayMenuBG)
					textImgDraw(txt_replayName)
					textImgDraw(txt_replaySize)
					textImgDraw(txt_replayData)
				--Draw Mini Menu BG
					animDraw(replayMenuBG2)
					animUpdate(replayMenuBG2)
				--Draw Replay Option Text
					for i=1, #t_replayOption do
						if i == replayOption + 0 then -- +0 To start center
							textImgSetBank(t_replayOption[i].id, 5)
						else
							textImgSetBank(t_replayOption[i].id, 0)
						end
						textImgDraw(t_replayOption[i].id)
					end
					if confirmScreen == false then
						--Draw Cursor
						animSetWindow(cursorBox, -108+replayOption*120,161, 56,15)
						f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
						animDraw(f_animVelocity(cursorBox, -1, -1))
					end
					if confirmScreen == true then f_confirmMenu() end
					--DELETE SELECTED REPLAY
					if deleteReplay == true then
						os.remove(t_replayList[mainReplay].path)
						t_replayList = nil --Delete the Table
						f_replayTable() --Just reload the table with applied changes
						deleteReplay = false
						break
					end
					animDraw(data.fadeTitle)
					animUpdate(data.fadeTitle)
					cmdInput()
					refresh()
				end
			end
		end
		if mainReplay < 1 then
			mainReplay = #t_replayList
			if #t_replayList > 14 then
				cursorPosY = 14
			else
				cursorPosY = #t_replayList
			end
		elseif mainReplay > #t_replayList then
			mainReplay = 1
			cursorPosY = 1
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 1 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 14 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 14 then
			moveTxt = (mainReplay - 14) * 15
		elseif cursorPosY == 1 then
			moveTxt = (mainReplay - 1) * 15
		end
		if #t_replayList <= 14 then
			maxReplays = #t_replayList
		elseif mainReplay - cursorPosY > 0 then
			maxReplays = mainReplay + 14 - cursorPosY
		else
			maxReplays = 14
		end
		animDraw(f_animVelocity(replayBG0, -1, -1))
		animSetScale(replayBG1, 220, maxReplays*15)
		animSetWindow(replayBG1, 80,20, 160,210)
		animDraw(replayBG1)
		textImgDraw(txt_replay)
		--animSetScale(cursorBox, 160,maxReplays*15) --For Optimized Cursor Box
		animSetWindow(cursorBox, 80,5+cursorPosY*15, 160,15)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		for i=1, maxReplays do
			if t_replayList[i].name:len() > 28 then
				replayText = string.sub(t_replayList[i].name, 1, 24)
				replayText = tostring(replayText .. '...')
			else
				replayText = t_replayList[i].name
			end
			if i > mainReplay - cursorPosY then
				t_replayList[i].id = createTextImg(font2, 0, 1, replayText, 85, 15+i*15-moveTxt)
				textImgDraw(t_replayList[i].id)
			end
		end
		if maxReplays > 14 then
			animDraw(replayUpArrow)
			animUpdate(replayUpArrow)
		end
		if #t_replayList > 14 and maxReplays < #t_replayList then
			animDraw(replayDownArrow)
			animUpdate(replayDownArrow)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; ONLINE MENU
--;===========================================================
t_mainNetplay = {
	{id = textImgNew(), text = 'HOST [CREATE ROOM]'},
	{id = textImgNew(), text = 'CLIENT [JOIN A ROOM]'},
}

function f_mainNetplay()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local mainNetplay = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	local cancel = false
	while true do
		if esc() or commandGetState(p1Cmd, 'e') then
			onlinegame = false --only for identify purposes
			assert(loadfile('save/data_sav.lua'))()
			sndPlay(sysSnd, 100, 2)
			return
		end
		if commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			mainNetplay = mainNetplay - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			mainNetplay = mainNetplay + 1
		end
		if mainNetplay < 1 then
			mainNetplay = #t_mainNetplay
			if #t_mainNetplay > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_mainNetplay-1
			end
		elseif mainNetplay > #t_mainNetplay then
			mainNetplay = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (mainNetplay - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (mainNetplay - 1) * 13
		end
		if #t_mainNetplay <= 5 then
			maxMainNetplay = #t_mainNetplay
		elseif mainNetplay - cursorPosY > 0 then
			maxMainNetplay = mainNetplay + 5 - cursorPosY
		else
			maxMainNetplay = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			sndPlay(sysSnd, 100, 1)
			--HOST (create online room)
			if mainNetplay == 1 then
				onlinegame = true --only for identify purposes
				script.options.f_onlineDefault()
				script.options.f_netsaveCfg()
				data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
				cancel = f_create()
				if not cancel then
					synchronize()
					math.randomseed(sszRandom())
					script.options.f_onlineCfg()
				end
				exitNetPlay()
				exitReplay()
				commandBufReset(p1Cmd, 1)
				f_saveReplay()
			--CLIENT/JOIN (join an existing room)
			elseif mainNetplay == 2 then
				--Default Connection Method
				if data.connectMode == 'Direct' then
					onlinegame = true
					script.options.f_onlineDefault()
					script.options.f_netsaveCfg()
					data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
					cancel = f_directConnect()
					if not cancel then
						synchronize()
						math.randomseed(sszRandom())
						script.options.f_onlineCfg()
					end
					exitNetPlay()
					exitReplay()
					commandBufReset(p1Cmd, 1)
					f_saveReplay()
				--Host info Stored in a Local Database
				elseif data.connectMode == 'Database' then
					f_hostRooms()
				end
			end	
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_mainNetplay do
			if i == mainNetplay then
				bank = 3
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_mainNetplay[i].id, jgFnt, bank, 0, t_mainNetplay[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'ONLINE MODE')
		textImgDraw(txt_version)
		f_sysTime()
		if maxMainNetplay > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_mainNetplay > 6 and maxMainNetplay < #t_mainNetplay then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		exitNetPlay()
    	exitReplay()
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; SAVE ONLINE REPLAY
--;===========================================================
function f_saveReplay()
--Create Replay File
	local netplayFile = io.open("save/data.replay","rb") --Read origin file
	if netplayFile ~= nil then
		if not createExit or not joinExit then
			if lfs.attributes("save/data.replay", "size") > 0 then --Save replay if have content
				ltn12.pump.all(
				ltn12.source.file(assert(io.open("save/data.replay", "rb"))), --Use this file to make a copy
				ltn12.sink.file(assert(io.open("replays/" .. os.date("%Y-%m-%d %I-%M%p") .. ".replay", "wb"))) --Save replay with a new name
				)
			end
			netplayFile:close()
			netplayFile = nil
		end
	end
end

--;===========================================================
--; ONLINE ROOM SCREENPACK
--;===========================================================
txt_hostTitle = createTextImg(jgFnt, 5, 0, 'ONLINE ROOM CREATED', 159, 13)
txt_client = createTextImg(jgFnt, 0, 0, 'Enter Host\'s IPv4', 159, 111)
txt_clientName = createTextImg(jgFnt, 0, 0, 'Enter Host Nickname', 159, 110, 0.9, 0.9)
txt_bar = createTextImg(opFnt, 0, 0, '|', 160, 133, 0.65, 0.65)
txt_ip = createTextImg(font14, 0, 0, '', 160, 132)
txt_netPort = createTextImg(jgFnt, 0, 0, '', 159, 72, 0.9, 0.9)
txt_hosting = createTextImg(jgFnt, 0, 0, '', 159, 228)
txt_connecting = createTextImg(jgFnt, 5, 0, '', 159, 228)
txt_cancel = createTextImg(jgFnt, 1, 0, 'CANCEL(ESC)', 161, 165)

--Scrolling background
onlineBG0 = animNew(sysSff, [[
100,0, 0,0, -1
]])
animAddPos(onlineBG0, 160, 0)
animSetTile(onlineBG0, 1, 1)
animSetColorKey(onlineBG0, -1)

--Transparent background
--onlineBG1 = animNew(sysSff, [[
--3,0, 0,0, -1
--]])
--animSetPos(onlineBG1, 20, 20)
--animSetAlpha(onlineBG1, 20, 100)
--animUpdate(onlineBG1)

--Up Arrow
--onlineUpArrow = animNew(sysSff, [[
--225,0, 0,0, 10
--225,1, 0,0, 10
--225,2, 0,0, 10
--225,3, 0,0, 10
--225,3, 0,0, 10
--225,2, 0,0, 10
--225,1, 0,0, 10
--225,0, 0,0, 10
--]])
--animAddPos(onlineUpArrow, 228, 11)
--animUpdate(onlineUpArrow)
--animSetScale(onlineUpArrow, 0.5, 0.5)

--Down Arrow
--onlineDownArrow = animNew(sysSff, [[
--226,0, 0,0, 10
--226,1, 0,0, 10
--226,2, 0,0, 10
--226,3, 0,0, 10
--226,3, 0,0, 10
--226,2, 0,0, 10
--226,1, 0,0, 10
--226,0, 0,0, 10
--]])
--animAddPos(onlineDownArrow, 228, 231)
--animUpdate(onlineDownArrow)
--animSetScale(onlineDownArrow, 0.5, 0.5)

--IP Window BG
textWindowBG = animNew(sysSff, [[
230,1, 0,0,
]])
animSetPos(textWindowBG, 83.5, 97)
animUpdate(textWindowBG)
animSetScale(textWindowBG, 1, 1)

--Connecting Window BG
joinWindowBG = animNew(sysSff, [[
230,1, 0,0,
]])
animSetPos(joinWindowBG, 83.5, 54)
animUpdate(joinWindowBG)
animSetScale(joinWindowBG, 1, 2)

--Connecting Icon
wirelessBG = animNew(sysSff, [[
400,0, 0,0, 18
400,1, 0,0, 18
400,2, 0,0, 18
400,3, 0,0, 18
400,4, 0,0, 18
400,5, 0,0, 18
400,6, 0,0, 18
]])
animAddPos(wirelessBG, 125, 87.5)
animUpdate(wirelessBG)
animSetScale(wirelessBG, 0.25, 0.25)

--;===========================================================
--; HOST MENU
--;===========================================================
function f_create()
	cmdInput()
	createExit = false
	textImgSetText(txt_hosting, 'Waiting for Player 2...')
	enterNetPlay(inputDialogGetStr(inputdia))
	netPlayer = 'Host' --For Replay Identify
	setDiscordState("Waiting Players")
	--if waitingRoom == 'Training' then
		--data.p1In = 1
		--f_practiceMenu() --Try to Wait client in Training Mode
	--end
	while not connected() do
		if esc() or commandGetState(p1Cmd, 'e') then --btnPalNo(p1Cmd) > 0 does not work when engine is waiting a connection, only esc, that's why still we can't program an Training Waiting Room
		    data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 2)
			netPlayer = ''
			setDiscordState("In Main Menu")
			return true
		end
		--Draw BG
		animDraw(f_animVelocity(onlineBG0, -1, -1))
		--Draw Menu Title
		textImgDraw(txt_hostTitle)
		--Draw Window BG
		animDraw(joinWindowBG)
		animUpdate(joinWindowBG)
		--Draw Port Info
		textImgSetText(txt_netPort, 'Netplay Port ['..getListenPort()..']')
		textImgDraw(txt_netPort)
		--Draw Cancel Button
		textImgDraw(txt_cancel)
		--Draw Cursor
		animSetWindow(cursorBox, 87,155, 144,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		--Draw Hosting Info
		textImgDraw(txt_hosting)
		--Draw Animated Icon
		animDraw(wirelessBG)
		animUpdate(wirelessBG)
		cmdInput()
		refresh()
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
	end
	return false
end

--;===========================================================
--; DIRECT CONNECTION MENU
--;===========================================================
t_directJoinMenu = {
	{id = textImgNew(), text = 'BACK'}, {id = textImgNew(), text = 'JOIN'},
}
for i=1, #t_directJoinMenu do
	t_directJoinMenu[i].id = createTextImg(jgFnt, 0, 0, t_directJoinMenu[i].text, 12+i*95, 151)
end

function f_directConnect()
	txt_clientTitle = createTextImg(jgFnt, 0, 0, 'SEARCH ROOM', 159, 13)
	local ip = ''
	local doneIP = false
	local directJoinMenu = 2
	local i = 0
	joinExit = false
	cmdInput()
	--ENTER IP SCREEN
	while true do
		--EXIT LOGIC
		if joinExit == true then
			clearInputText()
			netPlayer = ''
			sndPlay(sysSnd, 100, 2)
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			return true
		end
		--MAIN SCREEN
		if not doneIP then
			if esc() then
				joinExit = true
			elseif commandGetState(p1Cmd, 'r') then
				sndPlay(sysSnd, 100, 0)
				directJoinMenu = directJoinMenu + 1
			elseif commandGetState(p1Cmd, 'l') then
				sndPlay(sysSnd, 100, 0)
				directJoinMenu = directJoinMenu - 1
			end
			if directJoinMenu < 1 then directJoinMenu = 2 elseif directJoinMenu > 2 then directJoinMenu = 1 end
			ip = inputText('num',true)
			if clipboardPaste() then
				if string.match(getClipboardText(),'^%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?$') then
					setInputText(getClipboardText())
				elseif string.match(getClipboardText(),'^localhost$') then
					setInputText(getClipboardText())
				else
					sndPlay(sysSnd, 100, 5)
				end
			end
			if ip:match('^%.') then
				ip = ''
				setInputText(ip)
			elseif ip:len() > 15 then
				ip = ip:sub(1,15)
				setInputText(ip)
			elseif ip:match('%.%.+') then
				ip = ip:gsub('%.%.+','.')
				setInputText(ip)
			elseif ip:match('%d%d%d%d+') then
				ip = ip:gsub('(%d%d%d)%d+','%1')
				setInputText(ip)
			elseif ip:match('%d+%.%d+%.%d+%.%d+%.') then
				ip = ip:gsub('(%d+%.%d+%.%d+%.%d+)%.','%1')
				setInputText(ip)
			end
			--BUTTON SELECT
			if btnPalNo(p1Cmd) > 0 then
				--BACK
				if directJoinMenu == 1 then
					joinExit = true
				--JOIN
				elseif directJoinMenu == 2 then
					if ip:match('^%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?$') then
						doneIP = true
					elseif ip:match('^localhost$') then
						doneIP = true
					else
						sndPlay(sysSnd, 100, 5)
					end
				end
			end
			--Draw BG
			animDraw(f_animVelocity(onlineBG0, -1, -1))
			--Draw Menu Title
			textImgDraw(txt_clientTitle)
			--Draw IP Window BG
			animDraw(textWindowBG)
			animUpdate(textWindowBG)
			--Draw IP Window Title
			textImgDraw(txt_client)
			--Draw IP Text
			textImgSetText(txt_ip,ip)
			textImgDraw(txt_ip)
			if i%60 < 30 then
				textImgPosDraw(txt_bar, 160+(textImgGetWidth(txt_ip)*0.5)+(textImgGetWidth(txt_ip)>0 and 2 or 0), 134)
			end
			--Draw Button Option Text
			for i=1, #t_directJoinMenu do
				if i == directJoinMenu then
					textImgSetBank(t_directJoinMenu[i].id, 5)
				else
					textImgSetBank(t_directJoinMenu[i].id, 0)
				end
				textImgDraw(t_directJoinMenu[i].id)
			end
			--Draw Cursor
			animSetWindow(cursorBox, -9+directJoinMenu*96,141, 48.5,13)
			f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
			animDraw(f_animVelocity(cursorBox, -1, -1))
		end
		i = i >= 60 and 0 or i + 1
		if doneIP then break end --Exit for this bucle to start connecting
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
	--CONNECTING SCREEN
	sndPlay(sysSnd, 100, 1)
	enterNetPlay(ip) --Connect to entered IP address
	netPlayer = 'Client'
	textImgSetText(txt_connecting, 'Now connecting to ['..ip..']')
	setDiscordState("Searching Room")
	while not connected() do
		--CANCEL CONNECTION
		if esc() or commandGetState(p1Cmd, 'e') then
			clearInputText()
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 2)
			netPlayer = ''
			setDiscordState("In Main Menu")
			joinExit = true
			return true
		end
		--Draw Connecting BG
		animDraw(f_animVelocity(onlineBG0, -1, -1))
		--Draw Connecting Menu Title
		textImgSetText(txt_clientTitle, 'SEARCHING HOST ROOM')
		textImgDraw(txt_clientTitle)
		--Draw Window BG
		animDraw(joinWindowBG)
		animUpdate(joinWindowBG)
		--Draw Port Info
		textImgSetText(txt_netPort, 'Netplay Port ['..getListenPort()..']')
		textImgDraw(txt_netPort)
		--Draw Connecting Info
		textImgDraw(txt_connecting)
		--Draw Cancel Button
		textImgDraw(txt_cancel)
		--Draw Cursor
		animSetWindow(cursorBox, 87,155, 144,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		--Draw Animated Icon
		animDraw(wirelessBG)
		animUpdate(wirelessBG)
		cmdInput()
		refresh()
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
	end
	clearInputText()
	return false
end

--;===========================================================
--; HOST ROOMS MENU
--;===========================================================
function f_hostTable()
	local file = io.open("save/host_rooms.json","r")
	host_rooms = json.decode(file:read("*all"))
	file:close()
	t_hostList = {{id = textImgNew(), text = 'ADD NEW ROOM'},}
	for k, v in pairs(host_rooms.IP) do
		t_hostList[#t_hostList + 1] = {id = textImgNew(), text = k, address = v} --Insert Room Names from Local Database
	end
	t_hostList[#t_hostList+1] = {id = textImgNew(), text = 'BACK'}
end

function f_hostRooms()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local hostList = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	local t_tmp = {}
	f_hostTable()
	f_editHostReset()
	f_crudHostReset()
	--local cancel = false
	while true do
		if editHostScreen == false and crudHostScreen == false then
			if esc() or commandGetState(p1Cmd, 'e') then
				--onlinegame = false
				--assert(loadfile('save/data_sav.lua'))()
				sndPlay(sysSnd, 100, 2)
				break
				--return
			end
			if commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
				sndPlay(sysSnd, 100, 0)
				hostList = hostList - 1
			elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
				sndPlay(sysSnd, 100, 0)
				hostList = hostList + 1
			end
			if hostList < 1 then
				hostList = #t_hostList
				if #t_hostList > 5 then
					cursorPosY = 5
				else
					cursorPosY = #t_hostList-1
				end
			elseif hostList > #t_hostList then
				hostList = 1
				cursorPosY = 0
			elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
				cursorPosY = cursorPosY - 1
			elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
				cursorPosY = cursorPosY + 1
			end
			if cursorPosY == 5 then
				moveTxt = (hostList - 6) * 13
			elseif cursorPosY == 0 then
				moveTxt = (hostList - 1) * 13
			end
			if #t_hostList <= 5 then
				maxhostList = #t_hostList
			elseif hostList - cursorPosY > 0 then
				maxhostList = hostList + 5 - cursorPosY
			else
				maxhostList = 5
			end
			if btnPalNo(p1Cmd) > 0 then
				f_default()
				--ADD NEW HOST ADDRESS
				if hostList == 1 then
					sndPlay(sysSnd, 100, 1)
					editHostScreen = true
				--BACK
				elseif hostList == #t_hostList then
					sndPlay(sysSnd, 100, 2)
					--onlinegame = false
					--assert(loadfile('save/data_sav.lua'))()
					break
				--OPEN CRUD MENU
				else
					sndPlay(sysSnd, 100, 1)
					crudHostScreen = true
				end
			end
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_hostList do
			if i == hostList then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_hostList[i].id, jgFnt, bank, 0, t_hostList[i].text, 159, 142+i*13-moveTxt))
		end
		if editHostScreen == false and crudHostScreen == false then
			animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
			f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
			animDraw(f_animVelocity(cursorBox, -1, -1))
		end
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		if editHostScreen == false then
			textImgDraw(txt_gameFt)
			textImgSetText(txt_gameFt, 'HOST ROOMS')
			textImgDraw(txt_version)
		end
		f_sysTime()
		if crudHostScreen == false then
			if maxhostList > 6 then
				animDraw(arrowsU)
				animUpdate(arrowsU)
			end
			if #t_hostList > 6 and maxhostList < #t_hostList then
				animDraw(arrowsD)
				animUpdate(arrowsD)
			end
		end
		textBar = textBar >= 60 and 0 or textBar + 1
	--CRUD ACTIONS
		hostRoomName = (t_hostList[hostList].text) --Host Name Selected
		hostIP = (t_hostList[hostList].address) --Host IP Address Selected
		if crudHostScreen == true then f_crudHostScreen() end
		if editHostScreen == true then f_editHost() end
	--READ DATA
		if crudHostOption == 2 then
			f_crudHostReset()
			onlinegame = true
			script.options.f_onlineDefault()
			script.options.f_netsaveCfg()
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			cancel = f_databaseConnect()
			if not cancel then
				synchronize()
				math.randomseed(sszRandom())
				script.options.f_onlineCfg()
			end
			exitNetPlay()
			exitReplay()
			commandBufReset(p1Cmd, 1)
			f_saveReplay()
	--UPDATE DATA
		elseif crudHostOption == 3 then
			f_crudHostReset()
			editHostRoom = true --To Update Data
			editHostScreen = true
	--DELETE DATA
		elseif crudHostOption == 1 then
			f_confirmMenu()
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		--exitNetPlay()
    	--exitReplay()
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; CRUD MENU
--;===========================================================
--CRUD Window BG
crudHostWindowBG = animNew(sysSff, [[
230,1, 0,0,
]])
animSetPos(crudHostWindowBG, 60.5, 145)
animUpdate(crudHostWindowBG)
animSetScale(crudHostWindowBG, 1.3, 1.3)

t_crudHostOptionU = {{id = '', text = 'DELETE'},{id = '', text = 'JOIN'},}
t_crudHostOptionD = {{id = '', text = 'EDIT'}, {id = '', text = 'RETURN'},}

function f_crudHostScreen()
	if crudHostOption ~= 1 then
		cmdInput()
		--Cursor Logic
		if commandGetState(p1Cmd, 'u') then
			sndPlay(sysSnd, 100, 0)
			crudHostRow = crudHostRow - 1
			crudHostCursorU = crudHostCursorD
		elseif commandGetState(p1Cmd, 'd') then
			sndPlay(sysSnd, 100, 0)
			crudHostRow = crudHostRow + 1
			crudHostCursorD = crudHostCursorU
		end
		if crudHostRow < 1 then
			crudHostRow = 2
		elseif crudHostRow > 2 then
			crudHostRow = 1
		end
		if crudHostRow == 1 then
			if commandGetState(p1Cmd, 'l') then
				sndPlay(sysSnd, 100, 0)
				crudHostCursorU = crudHostCursorU - 1
				crudHostCursorD = crudHostCursorD - 1
			elseif commandGetState(p1Cmd, 'r') then
				sndPlay(sysSnd, 100, 0)
				crudHostCursorU = crudHostCursorU + 1
				crudHostCursorD = crudHostCursorD + 1
			end
		elseif crudHostRow == 2 then
			if commandGetState(p1Cmd, 'l') then
				sndPlay(sysSnd, 100, 0)
				crudHostCursorD = crudHostCursorD - 1
				crudHostCursorU = crudHostCursorU - 1
			elseif commandGetState(p1Cmd, 'r') then
				sndPlay(sysSnd, 100, 0)
				crudHostCursorD = crudHostCursorD + 1
				crudHostCursorU = crudHostCursorU + 1
			end
		end
		if crudHostCursorU < 1 then
			crudHostCursorU = #t_crudHostOptionU
		elseif crudHostCursorU > #t_crudHostOptionU then
			crudHostCursorU = 1
		end
		if crudHostCursorD < 1 then
			crudHostCursorD = #t_crudHostOptionD
		elseif crudHostCursorD > #t_crudHostOptionD then
			crudHostCursorD = 1
		end
		--ACTIONS
		if esc() or commandGetState(p1Cmd, 'e') then
			sndPlay(sysSnd, 100, 2)
			f_crudHostReset()
		--BUTTON SELECTED
		elseif btnPalNo(p1Cmd) > 0 then
			--DELETE HOST ADDRESS
			if crudHostCursorU == 1 and crudHostRow == 1 then
				sndPlay(sysSnd, 100, 1)
				f_confirmReset()
				crudHostOption = 1
			--JOIN TO HOST ADDRESS
			elseif crudHostCursorU == 2 and crudHostRow == 1 then
				sndPlay(sysSnd, 100, 1)
				crudHostOption = 2
				crudHostScreen = false
			--EDIT HOST ADDRESS
			elseif crudHostCursorD == 1 and crudHostRow == 2 then
				sndPlay(sysSnd, 100, 1)
				crudHostOption = 3
				crudHostScreen = false
			--BACK
			elseif crudHostCursorD == 2 and crudHostRow == 2 then
				sndPlay(sysSnd, 100, 2)
				f_crudHostReset()
			end
		end
	end
	--Draw Crud Window BG
	animDraw(crudHostWindowBG)
	animUpdate(crudHostWindowBG)
	--Draw Crud Title
	txt_crudTitle = createTextImg(font6, 0, 0, ''..hostRoomName..' ROOM', 160, 167.5)
	textImgDraw(txt_crudTitle)
	--Draw Crud Menu Text
	for i=1, #t_crudHostOptionU do
		if i == crudHostCursorU and crudHostRow == 1 then
			bank = 5
		else
			bank = 0
		end
		t_crudHostOptionU[i].id = createTextImg(jgFnt, bank, 0, t_crudHostOptionU[i].text, 12+i*100, 190)
		textImgDraw(t_crudHostOptionU[i].id)
	end
	for i=1, #t_crudHostOptionD do
		if i == crudHostCursorD and crudHostRow == 2 then
			bank = 5
		else
			bank = 0
		end
		t_crudHostOptionD[i].id = createTextImg(jgFnt, bank, 0, t_crudHostOptionD[i].text, 12+i*100, 210)
		textImgDraw(t_crudHostOptionD[i].id)
	end
	if crudHostOption ~= 1 then
		--Draw Cursors
		if crudHostRow == 1 then
			animSetWindow(cursorBox, -16+crudHostCursorU*100,178, 55,16)
			f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
			animDraw(f_animVelocity(cursorBox, -1, -1))
		elseif crudHostRow == 2 then
			animSetWindow(cursorBox, -16+crudHostCursorD*100,198, 55,16)
			f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
			animDraw(f_animVelocity(cursorBox, -1, -1))
		end
	end
end

function f_crudHostReset()
	crudHostScreen = false
	crudHostOption = 0
	--Cursor pos in JOIN
	crudHostRow = 1
	crudHostCursorU = 2
	crudHostCursorD = 2
end

--;===========================================================
--; CREATE/UPDATE HOST DATA
--;===========================================================
t_editOption = {
	{id = textImgNew(), text = ' CANCEL'}, {id = textImgNew(), text = '  ENTER'},
}
for i=1, #t_editOption do
	t_editOption[i].id = createTextImg(jgFnt, 0, 0, t_editOption[i].text, 12+i*95, 151)
end

function f_editHost()
	cmdInput()
	--ENTER HOST NAME
	if not doneName then
		if commandGetState(p1Cmd, 'r') then
			sndPlay(sysSnd, 100, 0)
			editHostMenu = editHostMenu + 1
		elseif commandGetState(p1Cmd, 'l') then
			sndPlay(sysSnd, 100, 0)
			editHostMenu = editHostMenu - 1
		end
		if editHostMenu < 1 then editHostMenu = 2 elseif editHostMenu > 2 then editHostMenu = 1 end
		editHostName = inputText('',true)
		if clipboardPaste() then
			if string.match(getClipboardText(),'^(.*)') then
				setInputText(getClipboardText())
			else
				sndPlay(sysSnd, 100, 5)
			end
		end
		if editHostName:len() > 5 then
			editHostName = editHostName:sub(1,16)
			setInputText(editHostName)
		end
		if editHostName ~= '' and editHostName ~= nil then
			if editHostName:match('^"*(%")$') then
				editHostName = editHostName:gsub('^("*)[%"]$','%1')
				setInputText(editHostName)
			end
		end
		--ACTIONS
		if esc() then
			sndPlay(sysSnd, 100, 2)
			f_editHostReset()
		elseif commandGetState(p1Cmd, 'w') then
			--BACK
			if editHostMenu == 1 then
				sndPlay(sysSnd, 100, 2)
				f_editHostReset()
			--SAVE NAME
			elseif editHostMenu == 2 then
				if editHostName ~= '' and editHostName ~= nil then
					clearInputText()
					sndPlay(sysSnd, 100, 1)
					hostName = (tostring(editHostName))
					doneName = true
				else
					sndPlay(sysSnd, 100, 5)
				end
			end
		end
		--Draw Fade BG
		animDraw(fadeWindowBG)
		--Draw Name Window BG
		animDraw(textWindowBG)
		animUpdate(textWindowBG)
		--Draw Name Window Title
		textImgDraw(txt_clientName)
		--Draw Name Text
		textImgSetText(txt_ip,editHostName)
		textImgDraw(txt_ip)
		if textBar%60 < 30 then
			textImgPosDraw(txt_bar, 160+(textImgGetWidth(txt_ip)*0.5)+(textImgGetWidth(txt_ip)>0 and 2 or 0), 134)
		end
		--Draw Button Option Text
		for i=1, #t_editOption do
			if i == editHostMenu then
				textImgSetBank(t_editOption[i].id, 5)
			else
				textImgSetBank(t_editOption[i].id, 0)
			end
			textImgDraw(t_editOption[i].id)
		end
		--Draw Cursor
		animSetWindow(cursorBox, -9+editHostMenu*96,141, 48.5,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		--Draw Hint Info
		textImgDraw(txt_titleFt)
		textImgSetText(txt_titleFt, 'COPIED TEXT CAN BE PASTED WITH CTRL V')
	--ENTER HOST IP ADDRESS
	else
		if commandGetState(p1Cmd, 'r') then
			sndPlay(sysSnd, 100, 0)
			editHostMenu = editHostMenu + 1
		elseif commandGetState(p1Cmd, 'l') then
			sndPlay(sysSnd, 100, 0)
			editHostMenu = editHostMenu - 1
		end
		if editHostMenu < 1 then editHostMenu = 2 elseif editHostMenu > 2 then editHostMenu = 1 end
		hostAddress = inputText('num',true)
		if clipboardPaste() then
			if string.match(getClipboardText(),'^%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?$') then
				setInputText(getClipboardText())
			elseif string.match(getClipboardText(),'^localhost$') then
				setInputText(getClipboardText())
			else
				sndPlay(sysSnd, 100, 5)
			end
		end
		if hostAddress:match('^%.') then
			hostAddress = ''
			setInputText(hostAddress)
		elseif hostAddress:len() > 15 then
			hostAddress = hostAddress:sub(1,15)
			setInputText(hostAddress)
		elseif hostAddress:match('%.%.+') then
			hostAddress = hostAddress:gsub('%.%.+','.')
			setInputText(hostAddress)
		elseif hostAddress:match('%d%d%d%d+') then
			hostAddress = hostAddress:gsub('(%d%d%d)%d+','%1')
			setInputText(hostAddress)
		elseif hostAddress:match('%d+%.%d+%.%d+%.%d+%.') then
			hostAddress = hostAddress:gsub('(%d+%.%d+%.%d+%.%d+)%.','%1')
			setInputText(hostAddress)
		end
		--ACTIONS
		if esc() then
			sndPlay(sysSnd, 100, 2)
			f_editHostReset()
		--BUTTON SELECTED
		elseif btnPalNo(p1Cmd) > 0 then
			--BACK
			if editHostMenu == 1 then
				sndPlay(sysSnd, 100, 2)
				f_editHostReset()
			--ENTER IP
			elseif editHostMenu == 2 then
				if hostAddress:match('^%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?$') then
					doneAddress = true
				elseif hostAddress:match('^localhost$') then
					doneAddress = true
				else
					sndPlay(sysSnd, 100, 5)
				end
			end
		end
		--Draw Fade BG
		animDraw(fadeWindowBG)
		--Draw IP Window BG
		animDraw(textWindowBG)
		animUpdate(textWindowBG)
		--Draw IP Window Title
		textImgSetText(txt_client, 'Enter Host\'s IPv4')
		textImgDraw(txt_client)
		--Draw IP Text
		textImgSetText(txt_ip,hostAddress)
		textImgDraw(txt_ip)
		if textBar%60 < 30 then
			textImgPosDraw(txt_bar, 160+(textImgGetWidth(txt_ip)*0.5)+(textImgGetWidth(txt_ip)>0 and 2 or 0), 134)
		end
		--Draw Button Option Text
		for i=1, #t_editOption do
			if i == editHostMenu then
				textImgSetBank(t_editOption[i].id, 5)
			else
				textImgSetBank(t_editOption[i].id, 0)
			end
			textImgDraw(t_editOption[i].id)
		end
		--Draw Cursor
		animSetWindow(cursorBox, -9+editHostMenu*96,141, 48.5,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		--Draw Hint Info
		textImgDraw(txt_titleFt)
		textImgSetText(txt_titleFt, 'COPIED IP CAN BE PASTED WITH CTRL V')
	end
	--SAVE ALL DATA
	if doneAddress == true then
		sndPlay(sysSnd, 100, 1)
		if editHostRoom == true then host_rooms.IP[hostRoomName] = nil end --To Update Data
		host_rooms.IP[hostName] = hostAddress
		t_tmp = {}
		for i = 1, #t_hostList do
			if i < #t_hostList then
				t_tmp[i] = t_hostList[i]
			else
				t_tmp[i] = {id = textImgNew(), text = hostName, address = hostAddress}
				t_tmp[i + 1] = t_hostList[i]
			end
		end
		t_hostList = t_tmp
		local file = io.open("save/host_rooms.json","w+")
		file:write(json.encode(host_rooms, {indent = true}))
		file:close()
		f_hostTable() --Refresh
		f_editHostReset()
	end
	cmdInput()
end

function f_editHostReset()
	clearInputText()
	editHostScreen = false
	editHostRoom = false
	doneAddress = false
	doneName = false
	editHostName = ''
	hostAddress = ''
	textBar = 0
	editHostMenu = 2 --Cursor pos in ENTER
end

--;===========================================================
--; READ LOCAL DATABASE TO CONNECTING MENU
--;===========================================================
function f_databaseConnect()
	cmdInput()
	sndPlay(sysSnd, 100, 1)
	joinExit = false
	txt_clientTitle = createTextImg(jgFnt, 0, 0, ""..hostRoomName.."'s ROOM", 159, 13)
	enterNetPlay(hostIP) --Connect to entered IP address
	netPlayer = 'Client'
	textImgSetText(txt_connecting, 'Now connecting to ['..hostIP..']')
	while not connected() do
		--CANCEL CONNECTION
		if esc() or commandGetState(p1Cmd, 'e') then
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 2)
			netPlayer = ''
			joinExit = true
			return true
		end
		--Draw Connecting BG
		animDraw(f_animVelocity(onlineBG0, -1, -1))
		--Draw Connecting Title
		textImgDraw(txt_clientTitle)
		--Draw Window BG
		animDraw(joinWindowBG)
		animUpdate(joinWindowBG)
		--Draw Port Info
		textImgSetText(txt_netPort, 'Netplay Port ['..getListenPort()..']')
		textImgDraw(txt_netPort)
		--Draw Connecting Info
		textImgDraw(txt_connecting)
		--Draw Cancel Button
		textImgDraw(txt_cancel)
		--Draw Cursor
		animSetWindow(cursorBox, 87,155, 144,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		--Draw Animated Icon
		animDraw(wirelessBG)
		animUpdate(wirelessBG)
		cmdInput()
		refresh()
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
	end
	return false
end

--;===========================================================
--; LOBBY MENU
--;===========================================================
t_mainLobby = {
	{id = textImgNew(), text = ''},
	{id = textImgNew(), text = 'PRACTICE'},
	{id = textImgNew(), text = 'ARCADE'},
	{id = textImgNew(), text = 'SURVIVAL'},
	{id = textImgNew(), text = 'ENDLESS'},
	{id = textImgNew(), text = 'BOSS RUSH'},
	{id = textImgNew(), text = 'BONUS RUSH'},
	{id = textImgNew(), text = 'SUDDEN DEATH'},
	{id = textImgNew(), text = 'TIME ATTACK'},
	{id = textImgNew(), text = 'ONLINE SETTINGS'},
}

function f_mainLobby()
	cmdInput()
	local cursorPosY = 0
	local moveTxt = 0
	local mainLobby = 1
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	local cancel = false
	setDiscordState("Playing Online")
	while true do
		--assert(loadfile('save/temp_sav.lua'))()
		if esc() or commandGetState(p1Cmd, 'e') or data.replayDone == true then
			sndPlay(sysSnd, 100, 2)
			data.replayDone = false
			f_saveTemp()
			break
		end
		if commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			mainLobby = mainLobby - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			mainLobby = mainLobby + 1
		end
		if mainLobby < 1 then
			mainLobby = #t_mainLobby
			if #t_mainLobby > 5 then
				cursorPosY = 5
			else
				cursorPosY = #t_mainLobby-1
			end
		elseif mainLobby > #t_mainLobby then
			mainLobby = 1
			cursorPosY = 0
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 0 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 5 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 5 then
			moveTxt = (mainLobby - 6) * 13
		elseif cursorPosY == 0 then
			moveTxt = (mainLobby - 1) * 13
		end
		if #t_mainLobby <= 5 then
			maxmainLobby = #t_mainLobby
		elseif mainLobby - cursorPosY > 0 then
			maxmainLobby = mainLobby + 5 - cursorPosY
		else
			maxmainLobby = 5
		end
		if btnPalNo(p1Cmd) > 0 then
			f_default()
			if replaygame == true then setGameMode('replay') end
			data.p2In = 2
			data.p2Faces = true
			data.coop = true
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 1)
			--ONLINE VERSUS
			if mainLobby == 1 then
				data.coop = false
				data.stageMenu = true
				setHomeTeam(1)
				data.gameMode = 'versus'
				data.rosterMode = 'versus'
				if data.ftcontrol > 0 then
					textImgSetText(txt_mainSelect, 'ONLINE RANKED VERSUS')
				else
					textImgSetText(txt_mainSelect, 'ONLINE VERSUS')
				end
				script.select.f_selectSimple()
			--ONLINE TRAINING
			elseif mainLobby == 2 then
				setRoundTime(-1)
				data.p1TeamMenu = {mode = 0, chars = 1}
				data.p2TeamMenu = {mode = 0, chars = 1}
				data.coop = false
				data.stageMenu = true
				data.versusScreen = false
				data.gameMode = 'training'
				data.rosterMode = 'training'
				setGameType(2)
				textImgSetText(txt_mainSelect, 'ONLINE TRAINING')
				script.select.f_selectSimple()
			--ONLINE ARCADE	
			elseif mainLobby == 3 then
				data.serviceScreen = true
				data.gameMode = 'arcade'
				data.rosterMode = 'arcade'
				textImgSetText(txt_mainSelect, 'ONLINE ARCADE COOPERATIVE')
                script.select.f_selectAdvance()
			--ONLINE SURVIVAL	
			elseif mainLobby == 4 then
				data.gameMode = 'survival'
				data.rosterMode = 'survival'
				textImgSetText(txt_mainSelect, 'ONLINE SURVIVAL COOPERATIVE')
				script.select.f_selectAdvance()
			--ONLINE ENDLESS
			elseif mainLobby == 5 then
				data.gameMode = 'endless'
				data.rosterMode = 'endless'
				textImgSetText(txt_mainSelect, 'ONLINE ENDLESS COOPERATIVE')
				script.select.f_selectAdvance()
			--ONLINE BOSS RUSH
			elseif mainLobby == 6 then
				if #t_bossChars ~= 0 then
					data.gameMode = 'bossrush'
					data.rosterMode = 'boss'
					textImgSetText(txt_mainSelect, 'ONLINE BOSS RUSH COOPERATIVE')
					script.select.f_selectAdvance()
				end	
			--ONLINE BONUS RUSH
			elseif mainLobby == 7 then
				if #t_bonusChars ~= 0 then
					data.versusScreen = false
					data.gameMode = 'bonusrush'
					data.rosterMode = 'bonus'
					textImgSetText(txt_mainSelect, 'ONLINE BONUS RUSH COOPERATIVE')
					script.select.f_selectAdvance()
				end	
			--ONLINE SUDDEN DEATH
			elseif mainLobby == 8 then
				setRoundTime(1000)
				setLifeMul(0)
				data.gameMode = 'allroster'
				data.rosterMode = 'suddendeath'
				textImgSetText(txt_mainSelect, 'ONLINE SUDDEN DEATH COOPERATIVE')
				script.select.f_selectAdvance()				
			--ONLINE TIME ATTACK
			elseif mainLobby == 9 then
				setRoundTime(3600)
				setLifeMul(2)
				data.gameMode = 'allroster'
				data.rosterMode = 'timeattack'
				textImgSetText(txt_mainSelect, 'ONLINE TIME ATTACK COOPERATIVE')
				script.select.f_selectAdvance()				
			--ONLINE SETTINGS
			elseif mainLobby == 10 then
				script.options.f_onlineCfg()
			end			
		end
		animDraw(f_animVelocity(titleBG0, -2.15, 0))
		for i=1, #t_mainLobby do
			if i == mainLobby then
				bank = 5
			else
				bank = 0
			end
			textImgDraw(f_updateTextImg(t_mainLobby[i].id, jgFnt, bank, 0, t_mainLobby[i].text, 159, 142+i*13-moveTxt))
		end
		animSetWindow(cursorBox, 0,145+cursorPosY*13, 316,13)
		f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		animDraw(f_animVelocity(cursorBox, -1, -1))
		animDraw(titleBG1)
		animAddPos(titleBG2, -1, 0)
		animUpdate(titleBG2)
		animDraw(titleBG2)
		animDraw(titleBG3)
		animDraw(titleBG4)
		animDraw(titleBG5)
		animDraw(titleBG6)
		f_titleText()
		textImgDraw(txt_gameFt)
		textImgSetText(txt_gameFt, 'ONLINE MENU')
		textImgDraw(txt_version)
		f_sysTime()
		if netPlayer == 'Host' then
			t_mainLobby[1].text = 'VERSUS PLAYER 2'
		elseif netPlayer == 'Client' then
			t_mainLobby[1].text = 'VERSUS PLAYER 1'
		end
		if maxmainLobby > 6 then
			animDraw(arrowsU)
			animUpdate(arrowsU)
		end
		if #t_mainLobby > 6 and maxmainLobby < #t_mainLobby then
			animDraw(arrowsD)
			animUpdate(arrowsD)
		end
		if commandGetState(p1Cmd, 'holdu') then
			bufd = 0
			bufu = bufu + 1
		elseif commandGetState(p1Cmd, 'holdd') then
			bufu = 0
			bufd = bufd + 1
		else
			bufu = 0
			bufd = 0
		end
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)		
		cmdInput()
		refresh()
	end
end

--;===========================================================
--; THE VAULT SCREENPACK
--;===========================================================
txt_vaultTitle = createTextImg(font6, 0, 0, 'THE VAULT', 159, 28)
txt_vaultBar = createTextImg(opFnt, 0, 0, '|', 160, 130, 0.65, 0.65)
txt_vaultText = createTextImg(font14, 0, 0, '', 160, 117)

--Background
vaultBG0 = animNew(sysSff, [[
2000,1, 0,0,
]])
animSetPos(vaultBG0, 160, 119)
animUpdate(vaultBG0)
animSetScale(vaultBG0, 0.30, 0.305)

--Text Window BG
vaultWindowBG = animNew(sysSff, [[
3,0, 0,0, -1
]])
animSetPos(vaultWindowBG, 20, 100)
animSetAlpha(vaultWindowBG, 20, 100)
animUpdate(vaultWindowBG)

--;===========================================================
--; THE VAULT MENU
--;===========================================================
t_vaultMenu = {
	{id = textImgNew(), text = 'BACK'}, {id = textImgNew(), text = 'ENTER'},
}
for i=1, #t_vaultMenu do
	t_vaultMenu[i].id = createTextImg(jgFnt, 0, 0, t_vaultMenu[i].text, 56+i*70, 230)
end

function f_randomWords()
	txt_vaultWords = createTextImg(jgFnt, 0, 0, '', 0, 0,0.9,0.9)
	local t_randomWord = {"Don't touch!", "Just, stop.", "No one seems to be home.", "zzzZZZ...", "Go away!", "No!", "It's a secret...", "Stop it!", "Not allowed!", "Nothing to see here...", '"CD3" is a joke alias of evil CD2.', "Ready to leave yet?", "Whenever you're ready...", "Fine, I can wait.", "So... what's up?", "Are you always like this?", "I mean, what's the point?", "Let me guess, you're gonna push the button?", "What a surprise...", "Don't push the button!", "I'm gonna stop talking", "...", "......", "GAH!", "I have heard about you "..data.userName..".", "Do you know what name of this Ikemen Plus was going to be?", "It was actually going to be called Ikemen Plus ???", "Zen is the search for enlightenment", "SSZ is a programming language written by Suehiro", "OpenGL? what's that?", "Who would thought that Ikemen Go had a Plus Version", "Go beyond, plus ULTRA!", "PlasmoidThunder? he is one of the greats devs", "If I could have access to an internet database...", "CD2 likes Geometry Dash so much that it occurred to him to imitate this screen", "I am a Legend?", "This is not supposed to be here but yes in the USX Project..", "I debuted in v1.3 of Ikemen Plus Ultra", "Is CD2 really planning to make all those changes from it TODO List?", "Did you know that this guy who programmed me started learning this in 2021?", "Let's play hangman S- _ _ _ E", "Let's play hangman U _ _ R _", "Let's play hangman _ _ N", "Press Start To Select an Option", "You can Write below", "Saquen a CD2 de Latinoamerica JAJAJA, mas bien por estar alli esto surgio", "Strong FS? is the guy that inspired CD2", "Greetings! "..data.userName}
	if data.userName == 'Strong FS' or data.userName == 'strong fs' or data.userName == 'StrongFS' or data.userName == 'strongfs' or data.userName == 'Strong Fs' or data.userName == 'STRONG FS' or data.userName == 'STRONGFS' then
		table.insert(t_randomWord,1, "Hey Strong! CD2 te manda Saludoss")
		table.insert(t_randomWord,2, "Hmmm Strong XD")
	end
	txtRandom = (t_randomWord[math.random(1, #t_randomWord)])
end

function f_prizeWords()
	txt_vaultWords = createTextImg(jgFnt, 5, 0, '', 0, 0,0.9,0.9)
	local t_randomWord = {"YES! YOU DID IT. If you go back to Main Menu you might find a surprise 0_0", "Well, this is a little Minigame to show you what the LUA is capable of"}
	txtRandom = (t_randomWord[math.random(1, #t_randomWord)])
end

function f_theVault()
	local word = ''
	local vaultMenu = 2
	local i = 0
	local t = 0
	local prize = false
	f_randomWords() --Get Random Words
	vaultExit = false
	cmdInput()
	playBGM(bgmVault)
	data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
	while true do
		--EXIT LOGIC
		if vaultExit == true then
			clearInputText()
			sndPlay(sysSnd, 100, 2)
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			f_menuMusic()
			break
		end
		--MAIN SCREEN
		if esc() then
			vaultExit = true
		elseif commandGetState(p1Cmd, 'r') then
			sndPlay(sysSnd, 100, 0)
			vaultMenu = vaultMenu + 1
		elseif commandGetState(p1Cmd, 'l') then
			sndPlay(sysSnd, 100, 0)
			vaultMenu = vaultMenu - 1
		end
		if vaultMenu < 1 then vaultMenu = 2 elseif vaultMenu > 2 then vaultMenu = 1 end
		word = inputText('',true)
		if clipboardPaste() then
			if string.match(getClipboardText(),'^(.*)') then
				setInputText(getClipboardText())
			else
				sndPlay(sysSnd, 100, 5)
			end
		end
		if word:len() > 5 then
			word = word:sub(1,18)
			setInputText(word)
		end
		if word ~= '' and word ~= nil then
			if word:match('^0(%d+)$') then
				word = word:gsub('^0(%d+)$','%1')
				setInputText(word)
			end
		end
		--BUTTON SELECT
		if commandGetState(p1Cmd, 'w') then
			--BACK
			if vaultMenu == 1 then
				vaultExit = true
			--ENTER
			elseif vaultMenu == 2 then
				t = 0 --Reset Vault Words Delay Time
				if word ~= '' and word ~= nil then
					vaultKey = (tostring(word))
					if vaultKey == 'ultra' or vaultKey == 'Ultra' or vaultKey == 'ULTRA' then
						sndPlay(sysSnd, 100, 1)
						data.vault = 'Ultra'
						f_saveProgress()
						assert(loadfile('save/stats_sav.lua'))()
						prize = true
					elseif vaultKey == 'zen' or vaultKey == 'Zen' or vaultKey == 'ZEN' then
						sndPlay(sysSnd, 100, 1)
						data.vault = 'Zen'
						f_saveProgress()
						assert(loadfile('save/stats_sav.lua'))()
						prize = true
					elseif vaultKey == 'ssz' or vaultKey == 'Ssz' or vaultKey == 'SSZ' then
						sndPlay(sysSnd, 100, 1)
						data.vault = 'SSZ'
						f_saveProgress()
						assert(loadfile('save/stats_sav.lua'))()
						prize = true
					else
						prize = false
					end
					clearInputText()
				else
					clearInputText()
					prize = false
				end
				if not prize then f_randomWords() else f_prizeWords() end
			end
		end
		--Draw BG
		animDraw(vaultBG0)
		animUpdate(vaultBG0)
		--Draw Menu Title
		textImgDraw(txt_vaultTitle)
		--Draw Text Window BG
		animSetScale(vaultWindowBG, 220, 30)
		animSetWindow(vaultWindowBG, 80,100, 160,30)
		animDraw(vaultWindowBG)
		--Draw Valt Words
		f_textRender(txt_vaultWords, txtRandom, t, 160, 78, 15, 2.5, 45)
		--Draw Text
		textImgSetText(txt_vaultText,word)
		textImgDraw(txt_vaultText)
		if i%60 < 30 then
			textImgPosDraw(txt_vaultBar, 160+(textImgGetWidth(txt_vaultText)*0.5)+(textImgGetWidth(txt_vaultText)>0 and 2 or 0), 120)
		end
		--Draw Button Option Text
		for i=1, #t_vaultMenu do
			if i == vaultMenu then
				textImgSetBank(t_vaultMenu[i].id, 5)
			else
				textImgSetBank(t_vaultMenu[i].id, 0)
			end
			textImgDraw(t_vaultMenu[i].id)
		end
		i = i >= 60 and 0 or i + 1
		t = t + 1
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
	clearInputText()
end

--;===========================================================
--; UNLOCK INFO SCREEN
--;===========================================================
txt_msgMenu = createTextImg(jgFnt, 0, 1, '', 0, 0) --Text that appears in black screens important message

function f_secret()
	local i = 0
	txt = 'COMPLETE THE ARCADE MODE TO UNLOCK THIS FEATURE!'
	cmdInput()
	while true do
		if btnPalNo(p1Cmd) > 0 then
			cmdInput()
			sndPlay(sysSnd, 100, 2)
			data.fadeTitle = f_fadeAnim(50, 'fadein', 'black', fadeSff)
			break
		end
        i = i + 1
        f_textRender(txt_msgMenu, txt, i, 20, 178, 15, 1.8, 35)
        animDraw(data.fadeTitle)
        animUpdate(data.fadeTitle)
		cmdInput()
        refresh()
    end
end

--;===========================================================
--; COMING SOON INFO SCREEN
--;===========================================================
function f_comingSoon()
	local i = 0
	txt = 'THIS FEATURE WILL BE AVAILABLE COMING SOON...'
	cmdInput()
	while true do
		if btnPalNo(p1Cmd) > 0 then
			cmdInput()
			sndPlay(sysSnd, 100, 2)
			data.fadeTitle = f_fadeAnim(50, 'fadein', 'black', fadeSff)
			break
		end
        i = i + 1
        f_textRender(txt_msgMenu, txt, i, 20, 178, 15, 1.4, 35)
        animDraw(data.fadeTitle)
        animUpdate(data.fadeTitle)
		cmdInput()
        refresh()
    end
end

--;===========================================================
--; CREDITS SCREEN
--;=========================================================== 
function f_playCredits()
	local scroll = 0
	local speed = 0
	local speedX1 = 0.5
	local speedX2 = 1.5
	local skip = false
	local creditsBoxCfg = textImgNew()
	local txtFont = font7--font14
	local txtBank = 0
	local txtAline = 0 --[1]= Align text left | [0]= Center Text | [-1]= Align text right
	local txtSpacing = 12 --spacing between lines (rendering Y position increasement for each line)
	local txtScaleX = 1
	local txtScaleY = 1
	local txtAlphaS = 255
	local txtAlphaD = 0
	local creditsTable = f_extractText(txt_creditsBox) --This returns a table with all text in the same written order
	cmdInput()
	data.fadeTitle = f_fadeAnim(50, 'fadein', 'black', fadeSff)
	while true do
		if scroll > 1600 then break end --Credits Duration
		--Actions
		if commandGetState(p1Cmd, 'w') and not skip then --Skip Button
			skip = true
		elseif commandGetState(p1Cmd, 'w') and skip then --Unskip Button
			skip = false
		end
		if not skip then speed = speedX1 --Normal
		elseif skip then speed = speedX2 --Faster
		end
		--Draw Text
		for i = 1, #creditsTable do
			textImgDraw(f_updateTextImg(creditsBoxCfg, txtFont, txtBank, txtAline, creditsTable[i], 155, 260 + txtSpacing * (i - 1) - scroll, txtScaleX, txtScaleY, txtAlphaS, txtAlphaD))
		end
		--f_drawQuickText(speedTest, font14, 0, 1, scroll, 50, 100) --Test Timer
		scroll = scroll + speed
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
	--When End
	data.fadeTitle = f_fadeAnim(50, 'fadein', 'black', fadeSff)
	if data.attractMode == true then
		playBGM(bgmTitle)
	elseif data.rosterMode == 'story' then
		playBGM(bgmStory)
	elseif data.rosterMode == 'arcade' then
		--Nothing because game over screen comes...
	else
		f_menuMusic()
	end
	--f_default()
end

txt_creditsBox = [[
I.K.E.M.E.N PLUS ULTRA



MAIN PROGRAM

SUEHIRO
ALCERIS
K4THOS
SHINLUCHO
NEATUNSOU
WINDBLADE
DAN
KIDCY
WINTERMOURN
SHIYO KAKUGE
KAMEKAZE
TWO4TEEZEE
SUPER
THEFCLASS97
RODKNEE
ROS
YAMORI X
JADE MIDORI
PLASMOIDTHUNDER
STRONG FS
CD2


CHARACTERS DESIGN

ELECBYTE TEAM
THE_NONE
SENNOU-ROOM
MAGE
DIVINEWOLF
PROUD OF RAGEQUITTIN
A.K.A. TOASTED MILQUE
S.Y.D
SILVAN
MASUKENPU-KUN
DONALDEUS
PHANTOM.OF.THE.SERVER
YOSHIN222
STUPA



STAGES DESIGN

ELECBYTE TEAM
HEKUTTA
SHIYO KAKUGE
NEXT ONE
AIROLG1990
RIVIERA
PHANTOM.OF.THE.SERVER
APPLEST0RE



GRAPHICS DESIGN

ELECBYTE TEAM



SOUND DESIGN

GENERIC SOUNDS
DING
TEKKEN 7 ANNOUNCER



STORY DESIGN

ELECBYTE TEAM
CD2



STORY ANIMATION

SWEET CREATURES
AUGUSTO SAPIENTI


SPECIAL THANKS

STRONG FS
PLASMOIDTHUNDER
ACDGAMES
OLDGAMER
DJ DELORIE
SHAWN HARGREAVES
TOMISLAV UZELAC AND OVE KAAVEN
GUAN FOO WAH
PETER WANG AND BRENNAN UNDERWOOD
EARLE F. PHILHOWER III
DAVID CORNISH
THE ENHANCED SPECIAL TESTING PEOPLE


AND YOU





PRESENTED BY

CABLE DORADO 2
 ]]

--;===========================================================
--; INITIALIZE LOOPS
--;===========================================================
f_mainStart() --Start Menu