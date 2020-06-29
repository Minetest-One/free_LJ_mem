-- by Thomas Wiegand (Minetest.one)
-- source https://github.com/Minetest-One/free_lj_mem

-----------------------------------------------------------------------------------------------
local title	= "free_lj_mem"
local date	= "01.04.2019"
local version	= "1.50"
local mname	= "free_lj_mem"
-----------------------------------------------------------------------------------------------

local oldluamem = nil
local newluamem = nil
local reducemem = nil
local maxmem = 0 -- ever registered maximun (guess needed)
local minmem = 0 -- seen minimum (try out also)
local log = 1
local warning = 0
local loaded = 0


-- following settings can be changed by admin as wanted, needed - useful
-- some parameter set in minetest.conf
looptime = 86400 -- set repeat time in sec, 60 min = 3600
if minetest.setting_get("looptime") ~= nil then
	looptime = tonumber(minetest.setting_get("looptime")) -- calue out of .conf
end
local terminal = 1 -- set 0 if no print in terminal wanted
local message = 1 -- set to 1 if want chatmessage to player set after
local player_name = minetest.setting_get("name") -- admin out of .conf
maxluamem = 350000 -- set to value 10% ? less then lowest known OOM
if minetest.setting_get("maxluamem") ~= nil then
	maxluamem = tonumber(minetest.setting_get("maxluamem")) -- value out of .conf
end
-- END of settings to change mostly


-- use debug_log_level to set - this is so much more code, hmm
-- as is this a error(no - then OOM), warning(yes if>max), action(yes collect), info(loading)
if minetest.setting_get("debug_log_level") == "warning" then
	warning = 1
end
if minetest.setting_get("debug_log_level") == "action" then
	warning = 1
	log = 1
end
if minetest.setting_get("debug_log_level") == "info" then
	warning = 1
	log = 1
	loaded = 1
end


-- detecting lua or luajit and version -- for later usage
local luajit = 0
if type(jit) == 'table' then
  print("[Mod] free_lj_mem detected: "..jit.version)
	luajit = 1
--	maxluamem = 500000 -- set to value less then known OOM with JIT
else
 	luajit = 0
-- 	maxluamem = 1000000 -- set to value less then known OOM with lua only
end

--	clearobjects quick	--?

local function cleanup()
	oldluamem = math.floor(collectgarbage("count"))
	if oldluamem > maxmem then maxmem = oldluamem end
	collectgarbage()
	newluamem = math.floor(collectgarbage("count"))
	reducemem = oldluamem - newluamem

-- recheck if settings was changed during game by /priv server /set ...
	if minetest.setting_get("looptime") ~= nil then
		looptime = tonumber(minetest.setting_get("looptime")) -- value read of .conf
	end
	if minetest.setting_get("maxluamem") ~= nil then
		maxluamem = tonumber(minetest.setting_get("maxluamem")) -- value read of .conf
	end

-- set of minimal memory usage registered
	if newluamem < minmem or minmem == 0 then minmem = newluamem end

-- prepare logtext with report collectgarbage() result
	local logtext = "[MOD] "..mname..": "..oldluamem.." -"..reducemem.." = "..newluamem.." (max: "..maxmem.." / min: "..minmem..") KB"
	if log then
		minetest.log("action", logtext)
	end

	if terminal then
		print(logtext)
	end

	if  message then
		minetest.chat_send_player(player_name, logtext)
	end

	-- prepare logtext with warning about newluamen > maxluamen
	local logtext = "[MOD] "..mname.." warning: "..newluamem.." actual more memory used then set max: "..maxluamem.." KB ! possible OOM"
	if warning and newluamem > maxluamem and log then
	 	minetest.log("action", logtext)
	end

	if warning and newluamem > maxluamem and terminal then
		print(logtext)
	end

	if warning and newluamem > maxluamem and message then
		minetest.chat_send_player(player_name, logtext)
	end

	-- release var as take some time to reuse
	oldluamem = nil
	newluamem = nil
	logtext = nil

	-- recall itself- yes!
	minetest.after(looptime, cleanup)
end

minetest.after(looptime, cleanup)


if loaded then
	print ("[Mod] "..title.." settings: "..looptime.." sec / warn: "..maxluamem.." KB log: "..minetest.setting_get("debug_log_level"))
	print ("[Mod] "..title.." ("..version.." "..date..") - end mem : "..math.floor(collectgarbage("count")).." KB")
end
