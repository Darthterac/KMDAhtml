-- Old Gods Guild Chat — Member Search & Roster Tools
-- Author: Doug "Lazyeyez"
-- "Void Interface" theme — pass 1 (dark mode + class-color hover states)
--
-- Design intent: this addon is named after the Old Gods, so the reskin leans
-- into that instead of doing a generic dark-mode pass. Panels are near-black
-- void glass, there's a single restrained violet "pulse" accent used for
-- focus/emphasis, and player class colors are the only saturated color
-- allowed to appear — and only on hover, so the UI reads as quiet until a
-- person interacts with it. See the OGUI module below for the shared kit;
-- reuse it for any future frames instead of hand-rolling new templates.

local tableAccents = {
    ["À"] = "A",
    ["Á"] = "A",
    ["Â"] = "A",
    ["Ã"] = "A",
    ["Ä"] = "A",
    ["Å"] = "A",
    ["Æ"] = "AE",
    ["Ç"] = "C",
    ["È"] = "E",
    ["É"] = "E",
    ["Ê"] = "E",
    ["Ë"] = "E",
    ["Ì"] = "I",
    ["Í"] = "I",
    ["Î"] = "I",
    ["Ï"] = "I",
    ["Ð"] = "D",
    ["Ñ"] = "N",
    ["Ò"] = "O",
    ["Ó"] = "O",
    ["Ô"] = "O",
    ["Õ"] = "O",
    ["Ö"] = "O",
    ["Ø"] = "O",
    ["Ù"] = "U",
    ["Ú"] = "U",
    ["Û"] = "U",
    ["Ü"] = "U",
    ["Ý"] = "Y",
    ["Þ"] = "P",
    ["ß"] = "ss",
    ["à"] = "a",
    ["á"] = "a",
    ["â"] = "a",
    ["ã"] = "a",
    ["ä"] = "a",
    ["å"] = "a",
    ["æ"] = "ae",
    ["ç"] = "c",
    ["è"] = "e",
    ["é"] = "e",
    ["ê"] = "e",
    ["ë"] = "e",
    ["ì"] = "i",
    ["í"] = "i",
    ["î"] = "i",
    ["ï"] = "i",
    ["ð"] = "d",
    ["ñ"] = "n",
    ["ò"] = "o",
    ["ó"] = "o",
    ["ô"] = "o",
    ["õ"] = "o",
    ["ö"] = "o",
    ["ø"] = "o",
    ["ù"] = "u",
    ["ú"] = "u",
    ["û"] = "u",
    ["ü"] = "u",
    ["ý"] = "y",
    ["þ"] = "p",
    ["ÿ"] = "y",
    ["Ā"] = "A",
    ["Ă"] = "A",
    ["Ą"] = "A",
    ["Ć"] = "C",
    ["Ĉ"] = "C",
    ["Ċ"] = "C",
    ["Č"] = "C",
    ["Ď"] = "D",
    ["Đ"] = "D",
    ["Ē"] = "E",
    ["Ĕ"] = "E",
    ["Ė"] = "E",
    ["Ę"] = "E",
    ["Ě"] = "E",
    ["Ĝ"] = "G",
    ["Ğ"] = "G",
    ["Ġ"] = "G",
    ["Ģ"] = "G",
    ["Ĥ"] = "H",
    ["Ħ"] = "H",
    ["Ĩ"] = "I",
    ["Ī"] = "I",
    ["Ĭ"] = "I",
    ["Į"] = "I",
    ["İ"] = "I",
    ["Ĳ"] = "IJ",
    ["Ĵ"] = "J",
    ["Ķ"] = "K",
    ["Ĺ"] = "L",
    ["Ļ"] = "L",
    ["Ľ"] = "L",
    ["Ŀ"] = "L",
    ["Ł"] = "L",
    ["Ń"] = "N",
    ["Ņ"] = "N",
    ["Ň"] = "N",
    ["Ŋ"] = "N",
    ["Ō"] = "O",
    ["Ŏ"] = "O",
    ["Ő"] = "O",
    ["Ŕ"] = "R",
    ["Ŗ"] = "R",
    ["Ř"] = "R",
    ["Ś"] = "S",
    ["Ŝ"] = "S",
    ["Ş"] = "S",
    ["Š"] = "S",
    ["Ţ"] = "T",
    ["Ť"] = "T",
    ["Ŧ"] = "T",
    ["Ũ"] = "U",
    ["Ū"] = "U",
    ["Ŭ"] = "U",
    ["Ů"] = "U",
    ["Ű"] = "U",
    ["Ų"] = "U",
    ["Ŵ"] = "W",
    ["Ŷ"] = "Y",
    ["Ÿ"] = "Y",
    ["Ź"] = "Z",
    ["Ż"] = "Z",
    ["Ž"] = "Z",
    ["ā"] = "a",
    ["ă"] = "a",
    ["ą"] = "a",
    ["ć"] = "c",
    ["ĉ"] = "c",
    ["ċ"] = "c",
    ["č"] = "c",
    ["ď"] = "d",
    ["đ"] = "d",
    ["ē"] = "e",
    ["ĕ"] = "e",
    ["ė"] = "e",
    ["ę"] = "e",
    ["ě"] = "e",
    ["ĝ"] = "g",
    ["ğ"] = "g",
    ["ġ"] = "g",
    ["ģ"] = "g",
    ["ĥ"] = "h",
    ["ħ"] = "h",
    ["ĩ"] = "i",
    ["ī"] = "i",
    ["ĭ"] = "i",
    ["į"] = "i",
    ["ı"] = "i",
    ["ĳ"] = "ij",
    ["ĵ"] = "j",
    ["ķ"] = "k",
    ["ĺ"] = "l",
    ["ļ"] = "l",
    ["ľ"] = "l",
    ["ŀ"] = "l",
    ["ł"] = "l",
    ["ń"] = "n",
    ["ņ"] = "n",
    ["ň"] = "n",
    ["ŋ"] = "n",
    ["ō"] = "o",
    ["ŏ"] = "o",
    ["ő"] = "o",
    ["ŕ"] = "r",
    ["ŗ"] = "r",
    ["ř"] = "r",
    ["ś"] = "s",
    ["ŝ"] = "s",
    ["ş"] = "s",
    ["š"] = "s",
    ["ţ"] = "t",
    ["ť"] = "t",
    ["ŧ"] = "t",
    ["ũ"] = "u",
    ["ū"] = "u",
    ["ŭ"] = "u",
    ["ů"] = "u",
    ["ű"] = "u",
    ["ų"] = "u",
    ["ŵ"] = "w",
    ["ŷ"] = "y",
    ["ź"] = "z",
    ["ż"] = "z",
    ["ž"] = "z",
}

local CLASS_COLORS = {
    ["Druid"] = "FF7D0A",
    ["Hunter"] = "A9D271",
    ["Mage"] = "40C7EB",
    ["Paladin"] = "F58CBA",
    ["Priest"] = "FFFFFF",
    ["Rogue"] = "FFF569",
    ["Shaman"] = "0070DE",
    ["Warlock"] = "8787ED",
    ["Warrior"] = "C79C6E",
    ["Death Knight"] = "C41E3A",
    ["Monk"] = "00FF96",
    ["Demon Hunter"] = "A330C9",
    ["Evoker"] = "33937F"
}

local RANK_COLORS = {
    ["GM"] = "FFA800",
    ["Officer"] = "A335EE",
    ["Veteran"] = "17a69a",
    ["Member"] = "0070DD",
    ["Initiate"] = "1EFF00"
}

local function GetClassColor(class)
    return CLASS_COLORS[class] or "FFFFFF"
end

local function GetRankColor(rank)
    return RANK_COLORS[rank] or "FFFFFF"
end

--#region Modern UI Kit ("Void Interface")
-- Shared dark-glass styling for every KMDA frame in this file. Palette is
-- deliberately restrained: void-black panels, one violet "Old God pulse"
-- accent used sparingly (focus states, the signature pulse line), and
-- player class colors as the only saturated color allowed to appear — and
-- only in response to a hover, so the UI feels like it reacts to a person
-- rather than shouting all the time. Reuse OGUI for new frames going
-- forward instead of reaching for Blizzard's stock templates.

local OGUI = {}

OGUI.Color = {
    bg         = { 0.043, 0.039, 0.055, 0.97 }, -- panel fill
    bgAlt      = { 0.075, 0.067, 0.094, 1.00 }, -- recessed / control fill
    border     = { 0.20, 0.16, 0.28, 1.00 },    -- hairline border, idle
    accent     = { 0.56, 0.30, 0.85, 1.00 },    -- "Old God pulse" violet
    text       = { 0.92, 0.91, 0.95, 1.00 },
    textMuted  = { 0.52, 0.49, 0.60, 1.00 },
    textHeader = { 0.72, 0.56, 0.89, 1.00 },
    textBtn    = { 0.35, 0.20, 0.79, 0.85 },
    online     = { 0.24, 0.84, 0.60, 1.00 }, -- teal-green
    offline    = { 0.79, 0.31, 0.42, 1.00 }, -- muted rose
}

OGUI.Backdrop = {
    bgFile   = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
    insets   = { left = 1, right = 1, top = 1, bottom = 1 },
}

function OGUI.HexToRGB(hex, alpha)
    hex = hex or "FFFFFF"
    return {
        tonumber(hex:sub(1, 2), 16) / 255,
        tonumber(hex:sub(3, 4), 16) / 255,
        tonumber(hex:sub(5, 6), 16) / 255,
        alpha or 1,
    }
end

-- Several stock Blizzard templates (GameMenuButtonTemplate, InputBoxTemplate,
-- etc.) don't ship with the backdrop API mixed in. Retrofit it rather than
-- requiring every CreateFrame call in the file to change templates.
function OGUI.EnsureBackdrop(frame)
    if not frame.SetBackdrop then
        Mixin(frame, BackdropTemplateMixin)
    end
end

-- Flat void-glass panel: solid dark fill + 1px hairline border.
function OGUI.SkinPanel(frame, colorOverride)
    OGUI.EnsureBackdrop(frame)
    frame:SetBackdrop(OGUI.Backdrop)
    local c = colorOverride or OGUI.Color.bg
    frame:SetBackdropColor(c[1], c[2], c[3], c[4])
    local b = OGUI.Color.border
    frame:SetBackdropBorderColor(b[1], b[2], b[3], b[4])
end

-- The UI's one animated flourish: a thin line under a title bar that
-- breathes slowly, like a heartbeat from the deep. Used once per top-level
-- frame — deliberately not reused anywhere else, so it stays a signature
-- rather than a tic.
function OGUI.AddPulseLine(parent, width, yOffset)
    local line = parent:CreateTexture(nil, "ARTWORK")
    local a = OGUI.Color.accent
    line:SetColorTexture(a[1], a[2], a[3], 1)
    line:SetSize(width, 2 or 120, 1)
    line:SetPoint("TOP", parent, "TOP", 0, yOffset or -30)

    local ag = line:CreateAnimationGroup()
    ag:SetLooping("BOUNCE")
    local anim = ag:CreateAnimation("Alpha")
    anim:SetFromAlpha(0.25)
    anim:SetToAlpha(0.99)
    anim:SetDuration(0.90)
    anim:SetSmoothing("IN_OUT")
    ag:Play()

    return line
end

local function ResolveColor(hoverColor, button)
    local hc = hoverColor
    if type(hc) == "function" then hc = hc(button) end
    if type(hc) == "string" then return OGUI.HexToRGB(hc) end
    if type(hc) == "table" then return hc end
    return OGUI.Color.accent
end

-- Strips a Blizzard button template down to flat void styling and gives it
-- a hover glow. hoverColor may be a hex string, an {r,g,b} table, or a
-- function(button) returning either — pass a getter when the right hover
-- color depends on runtime state, like the currently selected player's class.
function OGUI.SkinButton(button, hoverColor)
    OGUI.EnsureBackdrop(button)

    for _, region in ipairs({ button:GetRegions() }) do
        if region.GetObjectType and region:GetObjectType() == "Texture" then
            region:SetTexture(nil)
        end
    end

    button:SetBackdrop(OGUI.Backdrop)
    local c = OGUI.Color.bgAlt
    button:SetBackdropColor(c[1], c[2], c[3], c[4])
    local b = OGUI.Color.border
    button:SetBackdropBorderColor(b[1], b[2], b[3], b[4])

    local fs = button:GetFontString()
    if fs then
        local t = OGUI.Color.text
        fs:SetTextColor(t[1], t[2], t[3], 1)
    end

    button:SetScript("OnEnter", function(self)
        local hc = ResolveColor(hoverColor, self)
        self:SetBackdropBorderColor(hc[1], hc[2], hc[3], 1)
        self:SetBackdropColor(hc[1] * 0.22, hc[2] * 0.22, hc[3] * 0.22, 0.92)
        local hfs = self:GetFontString()
        if hfs then hfs:SetTextColor(hc[1], hc[2], hc[3], 1) end
    end)

    button:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(b[1], b[2], b[3], b[4])
        self:SetBackdropColor(c[1], c[2], c[3], c[4])
        local lfs = self:GetFontString()
        if lfs then
            local t = OGUI.Color.text
            lfs:SetTextColor(t[1], t[2], t[3], 1)
        end
    end)
end

-- Builds a fresh flat button with no Blizzard template baggage at all.
function OGUI.CreateButton(parent, width, height, text, hoverColor)
    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(width, height)
    local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fs:SetPoint("CENTER")
    btn:SetFontString(fs)
    btn:SetText(text)
    OGUI.SkinButton(btn, hoverColor)
    return btn
end

-- Small flat "×" close button used in place of Blizzard's stock close art,
-- so every frame in the addon shares the same chrome.
function OGUI.CreateCloseButton(parent)
    local btn = OGUI.CreateButton(parent, 22, 22, "×", { 0.79, 0.31, 0.42, 1 })
    btn:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 16)
    btn:SetPoint("TOPRIGHT", -6, -6)
    return btn
end

-- Flat, borderless edit box that matches the panel style, with the accent
-- color used as the focus ring.
function OGUI.SkinEditBox(editBox)
    OGUI.EnsureBackdrop(editBox)
    for _, region in ipairs({ editBox:GetRegions() }) do
        if region.GetObjectType and region:GetObjectType() == "Texture" then
            region:SetTexture(nil)
        end
    end
    editBox:SetBackdrop(OGUI.Backdrop)
    local c = OGUI.Color.bgAlt
    editBox:SetBackdropColor(c[1], c[2], c[3], c[4])
    local b = OGUI.Color.border
    editBox:SetBackdropBorderColor(b[1], b[2], b[3], b[4])
    editBox:SetTextInsets(8, 8, 0, 0)

    editBox:SetScript("OnEditFocusGained", function(self)
        local a = OGUI.Color.accent
        self:SetBackdropBorderColor(a[1], a[2], a[3], 1)
    end)
    editBox:SetScript("OnEditFocusLost", function(self)
        self:SetBackdropBorderColor(b[1], b[2], b[3], b[4])
    end)
end

_G.OGUI = OGUI -- exposed so future KMDA frames/modules can reuse the kit
--#endregion Modern UI Kit

--#region MemberSearch UI functions
local function FadeRow(row, stripe, classColor)
    local duration = 1.0
    local steps = 7 -- about .15 brightness each step
    local interval = duration / steps

    local r = classColor[1]
    local g = classColor[2]
    local b = classColor[3]

    local brightness = 0.20
    local alpha = 0.85

    local ticker
    local currentStep = 0

    ticker = C_Timer.NewTicker(interval, function()
        currentStep = currentStep + 1

        brightness  = math.max(0, brightness - 0.15 / 5)
        alpha       = math.max(0, alpha - (0.85 / steps))

        ---@diagnostic disable-next-line: lowercase-global
        selfColor   = brightness

        row:SetBackdropColor(
            r * brightness,
            g * brightness,
            b * brightness,
            alpha
        )

        stripe:SetColorTexture(r, g, b, alpha)

        if currentStep >= steps then
            ticker:Cancel()
            row:SetBackdropColor(0, 0, 0, 0)
            stripe:Hide()
        end
    end)
end

--#endregion

--#region MemberSearch RightClick Functions
local function ArmoryLinkLoL(CopiedNameLink, playerName)
    local linkFrame = _G["OldGodsArmoryLinkFrame"]
    if not linkFrame then
        linkFrame = CreateFrame("Frame", "OldGodsArmoryLinkFrame", UIParent, "BackdropTemplate")
        linkFrame:SetSize(450, 130)
        linkFrame:SetPoint("CENTER")
        linkFrame:SetFrameStrata("TOOLTIP")
        linkFrame:EnableMouse(true)
        linkFrame:SetMovable(true)
        linkFrame:RegisterForDrag("LeftButton")
        linkFrame:SetScript("OnDragStart", linkFrame.StartMoving)
        linkFrame:SetScript("OnDragStop", linkFrame.StopMovingOrSizing)
        OGUI.SkinPanel(linkFrame)

        linkFrame.title = linkFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        linkFrame.title:SetFont("Fonts\\FRIZQT__.TTF", 15)
        linkFrame.title:SetPoint("TOP", 0, -14)
        OGUI.AddPulseLine(linkFrame, 140, -30)

        linkFrame.instruction = linkFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        local muted = OGUI.Color.textMuted
        linkFrame.instruction:SetTextColor(muted[1], muted[2], muted[3], 1)
        linkFrame.instruction:SetPoint("TOP", linkFrame, "TOP", 0, -42)
        linkFrame.instruction:SetText("Press Control + C to copy")

        local editBox = CreateFrame("EditBox", nil, linkFrame, "InputBoxTemplate")
        editBox:SetSize(400, 30)
        editBox:SetPoint("CENTER", linkFrame, "CENTER", 0, -10)
        editBox:SetAutoFocus(true)
        OGUI.SkinEditBox(editBox)
        linkFrame.editBox = editBox

        editBox:SetScript("OnEscapePressed", function() linkFrame:Hide() end)

        editBox:SetScript("OnTextChanged", function(self)
            if self:GetText() ~= self.link then
                self:SetText(self.link)
                self:HighlightText()
            end
        end)

        editBox:SetScript("OnKeyUp", function(self, key)
            if IsControlKeyDown() and key == "C" then
                PlaySoundFile("Interface\\AddOns\\OldGods\\Sounds\\unregistered\\mixkit-open-selected-alert6.mp3")
                print(CreateAtlasMarkup("Battlenet-ClientIcon-WoW", 18, 18), " Link Copied!")
                linkFrame:Hide()
            end
        end)

        local closeButton = OGUI.CreateCloseButton(linkFrame)
        closeButton:SetScript("OnClick", function() linkFrame:Hide() end)
    end

    linkFrame.title:SetText("Armory Link for " .. (playerName or "Unknown"))
    linkFrame.editBox.link = CopiedNameLink
    linkFrame.editBox:SetText(CopiedNameLink)
    linkFrame.editBox:HighlightText()
    linkFrame:Show()
    linkFrame.editBox:SetFocus()
end

local function UrlFriendlyRealmName(realm) -- Function to format the return of realm from UnitName("target")
    if not realm then return nil end       -- and GetRealmName() into Blizzards url syntax.
    -- No need for a comparison table we just format in this order

    realm = realm:gsub("([A-Za-z])[Oo][Ff](%u)", "%1-of-%2") -- 1. Puts the -of- in the string                 | "AlterofStorms" to "Atler-of-Storms" |
    realm = realm:gsub("(%l)(%u)", "%1-%2")                  -- 2. Puts the - between lower and uppercase
    realm = realm:gsub("(%l)([0-9])", "%1-%2")               -- 2.1 hahaha Area52 you sneaky bugger
    realm = realm:gsub("\'", "")                             -- 3. Strip the hyphen returning url syntax       | "Kel'Thuzud" to "KelThuzud"          |
    realm = realm:gsub("%s+", "-")                           -- 4. GetRealmName() edgecase " " becomes -       | "Moon Guard" to "Moon-Gaurd"         |

    return
        realm -- 5. return the formated string like a boss, get a beer, do more tests dont push on a friday :}
end

local function ModMenu_GetArmoryLink(playerFullName)
    if not playerFullName then return end

    local name, realm = strsplit("-", playerFullName)
    if not realm or realm == "" then
        realm = GetRealmName()
    end

    if name and realm then
        Frealmn = UrlFriendlyRealmName(realm)
        local CopiedNameLink = "https://worldofwarcraft.blizzard.com/en-us/character/us/" ..
            Frealmn .. "/" .. name .. "/"
        ArmoryLinkLoL(CopiedNameLink, name)
    end
end
--#endregion MemberSearch RightClick Functions

--#region Member Search - Player Management
local guildRosterCache = {}
local searchFrame, scrollFrame, SR_scrollChild
local KMDARightClickMenu
local playerManagementFrame


--#region Player Management Frame
local function SetupMacroAndBind(action, player)
    if InCombatLockdown() then
        print("KMDA: Cannot update macros/bindings in combat.")
        return
    end

    local macroName = "KMDA_Action"
    local macroIndex = GetMacroIndexByName(macroName)
    local command = (action == "promote" and "/gpromote " or "/gdemote ") .. player

    if macroIndex == 0 then
        local numAccountMacros, _ = GetNumMacros()
        if numAccountMacros >= 120 then
            print("KMDA: General macro slots are full. Please delete one to use this feature.")
            return
        end
        macroIndex = CreateMacro(macroName, "INV_MISC_QUESTIONMARK", command, nil)
    else
        EditMacro(macroIndex, macroName, "INV_MISC_QUESTIONMARK", command)
    end

    local key = playerManagementFrame.selectedKey or "F5"
    SetBindingMacro(key, macroIndex)

    PlaySound(SOUNDKIT.READY_CHECK)
    print("KMDA: Action Ready! Press " ..
        key .. " to " .. (action == "promote" and "Promote" or "Demote") .. " " .. player)
end

local function CreatePlayerManagementFrame()
    if playerManagementFrame then return end

    playerManagementFrame = CreateFrame("Frame", "KMDAPlayerManagementFrame", UIParent, "BackdropTemplate")
    playerManagementFrame:SetSize(300, 320)
    playerManagementFrame:SetFrameStrata("TOOLTIP")
    OGUI.SkinPanel(playerManagementFrame)
    playerManagementFrame:EnableMouse(true)
    playerManagementFrame:SetClampedToScreen(true)
    playerManagementFrame.currentClassColor = nil -- set per-player in ShowPlayerManagementFrame, used for button hovers

    -- Title
    playerManagementFrame.title = playerManagementFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    playerManagementFrame.title:SetFont("Fonts\\FRIZQT__.TTF", 15)
    playerManagementFrame.title:SetPoint("TOP", 0, -15)
    playerManagementFrame.title:SetText("Player Management")
    OGUI.AddPulseLine(playerManagementFrame, 110, -30)

    -- Player Name
    playerManagementFrame.playerName = playerManagementFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    playerManagementFrame.playerName:SetPoint("TOP", playerManagementFrame.title, "BOTTOM", 0, -14)
    playerManagementFrame.playerName:SetFont("Fonts\\FRIZQT__.TTF", 19)

    -- Level and Rank
    playerManagementFrame.levelRank = playerManagementFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    playerManagementFrame.levelRank:SetFont("Fonts\\FRIZQT__.TTF", 16)
    do
        local m = OGUI.Color.textMuted
        playerManagementFrame.levelRank:SetTextColor(m[1], m[2], m[3])
    end
    playerManagementFrame.levelRank:SetPoint("TOP", playerManagementFrame.playerName, "BOTTOM", 0, -5)

    -- Keybind Display
    playerManagementFrame.keybindDisplay = playerManagementFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    playerManagementFrame.keybindDisplay:SetFont("Fonts\\FRIZQT__.TTF", 14)
    do
        local a = OGUI.Color.accent
        playerManagementFrame.keybindDisplay:SetTextColor(a[1], a[2], a[3])
    end
    playerManagementFrame.keybindDisplay:SetPoint("RIGHT", playerManagementFrame, "RIGHT", -20, 0)
    playerManagementFrame.keybindDisplay:SetPoint("TOP", playerManagementFrame.levelRank, "BOTTOM", 0, -10)
    playerManagementFrame.keybindDisplay:SetHeight(25)

    -- Key Selection Dropdown
    playerManagementFrame.selectedKey = "F5"
    local keyDropdown = CreateFrame("DropdownButton", nil, playerManagementFrame, "WowStyle1DropdownTemplate")
    keyDropdown:SetPoint("TOP", playerManagementFrame.levelRank, "BOTTOM", 0, -12)
    keyDropdown:SetPoint("RIGHT", playerManagementFrame.keybindDisplay, "LEFT", -5, 0)
    keyDropdown:SetWidth(120)
    keyDropdown:SetDefaultText("Bind: F5")
    playerManagementFrame.keybindDisplay:SetText(playerManagementFrame.selectedKey)

    -- Status Display
    playerManagementFrame.statusDisplay = playerManagementFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    playerManagementFrame.statusDisplay:SetPoint("LEFT", playerManagementFrame, "LEFT", 20, 0)
    playerManagementFrame.statusDisplay:SetPoint("TOP", keyDropdown, "TOP", 0, 0)
    playerManagementFrame.statusDisplay:SetPoint("BOTTOM", keyDropdown, "BOTTOM", 0, 0)
    playerManagementFrame.statusDisplay:SetJustifyH("LEFT")

    keyDropdown:SetupMenu(function(self, rootDescription)
        for _, key in ipairs({ "F5", "F6", "F7", "F8" }) do
            rootDescription:CreateButton(key, function()
                playerManagementFrame.selectedKey = key
                keyDropdown:SetText("Bind: " .. key)
                if playerManagementFrame.keybindDisplay then
                    playerManagementFrame.keybindDisplay:SetText(key)
                end
            end)
        end
    end)

    -- Buttons share one hover getter so they all glow in the selected
    -- player's class color, falling back to the accent violet if unknown.
    local function ClassHoverColor()
        return playerManagementFrame.currentClassColor
    end

    -- Promote Button
    playerManagementFrame.promoteBtn = CreateFrame("Button", nil, playerManagementFrame, "BackdropTemplate")
    playerManagementFrame.promoteBtn:SetSize(100, 25)
    playerManagementFrame.promoteBtn:SetPoint("TOP", keyDropdown, "BOTTOM", 0, -10)
    playerManagementFrame.promoteBtn:SetNormalFontObject("ReputationDetailFont")
    playerManagementFrame.promoteBtn:SetHighlightFontObject("GameFontHighlight")
    playerManagementFrame.promoteBtn:SetText("Promote")
    OGUI.SkinButton(playerManagementFrame.promoteBtn, ClassHoverColor)
    playerManagementFrame.promoteBtn:SetScript("OnClick", function()
        if playerManagementFrame.selectedPlayer then
            SetupMacroAndBind("promote", playerManagementFrame.selectedPlayer)
        end
    end)

    -- Whisper Button
    playerManagementFrame.whisperBtn = CreateFrame("Button", nil, playerManagementFrame, "BackdropTemplate")
    playerManagementFrame.whisperBtn:SetSize(100, 25)
    playerManagementFrame.whisperBtn:SetPoint("RIGHT", playerManagementFrame.promoteBtn, "LEFT", -10, 0)
    playerManagementFrame.whisperBtn:SetNormalFontObject("ReputationDetailFont")
    playerManagementFrame.whisperBtn:SetHighlightFontObject("GameFontHighlight")
    playerManagementFrame.whisperBtn:SetText("Whisper")
    OGUI.SkinButton(playerManagementFrame.whisperBtn, ClassHoverColor)
    playerManagementFrame.whisperBtn:SetScript("OnClick", function()
        if playerManagementFrame.selectedPlayer then
            ChatFrame_OpenChat("/w " .. playerManagementFrame.selectedPlayer .. " ")
        end
    end)

    -- Demote Button
    playerManagementFrame.demoteBtn = CreateFrame("Button", nil, playerManagementFrame, "BackdropTemplate")
    playerManagementFrame.demoteBtn:SetSize(100, 25)
    playerManagementFrame.demoteBtn:SetPoint("TOP", playerManagementFrame.promoteBtn, "BOTTOM", 0, -5)
    playerManagementFrame.demoteBtn:SetNormalFontObject("ReputationDetailFont")
    playerManagementFrame.demoteBtn:SetHighlightFontObject("GameFontHighlight")
    playerManagementFrame.demoteBtn:SetText("Demote")
    OGUI.SkinButton(playerManagementFrame.demoteBtn, ClassHoverColor)
    playerManagementFrame.demoteBtn:SetScript("OnClick", function()
        if playerManagementFrame.selectedPlayer then
            SetupMacroAndBind("demote", playerManagementFrame.selectedPlayer)
        end
    end)

    -- Invite Button
    playerManagementFrame.inviteBtn = CreateFrame("Button", nil, playerManagementFrame, "BackdropTemplate")
    playerManagementFrame.inviteBtn:SetSize(100, 25)
    playerManagementFrame.inviteBtn:SetPoint("RIGHT", playerManagementFrame.demoteBtn, "LEFT", -10, 0)
    playerManagementFrame.inviteBtn:SetNormalFontObject("ReputationDetailFont")
    playerManagementFrame.inviteBtn:SetHighlightFontObject("GameFontHighlight")
    playerManagementFrame.inviteBtn:SetText("Invite")
    OGUI.SkinButton(playerManagementFrame.inviteBtn, ClassHoverColor)
    playerManagementFrame.inviteBtn:SetScript("OnClick", function()
        if playerManagementFrame.selectedPlayer then
            C_PartyInfo.InviteUnit(playerManagementFrame.selectedPlayer)
        end
    end)

    -- Public Note Label
    local publicNoteLabel = playerManagementFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    publicNoteLabel:SetPoint("TOPLEFT", playerManagementFrame.inviteBtn, "BOTTOMLEFT", -20, -15)
    do
        local m = OGUI.Color.textMuted
        publicNoteLabel:SetTextColor(m[1], m[2], m[3])
    end
    publicNoteLabel:SetText("Public Note:")

    -- Public Note Display
    local publicNoteText = playerManagementFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    publicNoteText:SetPoint("TOPLEFT", publicNoteLabel, "BOTTOMLEFT", 0, -5)
    publicNoteText:SetWidth(255)
    publicNoteText:SetJustifyH("LEFT")
    do
        local t = OGUI.Color.text
        publicNoteText:SetTextColor(t[1], t[2], t[3])
    end

    playerManagementFrame.publicNoteText = publicNoteText

    --[[ Detailed Notes Label
    local detailedNotesLabel = playerManagementFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightCenter")
    detailedNotesLabel:SetPoint("TOPLEFT", publicNoteText, "BOTTOMLEFT", 0, -15)
    detailedNotesLabel:SetText("Create/Edit Player Notes:") ]]

    --[[ Open Notes Button
    local detailedNotesBtn = CreateFrame("Button", nil, playerManagementFrame, "UIPanelButtonTemplate")
    detailedNotesBtn:SetSize(150, 25)
    detailedNotesBtn:SetPoint("TOPLEFT", detailedNotesLabel, "BOTTOMLEFT", 0, -5)
    detailedNotesBtn:SetText("Open Notes")

    local time = 0
    detailedNotesBtn:SetScript("OnEnter", function(self)
        self:SetScript("OnUpdate", function(self, elapsed)
            time = (time + elapsed) % 100
            detailedNotesLabel:SetRotation(math.sin(time * 1.8) * math.rad(5))
        end)
    end)

    detailedNotesBtn:SetScript("OnLeave", function(self)
        self:SetScript("OnUpdate", nil)
        detailedNotesLabel:SetRotation(0)
    end)

    detailedNotesBtn:SetScript("OnClick", function()
        local playerName = playerManagementFrame.selectedPlayer
        if not playerName then return end

        CreateNotesFrame()

        if KMDA_SavedNotes and KMDA_SavedNotes[playerName] then
            KMDA_OpenSavedNote(playerName)
        else
            KMDA_NewNote()
            if notesFrame and notesFrame.titleBox then
                notesFrame.titleBox:SetText(playerName)
                notesFrame.editBox:SetFocus()
            end
        end
    end)]]

    -- Close Button
    local closeButton = OGUI.CreateCloseButton(playerManagementFrame)
    closeButton:SetScript("OnClick", function()
        playerManagementFrame:Hide()
    end)
end

local function ShowPlayerManagementFrame(name, online)
    CreatePlayerManagementFrame()
    playerManagementFrame.selectedPlayer = name

    -- Find member index and notes
    local index, note, officerNote, class, level, rank, years, months, days, hours, guid
    for i = 1, GetNumGuildMembers() do
        local n, r, _, l, c, _, nNote, oNote, _, _, _, _, _, _, _, _, playerGUID = GetGuildRosterInfo(i)
        if n == name then
            index = i
            note = nNote
            officerNote = oNote
            class = c
            level = l
            rank = r
            guid = playerGUID
            years, months, days, hours = GetGuildRosterLastOnline(i)
            break
        end
    end

    if class then
        local color = GetClassColor(class)
        playerManagementFrame.playerName:SetText("|cFF" .. color .. name .. "|r")
        playerManagementFrame.currentClassColor = OGUI.HexToRGB(color)
    else
        playerManagementFrame.playerName:SetText(name)
        playerManagementFrame.currentClassColor = nil
        if online then
            local o = OGUI.Color.online
            playerManagementFrame.playerName:SetTextColor(o[1], o[2], o[3])
        else
            local m = OGUI.Color.textMuted
            playerManagementFrame.playerName:SetTextColor(m[1], m[2], m[3])
        end
    end

    if level and rank then
        local rankColor = GetRankColor(rank)
        playerManagementFrame.levelRank:SetText("Level: " .. level .. "   Rank: |cFF" .. rankColor .. rank .. "|r")
    else
        playerManagementFrame.levelRank:SetText("")
    end

    if online then
        playerManagementFrame.statusDisplay:SetText("  Online Now!")
        local o = OGUI.Color.online
        playerManagementFrame.statusDisplay:SetTextColor(o[1], o[2], o[3])
    else
        local totalDays = (years or 0) * 365 + (months or 0) * 30 + (days or 0)
        if totalDays > 0 then
            playerManagementFrame.statusDisplay:SetText("Offline " .. totalDays .. " days")
        else
            playerManagementFrame.statusDisplay:SetText("Offline " .. (hours or 0) .. " hours")
        end
        local o = OGUI.Color.offline
        playerManagementFrame.statusDisplay:SetTextColor(o[1], o[2], o[3], 0.9)
    end

    playerManagementFrame.selectedIndex = index
    playerManagementFrame.selectedGUID = guid
    playerManagementFrame.publicNoteText:SetText((note or "None") .. "\n" .. (officerNote or "None"))

    playerManagementFrame:ClearAllPoints()
    if searchFrame and searchFrame:IsShown() then
        playerManagementFrame:SetPoint("LEFT", searchFrame, "RIGHT", 0, 0)
    else
        playerManagementFrame:SetPoint("CENTER")
    end
    playerManagementFrame:Show()
end
--#ndregion Create Player Management Frame

-- helper to hide RightClick menu
local function HideRightClickMenu()
    if KMDARightClickMenu then
        KMDARightClickMenu:Hide()
    end
end

-- Helper to create styled, clickable text lines in our menu. hoverColorFn is
-- an optional function() -> {r,g,b} used for the hover fill + accent stripe;
-- defaults to the violet accent when omitted.
local function CreateMenuOption(parent, text, yOffset, onClick, hoverColorFn)
    local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
    button:SetSize(parent:GetWidth() - 6, 24)
    button:SetPoint("TOP", 0, yOffset)
    OGUI.EnsureBackdrop(button)
    button:SetBackdrop(OGUI.Backdrop)
    button:SetBackdropColor(0, 0, 0, 0) -- transparent until hovered
    button:SetBackdropBorderColor(0, 0, 0, 0)

    local fontString = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fontString:SetPoint("LEFT", 10, 0)
    fontString:SetText(text)
    button:SetFontString(fontString)
    do
        local t = OGUI.Color.text
        fontString:SetTextColor(t[1], t[2], t[3], 1)
    end

    -- Left accent stripe, shown only on hover
    local stripe = button:CreateTexture(nil, "ARTWORK")
    stripe:SetPoint("TOPLEFT", 0, 0)
    stripe:SetPoint("BOTTOMLEFT", 0, 0)
    stripe:SetWidth(2)
    stripe:Hide()

    button:SetScript("OnEnter", function(self)
        local hc = (hoverColorFn and hoverColorFn()) or OGUI.Color.accent
        self:SetBackdropColor(hc[1] * 0.25, hc[2] * 0.25, hc[3] * 0.25, 0.85)
        stripe:SetColorTexture(hc[1], hc[2], hc[3], 1)
        stripe:Show()
        fontString:SetTextColor(hc[1], hc[2], hc[3], 1)
    end)

    button:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0, 0, 0, 0)
        stripe:Hide()
        local t = OGUI.Color.text
        fontString:SetTextColor(t[1], t[2], t[3], 1)
    end)

    button:SetScript("OnClick", function()
        onClick()
        C_Timer.After(0.5, HideRightClickMenu)
    end)

    return button
end

--right click menu functions
local function CreateRightClickMenu()
    if KMDARightClickMenu then return end

    KMDARightClickMenu = CreateFrame("Frame", "KMDARightClickMenu", UIParent, "BackdropTemplate")
    KMDARightClickMenu:SetFrameStrata("TOOLTIP")
    KMDARightClickMenu:SetSize(160, 112)
    OGUI.SkinPanel(KMDARightClickMenu)
    KMDARightClickMenu:Hide()

    -- Title for player name
    KMDARightClickMenu.title = KMDARightClickMenu:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    local font, height, flags = KMDARightClickMenu.title:GetFont()
    ---@diagnostic disable-next-line: param-type-mismatch
    KMDARightClickMenu.title:SetFont(font, height + 2, flags)
    KMDARightClickMenu.title:SetPoint("TOP", 0, -10)

    local function MenuHoverColor()
        return KMDARightClickMenu.playerClassColor
    end

    -- Invite Option
    KMDARightClickMenu.invite = CreateMenuOption(KMDARightClickMenu, "Invite", -34, function()
        if KMDARightClickMenu.playerName then
            C_PartyInfo.InviteUnit(KMDARightClickMenu.playerName)
        end
    end, MenuHoverColor)

    -- Whisper Option
    KMDARightClickMenu.whisper = CreateMenuOption(KMDARightClickMenu, "Whisper", -56, function()
        if KMDARightClickMenu.playerName then
            ChatFrame_OpenChat("/w " .. KMDARightClickMenu.playerName .. " ")
        end
    end, MenuHoverColor)

    --[[ Notes Option
    KMDARightClickMenu.notes = CreateMenuOption(KMDARightClickMenu, "Notes", -75, function()
        if KMDARightClickMenu.playerName then
            CreateNotesFrame()
            local playerName = KMDARightClickMenu.playerName
            if KMDA_SavedNotes and KMDA_SavedNotes[playerName] then
                KMDA_OpenSavedNote(playerName)
            else
                KMDA_NewNote()                              -- Clears fields
                if notesFrame and notesFrame.titleBox then
                    notesFrame.titleBox:SetText(playerName) -- Set title for new note
                    notesFrame.editBox:SetFocus()
                end
            end
        end
    end)]]

    --ModMenu_GetArmoryLink
    KMDARightClickMenu.armoryLink = CreateMenuOption(KMDARightClickMenu, "Armory Link", -78, function()
        if KMDARightClickMenu.playerName then
            ModMenu_GetArmoryLink(KMDARightClickMenu.playerName)
        end
    end, MenuHoverColor)


    -- Hide if the mouse leaves the menu area
    KMDARightClickMenu:SetScript("OnLeave", function(self)
        C_Timer.After(0.1, function()
            if not self:IsMouseOver() then
                self:Hide()
            end
        end)
    end)
end

local function ShowRightClickMenu(name, class)
    CreateRightClickMenu()               -- Ensure it's created

    KMDARightClickMenu.playerName = name -- Keep full name for functions
    local color = GetClassColor(class or "")
    KMDARightClickMenu.playerClassColor = class and OGUI.HexToRGB(color) or nil
    local shortName = Ambiguate(name, "short") -- Use short name for display
    KMDARightClickMenu.title:SetText("|cFF" .. color .. shortName .. "|r")

    KMDARightClickMenu:ClearAllPoints()
    local uiScale = UIParent:GetEffectiveScale()
    local x, y = GetCursorPosition()
    KMDARightClickMenu:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / uiScale, y / uiScale)
    KMDARightClickMenu:Raise()
    KMDARightClickMenu:Show()
end
--#endregion MemberSearch RightClick Menu

-- Normalize Search Input and Results
local function stripChars(str)
    if not str then return "" end
    local normalisedString = str:gsub("[%z\1-\127\194-\244][\128-\191]*", tableAccents)
    return string.lower(normalisedString)
end

-- Refresh the Guild Roster Search Table
--[[
local function RefreshGuildRosterCache()
    wipe(guildRosterCache) -- Clear old data
    for i = 1, GetNumGuildMembers() do
        local name, rank, _, _, class, _, _, _, online, _, _, _, _, _ = GetGuildRosterInfo(i)
        local hyperlinkName = "|Hplayer:" .. name .. "|h[" .. name .. "]|h"

        local year, month, day, hour = GetGuildRosterLastOnline(i)
        year = year and year or 0
        month = month and month or 0
        day = day and day or 0
        hour = hour and hour or 0
        local offlineHours = year * 8760 + month * 720 + day * 24 + hour

        table.insert(guildRosterCache, {
            linkName       = hyperlinkName,
            name           = name,
            normalizedName = stripChars(name),
            rank           = rank,
            class          = class,
            online         = online,
            year           = year,
            month          = month,
            day            = day,
            hour           = hour,
            lastOnline     = year .. "y " .. month .. "m " .. day .. "d " .. hour .. "h"
        })
    end

    table.sort(guildRosterCache, function(a, b)
        -- Online players first
        if a.online ~= b.online then
            return a.online
        end

        -- If both are online → sort by name
        if a.online then
            return a.name < b.name
        end

        -- Both offline → compare last online time
        if a.year ~= b.year then
            return a.year < b.year
        end

        if a.month ~= b.month then
            return a.month < b.month
        end

        if a.day ~= b.day then
            return a.day < b.day
        end

        if a.hour ~= b.hour then
            return a.hour < b.hour
        end

        -- final fallback
        return a.name < b.name
    end)
end
]]

local function RefreshGuildRosterCache()
    wipe(guildRosterCache) -- Clear old data

    -- Map current communities frame data provider using ONLY the first name prefix
    local scoreMap = {}
    local dp = CommunitiesFrame.MemberList.ScrollBox:GetDataProvider()
    for _, v in ipairs(dp.collection) do
        if v.memberInfo.name and v.memberInfo.overallDungeonScore then
            -- Grab everything before the first hyphen (e.g. "Darthterac-Lightbringer" -> "Darthterac")
            local cleanName = string.match(v.memberInfo.name, "^([^-]+)")
            scoreMap[cleanName] = v.memberInfo.overallDungeonScore
        end
    end

    for i = 1, GetNumGuildMembers() do
        local name, rank, _, _, class, _, _, _, online, _, _, _, _, _ = GetGuildRosterInfo(i)

        -- Clean up the guild roster name the exact same way just in case it contains a realm
        local cleanGuildName = string.match(name, "^([^-]+)") or name
        local mplusScore = scoreMap[cleanGuildName] or 0

        local hyperlinkName = "|Hplayer:" .. name .. "|h[" .. name .. "]|h"
        local year, month, day, hour = GetGuildRosterLastOnline(i)
        year = year and year or 0
        month = month and month or 0
        day = day and day or 0
        hour = hour and hour or 0

        table.insert(guildRosterCache, {
            linkName       = hyperlinkName,
            name           = name,
            normalizedName = stripChars(name),
            rank           = rank,
            class          = class,
            online         = online,
            year           = year,
            month          = month,
            day            = day,
            hour           = hour,
            lastOnline     = year .. "y " .. month .. "m " .. day .. "d " .. hour .. "h",
            score          = mplusScore
        })
    end

    table.sort(guildRosterCache, function(a, b)
        -- Online players first
        if a.online ~= b.online then
            return a.online
        end

        -- If both are online → sort by name
        if a.online then
            return a.name < b.name
        end

        -- Both offline → compare last online time
        if a.year ~= b.year then
            return a.year < b.year
        end

        if a.month ~= b.month then
            return a.month < b.month
        end

        if a.day ~= b.day then
            return a.day < b.day
        end

        if a.hour ~= b.hour then
            return a.hour < b.hour
        end

        -- final fallback
        return a.name < b.name
    end)
end

-- Clear Previous Search Results
local function ClearSearchResults()
    for _, child in ipairs({ SR_scrollChild:GetChildren() }) do
        child:Hide()
        child:SetParent(nil) -- Prevent lingering references
    end
end

-- helper function thanks Nyx
local function FormatOfflineTime(lastOnline)
    -- Expecting lastOnline like: "0y 0m 0d 0h"
    local y, m, d, h = lastOnline:match("(%d+)y%s+(%d+)m%s+(%d+)d%s+(%d+)h")

    y = tonumber(y) or 0
    m = tonumber(m) or 0
    d = tonumber(d) or 0
    h = tonumber(h) or 0

    -- Recently condition
    if y == 0 and m == 0 and d == 0 and h == 0 then
        return "|cff8f4dd9Logged Recently!|r"
    end

    return string.format("|cffc94f6bOffline|r %dy %dm %dd %dh", y, m, d, h)
end

-- Member Searcch Results Population
local function UpdateSearchResults(searchText)
    ClearSearchResults() -- Remove old results
    local offsetY = 6
    local rowHeight = 23

    for _, member in ipairs(guildRosterCache) do
        local playerName = member.name
        local status

        if member.online then
            status = "|cff3dd699Online|r"
        else
            status = FormatOfflineTime(member.lastOnline)
        end

        -- Compare normalized strings
        if member.normalizedName:find(searchText, 1, true) then
            -- Each row is itself the clickable element now (not just the name),
            -- and glows in the player's own class color on hover — the void
            -- reacting to a person, not a generic highlight.
            local row = CreateFrame("Button", nil, SR_scrollChild, "BackdropTemplate")
            row:SetSize(560, rowHeight)
            row:SetPoint("TOPLEFT", SR_scrollChild, "TOPLEFT", 4, -offsetY)
            row:RegisterForClicks("LeftButtonUp", "RightButtonUp")
            OGUI.EnsureBackdrop(row)
            row:SetBackdrop(OGUI.Backdrop)
            row:SetBackdropColor(0, 0, 0, 0)
            row:SetBackdropBorderColor(0, 0, 0, 0)

            local stripe = row:CreateTexture(nil, "ARTWORK")
            stripe:SetPoint("TOPLEFT", 0, 0)
            stripe:SetPoint("BOTTOMLEFT", 0, 0)
            stripe:SetWidth(2)
            stripe:Hide()

            local classColor = OGUI.HexToRGB(GetClassColor(member.class))

            row:SetScript("OnEnter", function(self)
                self:SetBackdropColor(
                    classColor[1] * 0.20,
                    classColor[2] * 0.20,
                    classColor[3] * 0.20,
                    0.85
                )

                stripe:SetColorTexture(
                    classColor[1],
                    classColor[2],
                    classColor[3],
                    1
                )

                stripe:Show()
            end)

            row:SetScript("OnLeave", function(self)
                FadeRow(self, stripe, classColor)
            end)
            row:SetScript("OnClick", function(self, button)
                if button == "RightButton" then
                    ShowRightClickMenu(member.name, member.class)
                elseif button == "LeftButton" then
                    if not C_GuildInfo.IsGuildOfficer() then
                        print("The Player Managment requires Officer rank.")
                        return
                    end
                    ShowPlayerManagementFrame(member.name, member.online)
                end
            end)


            ----------------------------------------------------------
            -- 1) Name Column (always class-colored, WoW convention)
            ----------------------------------------------------------
            local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2Outline")
            nameText:SetPoint("LEFT", row, "LEFT", 10, 0)
            nameText:SetWidth(175)
            nameText:SetWordWrap(false)
            nameText:SetMaxLines(1)
            nameText:SetJustifyH("LEFT")
            nameText:SetText("|cFF" .. GetClassColor(member.class) .. playerName .. "|r")

            ----------------------------------------------------------
            -- 2) Rank Column
            ----------------------------------------------------------
            local rankCol = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            rankCol:SetPoint("LEFT", nameText, "RIGHT", 35, 0)
            rankCol:SetWidth(85)
            rankCol:SetJustifyH("LEFT")
            rankCol:SetWordWrap(false)
            rankCol:SetMaxLines(1)
            do
                local rc = OGUI.Color.textMuted
                rankCol:SetTextColor(rc[1], rc[2], rc[3], 1)
            end
            rankCol:SetText(member.rank)

            ----------------------------------------------------------
            -- 3) Status Column
            ----------------------------------------------------------
            local statusCol = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            statusCol:SetPoint("LEFT", rankCol, "RIGHT", 30, 0)
            statusCol:SetWidth(165)
            statusCol:SetWordWrap(false)
            statusCol:SetMaxLines(1)
            statusCol:SetJustifyH("LEFT")
            statusCol:SetText(status)

            ----------------------------------------------------------
            -- 4) Mythic+ Score Column (NEW)
            ----------------------------------------------------------
            local scoreCol = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            scoreCol:SetPoint("LEFT", statusCol, "RIGHT", -10, 0)
            scoreCol:SetWidth(70)
            scoreCol:SetJustifyH("LEFT")
            scoreCol:SetWordWrap(false)
            scoreCol:SetMaxLines(1)

            -- Format score color nicely based on standard score rules
            if member.score and member.score > 0 then
                local scoreColor = "ffffffff" -- default white
                if member.score >= 2500 then
                    scoreColor = "ffffe54e"   -- Gold
                elseif member.score >= 2000 then
                    scoreColor = "ffd335d9"   -- Purple
                elseif member.score >= 1600 then
                    scoreColor = "ff0070dd"   -- Blue
                elseif member.score >= 1000 then
                    scoreColor = "ff1eff0F"   -- Green
                end
                scoreCol:SetText("|c" .. scoreColor .. member.score .. "|r")
            else
                scoreCol:SetText("|cff777777 " .. "-" .. " |r") -- Gray placeholder dash for 0 rating
            end

            -- Increase the offset so the next row appears below
            offsetY = offsetY + rowHeight
        end
    end

    -- Adjust scroll child height so it can accommodate all rows
    SR_scrollChild:SetSize(520, math.max(offsetY, scrollFrame:GetHeight()))
end

-- Create the search frame (only once)
local function CreateSearchFrame()
    if searchFrame then return end -- Reuse the frame if it already exists

    searchFrame = CreateFrame("Frame", "KMDA_SearchFrame", UIParent, "BackdropTemplate")
    searchFrame:SetSize(560, 360)
    searchFrame:SetPoint("CENTER")
    searchFrame:SetFrameStrata("FULLSCREEN_DIALOG")
    searchFrame:SetFrameLevel(1)
    OGUI.SkinPanel(searchFrame)
    searchFrame:EnableMouse(true)
    searchFrame:SetMovable(true)
    searchFrame:RegisterForDrag("LeftButton")
    searchFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    searchFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    searchFrame:RegisterEvent("GUILD_ROSTER_UPDATE")
    searchFrame:SetScript("OnEvent", function(self, event)
        if event == "GUILD_ROSTER_UPDATE" and self:IsVisible() then
            RefreshGuildRosterCache()
            local inputBox = _G["KMDA_SearchInputBox"]
            local searchText = inputBox and stripChars(inputBox:GetText()) or ""
            UpdateSearchResults(searchText)
        end
    end)

    -- Title bar
    local title = searchFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    title:SetFont("Fonts\\FRIZQT__.TTF", 14)
    title:SetPoint("TOP", 0, -8)
    title:SetText("Lazy Search")
    OGUI.AddPulseLine(searchFrame, 98, -24)

    -- Input box label
    local inputLabel = searchFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal_NoShadow")
    inputLabel:SetPoint("TOPLEFT", 95, -40)
    inputLabel:SetText(CreateAtlasMarkup("communities-icon-searchmagnifyingglass", 24, 24) .. " Search:")
    do
        local a = OGUI.Color.accent
        inputLabel:SetTextColor(a[1], a[2], a[3])
    end

    -- Input box for search
    local inputBox = CreateFrame("EditBox", "KMDA_SearchInputBox", searchFrame, "InputBoxTemplate")
    inputBox:SetSize(200, 24)
    inputBox:SetPoint("LEFT", inputLabel, "RIGHT", 5, 0)
    inputBox:SetAutoFocus(false)
    OGUI.SkinEditBox(inputBox)
    inputBox:SetScript("OnTextChanged", function(self)
        local searchTextGet = self:GetText()
        local searchText = stripChars(searchTextGet) -- Normalize search input too
        UpdateSearchResults(searchText)
    end)

    -- Refresh Search Button
    local refreshButton = CreateFrame("Button", nil, searchFrame, "BackdropTemplate")
    refreshButton:SetSize(64, 24)
    refreshButton:SetPoint("LEFT", inputBox, "RIGHT", 5, 0)
    refreshButton:SetNormalFontObject("ChatFontNormal")
    refreshButton:SetHighlightFontObject("ChatFontSmall")
    refreshButton:SetText("Refresh")
    OGUI.SkinButton(refreshButton)
    refreshButton:SetScript("OnClick", function()
        C_GuildInfo.GuildRoster()
        inputBox:SetText("")
        inputBox:ClearFocus()
    end)

    -- Close button
    local closeButton = OGUI.CreateCloseButton(searchFrame)
    closeButton:SetScript("OnClick", function()
        searchFrame:Hide()
    end)

    -- Headers for columns (offsets tuned to line up with the row grid below)
    local headers = {
        { text = "NAME",   width = 185, point = "TOPLEFT", refFrame = "searchFrame", offsetX = 0,   offsetY = -68 },
        { text = "RANK",   width = 185, point = "TOPLEFT", refFrame = "searchFrame", offsetX = 155, offsetY = -68 },
        { text = "STATUS", width = 185, point = "TOPLEFT", refFrame = "searchFrame", offsetX = 275, offsetY = -68 },
        { text = "RATING", width = 185, point = "TOPLEFT", refFrame = "searchFrame", offsetX = 420, offsetY = -68 },
    }

    for _, header in ipairs(headers) do
        local headerText = searchFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        headerText:SetSize(header.width, 20)
        headerText:SetPoint(header.point, searchFrame, header.point, header.offsetX, header.offsetY)
        headerText:SetText(header.text)
        local m = OGUI.Color.textHeader
        headerText:SetTextColor(m[1], m[2], m[3])
    end

    -- Thin divider between the header row and the scrolling results
    local divider = searchFrame:CreateTexture(nil, "ARTWORK")
    local b = OGUI.Color.border
    divider:SetColorTexture(b[1], b[2], b[3], 0.8)
    divider:SetSize(548, 1.5)
    divider:SetPoint("TOP", searchFrame, "TOP", 0, -85)

    -- Scrollable list for results
    scrollFrame = CreateFrame("ScrollFrame", "KMDA_SearchResultsScrollFrame", searchFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetSize(searchFrame:GetWidth() - 20, searchFrame:GetHeight() - 98)
    scrollFrame:SetPoint("BOTTOM", 0, 10)

    -- Best-effort scrollbar tint so it doesn't clash with the void palette;
    -- harmless no-op if the client's scrollbar structure doesn't match.
    local scrollBar = _G[(scrollFrame:GetName() or "") .. "ScrollBar"]
    
    if scrollBar then
        scrollBar:SetThumbTexture(464139)
        local thumb = scrollBar.GetThumbTexture and scrollBar:GetThumbTexture()
        if thumb then
            local a = OGUI.Color.accent
            thumb:SetVertexColor(a[1], a[2], a[3])
        end
    end

    SR_scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollFrame:SetScrollChild(SR_scrollChild)
    return SR_scrollChild
end


-- Main function to initiate and refresh member search
local function KMDA_MemberSearch()
    C_GuildInfo.GuildRoster() -- Trigger GUILD_ROSTER_UPDATE
    RefreshGuildRosterCache() -- Update cache
    CreateSearchFrame()
    searchFrame:Show()
end

SLASH_LAZYSEARCH1 = "/lazy"
SLASH_LAZYSEARCH2 = "/ls"

SlashCmdList["LAZYSEARCH"] = KMDA_MemberSearch

local myTab = CreateFrame("Button", "LazySearchFrameTab", CommunitiesFrame, "BackdropTemplate")
myTab:SetPoint("BOTTOMLEFT", CommunitiesFrame.GuildInfoTab, "BOTTOMRIGHT", -35, -58)
myTab:SetSize(42, 42)
myTab:SetNormalAtlas("ui-debug-tool-icon-large")
myTab:SetHighlightAtlas("communities-icon-searchmagnifyingglass")
myTab:SetPushedAtlas("communities-icon-searchmagnifyingglass")
myTab:SetScript("OnEnter", function()
    GameTooltip:SetOwner(myTab, "ANCHOR_TOPRIGHT", 98, -7)
    GameTooltip:ClearLines()
    GameTooltip:AddLine("Lazy Search", 1, 0.90, 0.25, false)
    GameTooltip:Show()
end)

myTab:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

myTab:SetScript("OnClick", function()
    KMDA_MemberSearch()
end)

--#endregion MemberSearch
