repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer.Character

--[[====| Variables |====]]--

local lighting = game:GetService("Lighting")

local map = workspace:WaitForChild("Map")
local blocks = workspace:WaitForChild("Blocks")
local water = workspace:WaitForChild("Water")

--[[====| Functions |====]]--

local function Create(obj, prop)
	local s, e = pcall(function()
		local obj = Instance.new(obj)
		for i,v in pairs(prop) do
			obj[i] = v
		end
		return obj
	end)
	if s then
		return e
	else
		error(e)
	end
end

local function Shift(color, adj)
	local h, s, v = color:ToHSV()
	return Color3.fromHSV(h, s, math.clamp(v + adj / 100, 0, 1))
end

local function Tween(obj, info, prop)
	return game:GetService("TweenService"):Create(obj, info, prop)
end

--[[====| Main |====]]--

--// Changing lighting settings

if lighting.ClockTime == 0 then
	lighting.Ambient = Color3.fromRGB(2, 35, 0);
	lighting.Brightness = 2;
	lighting.ColorShift_Top = Color3.fromRGB(182, 255, 178);
	lighting.OutdoorAmbient = Color3.fromRGB(4, 22, 0);
else
	lighting.Ambient = Color3.fromRGB(77, 110, 159);
	lighting.Brightness = 3;
	lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255);
	lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0);
end

lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
lighting.EnvironmentDiffuseScale = 1
lighting.EnvironmentSpecularScale = 1
lighting.GlobalShadows = true
lighting.ShadowSoftness = 0
lighting.ExposureCompensation = 0
sethiddenproperty(lighting, "Technology", Enum.Technology.Future)

--// Adding lighting instances

lighting:ClearAllChildren()

local atmosphere = Create("Atmosphere", {
	Density = .25;
	Offset = 1;
	Parent = lighting;
});

Create("Sky", {
	SkyboxBk = "rbxassetid://653719502";
	SkyboxDn = "rbxassetid://653718790";
	SkyboxFt = "rbxassetid://653719067";
	SkyboxLf = "rbxassetid://653719190";
	SkyboxRt = "rbxassetid://653718931";
	SkyboxUp = "rbxassetid://653719321";
	Parent = lighting;
});

Create("BloomEffect", {
	Parent = lighting;
});

local colorcorrection = Create("ColorCorrectionEffect", {
	Brightness = .05;
	Saturation = .2;
	Parent = lighting;
});

Create("DepthOfFieldEffect", {
	FarIntensity = .333;
	FocusDistance = 110;
	InFocusRadius = 0;
	NearIntensity = 0;
	Parent = lighting;
});

Create("SunRaysEffect", {
	Intensity = .25;
	Spread = .75;
	Parent = lighting;
});

--// Changing ground

for i,v in pairs(map:GetChildren()) do
	if v:IsA("BasePart") then
		if v.Color == Color3.fromRGB(105, 64, 40) then
			v.Color = Color3.fromRGB(98, 56, 36)
		elseif v.Color == Color3.fromRGB(58, 125, 21) then
			v.Color = Color3.fromRGB(69, 126, 39)
		end
	end
end

--// Random colors for parts

for i,v in pairs(blocks:GetDescendants()) do
	if v:IsA("BasePart") then
		v.Color = Shift(v.Color, math.random(-6, 6))
		--local light = Create("PointLight", {
		--	Brightness = .02;
		--	Color = Color3.fromRGB(255, 246, 198);
		--	Range = 20;
		--	Enabled = false;
		--	Shadows = true;
		--	Parent = v;
		--});
		--if lighting.ClockTime == 0 then
		--	light.Enabled = true
		--end
		--task.spawn(function()
		--	while task.wait() do
		--		Tween(light, TweenInfo.new(.1, Enum.EasingStyle.Linear), {
		--			Brightness = math.random(1, 3) / 100;
		--			Range = math.random(10, 20);
		--		}):Play()
		--		task.wait(math.random(10, 200) / 100)
		--	end
		--end)
	end
end

for i,v in pairs(blocks:GetChildren()) do
	v.ChildAdded:Connect(function(v)
		if v:IsA("BasePart") then
			v.Color = Shift(v.Color, math.random(-6, 6))
		end
	end)
end

--// Night and day

lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
	if lighting.ClockTime == 0 then
		Tween(lighting, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Ambient = Color3.fromRGB(2, 35, 0);
			Brightness = 2;
			ColorShift_Top = Color3.fromRGB(182, 255, 178);
			OutdoorAmbient = Color3.fromRGB(4, 22, 0);
		}):Play()
		Tween(atmosphere, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Density = .4;
			Offset = .5;
		}):Play()
		Tween(colorcorrection, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Contrast = .05;
			TintColor = Color3.fromRGB(210, 255, 190);
		}):Play()
	else
		Tween(lighting, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Ambient = Color3.fromRGB(77, 110, 159);
			Brightness = 3;
			ColorShift_Top = Color3.fromRGB(255, 255, 255);
			OutdoorAmbient = Color3.fromRGB(0, 0, 0);
		}):Play()
		Tween(atmosphere, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Density = .25;
			Offset = 1;
		}):Play()
		Tween(colorcorrection, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Contrast = 0;
			TintColor = Color3.fromRGB(255, 255, 255);
		}):Play()
	end
end)
