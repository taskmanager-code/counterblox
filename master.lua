local modules = {
    viewmodel = loadstring(game:HttpGet("https://raw.githubusercontent.com/taskmanager-code/counterblox/main/modules/viewmodel.lua"))(),
}

modules.viewmodel.on_new_viewmodel:Connect(function(module)
    local arm_parts = module.get_arm_parts()
    local weapon_parts = module.get_weapon_parts()

    for _,weapon_part in pairs (weapon_parts) do
        if weapon_part:IsA("MeshPart") then weapon_part.TextureID = "" end

        weapon_part.Color = Color3.fromRGB(0, 255, 0)
        weapon_part.Material = "ForceField"
    end
end)
