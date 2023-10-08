
module(..., package.seeall)

--;===========================================================
--; STORY SCREENPACK
--;===========================================================
--Scrolling background
storyBG0 = animNew(sysSff, [[
100,0, 0,0, -1
]])
animAddPos(storyBG0, 160, 0)
animSetTile(storyBG0, 1, 1)
animSetColorKey(storyBG0, -1)

--Above Transparent background
storyBG1 = animNew(sysSff, [[
3,0, 0,0, -1
]])
animSetPos(storyBG1, 48, 19)
animSetAlpha(storyBG1, 20, 100)
animUpdate(storyBG1)

--Below Transparent background
storyBG2 = animNew(sysSff, [[
3,0, 0,0, -1
]])
animSetPos(storyBG2, 40, 140)
animSetAlpha(storyBG2, 20, 100)
animUpdate(storyBG2)

--Arc Left Arrow
storyLeftArrow = animNew(sysSff, [[
223,0, 0,0, 10
223,1, 0,0, 10
223,2, 0,0, 10
223,3, 0,0, 10
223,3, 0,0, 10
223,2, 0,0, 10
223,1, 0,0, 10
223,0, 0,0, 10
]])
animAddPos(storyLeftArrow, 69, 112)
animUpdate(storyLeftArrow)
animSetScale(storyLeftArrow, 0.5, 0.5)

--Arc Right Arrow
storyRightArrow = animNew(sysSff, [[
224,0, 0,0, 10
224,1, 0,0, 10
224,2, 0,0, 10
224,3, 0,0, 10
224,3, 0,0, 10
224,2, 0,0, 10
224,1, 0,0, 10
224,0, 0,0, 10
]])
animAddPos(storyRightArrow, 242, 112)
animUpdate(storyRightArrow)
animSetScale(storyRightArrow, 0.5, 0.5)

--Chapter Up Arrow
storyUpArrow = animNew(sysSff, [[
225,0, 0,0, 10
225,1, 0,0, 10
225,2, 0,0, 10
225,3, 0,0, 10
225,3, 0,0, 10
225,2, 0,0, 10
225,1, 0,0, 10
225,0, 0,0, 10
]])
animAddPos(storyUpArrow, 155, 131)
animUpdate(storyUpArrow)
animSetScale(storyUpArrow, 0.5, 0.5)

--Chapter Down Arrow
storyDownArrow = animNew(sysSff, [[
226,0, 0,0, 10
226,1, 0,0, 10
226,2, 0,0, 10
226,3, 0,0, 10
226,3, 0,0, 10
226,2, 0,0, 10
226,1, 0,0, 10
226,0, 0,0, 10
]])
animAddPos(storyDownArrow, 155, 231)
animUpdate(storyDownArrow)
animSetScale(storyDownArrow, 0.5, 0.5)

--;===========================================================
--; ARC SELECT
--;===========================================================
t_storySelect = {
	{Name = 'KUNG FU MAN',		Img = '', ID = textImgNew(), Status = ''},
	{Name = 'KUNG FU GIRL',	    Img = '', ID = textImgNew(), Status = ''},
	{Name = 'SUAVE DUDE',  		Img = '', ID = textImgNew(), Status = ''},
	{Name = 'YOUR ARC HERE', 	Img = '', ID = textImgNew(), Status = ''},
	{Name = 'YOUR ARC HERE', 	Img = '', ID = textImgNew(), Status = ''},
	{Name = 'YOUR ARC HERE', 	Img = '', ID = textImgNew(), Status = ''},
}

--Arc Icon Preview
--function f_storyPreview()
	--storyPreview = ''
	--storyPreview = '0,' .. storyList-1 .. ', 0,0, 0'
	--storyPreview = animNew(storySff, storyPreview)
	--animSetScale(storyPreview, 0.4, 0.25)
	--animSetPos(storyPreview, 50, 21)
	--animUpdate(storyPreview)
	--animDraw(storyPreview)
	--return storyPreview
--end

--;===========================================================
--; CHAPTER SELECT
--;===========================================================
t_arc1 = {
	{Name = 'Lost Chapter 1',		    	   Img = '', ID = textImgNew(), Status = ''},
	{Name = 'Lost Chapter 2',	     		   Img = '', ID = textImgNew(), Status = ''},
	{Name = 'Lost Chapter 3',  			 	   Img = '', ID = textImgNew(), Status = ''},
	{Name = 'Lost Chapter 4', 				   Img = '', ID = textImgNew(), Status = ''},
	{Name = 'PROGRAM YOUR STORY CHAPTER HERE', Img = '', ID = textImgNew(), Status = ''},
	{Name = 'PROGRAM YOUR STORY CHAPTER HERE', Img = '', ID = textImgNew(), Status = ''},
}

--Chapter Preview
--function f_storyPreview()
	--storyPreview = ''
	--storyPreview = '0,' .. storyList-1 .. ', 0,0, 0'
	--storyPreview = animNew(storySff, storyPreview)
	--animSetScale(storyPreview, 0.4, 0.25)
	--animSetPos(storyPreview, 50, 21)
	--animUpdate(storyPreview)
	--animDraw(storyPreview)
	--return storyPreview
--end

t_arc2 = {
	{Name = 'PROGRAM YOUR STORY CHAPTER HERE', Img = '', ID = textImgNew(), Status = ''},
	{Name = 'PROGRAM YOUR STORY CHAPTER HERE', Img = '', ID = textImgNew(), Status = ''},
	{Name = 'PROGRAM YOUR STORY CHAPTER HERE', Img = '', ID = textImgNew(), Status = ''},
	{Name = 'PROGRAM YOUR STORY CHAPTER HERE', Img = '', ID = textImgNew(), Status = ''},
	{Name = 'PROGRAM YOUR STORY CHAPTER HERE', Img = '', ID = textImgNew(), Status = ''},
	{Name = 'PROGRAM YOUR STORY CHAPTER HERE', Img = '', ID = textImgNew(), Status = ''},
}

--;===========================================================
--; STORY MENU
--;===========================================================
function f_storyMenu()
	cmdInput()
	local storyMenu = 1
	local cursorPosX = 1
	local moveArc = 0
	local chapterMenu = 1
	local cursorPosY = 1
	local moveChapter = 0
	local t_chapter = nil
	local bufu = 0
	local bufd = 0
	local bufr = 0
	local bufl = 0
	--storyList = 0 --Important to avoid errors when read storyPreview
	data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
	while true do
--Story Progress Logic
	--if data.story1Status == 1 then story1Progress = 'COMPLETED' elseif data.story1Status == 0 then story1Progress = 'INCOMPLETE' end
	--if data.story2Status == 1 then story2Progress = 'COMPLETED' elseif data.story2Status == 0 then story2Progress = 'INCOMPLETE' end
	--if data.story3Status == 1 then story3Progress = 'COMPLETED' elseif data.story3Status == 0 then story3Progress = 'INCOMPLETE' end
	--data.storysProgress = data.story1Status + data.story2Status + data.story3Status
	--storyData = (math.floor((data.storysProgress * 100 / 3) + 0.5)) --The number (3) is the amount of all data.storyStatus
	txt_storyMenu = createTextImg(jgFnt, 0, -1, 'STORY SELECT:', 80, 12)
	--txt_storyProgress = createTextImg(jgFnt, 2, 1, '['..storyData..'%]', 202, 128) --needs to be inside of story Menu function, to load story data %
	--BACK
		if esc() then
			--f_saveProgress()
			data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
			sndPlay(sysSnd, 100, 2)
			break
	--Arc Selection
		elseif commandGetState(p1Cmd, 'l') or (commandGetState(p1Cmd, 'holdl') and bufl >= 30) then
			sndPlay(sysSnd, 100, 0)
			storyMenu = storyMenu - 1
		elseif commandGetState(p1Cmd, 'r') or (commandGetState(p1Cmd, 'holdr') and bufr >= 30) then
			sndPlay(sysSnd, 100, 0)
			storyMenu = storyMenu + 1
	--Chapter Selection
		elseif commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30) then
			sndPlay(sysSnd, 100, 0)
			chapterMenu = chapterMenu - 1
		elseif commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30) then
			sndPlay(sysSnd, 100, 0)
			chapterMenu = chapterMenu + 1
		elseif btnPalNo(p1Cmd) > 0 then
			f_default()
			--setGameMode('story')
		--CHAPTER 1
			if chapterMenu == 1 then
				--data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
				sndPlay(sysSnd, 100, 1)
				--setRoundTime(-1)
				--data.p2In = 0
				--data.p1TeamMenu = {mode = 0, chars = 1}				
				--data.p2TeamMenu = {mode = 0, chars = 1}
				--data.p1Char = {t_charAdd['dragon claw']}
				--data.p2Char = {t_charAdd['kung fu man/master/master kung fu man.def']}
				--data.stageMenu = true
				--data.versusScreen = true
				data.rosterMode = 'story'
				--data.storyNo = 'story 1'
				--textImgSetText(txt_mainSelect, 'story 1 [' .. story1Progress .. ']')
				--script.select.f_selectSimple()
		--CHAPTER 2
			elseif chapterMenu == 2 then
				--data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
				sndPlay(sysSnd, 100, 1)
		--CHAPTER 3
			elseif chapterMenu == 3 then
				--data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
				sndPlay(sysSnd, 100, 1)
		--CHAPTER 4
			elseif chapterMenu == 4 then
				--data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
				sndPlay(sysSnd, 100, 1)
		--CHAPTER 5
			elseif chapterMenu == 5 then
				--data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
				sndPlay(sysSnd, 100, 1)
		--CHAPTER 6
			elseif chapterMenu == 6 then
				--data.fadeTitle = f_fadeAnim(10, 'fadein', 'black', fadeSff)
				sndPlay(sysSnd, 100, 1)
			end
		end
	--Arc Cursor position calculation
		if storyMenu < 1 then
			storyMenu = #t_storySelect
			if #t_storySelect > 4 then
				cursorPosX = 4
			else
				cursorPosX = #t_storySelect
			end
		elseif storyMenu > #t_storySelect then
			storyMenu = 1
			cursorPosX = 1
		elseif (commandGetState(p1Cmd, 'l') or (commandGetState(p1Cmd, 'holdl') and bufl >= 30)) and cursorPosX > 1 then
			cursorPosX = cursorPosX - 1
		elseif (commandGetState(p1Cmd, 'r') or (commandGetState(p1Cmd, 'holdr') and bufr >= 30)) and cursorPosX < 4 then
			cursorPosX = cursorPosX + 1
		end
		if cursorPosX == 4 then
			moveArc = (storyMenu - 4) * 105
		elseif cursorPosX == 1 then
			moveArc = (storyMenu - 1) * 105
		end
		if #t_storySelect <= 4 then
			maxarcs = #t_storySelect
		elseif storyMenu - cursorPosX > 0 then
			maxarcs = storyMenu + 4 - cursorPosX
		else
			maxarcs = 4
		end
	--Chapter Cursor position calculation
		if storyMenu == 1 then t_chapter = t_arc1
		elseif storyMenu == 2 then t_chapter = t_arc2
		end
		if chapterMenu < 1 then
			chapterMenu = #t_chapter
			if #t_chapter > 6 then
				cursorPosY = 6
			else
				cursorPosY = #t_chapter
			end
		elseif chapterMenu > #t_chapter then
			chapterMenu = 1
			cursorPosY = 1
		elseif (commandGetState(p1Cmd, 'u') or (commandGetState(p1Cmd, 'holdu') and bufu >= 30)) and cursorPosY > 1 then
			cursorPosY = cursorPosY - 1
		elseif (commandGetState(p1Cmd, 'd') or (commandGetState(p1Cmd, 'holdd') and bufd >= 30)) and cursorPosY < 6 then
			cursorPosY = cursorPosY + 1
		end
		if cursorPosY == 6 then
			moveChapter = (chapterMenu - 6) * 20
		elseif cursorPosY == 1 then
			moveChapter = (chapterMenu - 1) * 20
		end
		if #t_chapter <= 6 then
			maxchapters = #t_chapter
		elseif chapterMenu - cursorPosY > 0 then
			maxchapters = chapterMenu + 6 - cursorPosY
		else
			maxchapters = 6
		end
		animDraw(f_animVelocity(storyBG0, -1, -1))
	--Draw Title Menu
		textImgDraw(txt_storyMenu)
		--textImgDraw(txt_storyProgress)
	--Draw Above Transparent BG
		--animSetScale(storyBG1, 219.5, 94)
		--animSetWindow(storyBG1, 0,5, 320,110)
		--animDraw(storyBG1)
	--Draw Below Transparent Table BG
		--animSetScale(storyBG2, 240, maxarcs*15)
		--animSetWindow(storyBG2, 10,20, 269,210)
		--animDraw(storyBG2)
	--Draw Below Table Cursor
		--animSetWindow(cursorBox, 40,125+cursorPosX*15, 239,15)
		--f_dynamicAlpha(cursorBox, 20,100,5, 255,255,0)
		--animDraw(f_animVelocity(cursorBox, -1, -1))
		--storyList = storyMenu --Uses menu position to show image in these order
		--f_storyPreview() --Show story image preview
	--Draw story Info
		--if storyMenu == 1 then
			--for i=1, #t_arc1 do
				--textImgDraw(t_arc1[1].id)
			--end
		--elseif storyMenu == 2 then
			--for i=1, #t_arc1 do
				--textImgDraw(t_arc1[2].id)
			--end
		--end
	--Set story status
		--t_storySelect[1].Status = story1Progress
		--t_storySelect[2].Status = story2Progress
		--t_storySelect[3].Status = story3Progress
	--Draw Text for Arcs Table
		for i=1, maxarcs do
			if i > storyMenu - cursorPosX then
				if i == storyMenu then
					bank = 1
				else
					bank = 0
				end
				if t_storySelect[i].ID ~= nil then
					textImgDraw(f_updateTextImg(t_storySelect[i].ID, jgFnt, bank, 0, t_storySelect[i].Name, -110.5+i*105-moveArc, 60,0.85,0.85))
					--t_storySelect[i].Status
				end
			end
		end
	--Draw Left Animated Cursor
		if maxarcs > 4 then
			animDraw(storyLeftArrow)
			animUpdate(storyLeftArrow)
		end
	--Draw Right Animated Cursor
		if #t_storySelect > 4 and maxarcs < #t_storySelect then
			animDraw(storyRightArrow)
			animUpdate(storyRightArrow)
		end
	--Draw Text for Chapter Table
		for i=1, maxchapters do
			if i > chapterMenu - cursorPosY then
				if i == chapterMenu then
					bank = 5
				else
					bank = 0
				end
				if t_chapter[i].ID ~= nil then
					textImgDraw(f_updateTextImg(t_chapter[i].ID, jgFnt, bank, 1, t_chapter[i].Name, -40, 70+i*20-moveChapter))
				end
			end
		end
	--Draw Up Animated Cursor
		if maxchapters > 6 then
			animDraw(storyUpArrow)
			animUpdate(storyUpArrow)
		end
	--Draw Down Animated Cursor
		if #t_chapter > 6 and maxchapters < #t_chapter then
			animDraw(storyDownArrow)
			animUpdate(storyDownArrow)
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
		animDraw(data.fadeTitle)
		animUpdate(data.fadeTitle)
		cmdInput()
		refresh()
	end
end
