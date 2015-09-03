﻿local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local x = "8"
local bigmark = 11
local smallmark = 5
local timersize = 12

-- [[ Raid Buffs ]] -- http://www.wowhead.com/guide=1100#buffs-stats

-- Effect: +5% Strength, Agility, and Intellect
oUF.Tags.Methods['mlight:SAI'] = function(u) 
	if not (
	UnitBuff(u, GetSpellInfo(1126)) or -- druid
	UnitBuff(u, GetSpellInfo(20217)) or -- paladin
	UnitBuff(u, GetSpellInfo(115921)) or -- monk
	UnitBuff(u, GetSpellInfo(90363)) -- hunter
	) then return "|cffCD00CD"..x.."|r" end 
end
oUF.Tags.Events['mlight:SAI'] = "UNIT_AURA"

-- Effect: +10% Stamina
oUF.Tags.Methods['mlight:Stamina'] = function(u) 
	if not (
	UnitBuff(u, GetSpellInfo(21562)) or -- priest
	UnitBuff(u, GetSpellInfo(109773)) or -- warlock
	UnitBuff(u, GetSpellInfo(469)) or -- warrior
	UnitBuff(u, GetSpellInfo(90364)) -- hunter
	) then return "|cffFFFFFF"..x.."|r" end 
end
oUF.Tags.Events['mlight:Stamina'] = "UNIT_AURA"

-- Effect: +10% melee and ranged attack power
oUF.Tags.Methods['mlight:AP'] = function(u) 
	if not (
	UnitBuff(u, GetSpellInfo(57330)) or -- death knight
	UnitBuff(u, GetSpellInfo(6673)) or -- warrior
	UnitBuff(u, GetSpellInfo(19506)) -- hunter
	) then return "|cff8B4513"..x.."|r" end 
end
oUF.Tags.Events['mlight:AP'] = "UNIT_AURA"

-- Effect: +10% spell power
oUF.Tags.Methods['mlight:SP'] = function(u) 
	if not (
	UnitBuff(u, GetSpellInfo(1459)) or UnitBuff(u, GetSpellInfo(61316)) or -- mage
	--UnitBuff(u, GetSpellInfo(77747)) or -- shaman
	UnitBuff(u, GetSpellInfo(109773)) or -- warlock
	UnitBuff(u, GetSpellInfo(126309)) -- hunter
	) then return "|cff00FFFF"..x.."|r" end 
end
oUF.Tags.Events['mlight:SP'] = "UNIT_AURA"

-- Effect: +10% melee and ranged haste
oUF.Tags.Methods['mlight:Haste'] = function(u) 
	if not (
	UnitBuff(u, GetSpellInfo(55610)) or -- death knight
	UnitBuff(u, GetSpellInfo(113742)) or -- rogue
	UnitBuff(u, GetSpellInfo(30809)) or -- shaman
	UnitBuff(u, GetSpellInfo(128432)) or UnitBuff(u, GetSpellInfo(128433)) -- hunter (pet)
	) then return "|cffEEB422"..x.."|r" end
end
oUF.Tags.Events['mlight:Haste'] = "UNIT_AURA"

-- Effect: +5% spell haste
oUF.Tags.Methods['mlight:SpellHaste'] = function(u) 
	if not (
	UnitBuff(u, GetSpellInfo(24907)) or -- druid
	UnitBuff(u, GetSpellInfo(15473)) or -- priest
	UnitBuff(u, GetSpellInfo(51470)) -- shaman
	) then return "|cffFF1493"..x.."|r" end
end
oUF.Tags.Events['mlight:SpellHaste'] = "UNIT_AURA"

-- Effect: +5% ranged, melee, and spell critical chance
oUF.Tags.Methods['mlight:Crit'] = function(u) 
	if not (
	UnitBuff(u, GetSpellInfo(17007)) or -- druid
	UnitBuff(u, GetSpellInfo(1459)) or UnitBuff(u, GetSpellInfo(61316)) or -- mage
	UnitBuff(u, GetSpellInfo(116781)) or -- monk
	UnitBuff(u, GetSpellInfo(126373)) or UnitBuff(u, GetSpellInfo(126309)) or -- hunter
	UnitBuff(u, GetSpellInfo(97229)) or UnitBuff(u, GetSpellInfo(90309)) -- hunter (pet)
	) then return "|cffEEEE00"..x.."|r" end
end
oUF.Tags.Events['mlight:Crit'] = "UNIT_AURA"

-- Effect: +3000 mastery
oUF.Tags.Methods['mlight:Mastery'] = function(u) 
	if not (
	UnitBuff(u, GetSpellInfo(19740)) or -- paladin
	UnitBuff(u, GetSpellInfo(116956)) or -- shaman
	UnitBuff(u, GetSpellInfo(128997)) or -- hunter
	UnitBuff(u, GetSpellInfo(93435)) -- hunter (pet)
	) then return "|cffD3D3D3"..x.."|r" end
end
oUF.Tags.Events['mlight:Mastery'] = "UNIT_AURA"

-- [[ Healers' indicators ]] -- 

-- Priest 牧师
local pomCount = {"①","②","③","④","⑤","⑥","⑦","⑧","⑨","⑩"}
oUF.Tags.Methods['freebgrid:pom'] = function(u) -- 愈合祷言
    local name, _,_, c, _,_,_, fromwho = UnitBuff(u, GetSpellInfo(41635))
    if fromwho == "player" then
        if c and c ~= 0 then return "|cff66FFFF"..pomCount[c].."|r" end
    else
        if c and c ~= 0 then return "|cffFFCF7F"..pomCount[c].."|r" end 
    end
end
oUF.Tags.Events['freebgrid:pom'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:rnw'] = function(u) -- 恢复
    local name, _,_,_,_,_, expirationTime, fromwho = UnitBuff(u, GetSpellInfo(139))
    if(fromwho == "player") then
        local spellTimer = expirationTime - GetTime()
        if spellTimer > 4 then
            return "|cff33FF33"..T.FormatTime(spellTimer).."|r"
        elseif spellTimer > 2 then
            return "|cffFF9900"..T.FormatTime(spellTimer).."|r"
        else
            return "|cffFF0000"..T.FormatTime(spellTimer).."|r"
        end
    end
end
oUF.Tags.Events['freebgrid:rnw'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:pws'] = function(u) -- 盾和虚弱灵魂
	local pws_time, ws_time, r, g, b, colorstr
	
	local pws, _,_,_,_,_, pws_expiration = UnitBuff(u, GetSpellInfo(17), nil, "PLAYER")
	if pws then
	
		pws_time = T.FormatTime(pws_expiration-GetTime())
		
		real_absorb = select(15, UnitBuff(u, GetSpellInfo(17), nil, "PLAYER"))
		max_absorb = string.match(gsub(gsub(GetSpellDescription(17), ",", ""),"%d+","",1),"%d+")
		r, g, b = T.ColorGradient(real_absorb/max_absorb, 1,0,0, 1,1,.8, 1,1,1)
		colorstr = ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
		
	end
	
	local ws, _,_,_,_,_, ws_expiration = UnitDebuff(u, GetSpellInfo(6788))
	if ws then
		ws_time = T.FormatTime(ws_expiration-GetTime())	
	end
	
	if pws then
		return colorstr..pws_time.."|r"
	elseif ws then
		return "|cff9370DB-"..ws_time.."|r"
	end
end
oUF.Tags.Events['freebgrid:pws'] = "UNIT_AURA UNIT_ABSORB_AMOUNT_CHANGED"

oUF.Tags.Methods['freebgrid:yzdx'] = function(u) -- 意志洞悉
	if UnitBuff(u, GetSpellInfo(152118), nil, "PLAYER") then
		real_absorb = select(15, UnitBuff(u, GetSpellInfo(152118), nil, "PLAYER"))
		max_absorb = UnitHealthMax("player")*0.75
		local r, g, b = T.ColorGradient(real_absorb/max_absorb, 1,0,0, 1,1,.3, 1,1,1)
		local colorstr = ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
		return colorstr..x.."|r"
	end 
end
oUF.Tags.Events['freebgrid:yzdx'] = "UNIT_ABSORB_AMOUNT_CHANGED" 
 
-- Druid 德鲁伊
oUF.Tags.Methods['freebgrid:lb'] = function(u) -- 生命绽放
    local name, _,_, c,_,_, expirationTime, fromwho = UnitBuff(u, GetSpellInfo(33763))
    if(fromwho == "player") then
		local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if c > 2 then
            return "|cffA7FD0A"..TimeLeft.."|r"
        elseif c > 1 then
            return "|cffFF9900"..TimeLeft.."|r"
        else
            return "|cffFF0000"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['freebgrid:lb'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:rejuv'] = function(u) -- 回春
    local name, _,_,_,_,_, expirationTime, fromwho = UnitBuff(u, GetSpellInfo(774))
    if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            return "|cffFF00BB"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['freebgrid:rejuv'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:regrow'] = function(u) -- 愈合
	local name, _,_,_,_,_, expirationTime, fromwho = UnitBuff(u, GetSpellInfo(8936))
    if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 3 then
			return "|cffFFA500"..TimeLeft.."|r"
		elseif spellTimer > 0 then
            return "|cff33FF33"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['freebgrid:regrow'] = "UNIT_AURA"

-- Shaman 萨满
oUF.Tags.Methods['freebgrid:ripTime'] = function(u) --激流
    local name, _,_,_,_,_, expirationTime, fromwho = UnitBuff(u, GetSpellInfo(61295))
    if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            return "|cff00FFDD"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['freebgrid:ripTime'] = 'UNIT_AURA'

local earthCount = {"①","②","③","④","⑤","⑥","⑦","⑧","⑨","⑩"}
oUF.Tags.Methods['freebgrid:earth'] = function(u) -- 大地之盾
    local c = select(4, UnitAura(u, GetSpellInfo(974))) if c then return '|cffFFCF7F'..earthCount[c]..'|r' end 
end
oUF.Tags.Events['freebgrid:earth'] = 'UNIT_AURA'

-- Paladin 骑士
oUF.Tags.Methods['freebgrid:beacon'] = function(u) if UnitBuff(u, GetSpellInfo(53563)) then return "|cffFFB90FO|r" end end --道标
oUF.Tags.Events['freebgrid:beacon'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:forbearance'] = function(u) if UnitDebuff(u, GetSpellInfo(25771)) then return "|cffFF9900"..x.."|r" end end
oUF.Tags.Events['freebgrid:forbearance'] = "UNIT_AURA" -- 自律

oUF.Tags.Methods['freebgrid:eternalflame'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitBuff(u, GetSpellInfo(114163))
    if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            return "|cffFFD700"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['freebgrid:eternalflame'] = "UNIT_AURA" -- 永恒之火

oUF.Tags.Methods['freebgrid:sjhd'] = function(u)
	for i = 1,10 do
		local name, _,_,_,_,_, expirationTime, fromwho,_,_,spellid = UnitBuff(u, i, nil, "PLAYER")
		if name then
			if spellid == 148039 then
				local spellTimer = (expirationTime-GetTime())
				local TimeLeft = T.FormatTime(spellTimer)
				if spellTimer > 0 then
					return "|cffFFD700"..TimeLeft.."|r"
				end
			end
		else
			break
		end
	end
end
oUF.Tags.Events['freebgrid:sjhd'] = "UNIT_AURA" -- 圣洁护盾

-- Monk 武僧
oUF.Tags.Methods['freebgrid:zs'] = function(u) -- 禅意珠
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(124081))
    if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            return "|cff00FBFF"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['freebgrid:zs'] = 'UNIT_AURA'

oUF.Tags.Methods['freebgrid:sooth'] = function(u)-- 抚慰之雾
	local name, _,_,_,_,_, _, fromwho = UnitAura(u, GetSpellInfo(115175))
	if (fromwho == "player") then
		return "|cff97FFFF"..x.."|r"
	end
end 
oUF.Tags.Events['freebgrid:sooth'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:remist'] = function(u) -- 复苏之雾
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(115151))
    if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            return "|cff55FF00"..TimeLeft.."|r"
        end
    end
end 
oUF.Tags.Events['freebgrid:remist'] = 'UNIT_AURA'

classIndicators={
    ["DRUID"] = {
        ["TL"] = "[freebgrid:lb]",
        ["BR"] = "[mlight:SAI]",--[mlight:SpellHaste][mlight:Crit]
        ["BL"] = "",
        ["TR"] = "[freebgrid:regrow]",
        ["Cen"] = "[freebgrid:rejuv]",
    },
    ["PRIEST"] = {
        ["TL"] = "[freebgrid:rnw][freebgrid:pws]",
        ["BR"] = "[mlight:Stamina]",
        ["BL"] = "",
        ["TR"] = "[freebgrid:pom]",
        ["Cen"] = "[freebgrid:yzdx]",
    },
    ["PALADIN"] = {
        ["TL"] = "[freebgrid:eternalflame][freebgrid:sjhd]",
        ["BR"] = "[mlight:SAI]",--mlight:Mastery
        ["BL"] = "",
        ["TR"] = "[freebgrid:beacon]",
        ["Cen"] = "[freebgrid:forbearance]",
    },
    ["WARLOCK"] = {
        ["TL"] = "",
        ["BR"] = "[mlight:Stamina][mlight:SP]",
        ["BL"] = "",
        ["TR"] = "",
        ["Cen"] = "",
    },
    ["WARRIOR"] = {
        ["TL"] = "",
        ["BR"] = "[mlight:Stamina][mlight:AP]",
        ["BL"] = "",
        ["TR"] = "",
        ["Cen"] = "",
    },
    ["DEATHKNIGHT"] = {
        ["TL"] = "",
        ["BR"] = "[mlight:AP]",--[mlight:Haste]
        ["BL"] = "",
        ["TR"] = "",
        ["Cen"] = "",
    },
    ["SHAMAN"] = {
        ["TL"] = "[freebgrid:ripTime]",
        ["BR"] = "[mlight:SP]",--[mlight:Haste][mlight:SpellHaste][mlight:Mastery]
        ["BL"] = "",
        ["TR"] = "[freebgrid:earth]",
        ["Cen"] = "",
    },
    ["HUNTER"] = {
        ["TL"] = "",
        ["BR"] = "[mlight:SAI][mlight:Stamina][mlight:AP][mlight:SP]",--[mlight:Haste][mlight:Crit][mlight:Mastery]
        ["BL"] = "",
        ["TR"] = "",
        ["Cen"] = "",
    },
    ["ROGUE"] = {
        ["TL"] = "",
        ["BR"] = "",--[mlight:Haste]
        ["BL"] = "",
        ["TR"] = "",
        ["Cen"] = "",
    },
    ["MAGE"] = {
        ["TL"] = "",
        ["BR"] = "[mlight:SP]",--[mlight:Crit]
        ["BL"] = "",
        ["TR"] = "",
        ["Cen"] = "",
    },
	["MONK"] = {
        ["TL"] = "[freebgrid:remist]",
        ["BR"] = "[mlight:SAI]",--[mlight:Crit]
        ["BL"] = "[freebgrid:zs]",
        ["TR"] = "",
        ["Cen"] = "[freebgrid:sooth]",
    },
}

local update = .25

local Enable = function(self)
    if(self.AltzIndicators) then
        self.AuraStatusBL = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusBL:ClearAllPoints()
        self.AuraStatusBL:SetPoint("LEFT", 1, 0)
		self.AuraStatusBL:SetJustifyH("LEFT")
        self.AuraStatusBL:SetFont(G.norFont, timersize, "OUTLINE")
        self.AuraStatusBL.frequentUpdates = update
        self:Tag(self.AuraStatusBL, classIndicators[G.myClass]["BL"])	

		self.AuraStatusBR = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusBR:ClearAllPoints()
        self.AuraStatusBR:SetPoint("BOTTOMRIGHT", 3, 0)
		self.AuraStatusBR:SetJustifyH("RIGHT")
        self.AuraStatusBR:SetFont(G.symbols, smallmark, "OUTLINE")
        self.AuraStatusBR.frequentUpdates = update
        self:Tag(self.AuraStatusBR, classIndicators[G.myClass]["BR"])
		
        self.AuraStatusTL = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusTL:ClearAllPoints()
        self.AuraStatusTL:SetPoint("TOPLEFT", 1, 0)
		self.AuraStatusTL:SetJustifyH("LEFT")
        self.AuraStatusTL:SetFont(G.norFont, timersize, "OUTLINE")
        self.AuraStatusTL.frequentUpdates = update
        self:Tag(self.AuraStatusTL, classIndicators[G.myClass]["TL"])
		
        self.AuraStatusTR = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusTR:ClearAllPoints()
        
		if G.myClass == "DRUID" then
			self.AuraStatusTR:SetPoint("TOPRIGHT", 0, 0)
			self.AuraStatusTR:SetFont(ChatFrame1:GetFont(), timersize, "OUTLINE")
		elseif G.myClass == "PRIEST" or G.myClass == "SHAMAN" then
			self.AuraStatusTR:SetPoint("TOPRIGHT", 0, 0)
			self.AuraStatusTR:SetFont(ChatFrame1:GetFont(), timersize+3, "OUTLINE")
		else
			self.AuraStatusTR:SetPoint("CENTER", self.Health, "TOPRIGHT", -4, -4)
			self.AuraStatusTR:SetFont(G.symbols, bigmark, "OUTLINE")
		end
        self.AuraStatusTR.frequentUpdates = update
        self:Tag(self.AuraStatusTR, classIndicators[G.myClass]["TR"])
		
        self.AuraStatusCen = self.Health:CreateFontString(nil, "OVERLAY")
       
        self.AuraStatusCen:SetJustifyH("CENTER")
		if G.myClass == "DRUID" then
			self.AuraStatusCen:SetFont(ChatFrame1:GetFont(), timersize, "OUTLINE")
			self.AuraStatusCen:SetPoint("TOP", 0, 0)
		else
			self.AuraStatusCen:SetFont(G.symbols, smallmark+2, "OUTLINE")
			self.AuraStatusCen:SetPoint("TOP", 0, 2)
		end
        self.AuraStatusCen:SetWidth(0)
        self.AuraStatusCen.frequentUpdates = update
        self:Tag(self.AuraStatusCen, classIndicators[G.myClass]["Cen"])
    end
end

oUF:AddElement('AltzIndicators', nil, Enable, nil)