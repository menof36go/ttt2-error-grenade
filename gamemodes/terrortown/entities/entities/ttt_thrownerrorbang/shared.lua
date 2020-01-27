local effectLength = 1.5; --time in seconds, for the grenade to transition from full white to clear
local effectDelay = 0.5; --time, in seconds when the effects still are going on, even when the whiteness of the flash is gone (set to -1 for no effects at all =]).
local pos, endflash, endflash2;
local last = nil
local selected = nil
local first = true

local random = math.random

local flashes = {
	[0] = Material("vgui/ttt/ErrorFlash/Cute.png"),
	[1] = Material("vgui/ttt/ErrorFlash/Glitch1.png"),
	[2] = Material("vgui/ttt/ErrorFlash/Glitch2.png"),
	[3] = Material("vgui/ttt/ErrorFlash/Glitch3.png"),
	[4] = Material("vgui/ttt/ErrorFlash/InsertDisk.png"),
	[5] = Material("vgui/ttt/ErrorFlash/Win7.png"),
	[6] = Material("vgui/ttt/ErrorFlash/Win10.png"),
	[7] = Material("vgui/ttt/ErrorFlash/Win10AdvancedStart.png"),
	[8] = Material("vgui/ttt/ErrorFlash/Linux.png"),
};

if (CLIENT) then
	function ENT:Initialize()
		pos = self:GetPos()
		timer.Simple(2, function()
			local beeplight = DynamicLight(self:EntIndex())

			if (beeplight) then
				beeplight.Pos = pos
				beeplight.r = 255
				beeplight.g = 255
				beeplight.b = 255
				beeplight.Brightness = 6
				beeplight.Size = 1000
				beeplight.Decay = 1000
				beeplight.DieTime = CurTime() + 0.15
			end
		end)
	end

	function ENT:Think()
		pos = self:GetPos()
	end

	function ENT:Draw()
		self.Entity:DrawModel()
	end

	function ENT:IsTranslucent()
		return true
	end

	function ErrorFlashbangFlash()
		local pl = LocalPlayer();

		if pl:GetNetworkedFloat("RCS_flashed_time") > CurTime() then
			if first then
				first = false

				if random(1, 30) == 15 then
					selected = flashes[0]
				else
					local rand = random(1, 7)

					if last == rand then
						rand = rand + 1
					end

					last = rand

					selected = flashes[rand]
				end
			end

			local e = pl:GetNetworkedFloat("RCS_flashed_time"); --when it dies away
			local s = pl:GetNetworkedFloat("RCS_flashed_time_start"); --when it started

			local alpha;
			if(e - CurTime() > effectLength)then
				alpha = 255;
			else
				local pf = 1 - (CurTime() - (e - effectLength)) / (e - (e - effectLength));
				alpha = pf * 255;
			end

			surface.SetDrawColor(255, 255, 255, math.Round(alpha));
			surface.SetMaterial(selected)
			surface.DrawTexturedRect(0, 0, surface.ScreenWidth(), surface.ScreenHeight());
		else
			first = true
		end
	end
	hook.Add("DrawOverlay", "ErrorFlashbangFlash", ErrorFlashbangFlash);

	--motion blur and other junk
	local function ErrorFlashbangMotionBlur()
		local pl = LocalPlayer();
		local e = pl:GetNetworkedFloat("RCS_flashed_time") + effectDelay; --when it dies away
		local s = pl:GetNetworkedFloat("RCS_flashed_time_start"); --when it started
		if (e > CurTime()  &&  e - effectDelay-CurTime() <= effectLength) then
			local pf = 1 - (CurTime() - (e - effectLength)) / (effectLength);
			DrawMotionBlur(0, pf / ((effectLength + effectDelay) / effectLength), 0);
		elseif (e > CurTime()) then
			DrawMotionBlur( 0, 0.01, 0);
		else
			DrawMotionBlur( 0, 0, 0);
		end
	end
	hook.Add("RenderScreenspaceEffects", "ErrorFlashbangMotionBlur", ErrorFlashbangMotionBlur)

end

ENT.Type = "anim"

function ENT:OnRemove()
end

function ENT:PhysicsUpdate()
end

function ENT:PhysicsCollide(data,phys)
	if data.Speed > 50 then
		self.Entity:EmitSound(Sound("weapons/flashbang/grenade_hit1.wav"))
	end

	local bounce = -data.Speed * data.HitNormal * .1 + (data.OurOldVelocity * -0.6)
	phys:ApplyForceCenter(bounce)
end
