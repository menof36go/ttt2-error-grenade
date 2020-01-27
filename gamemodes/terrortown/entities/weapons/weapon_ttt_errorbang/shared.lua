if SERVER then --the init.lua stuff goes in here
	resource.AddFile("materials/vgui/ttt/ErrorFlash/icon_errorbang.vmt")

	AddCSLuaFile()
end

if CLIENT then --the init.lua stuff goes in here
	SWEP.PrintName = "Error-Flashbang"
	SWEP.SlotPos = 2

	SWEP.EquipMenuData = {
	   type = "item_weapon",
	   desc = "Throw some errors at your opponents!"
   };
end

SWEP.Grenade = "ttt_thrownerrorbang" --self explanitory
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.Base = "weapon_tttbasegrenade"
SWEP.ViewModel = "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel	= "models/weapons/w_eq_flashbang.mdl"
SWEP.ViewModelFlip = true
SWEP.AutoSwitchFrom	= true
SWEP.DrawCrosshair = false
SWEP.IsGrenade = true
SWEP.NoSights = true
SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = { [ROLE_TRAITOR] = ROLE_TRAITOR } -- only traitors can buy
SWEP.LimitedStock = false
SWEP.Icon = "VGUI/ttt/ErrorFlash/icon_errorbang"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1.0
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:GetGrenadeName()
   return "ttt_thrownerrorbang"
end
