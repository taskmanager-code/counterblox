local signal =  loadstring(game:HttpGet("https://raw.githubusercontent.com/taskmanager-code/counterblox/main/modules/signal.lua"))()
local camera = workspace.CurrentCamera

local viewmodel = {on_new_viewmodel = signal.new("on_new_viewmodel")}

local function create(Object, Properties, Parent)
    local Obj = Instance.new(Object)

    for i,v in pairs (Properties) do
        Obj[i] = v
    end
    if Parent ~= nil then
        Obj.Parent = Parent
    end

    return Obj
end

function viewmodel.get()
    local module = {}

    local arms = camera:FindFirstChild("Arms")
    if not arms then return end

    module.get_arms = function()
        for i,v in pairs(arms:GetChildren()) do
            if not v:IsA("Model") then continue end
            if not v:FindFirstChild("Right Arm") then continue end
            
            return v
        end
    end

    module.get_arm_parts = function()
        local arms = module.get_arms()
        if not arms then return end

        return {arms:FindFirstChild("Right Arm"), arms:FindFirstChild("Left Arm")}
    end
    module.reset_arm_parts = function()
        local arm_parts = module.get_arms()
        if not arm_parts then return end

        for _,arm_part in pairs (arm_parts) do
            local OriginalColor = arm_part:FindFirstChild("OriginalColor")
            if OriginalColor then
                arm_part.Color = OriginalColor.Value
            end

            local OriginalMaterial = arm_part:FindFirstChild("OriginalMaterial")
            if OriginalMaterial then
                arm_part.Color = OriginalMaterial.Value
            end
        end
    end

    module.get_weapon_parts = function()
        local weapon_parts = {}

        for _,weapon_part in pairs (arms:GetChildren()) do
            if not weapon_part:IsA("BasePart") and not weapon_part:IsA("Part") then continue end
    
            table.insert(weapon_parts, weapon_part)
        end
    
        return weapon_parts
    end
    module.reset_weapon_parts = function()
        local weapon_parts = module.get_weapon_parts()

        for _,weapon_part in pairs (weapon_parts) do
            local OriginalColor = weapon_part:FindFirstChild("OriginalColor")
            if OriginalColor then
                weapon_part.Color = OriginalColor.Value
            end

            local OriginalMaterial = weapon_part:FindFirstChild("OriginalMaterial")
            if OriginalMaterial then
                weapon_part.Material = OriginalMaterial.Value
            end

            if weapon_part:IsA("MeshPart") then
                local OriginalTexture = weapon_part:FindFirstChild("OriginalTexture")

                if OriginalTexture then
                    weapon_part.TextureID = OriginalTexture.Value
                end
            end
        end
    end

    module.get_gloves = function()
        local gloves = {}

        for _,arm in pairs (module.get_arm_parts()) do
            local glove = arm:FindFirstChild("Glove") or arm:FindFirstChild("LGlove") or arm:FindFirstChild("RGlove")

            if glove then
                table.insert(gloves, glove)
            end
        end

        return gloves
    end
    module.reset_gloves = function()
        local gloves = module.get_gloves()

        for _,glove in pairs (gloves) do
            local OriginalMaterial = glove:FindFirstChild("OriginalMaterial")
            if OriginalMaterial then
                glove.Color = OriginalMaterial.Value
            end

            local OriginalTexture = glove:FindFirstChild("OriginalTexture")

            if OriginalTexture then
                glove.TextureID = OriginalTexture.Value
            end
        end
    end

    module.get_sleeves = function()
        local sleeves = {}

        for _,arm in pairs (module.get_arm_parts()) do
            local sleeve = arm:FindFirstChild("Sleeve")

            if sleeve then
                table.insert(sleeves, sleeve)
            end
        end

        return sleeves
    end
    module.reset_sleeves = function()
        local sleeves = module.get_sleeves()

        for _,sleeve in pairs (sleeves) do
            local OriginalMaterial = sleeve:FindFirstChild("OriginalMaterial")
            if OriginalMaterial then
                sleeve.Color = OriginalMaterial.Value
            end

            local OriginalTexture = sleeve:FindFirstChild("OriginalTexture")

            if OriginalTexture then
                sleeve.TextureID = OriginalTexture.Value
            end
        end
    end

    return module
end

local function OnCameraChildAdded(Child)
    local model = viewmodel.get()

    if not model then return end

    local arm_parts = model.get_arm_parts()
    for _,arm_part in pairs (arm_parts) do
        create("Color3Value", {Value = arm_part.Color, Name = "OriginalColor"}, arm_part)
        create("StringValue", {Value = arm_part.Material.Name, Name = "OriginalMaterial"}, arm_part)
    end

    local gun_parts = model.get_weapon_parts()
    for _,gun_part in pairs (gun_parts) do
        create("Color3Value", {Value = gun_part.Color, Name = "OriginalColor"}, gun_part)
        create("StringValue", {Value = gun_part.Material.Name, Name = "OriginalMaterial"}, gun_part)

        if gun_part:IsA("MeshPart") then
            create("StringValue", {Value = gun_part.TextureID, Name = "OriginalTexture"}, gun_part)
        end
    end

    local gloves = model.get_gloves()
    for _,glove in pairs (gloves) do
        create("StringValue", {Value = glove.Material.Name, Name = "OriginalMaterial"}, glove)
        create("StringValue", {Value = glove.Mesh.TextureId, Name = "OriginalTexture"}, glove)
    end

    local sleeves = model.get_sleeves()
    for _,sleeve in pairs (sleeves) do
        create("StringValue", {Value = sleeve.Material.Name, Name = "OriginalMaterial"}, sleeve)
        create("StringValue", {Value = sleeve.Mesh.TextureId, Name = "OriginalTexture"}, sleeve)
    end

    viewmodel.on_new_viewmodel:Fire(model)
end
camera.ChildAdded:Connect(OnCameraChildAdded)
for _,Child in pairs (camera:GetChildren()) do OnCameraChildAdded(Child) end

return viewmodel
