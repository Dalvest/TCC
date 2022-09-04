script.on_load(
function()
  --Creating a global variable with our addon's information,
  --so that dependancies can be checked when the game loads
  _G["TCC_INFO"]={
      version="1.15", --Keep this updated, For dependancy checks with other mods
      }
    --[[ EXAMPLE OF FAILED CHECK
  if not _G["INFERNO_CORE_INFO"] then
    Hyperspace.ErrorMessage("Info: It appears that Inferno-Core was not patched before TCC. You may continue, but it is recommended to patch Inferno-Core before the Trash Compactor Collection.")
  end
  --]]


end
)
