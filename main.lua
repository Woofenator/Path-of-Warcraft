local PoW = LibStub("AceAddon-3.0"):NewAddon("PathOfWarcraft", "AceConsole-3.0",
                                             "AceEvent-3.0", "AceHook-3.0");
local AceGUI = LibStub("AceGUI-3.0")

function PoW:OnInitialize()
    self:SecureHook("TalentFrame_LoadUI");
    self:SecureHook("ToggleTalentFrame");

    local frame = AceGUI:Create("Frame");

    frame:SetTitle("Path of Warcraft");
    frame:SetHeight(800);
    frame:SetWidth(GetNumTalentTabs() * 300)
    frame:Hide();

    self.frame = frame;
    self.ogHandlers = nil;
    -- self:SetBackdrop();
end

function PoW:OnEnable()
    -- Called when the addon is enabled
end

function PoW:OnDisable()
    -- Called when the addon is disabled
    PlayerTalentFrame:SetScript("OnShow", self.ogHandlers.OnShow);
    PlayerTalentFrame:SetScript("OnHide", self.ogHandlers.OnHide);
    self.ogHandlers = nil;
end

function PoW:MuteBlizzSounds()
    self:Print("Muting Blizz TalentUI Sounds")
    local originalHandlers = {};
    originalHandlers.OnShow = PlayerTalentFrame:GetScript("OnShow");
    originalHandlers.OnHide = PlayerTalentFrame:GetScript("OnHide");

    PlayerTalentFrame:SetScript("OnShow", function() end);
    PlayerTalentFrame:SetScript("OnHide", function() end);

    self.ogHandlers = originalHandlers;
end

function PoW:PrintTalentInfo()
    local name, _, pointsSpent, fileName = GetTalentTabInfo(2);
    local base;

    if (name) then
        base = "Interface\\TalentFrame\\" .. fileName .. "-";
    else
        -- temporary default for classes without talents poor guys
        base = "Interface\\TalentFrame\\MageFire-";
    end

    self:Print("Name: ", name);
    self:Print("pointsSpent: ", pointsSpent);
    self:Print("fileName: ", base);
    -- self.frame:SetBackdrop({bgFile = base .. 'TopLeft'})
end

function PoW:ToggleTalentFrame()
    -- Here to disable sound spamming on PlayerTalentFrame hiding
    if (self.ogHandlers == nil) then self:MuteBlizzSounds(); end

    if (PlayerTalentFrame:IsShown()) then HideUIPanel(PlayerTalentFrame); end

    if (self.frame:IsShown()) then
        PlaySound(SOUNDKIT.TALENT_SCREEN_CLOSE);
        self.frame:Hide();
    else
        PlaySound(SOUNDKIT.TALENT_SCREEN_OPEN);
        self:PrintTalentInfo();
        self.frame:Show();
    end
end

function PoW:TalentFrame_LoadUI()
    if (self.ogHandlers == nil) then self:MuteBlizzSounds(); end
end
