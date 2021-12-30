xAdmin = {
	Database = {},
	Config = {},
	Core = {},
	Users = {},
	Groups = {},
	Commands = {},
	AdminChat = {},
	Utility = {},
	Github = true -- This can be used to identify the github xAdmin from the gmodstore xAdmin 
}

local debugEnabled = false
local function debugPrint(msg)
	if not debugEnabled then return end
	print("------------------------------------XADMIN DEBUG------------------------------------", msg)
end

-- Load permissions before everything else so it doesnt break shit
-- TOOD: Find a better, non shit way of doing this!
if SERVER then
	AddCSLuaFile("xadmin/_config/sh_permissions.lua")
	include("xadmin/_config/sh_permissions.lua")

	include("xadmin/_config/sv_mysql_config.lua")

	include("xadmin/core/sv_db.lua")
else
	include("xadmin/_config/sh_permissions.lua")
end

print([[
--------------------------------------------------------------
xAdmin - R.I.P PoliceRP.xyz
--------------------------------------------------------------
]])

xAdmin.Core.Version = "1.5"

-- This is a little messy and hard to read
local function loadFolder(path, ignore)
	ignore = ignore or {}
	print("[xAdmin] Loading folder: " .. path)

	local files, folders = file.Find(path .. "*", "LUA")

	for k, v in SortedPairs(files) do
		local name = path .. v
		if ignore[name] == true then continue end

		print("[xAdmin] Loading File: " .. name)

		if string.StartWith(v, "sh_") then

			if SERVER then
				AddCSLuaFile(name)
				include(name)
			elseif CLIENT then
				include(name)
			end

			continue
		elseif string.StartWith(v, "sv_") then

			if SERVER then
				include(name)
				debugPrint(name)
			end

			continue
		elseif string.StartWith(v, "cl_") then

			if SERVER then
				AddCSLuaFile(name)
				debugPrint(name)
			elseif CLIENT then
				include(name)
				debugPrint(name)
			end

			continue
		end
	end
end
loadFolder("xadmin/core/", {
	["xadmin/core/sv_db.lua"] = true,
})
loadFolder("xadmin/_config/", {
	["xadmin/_config/sh_permissions.lua"] = true, -- We dont need to load it twice
})
loadFolder("xadmin/extras/")
loadFolder("xadmin/commands/")
