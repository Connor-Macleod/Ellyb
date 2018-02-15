---@type Ellyb
local Ellyb = Ellyb(...);

-- Lua imports
local pairs = pairs;
local strsub = strsub;
local strtrim = strtrim;
local concat = table.concat;
local insert = table.insert;
local wipe = wipe;

-- WoW imports
local IsShiftKeyDown = IsShiftKeyDown;
local GetTime = GetTime;
local Mixin = Mixin;

local EditBoxes = {};

---@param editBox EditBox|ScriptObject
local function saveEditBoxOriginalText(editBox)
	if editBox.readOnly then
		editBox.originalText = editBox:GetText();
	end
end

---@param editBox EditBox|ScriptObject
local function restoreOriginalText(editBox, userInput)
	if userInput and editBox.readOnly then
		editBox:SetText(editBox.originalText);
	end
end

---@param editBox EditBox|ScriptObject
function EditBoxes.makeReadOnly(editBox)

	editBox.readOnly = true;

	editBox:HookScript("OnShow", saveEditBoxOriginalText);

	editBox:HookScript("OnTextChanged", restoreOriginalText);
end


---@param editBox EditBox|ScriptObject
function EditBoxes.selectAllTextOnFocus(editBox)
	editBox:HookScript("OnEditFocusGained", editBox.HighlightText);
end

---@param editBox EditBox|ScriptObject
function EditBoxes.looseFocusOnEscape(editBox)
	editBox:HookScript("OnEscapePressed", editBox.ClearFocus);
end

---Setup keyboard navigation using the tab key inside a list of EditBoxes.
---Pressing tab will jump to the next EditBox in the list, and shift-tab will go back to the previous one.
---@param ... EditBox[] @ A list of EditBoxes
function EditBoxes.setupTabKeyNavigation(...)
	local editBoxes = { ... };
	local maxBound = #editBoxes;
	local minBound = 1;
	for index, editbox in pairs(editBoxes) do
		editbox:SetScript("OnTabPressed", function(self, button)
			local cursor = index
			if IsShiftKeyDown() then
				if cursor == minBound then
					cursor = maxBound
				else
					cursor = cursor - 1
				end
			else
				if cursor == maxBound then
					cursor = minBound
				else
					cursor = cursor + 1
				end
			end
			editBoxes[cursor]:SetFocus();
		end)
	end
end

local MAX_CHARACTERS_IN_EDITBOX = 2500;

--- Mixin that will define the behaviour of an EditBox optimized to allow pasting of huge amount of text by using
--- a buffer to get the pasted text and truncate the text that is actually displayed in the UI.
---@class EditBoxWithPasteBufferMixin : EditBox
local EditBoxWithPasteBufferMixin = {
	pastedTextBuffer = {},
	lastPaste = 0,
	pastedText = "",
};

--- Reset paste buffer, to prepare for the next paste
function EditBoxWithPasteBufferMixin:ResetPasteBuffer()
	wipe(self.pastedTextBuffer)
	self.lastPaste = GetTime();
end

--- Clear the buffer of the EditBox, save the pasted text to be retrieved via custom GetText()
function EditBoxWithPasteBufferMixin:ClearBuffer()
	-- Remove OnUpdate script to clear buffer
	self:SetScript('OnUpdate', nil)

	-- Get the pasted text from the buffer
	self.pastedText = strtrim(concat(self.pastedTextBuffer));

	-- Only insert a chunk of the text inside the EditBox to preserve performances
	self:SetText(strsub(self.pastedText, 1, MAX_CHARACTERS_IN_EDITBOX));

	-- Reset the buffer, prepare for next paste
	self:ResetPasteBuffer();
end

function EditBoxWithPasteBufferMixin:OnChar(char)
	-- If the time is different this is a new paste, we prepare the buffer to be cleared on the next frame
	if self.lastPaste ~= GetTime() then
		self:SetScript('OnUpdate', self.ClearBuffer)
	end

	-- Insert new char in the buffer
	insert(self.pastedTextBuffer, char)
end

--- Override the EditBox GetText function to fetch the text from the pastedText buffer result rather than the truncated UI
---@return string pastedText
function EditBoxWithPasteBufferMixin:GetText()
	return self.pastedText;
end

--- Setup a paste buffer behaviour to allow the user to paste a huge amount of data inside the EditBox.
--- This was largely inspired by how WeakAuras handle pasting huge exports by using this kind of buffer.
---@param editBox EditBox @ The EditBox that should get the paste buffer behavior
---@param onPastedCallback function @ Called when something has been pasted, with the entire text pasted as first argument
function EditBoxes.setupEditBoxWithPasteBuffer(editBox, onPastedCallback)

	-- Inject our mixin's methods into the EditBox
	Mixin(editBox, EditBoxWithPasteBufferMixin);

	-- Register scripts
	editBox:SetScript("OnChar", editBox.OnChar);

	-- Limit the number of characters in the EditBox to preserve performances
	editBox:SetMaxBytes(MAX_CHARACTERS_IN_EDITBOX);
end

Ellyb.EditBoxes = EditBoxes;