local flashIntensity = 2400; --the higher the number, the longer the flash will be whitening your screen
local flashMaxRange = 600;

resource.AddFile("materials/vgui/ttt/ErrorFlash/Cute.png")
resource.AddFile("materials/vgui/ttt/ErrorFlash/Glitch1.png")
resource.AddFile("materials/vgui/ttt/ErrorFlash/Glitch2.png")
resource.AddFile("materials/vgui/ttt/ErrorFlash/Glitch3.png")
resource.AddFile("materials/vgui/ttt/ErrorFlash/InsertDisk.png")
resource.AddFile("materials/vgui/ttt/ErrorFlash/Win7.png")
resource.AddFile("materials/vgui/ttt/ErrorFlash/Win10.png")
resource.AddFile("materials/vgui/ttt/ErrorFlash/Win10AdvancedStart.png")
resource.AddFile("materials/vgui/ttt/ErrorFlash/Linux.png")

AddCSLuaFile("shared.lua")
include("shared.lua")

local function simplifyangle(angle)
	while(angle>=180) do
		angle = angle - 360;
	end
	while(angle <= -180) do
		angle = angle + 360;
	end
	return angle;
end

function ENT:Explode()
	self.Entity:EmitSound(Sound("weapons/flashbang/flashbang_explode" .. math.random(1,2) .. ".wav"));

	for _,pl in pairs(player.GetAll()) do
		local ePos = self.Entity:GetPos()
		local eyePos = pl:EyePos()
		local tracedata = {
			["start"] = eyePos,
			["endpos"] = ePos,
			["filter"] = { pl, self },
		};
		local tr = util.TraceLine(tracedata);
		local toBang = ePos - eyePos
		local toBangNormalized = toBang:GetNormalized()
		local dist = toBang:Length()

		if !tr.Hit and dist < flashMaxRange then
			local aim = pl:GetAimVector():GetNormalized()
			local turnFactor = math.max(0.2, (aim:Dot(toBangNormalized) + 1) / 2)
			local endtime = (flashIntensity / dist) * turnFactor;

			if (endtime > 6) then
				endtime = 6;
			end

			simpendtime = math.floor(endtime);
			tenthendtime = math.floor((endtime - simpendtime)*10);

			if (pl:GetNetworkedFloat("RCS_flashed_time") > CurTime()) then --if you're already flashed
				pl:SetNetworkedFloat("RCS_flashed_time", endtime + pl:GetNetworkedFloat("RCS_flashed_time") + CurTime() - pl:GetNetworkedFloat("RCS_flashed_time_start")); --add more to it
			else --not flashed
				pl:SetNetworkedFloat("RCS_flashed_time", endtime + CurTime());
			end
			pl:SetNetworkedFloat("RCS_flashed_time_start", CurTime());
		end
	end
	self.Entity:Remove();
end

function ENT:Initialize()
	self.Entity:SetModel("models/weapons/w_eq_flashbang_thrown.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(false)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	local phys = self.Entity:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end

	timer.Simple(2, function()
		if self.Entity then
			self:Explode()
		end
	end)
end


function ENT:Think()
end

function ENT:SetDetonateTimer(length)
   self:SetDetonateExact(CurTime() + length)
end

function ENT:SetDetonateExact()
end

function ENT:OnTakeDamage()
	self:Explode()
end

function ENT:SetThrower()
end

function ENT:Use()
end

function ENT:StartTouch()
end

function ENT:EndTouch()
end

function ENT:Touch()
end
