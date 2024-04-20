﻿--;===========================================================
--; LOAD VISUAL NOVEL DATA
--;===========================================================
t_vnBoxText = {}
local t = {}
local group = ''
local section = 0
local file = io.open("vn/textbox.def","r")
local content = file:read("*all")
file:close()
content = content:gsub('([^\r\n]*)%s*;[^\r\n]*', '%1')
content = content:gsub('\n%s*\n', '\n')

function f_test()
chapt = #t_vnBoxText+1
t_vnBoxText[chapt] = {}
end

for line in content:gmatch('[^\r\n]+') do
	line = tostring(line:lower()) --line:lower()
	if line:match('^%s*%[%s*chapter1%s*%]') then
		section = 1
		chapt = #t_vnBoxText+1 --Add chapter to the table
		t_vnBoxText[chapt] = {} --Create sub-table to store content from this chapter
	elseif line:match('^%s*%[%s*chapter2%s*%]') then
		section = 2
		f_test()
	elseif line:match('^%s*%[%s*chapter3a%s*%]') then
		section = 3
		f_test()
	elseif line:match('^%s*%[%s*chapter3b%s*%]') then
		section = 4
		f_test()
	elseif line:match('^%s*%[%s*chapter4a%s*%]') then
		section = 5
		f_test()
	elseif line:match('^%s*%[%s*chapter4b%s*%]') then
		section = 6
		f_test()
	elseif line:match('^%s*%[%s*chapter4c%s*%]') then
		section = 7
		f_test()
	elseif line:match('^%s*%[%s*chapter4d%s*%]') then
		section = 8
		f_test()
	elseif section > 0 then --[ChapterNo]
		if line:match('^%s*character%s*=') then
			local data = line:gsub('%s*;.*$', '')
			--if not data:match('=%s*$') then
				t_vnBoxText[chapt][#t_vnBoxText[chapt]+1] = {} --Add content filtered to the end of the "chapter" sub-table
				t_vnBoxText[chapt][#t_vnBoxText[chapt]]['ID'] = ''
				t_vnBoxText[chapt][#t_vnBoxText[chapt]]['character'] = data:gsub('^%s*character%s*=%s*["]*%s*(.-)%s*["]*%s*$', '%1')
			--end
		end
		if line:match('text:$') then
			t_vnBoxText[chapt][#t_vnBoxText[chapt]]['text'] = ""
		end
		if type(t_vnBoxText[chapt][#t_vnBoxText[chapt]].text) == 'string' then
			if t_vnBoxText[chapt][#t_vnBoxText[chapt]].text == '' then
				t_vnBoxText[chapt][#t_vnBoxText[chapt]].text = " " --line  --line get "text:" and we don't need that
			else
				t_vnBoxText[chapt][#t_vnBoxText[chapt]].text = t_vnBoxText[chapt][#t_vnBoxText[chapt]].text .. '\n' .. line
			end
		end
	end
	--textImgDraw(txt_loading)
	--refresh()
end
if data.debugLog then
	f_printTable(t_vnBoxText, "save/debug/t_vnBoxText.txt")
end

--;===========================================================
--; LOAD VISUAL NOVEL SRIPTS
--;===========================================================
require("vn.story1")

--;===========================================================
--; LOAD VISUAL NOVEL ASSETS
--;===========================================================
txt_nameCfg = createTextImg(font1, 0, 1, "", 2, 175) --Name Text Config
txt_boxCfg = createTextImg(font1, 0, 1, "", 0, 0) --Narrative Text Box Config
--txt_vnName = "" --Name Text
--txt_vn = "" --Narrative Text Box

--Background 1
vnBG0 = animNew(vnSff, [[
0,0, 0,0, -1
]])
animAddPos(vnBG0, 0, 0)
animUpdate(vnBG0)

--Text background
vnTxtBG = animNew(vnSff, [[
100,0, 0,0, -1
]])
animAddPos(vnTxtBG, -8, 177.5)
animSetScale(vnTxtBG, 2.21, 1)
animUpdate(vnTxtBG)

--Next Text Arrow
vnNext = animNew(vnSff, [[
101,0, 0,0, 10
101,1, 0,0, 10
101,2, 0,0, 10
101,3, 0,0, 10
101,3, 0,0, 10
101,2, 0,0, 10
101,1, 0,0, 10
101,0, 0,0, 10
]])
animAddPos(vnNext, 308, 222)
animSetScale(vnNext, 0.5, 0.5)
animUpdate(vnNext)

--Skip Button
vnSkip = animNew(vnSff, [[
100,1, 0,0, -1
]])
animAddPos(vnSkip, 300, 220)
animUpdate(vnSkip)

--Kung Fu Man 1
vnKfm1 = animNew(vnSff, [[
1,0, 0,0, -1
]])
animAddPos(vnKfm1, 0, 0)
animSetScale(vnKfm1, 0.25, 0.25)
animUpdate(vnKfm1)