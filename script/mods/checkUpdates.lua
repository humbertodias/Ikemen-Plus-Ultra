﻿--Insert new item to t_mainMenu table loaded by screenpack.lua
table.insert(t_mainMenu,#t_mainMenu,{id = textImgNew(), text = "CHECK UPDATES", gotomenu = "f_checkUpdates()"})