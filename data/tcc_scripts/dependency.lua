mods.trash = {}
  --Creating a global variable with our addon's information,
  --so that dependancies can be checked when the game loads
TCC_INFO = {
  VERSION = {
    MAJOR = 1,
    MINOR = 2,
    FEATURE = 0,
  },
}
if not INFERNO_CORE_INFO then 
  error("Warning! Inferno-Core was not patched before Trash Compactor Collaboration! Please re-patch your mods, or the game will not work!") 
end