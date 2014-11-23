function safeGet(path,fallback,origin)
	local from = origin or _G
	local lPath = ''
	for curr,delim in string.gmatch (path, "([%a_]+)([^%a_]*)") do
		local isFunc = string.find(delim,'%(')
		if isFunc then
			from = from[curr](from)
		else
			from = from[curr]
		end
		lPath = lPath..curr..delim
		if not from then
			break
		elseif type(from) ~= 'table' and type(from) ~= 'userdata' then
			if lPath ~= path then
				from = nil
				break
			end
		end
	end
	if not from and fallback ~= nil then
		return fallback
	else
		return from
	end
end
function RayTest (len,ignoreUnit)
	local from = safeGet('managers.player:player_unit():movement():m_head_pos()')
	if not from then return end
	local to = from + safeGet('managers.player:player_unit():movement():m_head_rot():y()') * (len or 300000)
	return World:raycast( "ray", from, to, "slot_mask", managers.slot:get_mask( ignoreUnit and "trip_mine_placeables" or "bullet_impact_targets" ), "ignore_unit", {} )
end
function pairsByKeys (t, f) -- pairs but sorted
  local a = {}
  for n in pairs(t) do table.insert(a, n) end
  table.sort(a, f)
  local i = 0
  local iter = function ()
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
  end
  return iter
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local ignore = function() end
_Output = _Output or {}
_Output.Chat = function (name,message,color)
	if safeGet('managers.chat._receivers') and managers.chat._receivers[1] then
		for _,rcv in pairs( managers.chat._receivers[1] ) do
			rcv:receive_message( name or "*", tostring(message), color or tweak_data.chat_colors[5] )
		end
	end
end
function toStr(...)
	local result = ''
	for k,v in pairs({...}) do
		result = result .. ' ' .. tostring(v)
	end
	return result
end

_Output = _Output or {}
_Output.Chat = function (name,message,color)
	if safeGet('managers.chat._receivers') and managers.chat._receivers[1] then
		for _,rcv in pairs( managers.chat._receivers[1] ) do
			rcv:receive_message( name or "*", tostring(message), color or tweak_data.chat_colors[5] )
		end
	end
end
_Output.Console = function(...)
	io.stderr:write(toStr(...)..'\n')
end
_Output.Debug = function(...)
	safeGet('managers.mission._show_debug_subtitle')(managers.mission,toStr(...)..'  ')
end
_Output.File = function(txt)
	local f = io.open("!script\\output.txt", "a")
	local v = (type(txt)=="string" or type(txt)=="number") and txt or type(txt)
	if type(txt) == "boolean" then v = txt and "TRUE" or "FALSE" end
	--f:write(os.date("%X:")..v.."\n")
	f:write(v.."\n")
	f:close()
end

