if SERVER then
   AddCSLuaFile("shared.lua")
   
   resource.AddFile("materials/vgui/ttt/lykrast/icon_cloakingdevice.png")
end

if CLIENT then
    SWEP.PrintName = "Cloaking Device"
    SWEP.Slot = 7
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
    SWEP.Icon = "vgui/ttt/lykrast/icon_cloakingdevice.png"
 
    SWEP.EquipMenuData = {
       type = "item_weapon",
       desc = [[Hold it to become nearly invisible.
Doesn't hide your name, shadow or
bloodstains on your body.]]
    }
end

SWEP.Author= "Lykrast"

SWEP.Base = "weapon_tttbase"
SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.HoldType = "slam"
 
SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_TRAITOR}
 
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = "models/weapons/w_slam.mdl"

SWEP.UseHands = true
 
 --- PRIMARY FIRE ---
SWEP.Primary.Delay = 0.5
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.NoSights = true
SWEP.AllowDrop = true

function SWEP:PrimaryAttack()
    return false
end

function SWEP:DrawWorldModel()

end

function SWEP:DrawWorldModelTranslucent()

end

function SWEP:Cloak()
    self.cloakedPly = self.Owner
    
    if IsValid(self.cloakedPly) then
        self.oldColor = self.cloakedPly:GetColor()
        self.cloakedPly:SetColor(Color(255, 255, 255, 3))
        
        self.oldMat = self.cloakedPly:GetMaterial()
        self.cloakedPly:SetMaterial("sprites/heatwave")
        
        self:EmitSound("AlyxEMP.Charge")
        
        self.conceal = true
    end
end

function SWEP:UnCloak()
    if IsValid(self.cloakedPly) then
        self.cloakedPly:SetColor(self.oldColor)
        self.cloakedPly:SetMaterial(self.oldMat)
        
        self:EmitSound("AlyxEMP.Discharge")
        
        self.conceal = false
    end
end

function SWEP:Deploy()
   self:Cloak()
end

function SWEP:Holster()
    if self.conceal then
        self:UnCloak()
    end
        
    return true
end

function SWEP:OnDrop() -- Hopefully this'll work
    if self.conceal then
        self:UnCloak()
    end
    
    self:Remove()
end
--[[
function SWEP:OnRemove() -- hopefully this works for Player.StripWeapons
    if self.conceal then
        self:UnCloak()
    end
    
    -- self:Remove()
end
--]]
function SWEP:ShouldDropOnDie()
    return false
end

hook.Add("TTTPrepareRound", "UnCloakAll", function()
    for _, v in pairs(player.GetAll()) do
        v:SetMaterial("models/glass")
    end
end)
