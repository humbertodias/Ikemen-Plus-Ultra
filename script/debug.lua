data = require('script.data')
assert(loadfile('script/data_sav.lua'))()

package.path = package.path..';./script/ltn12.lua'
ltn12 = require('ltn12')

if data.debugMode == true then
--Keys available on lib/alpha/sdlpluing.ssz
addHotkey('F1', false, false, false, 'kill(1);kill(2)') --Sets Double KO
addHotkey('F1', true, false, false, 'kill(2);kill(4)') --Ctrl+F1: Sets Player 2's life to zero
addHotkey('F1', false, false, true, 'kill(1);kill(3)') --Shift+F1: Player 1's life to zero
addHotkey('F2', false, false, false, 'kill(1,1);kill(2,1);kill(3,1);kill(4,1)') --Sets both players' life to 1
addHotkey('F2', true, false, false, 'kill(2,1);kill(4,1)') --Ctrl+F2: Sets Player 2's life to 1
addHotkey('F2', false, false, true, 'kill(1,1);kill(3,1)') --Shift+F2: Sets Player 1's life to 1
addHotkey('F3', false, false, false, 'setTime(0)') --Sets Time Over
addHotkey('F4', false, false, false, 'roundReset()') --Reset the round
addHotkey('F4', true, false, false, 'reload()') --CTRL+F4: Reloads stage, characters and fight data
addHotkey('F5', false, false, false, 'lifeMax(1);lifeMax(2)') --Gives both Players full life
addHotkey('F5', true, false, false, 'lifeMax(2);lifeMax(4)') --Ctrl+F1: Gives Player 2's full life
addHotkey('F5', false, false, true, 'lifeMax(1);lifeMax(3)') --Shift+F1: Gives Player 1's full life
addHotkey('F6', false, false, false, 'powMax(1);powMax(2)') --Gives both players full life
addHotkey('F6', true, false, false, 'barAdd(2)') --Ctrl+F6: Increases Player 2's power to 1
addHotkey('F6', false, false, true, 'barAdd(1)') --Shift+F6: Increases Player 1's power to 1
addHotkey('F7', false, false, false, 'full(1);full(2);full(3);full(4);setTime(getRoundTime())') --Restores full life and power to all players

addHotkey('c', true, false, false, 'toggleClsnDraw()') --CTRL+C: Toggles display of collision boxes, target data (including remaining juggle points) and NotHitBy attributes
addHotkey('d', true, false, false, 'toggleDebugDraw()') --CTRL+D: Toggles debug information display
addHotkey('l', true, false, false, 'toggleStatusDraw()') --CTRL+L: Toggles display of the life and power bars
addHotkey('i', true, false, false, 'stand(1);stand(2);stand(3);stand(4)') --CTRL+I: Forces both players into stand state
--addHotkey('v', true, false, false, 'changeVsync()') --CTRL+V: Enable V-sync (stops "shearing")

--Ctrl-# (where # is from 1-4) Toggles AI for the #th player OR Ctrl-Alt-# (where # is from 1-4) Enables/Disables the player
addHotkey('1', true, false, false, 'toggleAI(1)')
addHotkey('2', true, false, false, 'toggleAI(2)')
addHotkey('3', true, false, false, 'toggleAI(3)')
addHotkey('4', true, false, false, 'toggleAI(4)')

addHotkey('BACKSPACE', false, false, false, 'changeSpeed()') --Run the game as fast as possible
addHotkey('SCROLLLOCK', false, false, false, 'step()') --???
end

addHotkey('PRINTSCREEN', false, false, false, 'takeScreenshotVS()') --Takes a screenshot and saves it to "screenshots" folder
addHotkey('SPACE', false, false, false, 'togglePause()') --Pause the game (OLD = RETURN)

speed = 1.0

function changeSpeed()
  if speed >= 4 then
    speed = 0.25
  else
    speed = speed*2.0
  end
  setAccel(speed)
end

function toggleAI(p)
  local oldid = id()
  if player(p) then
    if ailevel() > 0 then
      setAILevel(0)
    else
      setAILevel(8)
    end
    playerid(oldid)
  end
end

function kill(p, ...)
  local oldid = id()
  if player(p) then
    local n = ...
    if not n then n = 0 end
    setLife(n)
    playerid(oldid)
  end
end

function lifeMax(p)
  local oldid = id()
  if player(p) then
    setLife(lifemax())
    playerid(oldid)
  end
end

function powMax(p)
  local oldid = id()
  if player(p) then
    setPower(powermax())
    playerid(oldid)
  end
end

function barAdd(p)
  local oldid = id()
  if player(p) then
    setPower(power()+1000)
    playerid(oldid)
  end
end

function full(p)
  local oldid = id()
  if player(p) then
    setLife(lifemax())
    setPower(powermax())
    playerid(oldid)
  end
end

function stand(p)
  local oldid = id()
  if player(p) then
    selfState(0)
    playerid(oldid)
  end
end

function info()
  puts(
    string.format(
      'name:%s state:%d>%d %s move:%s physics:%s',
      name(), prevstateno(), stateno(), statetype(), movetype(), physics()))
  puts(
    string.format(
      'anim:%d %d elem:%d %d pos:%.3f,%.3f vel:%.3f,%.3f',
      anim(), animtime(), animelemno(0), animelemtime(animelemno(0)),
      posX(), posY(), velX(), velY()))
end

function status(p)
  local oldid = id()
  if not player(p) then return false end
  ret =
    string.format(
      'STA:%s%s%s%6d(%d) ANI:%6d(%d)%2d LIF:%5d POW:%5d TIM:%d',
      statetype(), movetype(), physics(), stateno(), stateOwner(),
      anim(), animOwner(), animelemno(0), life(), power(), time())
  playerid(oldid)
  return ret;
end

function takeScreenshotVS()
	sysSnd = sndNew('data/system.snd')
	if data.screenshotSnd == 1 then
		sndPlay(sysSnd, 22, 0)
	elseif data.screenshotSnd == 2 then
		sndPlay(sysSnd, 22, 1)
	elseif data.screenshotSnd == 3 then
		sndPlay(sysSnd, 22, 2)
	elseif data.screenshotSnd == 4 then
		sndPlay(sysSnd, 22, 3)
	end
	batOpen("tools", "screenshot.vbs")
	--Set time to capture the correct screenshot
	ltn12.pump.all(
	--(echo nircmd savescreenshotwin "..\screenshots\Screenshot.dat" ^| del x.vbs x.bat)>x.bat   Backup Bat Code
	ltn12.source.file(assert(io.open("tools/screenshot.dat", "rb"))),
	ltn12.sink.file(assert(io.open("screenshots/" .. os.date("%Y-%m-%d %I-%M%p-%S") .. ".png", "wb"))) --Currently works but show the previous screenshot taken
	)
end
