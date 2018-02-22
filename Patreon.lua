----------------------------------------------------------------------------------
--- List of Ellypse's Patreon supporters
--- http://patreon.com/Ellypse
---
--- The Ellyb library is made thanks to the generous contribution of my Patreon supporters
--- This file lists those supporters and prepares and formatted list for me to easily insert
--- inside my add-ons
----------------------------------------------------------------------------------

---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.GetPatreonSupporters then
	return
end

-- Lua imports
local sort = sort;
local pairs = pairs;

local PURPLE = Ellyb.ColorManager.PURPLE;

local GOLDEN_SUPPORTERS = {
	"Bas(AstaLawl)",
	"Connor Macleod",
	"Vlad",
	"Mooncubus",
}

local PATREON_SUPPORTERS = {
	"Nikradical",
	"Solanya",
	"Ripperley",
	"Keyboardturner",
	"Petr Cihelka",
}

sort(GOLDEN_SUPPORTERS);
sort(PATREON_SUPPORTERS);

local LINE_FORMAT = "- %s\n";

local patreonMessage = "";
for _, patreonSupporter in pairs(GOLDEN_SUPPORTERS) do
	patreonMessage = patreonMessage .. LINE_FORMAT:format(PURPLE:WrapTextInColorCode(patreonSupporter));
end
patreonMessage = patreonMessage .. "\n";
for _, patreonSupporter in pairs(PATREON_SUPPORTERS) do
	patreonMessage = patreonMessage .. LINE_FORMAT:format(patreonSupporter);
end

Ellyb.PATREON_SUPPORTERS_LIST = patreonMessage;

--- Get the list of Patreon supporters. It will look for the most recent version of the library to make sure we
--- always display a list that is the most up to date
---@return string listOfPatreonSupporters @ Return the list of Patreon supporters
function Ellyb:GetPatreonSupporters()
	return self:GetMostUpToDateVersion().PATREON_SUPPORTERS_LIST;
end