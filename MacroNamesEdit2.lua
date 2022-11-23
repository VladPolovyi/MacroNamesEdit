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
local IText1_output = "Addon checks if there is one dps and one healer/tank in the group."
-- local InputDps_output = "dps macro"
-- local InputHeal_output = "heal macro"
-- local Macro_output = "#showtooltip Intervene\n/cancelaura Bladestorm\n/use [@NAME] Intervene"

-- text info
local IText1 = CreateFrame("SimpleHTML", "TextExplain1", MacroNameFrame)

-- inputs
local InputDps = CreateFrame("Editbox", nil, MacroNameFrame, "InputBoxTemplate")
local InputHeal = CreateFrame("Editbox", nil, MacroNameFrame, "InputBoxTemplate")
-- local InputMacros = CreateFrame("ScrollFrame", "inputMacros", Main_Frame, "InputScrollFrameTemplate")
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

    SavedDPS:SetPoint("TOPLEFT", 10, -210)
    SavedDPS:SetFontObject("p", "GameFontHighlightSmall")
    SavedDPS:SetSize(string.len(IText1_output), 10)

    SavedHEAL:SetPoint("TOPLEFT", 10, -230)
    SavedHEAL:SetFontObject("p", "GameFontHighlightSmall")
    SavedHEAL:SetSize(string.len(IText1_output), 10)
end

local function createInput()
    InputDps:SetPoint("TOPLEFT", 15, -150)
    InputDps:SetSize(570, 10)
    InputDps:SetAutoFocus(false)
    InputDps:SetMaxLetters(30)
    InputDps:SetFontObject("ChatFontNormal")
    InputDps:SetMultiLine(false)
    local InputDpsTitle = MacroNameFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    InputDpsTitle:SetText("Enter DPS macros")
    InputDpsTitle:SetPoint("TOPLEFT", InputDps, 0, 20)

    InputHeal:SetPoint("TOPLEFT", 15, -190)
    InputHeal:SetSize(570, 10)
    InputHeal:SetAutoFocus(false)
    InputHeal:SetMaxLetters(30)
    InputHeal:SetFontObject("ChatFontNormal")
    InputHeal:SetMultiLine(false)
    local InputHealTitle = MacroNameFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    InputHealTitle:SetText("Enter Healer macros")
    InputHealTitle:SetPoint("TOPLEFT", InputHeal, 0, 20)

    ApplyButton:SetPoint("CENTER", 0, -200)
    ApplyButton:SetSize(140, 40)
    ApplyButton:SetText("Apply")
    ApplyButton:SetNormalFontObject("GameFontNormalLarge")
    ApplyButton:SetHighlightFontObject("GameFontHighlightLarge")
end

local function updateInputs()
    if savedValues_DB.Dps then
        SavedDPS:SetText(savedValues_DB.Dps)
        InputDps:SetText("")
    end

    if savedValues_DB.Heal then
        SavedHEAL:SetText(savedValues_DB.Heal)
        InputHeal:SetText("")
    end

    -- if savedValues_DB.Macro then
    -- 	InputMacros.EditBox:SetText(savedValues_DB.Macro)
    -- 	InputMacros.EditBox:SetMaxLetters(300)
    -- end
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
        if savedValues_DB.Dps ~= nil and savedValues_DB.Heal ~= nil and savedValues_DB.Macro ~= nil then
            -- print("apply stuff")

            if GetNumGroupMembers() > 0 then
                local party1name = UnitName("party1")
                local party2name = UnitName("party2")

                local party1role = UnitGroupRolesAssigned("party1")
                local party2role = UnitGroupRolesAssigned("party2")
                local name_healer = ""
                local name_dps = ""

                print("party1 in party?: ")

                print(UnitInParty("party1"))
                print(UnitName("party1"))

                
                print("party2 in party?: ")

                print(UnitInParty("party2"))
                print(UnitName("party2"))


                if party1name ~= nil then
                    if party1role == "DAMAGER" then
                        name_dps = party1name
                    elseif party1role == "HEALER" then
                        name_healer = party1name
                    else
                        print("something wrong with party1: " .. party1role)
                    end
                end
                if party2name ~= nil then
                    if party2role == "DAMAGER" then
                        name_dps = party2name
                    elseif party2role == "HEALER" then
                        name_healer = party2name
                    else
                        print("something wrong with party2: " .. party2role)
                    end
                end

                if name_dps ~= nil then
                    local intevene_macro_dps = savedValues_DB.Macro:gsub("NAME", name_dps)

                    local macroId = EditMacro(savedValues_DB.Dps, nil, nil, intevene_macro_dps, 1, 1)
                    print(
                        "Edited macros [name:|cff00ccff" ..
                            savedValues_DB.Dps .. "|r ] with name: |cff00ccff" .. name_dps .. "|r"
                    )
                else
                    print("no dps")
                end

                if name_healer ~= nil then
                    local intevene_macro_healer = savedValues_DB.Macro:gsub("NAME", name_healer)

                    local macroId2 = EditMacro(savedValues_DB.Heal, nil, nil, intevene_macro_healer, 1, 1)
                    print(
                        "Edited macros [name: |cff00ccff" ..
                            savedValues_DB.Heal .. "|r ] with name: |cff00ccff" .. name_healer .. "|r"
                    )
                else
                    print("no healer")
                end
            else
                print("|cff00ccffYou are not in party|r")
                print(savedValues_DB.Dps)
                print(savedValues_DB.Heal)
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
                -- savedValues_DB.Macro = InputMacros.EditBox:GetText()
                SaveOptions()
                updateInputs()
                applyEdit()
            else
                updateInputs()
                if savedValues_DB.ChatMessagesOn then
                    print(ColorText(L["SortGroup_in_combat_options_output"], "option"))
                end
            end
        end
    )
end

--Events
local function frameEvent()
    MacroNameFrame:RegisterEvent("PLAYER_LOGOUT")
    MacroNameFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    MacroNameFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    MacroNameFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    MacroNameFrame:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
    MacroNameFrame:SetScript(
        "OnEvent",
        function(self, event, ...)
            print(event)

            if event == "PLAYER_LOGOUT" then
                SaveOptions()
                MacroNameFrame:UnregisterEvent(event)
            elseif event == "PLAYER_REGEN_ENABLED" then
                for frame, _ in pairs(UpdateTable) do
                    UpdateTable[frame] = nil
                end

                applyEdit()
            elseif event == "GROUP_ROSTER_UPDATE" then
                if not InCombatLockdown() then
                    applyEdit()
                end
            elseif
                (event == "PLAYER_ENTERING_WORLD" and HasLoadedCUFProfiles() and not InCombatLockdown()) or
                    (event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" and HasLoadedCUFProfiles() and
                        not InCombatLockdown())
             then
                if internValues_DB.firstLoad then
                    loadData()
                    updateInputs()
                    -- resetRaidContainer() -- hooks
                    internValues_DB.showChatMessages = true
                    internValues_DB.firstLoad = false
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
