---@type Ellyb
local Ellyb = Ellyb(...);

-- We are using Ellyb.loc here to store the locale table so we get code completion from the IDE
-- The table will be replaced by the complete Localization system, with metatable lookups for the localization keys
---@class loc : Localization
local loc  = {
	-- System
	MODIFIERS_CTRL = "Ctrl",
	MODIFIERS_ALT = "Alt",
	MODIFIERS_SHIFT = "Shift",
	MODIFIERS_MAC_CTRL = "Command",
	MODIFIERS_MAC_ALT = "Option",
	MODIFIERS_MAC_SHIFT = "Shift",
	CLICK = "Click",
	RIGHT_CLICK = "Right-Click",
	LEFT_CLICK = "Left-Click",
	MIDDLE_CLICK = "Middle-Click",
	DOUBLE_CLICK = "Double-Click",

	-- Popups
	COPY_URL_POPUP_TEXT = [[
You can copy this link by using the %s keyboard shortcut and then paste the link inside your browser using the %s shortcut.
]],

	-- Patreon supporters
	---@language HTML
	PATREON_SUPPORTERS = [[This is add-on is being maintained and updated thanks to the help of <a href="ellypse_patreon">|cfff96854Ellype's Patreon supporters|r</a>:

%s
]],
};

loc = Ellyb.Localization(loc);
Ellyb.loc = loc;

Ellyb.loc:RegisterNewLocale("enUS", "English", {});

Ellyb.loc:RegisterNewLocale("frFR", "Français", {
	-- System
	MODIFIERS_CTRL = "Contrôle",
	MODIFIERS_ALT = "Alt",
	MODIFIERS_SHIFT = "Maj",
	MODIFIERS_MAC_CTRL = "Commande",
	MODIFIERS_MAC_ALT = "Option",
	MODIFIERS_MAC_SHIFT = "Maj",
	CLICK = "Clic",
	RIGHT_CLICK = "Clic droit",
	LEFT_CLICK = "Clic gauche",
	MIDDLE_CLICK = "Clic milieu",
	DOUBLE_CLICK = "Double clic",

	-- Popups
	COPY_URL_POPUP_TEXT = [[
Vous pouvez copier ce lien en utilisant le raccourci clavier %s pour ensuite le coller dans votre navigateur web avec le raccourci clavier %s.
]],

	-- Patreon supporters
	---@language HTML
	PATREON_SUPPORTERS = [[Cet add-on est maintenu et mis-à-jour grâce au soutien des <a href="ellypse_patreon">|cfff96854supporters du Patreon de Ellypse|r</a>:

%s
]],
})

Ellyb.loc:SetCurrentLocale(GetLocale(), true);