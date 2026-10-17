local function vter(cvec)
	local i = -1
	local n = cvec:size()
	return function()
		i = i + 1
		if i < n then return cvec[i] end
	end
end

local prismatic_rooms = {
    PLAYER_SHIP_ZOG_SUPER = {0, 1, 2, 3, 4, 5, 10, 11, 12, 13, 18, 19, 20, 23},
    PLAYER_SHIP_TRASH_EATER_2 = {0, 1, 10, 14, 15, 16},

    TC_SCRAPPER_ZOG_SUPER = {0, 1, 2, 3, 4, 5, 10, 11, 12, 13, 18, 19, 20, 23},
}

local PHeal = Hyperspace.StatBoostDefinition()
PHeal.stat = Hyperspace.CrewStat.PASSIVE_HEAL_AMOUNT
PHeal.amount = 5
PHeal.duration = 0.1
PHeal.maxStacks = 1
PHeal.boostType = Hyperspace.StatBoostDefinition.BoostType.FLAT
PHeal.boostSource = Hyperspace.StatBoostDefinition.BoostSource.AUGMENT
PHeal.shipTarget = Hyperspace.StatBoostDefinition.ShipTarget.ORIGINAL_SHIP
PHeal.crewTarget = Hyperspace.StatBoostDefinition.CrewTarget.ALLIES
PHeal.realBoostId = Hyperspace.StatBoostDefinition.statBoostDefs:size()
Hyperspace.StatBoostDefinition.statBoostDefs:push_back(PHeal)

local PDef = Hyperspace.StatBoostDefinition()
PDef.stat = Hyperspace.CrewStat.DAMAGE_TAKEN_MULTIPLIER
PDef.amount = 0.5
PDef.duration = 0.1
PDef.maxStacks = 1
PDef.boostType = Hyperspace.StatBoostDefinition.BoostType.MULT
PDef.boostSource = Hyperspace.StatBoostDefinition.BoostSource.AUGMENT
PDef.shipTarget = Hyperspace.StatBoostDefinition.ShipTarget.ORIGINAL_SHIP
PDef.crewTarget = Hyperspace.StatBoostDefinition.CrewTarget.ALLIES
PDef.realBoostId = Hyperspace.StatBoostDefinition.statBoostDefs:size()
Hyperspace.StatBoostDefinition.statBoostDefs:push_back(PDef)

local PTP = Hyperspace.StatBoostDefinition()
PTP.stat = Hyperspace.CrewStat.TELEPORT_MOVE
PTP.value = true
PTP.duration = 0.1
PTP.maxStacks = 1
PTP.boostType = Hyperspace.StatBoostDefinition.BoostType.SET
PTP.boostSource = Hyperspace.StatBoostDefinition.BoostSource.AUGMENT
PTP.shipTarget = Hyperspace.StatBoostDefinition.ShipTarget.ORIGINAL_SHIP
PTP.crewTarget = Hyperspace.StatBoostDefinition.CrewTarget.ALLIES
PTP.realBoostId = Hyperspace.StatBoostDefinition.statBoostDefs:size()
Hyperspace.StatBoostDefinition.statBoostDefs:push_back(PTP)

local PMC = Hyperspace.StatBoostDefinition()
PMC.stat = Hyperspace.CrewStat.RESISTS_MIND_CONTROL
PMC.value = true
PMC.duration = 0.1
PMC.maxStacks = 1
PMC.boostType = Hyperspace.StatBoostDefinition.BoostType.SET
PMC.boostSource = Hyperspace.StatBoostDefinition.BoostSource.AUGMENT
PMC.shipTarget = Hyperspace.StatBoostDefinition.ShipTarget.ORIGINAL_SHIP
PMC.crewTarget = Hyperspace.StatBoostDefinition.CrewTarget.ALLIES
PMC.realBoostId = Hyperspace.StatBoostDefinition.statBoostDefs:size()
Hyperspace.StatBoostDefinition.statBoostDefs:push_back(PMC)

script.on_internal_event(Defines.InternalEvents.SHIP_LOOP, function(shipManager)
    local blueprint = shipManager.myBlueprint.blueprintName
    local rooms = prismatic_rooms[blueprint]
    if not rooms then return end

    for crew in vter(shipManager.vCrewList) do
        for _, room in ipairs(rooms) do
            if crew:InsideRoom(room) then
                Hyperspace.StatBoostManager.GetInstance():CreateTimedAugmentBoost(Hyperspace.StatBoost(PHeal), crew)
                Hyperspace.StatBoostManager.GetInstance():CreateTimedAugmentBoost(Hyperspace.StatBoost(PDef), crew)
                Hyperspace.StatBoostManager.GetInstance():CreateTimedAugmentBoost(Hyperspace.StatBoost(PMC), crew)
                if shipManager.iShipId == 0 then
                    Hyperspace.StatBoostManager.GetInstance():CreateTimedAugmentBoost(Hyperspace.StatBoost(PTP), crew)
                end
            end
        end
    end
end)

script.on_internal_event(Defines.InternalEvents.PROJECTILE_FIRE, function(projectile, weapon)
    local shipManager = Hyperspace.Global.GetInstance():GetShipManager(projectile.ownerId)
    local shipManager = Hyperspace.ships(weapon.iShipId)
    if not shipManager then return end
    if shipManager:HasAugmentation("SHIELD_DRAINER") > 0 and weapon then

        local shieldPower = shipManager.shieldSystem.shields.power

        if shieldPower.super.first > 0 then
            shieldPower.super.first = math.max(0, shieldPower.super.first - 1)
            projectile.damage.iDamage = projectile.damage.iDamage + 2
        elseif shieldPower.first > 0 then
            shieldPower.first = math.max(0, shieldPower.first - 1)
            projectile.damage.iDamage = projectile.damage.iDamage + 2
        end
    end
end)