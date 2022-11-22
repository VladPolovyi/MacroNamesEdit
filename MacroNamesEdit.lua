MacroNamesEditInformation = {}
local LocaleMacroEdit = LibStub("AceLocale-3.0"):GetLocale("NamesEdit")

-- Main Frame
-- local Main_Frame = CreateFrame("Frame", "MainPanel", InterfaceOptionsFramePanelContainer)
local MacroNameFrame = CreateFrame("Frame", "asd", SettingsPanel.Container)

-- local Main_Frame = CreateFrame("Frame", UIParent)

--default values
local defaultValues_DB = {
	Dps = "dps_macro_name",
	Heal = "heal_macro_name",
	Macro = "#showtooltip Intervene\n/cancelaura Bladestorm\n/use [@NAME] Intervene",
	DpsName = "dpsname",
	Healname = "healname"
}

--saved values, loaded by loadData()
local savedValues_DB = {}

--values changed by events
local internValues_DB = {
	showChatMessages = false, -- true when 'PLAYER_ENTERING_WORLD' fired or cb Event gets triggered
	firstLoad = true
}

local UpdateTable = {}

--*End Variables*

--*End Variables*

--Text top
local Main_Title = MacroNameFrame:CreateFontString("MainTitle", "OVERLAY", "GameFontHighlight")
local Main_Text_Version = CreateFrame("SimpleHTML", "MainTextVersion", MacroNameFrame)
local Main_Text_Author = CreateFrame("SimpleHTML", "MainTextAuthor", MacroNameFrame)
local MNE_version = "1.0.0"
local MNE_versionOutput = "|cFF00FF00Version|r  " .. MNE_version
local MNE_author = "Solairexc"
local MNE_authorOutput = "|cFF00FF00Author|r   " .. MNE_author
local IText1_output = "Addon changes names in your one pair of macros for heal and dps"
local MNE_YourHealMacro = "|cffffcc00Used macro for Healer: |r   "
local MNE_YourDpsMacro = "|cffffcc00Used macro for Dps: |r   "

-- local InputDps_output = "dps macro"
-- local InputHeal_output = "heal macro"
local Macro_output = "#showtooltip Intervene\n/cancelaura Bladestorm\n/use [@NAME] Intervene"

-- text info
local IText1 = CreateFrame("SimpleHTML", "TextExplain1", MacroNameFrame)

-- inputs
local InputDps = CreateFrame("Editbox", nil, MacroNameFrame, "InputBoxTemplate")
local InputHeal = CreateFrame("Editbox", nil, MacroNameFrame, "InputBoxTemplate")
-- local InputMacros = CreateFrame("Editbox", nil, MacroNameFrame, "InputBoxTemplate")
local InputMacros = CreateFrame("ScrollFrame", nil, MacroNameFrame, "UIPanelScrollFrameTemplate") -- or your actual parent instead
local InputMacrosE = CreateFrame("EditBox", nil, InputMacros)

local ApplyButton = CreateFrame("Button", "ApplyButton", MacroNameFrame, "GameMenuButtonTemplate")

local SavedDPS = CreateFrame("SimpleHTML", "SavedDPS", MacroNameFrame)
local SavedHEAL = CreateFrame("SimpleHTML", "SavedHEAL", MacroNameFrame)

local function createFrame()
	MacroNameFrame.name = "MacroNamesEdit"
	Main_Title:SetFont("Fonts\\FRIZQT__.TTF", 18)
	Main_Title:SetTextColor(1, 0.8, 0)
	Main_Title:SetPoint("TOPLEFT", 12, -18)
	Main_Title:SetText("MacroNamesEdit")

	InterfaceOptions_AddCategory(MacroNameFrame)
end

local function createText()
	Main_Text_Version:SetPoint("TOPLEFT", 20, -45)
	Main_Text_Version:SetFontObject("p", "GameTooltipTextSmall")
	Main_Text_Version:SetText(MNE_versionOutput)
	Main_Text_Version:SetSize(string.len(MNE_versionOutput), 10)

	Main_Text_Author:SetPoint("TOPLEFT", 20, -55)
	Main_Text_Author:SetFontObject("p", "GameFontHighlightSmall")
	Main_Text_Author:SetText(MNE_authorOutput)
	Main_Text_Author:SetSize(string.len(MNE_authorOutput), 10)

	IText1:SetPoint("TOPLEFT", 10, -100)
	IText1:SetFontObject("p", "GameFontHighlightSmall")
	IText1:SetText(IText1_output)
	IText1:SetSize(string.len(IText1_output), 10)

	SavedHEAL:SetPoint("TOPLEFT", 20, -220)
	SavedHEAL:SetFontObject("p", "GameFontHighlightMedium")
	SavedHEAL:SetSize(540, 10)

	-- SavedHEAL:SetSize(string.len(MNE_YourHealMacro .. defaultValues_DB.Heal), 10)

	SavedDPS:SetPoint("TOPLEFT", 20, -240)
	SavedDPS:SetFontObject("p", "GameFontHighlightMedium")
	SavedDPS:SetSize(540, 10)
	-- SavedDPS:SetSize(string.len(MNE_YourDpsMacro .. defaultValues_DB.Dps), 10)
end

local function createInput()
	InputHeal:SetPoint("TOPLEFT", 15, -150)
	InputHeal:SetSize(570, 10)
	InputHeal:SetAutoFocus(false)
	InputHeal:SetMaxLetters(30)
	InputHeal:SetFontObject("ChatFontNormal")
	InputHeal:SetMultiLine(false)
	local InputHealTitle = MacroNameFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	InputHealTitle:SetText("Enter Healer macros")
	InputHealTitle:SetPoint("TOPLEFT", InputHeal, 0, 20)

	InputDps:SetPoint("TOPLEFT", 15, -190)
	InputDps:SetSize(570, 10)
	InputDps:SetAutoFocus(false)
	InputDps:SetMaxLetters(30)
	InputDps:SetFontObject("ChatFontNormal")
	InputDps:SetMultiLine(false)
	local InputDpsTitle = MacroNameFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	InputDpsTitle:SetText("Enter DPS macros")
	InputDpsTitle:SetPoint("TOPLEFT", InputDps, 0, 20)

	InputMacros:SetSize(570, 150)
	InputMacros:SetPoint("TOPLEFT", 15, -300)
	InputMacrosE:SetMultiLine(true)
	InputMacrosE:SetFontObject(ChatFontNormal)
	InputMacrosE:SetWidth(300)
	InputMacros:SetScrollChild(InputMacrosE)
	InputMacrosE:SetAutoFocus(false)

	-- InputMacros:SetPoint("TOPLEFT", 15, -300)
	-- InputMacros:SetSize(570, 150)
	-- InputMacros:SetAutoFocus(false)
	-- InputMacros:SetMaxLetters(1000)
	-- InputMacros:SetFontObject("ChatFontNormal")
	-- InputMacros:SetMultiLine(true)
	-- InputMacros:SetTextInsets(50,50,50,50)
	-- local InputMacroTitle = MacroNameFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	-- InputMacroTitle:SetText("Macros body")
	-- InputMacroTitle:SetPoint("TOPLEFT", InputMacros, 0, 20)

	-- InputMacros:SetBackdrop({
	-- 	bgFile = [[Interface\Buttons\WHITE8x8]],
	-- 	edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
	-- 	edgeSize = 14,
	-- 	insets = {left = 3, right = 3, top = 3, bottom = 3},
	-- })
	-- InputMacros:SetBackdropColor(0, 0, 0)
	-- InputMacros:SetBackdropBorderColor(0.3, 0.3, 0.3)
	-- InputMacros:SetMultiLine(true)
	-- InputMacros:SetSize(300, 300)
	-- InputMacros:SetPoint("TOPLEFT", 300, -107)
	-- InputMacros:SetAutoFocus(false)
	-- InputMacros:SetText("test")
	-- InputMacros:SetCursorPosition(0)
	-- InputMacros:SetFont("Fonts\\FRIZQT__.TTF", 10)
	-- InputMacros:SetJustifyH("LEFT")
	-- InputMacros:SetJustifyV("CENTER")
	ApplyButton:SetPoint("CENTER", 0, -200)
	ApplyButton:SetSize(140, 40)
	ApplyButton:SetText("Apply")
	ApplyButton:SetNormalFontObject("GameFontNormalLarge")
	ApplyButton:SetHighlightFontObject("GameFontHighlightLarge")
end

local function updateInputs()
	if savedValues_DB.Dps then
		SavedDPS:SetText(MNE_YourDpsMacro .. savedValues_DB.Dps)
	-- InputDps:SetText("")
	end

	if savedValues_DB.Heal then
		SavedHEAL:SetText(MNE_YourHealMacro .. savedValues_DB.Heal)
	-- InputHeal:SetText("")
	end

	if savedValues_DB.Macro then
		InputMacrosE:SetText(savedValues_DB.Macro)
	-- InputMacros:SetMaxLetters(300)
	end
end

--Fired by player logout + cbs
local function SaveOptions()
	for key in pairs(savedValues_DB) do
		if savedValues_DB[key] ~= nil and savedValues_DB[key] ~= "" then
			MacroNamesEditInformation[key] = savedValues_DB[key]
		end
	end
end

--*End Creating*
local function loadData()
	--load defaults first
	for key in pairs(defaultValues_DB) do
		savedValues_DB[key] = defaultValues_DB[key]
	end

	--load saved data, fallback are the defaulValues
	for key in pairs(MacroNamesEditInformation) do
		if MacroNamesEditInformation[key] ~= nil and MacroNamesEditInformation[key] ~= "" then
			savedValues_DB[key] = MacroNamesEditInformation[key]
		end
	end
end

local function applyEdit()
	if not InCombatLockdown() then
		if savedValues_DB.Dps ~= "" and savedValues_DB.Heal ~= "" and savedValues_DB.Macro ~= "" then
			-- print("apply stuff")

			if GetNumGroupMembers() > 0 then
				-- print("Healer: |cff00ccff" .. name_healer .. "|r Dps: |cff00ccff" .. name_dps .. "|r")
				local party1name = UnitName("party1")
				local party2name = UnitName("party2")

				local party1role = UnitGroupRolesAssigned("party1")
				local party2role = UnitGroupRolesAssigned("party2")
				local name_healer = ""
				local name_dps = ""

				if party1name ~= nil then
					if party1role == "DAMAGER" then
						name_dps = party1name
					elseif party1role == "HEALER" then
						name_healer = party1name
					end
				end
				if party2name ~= nil then
					if party2role == "DAMAGER" then
						name_dps = party2name
					elseif party2role == "HEALER" then
						name_healer = party2name
					end
				end

				print(name_dps)
				print(name_healer)

				if name_healer and name_dps == "" then
					if party1role == "TANK" then
						name_dps = party1name
					elseif party2role == "TANK" then
						name_dps = party2name
					end
				end

				if name_dps and name_healer == "" then
					if party1role == "TANK" then
						name_healer = party1name
					elseif party2role == "TANK" then
						name_healer = party2name
					end
				end

				if name_dps ~= nil then
					print("Edited macros |cff00ccff" .. savedValues_DB.Dps .. "|r with name: |cff00ccff" .. name_dps .. "|r")
					local intevene_macro_dps = savedValues_DB.Macro:gsub("NAME", name_dps)

					local macroId = EditMacro(savedValues_DB.Dps, nil, nil, intevene_macro_dps, 1, 1)
				else
					print("no dps")
				end

				if name_healer ~= nil then
					print("Edited macros |cff00ccff" .. savedValues_DB.Heal .. "|r with name: |cff00ccff" .. name_healer .. "|r")
					local intevene_macro_healer = savedValues_DB.Macro:gsub("NAME", name_healer)
					local macroId2 = EditMacro(savedValues_DB.Heal, nil, nil, intevene_macro_healer, 1, 1)
				else
					print("no healer")
				end
			else
				print("|cff00ccffYou are not in party|r")
			end
		else
			print("|cff00ccffSome fields not filled|r")
		end
	end
end

local function applyButtonEvent()
	ApplyButton:SetScript(
		"OnClick",
		function()
			if not InCombatLockdown() then
				internValues_DB.showChatMessages = true
				savedValues_DB.Dps = InputDps:GetText()
				savedValues_DB.Heal = InputHeal:GetText()
				savedValues_DB.Macro = InputMacrosE:GetText()
				SaveOptions()
				updateInputs()
				applyEdit()
			else
				-- if savedValues_DB.ChatMessagesOn then
				-- end
				updateInputs()
			end
		end
	)
end

--Events
local function frameEvent()
	MacroNameFrame:RegisterEvent("PLAYER_LOGOUT")
	-- MacroNameFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	MacroNameFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
	MacroNameFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	MacroNameFrame:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
	MacroNameFrame:SetScript(
		"OnEvent",
		function(self, event, ...)
			-- print(event)

			if event == "PLAYER_LOGOUT" then
				SaveOptions()
				MacroNameFrame:UnregisterEvent(event)
			elseif event == "PLAYER_REGEN_ENABLED" then
				-- print("regen?")
				for frame, _ in pairs(UpdateTable) do
					UpdateTable[frame] = nil
				end

				applyEdit()
			elseif event == "GROUP_ROSTER_UPDATE" then
				-- print("roster?")
				if not InCombatLockdown() then
					applyEdit()
				end
			elseif
				(event == "PLAYER_ENTERING_WORLD" and not InCombatLockdown()) or
					(event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" and HasLoadedCUFProfiles() and not InCombatLockdown())
			 then
				-- print("entering?")

				if internValues_DB.firstLoad then
					-- print("first load")
					loadData()
					updateInputs()
					internValues_DB.showChatMessages = true
				-- internValues_DB.firstLoad = false
				end
				applyEdit()
			end
		end
	)
end

---End Events
local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript(
	"OnEvent",
	function(self, event, argument)
		if event == "ADDON_LOADED" and argument == "MacroNamesEdit" then
			createFrame()
			createText()
			createInput()
			frameEvent()
			applyButtonEvent()
			self:UnregisterEvent("ADDON_LOADED")
		end
	end
)
