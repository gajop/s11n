_UnitBridge = _ObjectBridge:extends{}

function _UnitBridge:init()
    self.getFuncs = {
        pos = function(objectID)
            local px, py, pz = Spring.GetUnitPosition(objectID)
            return {x = px, y = py, z = pz}
        end,
        dir = function(objectID)
            local dirX, dirY, dirZ = Spring.GetUnitDirection(objectID)
            return {x = dirX, y = dirY, z = dirZ}
        end,
        midAimPos = function(objectID)
            local px, py, pz, mpx, mpy, mpz, apx, apy, apz = Spring.GetUnitPosition(objectID, true, true)
            return {mid = {x = mpx - px, y = mpy - py, z = mpz - pz},
                    aim = {x = apx - px, y = apy - py, z = apz - pz}}
        end,
        blocking = function(objectID)
            local isBlocking, isSolidObjectCollidable, isProjectileCollidable,
              isRaySegmentCollidable, crushable, blockEnemyPushing, blockHeightChanges = Spring.GetUnitBlocking(objectID)
            return { isBlocking = isBlocking, isSolidObjectCollidable = isSolidObjectCollidable, isProjectileCollidable = isProjectileCollidable,
              isRaySegmentCollidable = isRaySegmentCollidable, crushable = crushable, blockEnemyPushing = blockEnemyPushing, blockHeightChanges = blockHeightChanges }
        end,
        radiusHeight = function(objectID)
            return { height = Spring.GetUnitHeight(objectID),
                     radius = Spring.GetUnitRadius(objectID) }
        end,
        collision = function(objectID)
            local scaleX, scaleY, scaleZ,
                  offsetX, offsetY, offsetZ,
                  vType, testType, axis, disabled = Spring.GetUnitCollisionVolumeData(objectID)
            return {
                scaleX = scaleX, scaleY = scaleY, scaleZ = scaleZ,
                offsetX = offsetX, offsetY = offsetY, offsetZ = offsetZ,
                vType = vType, testType = testType, axis = axis, disabled = disabled,
            }
        end,
        team = function(objectID)
            return Spring.GetUnitTeam(objectID)
        end,
        defName = function(objectID)
            return UnitDefs[Spring.GetUnitDefID(objectID)].name
        end,
        health = function(objectID)
            return Spring.GetUnitHealth(objectID)
        end,
        maxHealth = function(objectID)
            local _, maxHealth = Spring.GetUnitHealth(objectID)
            return maxHealth
        end,
        tooltip = function(objectID)
            return Spring.GetUnitTooltip(objectID)
        end,
        stockpile = function(objectID)
            return Spring.GetUnitStockpile(objectID)
        end,
        experience = function(objectID)
            return Spring.GetUnitExperience(objectID)
        end,
        neutral = function(objectID)
            return Spring.GetUnitNeutral(objectID)
        end,
        fuel = function(objectID)
            return Spring.GetUnitFuel(objectID)
        end,
        states = function(objectID)
            return Spring.GetUnitStates(objectID)
        end,
        losState = function(objectID)
            return Spring.GetUnitLosState(objectID, 0)
        end,
        rules = function(objectID)
            local ret = {}
            for rule, value in pairs(Spring.GetUnitRulesParams(objectID)) do
                ret[rule] = value
            end
            return ret
        end,
        commands = function(objectID)
            -- -1 needed here to work around jk's attempt at optimization (otherwise we get errors)
            local commands = Spring.GetUnitCommands(objectID, -1)
            for _, command in pairs(commands) do
                if command.id >= 0 then
                    command.name = CMD[command.id]
                else
                    command.name = "BUILD_COMMAND"
                    local buildUnitDef = UnitDefs[math.abs(command.id)]
                    if buildUnitDef ~= nil then
                        command.buildUnitDef = buildUnitDef.name
                    else
                        Spring.Log("s11n", LOG.ERROR, "No such unit def: (" .. math.abs(command.id) ..  ") for build command: " .. tostring(command.id))
                    end
                end
                command.options = nil
                command.tag = nil
                command.id = nil
                -- TODO
                -- serialized unit commands use the model unit id
--                 if isUnitCommand(command) then
--                     command.params[1] = self:getModelUnitId(command.params[1])
--                 end
            end
            return commands
        end,
        armored = function(objectID)
            local armored, armorMultiple = Spring.GetUnitArmored(objectID)
            return { armored = armored, armorMultiple = armorMultiple }
        end,
    }
    self.setFuncs = {
        pos = function(objectID, value)
            Spring.SetUnitPosition(objectID, value.x, value.y, value.z)
        end,
        dir = function(objectID, value)
            Spring.SetUnitDirection(objectID, value.x, value.y, value.z)
        end,
        midAimPos = function(objectID, value)
            Spring.SetUnitMidAndAimPos(objectID, value.mid.x, value.mid.y, value.mid.z,
                                                 value.aim.x, value.aim.y, value.aim.z, true)
        end,
        blocking = function(objectID, value)
            Spring.SetUnitBlocking(objectID, value.isBlocking, value.isSolidObjectCollidable, value.isProjectileCollidable, value.isRaySegmentCollidable, value.crushable, value.blockEnemyPushing, value.blockHeightChanges)
        end,
        radiusHeight = function(objectID, value)
            Spring.SetUnitRadiusAndHeight(objectID, value.radius, value.height)
        end,
        collision = function(objectID, value)
            Spring.SetUnitCollisionVolumeData(objectID,
                value.scaleX, value.scaleY, value.scaleZ,
                value.offsetX, value.offsetY, value.offsetZ,
                value.vType, 1, value.axis)
        end,
        health = function(objectID, value)
            Spring.SetUnitHealth(objectID, value)
        end,
        maxHealth = function(objectID, value)
            Spring.SetUnitMaxHealth(objectID, value)
        end,
        tooltip = function(objectID, value)
            Spring.SetUnitTooltip(objectID, value)
        end,
        stockpile = function(objectID, value)
            Spring.SetUnitStockpile(objectID, value)
        end,
        experience = function(objectID, value)
            Spring.SetUnitExperience(objectID, value)
        end,
        neutral = function(objectID, value)
            Spring.SetUnitNeutral(objectID, value)
        end,
        fuel = function(objectID, value)
            Spring.SetUnitFuel(objectID, value)
        end,
        states = function(objectID, value)
            if value.cloak ~= nil then
                Spring.GiveOrderToUnit(objectID, CMD.INSERT,
                    { 0, CMD.CLOAK, 0, boolToNumber(value.cloak)},
                    {"alt"}
                );
            end
            if value.firestate ~= nil then
                Spring.GiveOrderToUnit(objectID, CMD.INSERT,
                    { 0, CMD.FIRE_STATE, 0, value.firestate},
                    {"alt"}
                );
            end
            if value.movestate ~= nil then
                Spring.GiveOrderToUnit(objectID, CMD.INSERT,
                    { 0, CMD.MOVE_STATE, 0, value.movestate},
                    {"alt"}
                );
            end
            -- setting the active state doesn't work currently
            --[[
            if value.active ~= nil then
                Spring.GiveOrderToUnit(objectID, CMD.INSERT,
                    { 0, CMD.IDLEMODE, 0, boolToNumber(value.active)},
                    {"alt"}
                );
            end
            --]]
            if value["repeat"] ~= nil then
                Spring.GiveOrderToUnit(objectID, CMD.INSERT,
                    { 0, CMD.REPEAT, 0, boolToNumber(value["repeat"])},
                    {"alt"}
                );
            end
        end,
        losState = function(objectID, value)
            Spring.SetUnitLosState(objectID, 0, value)
        end,
        rules = function(objectID, value)
            for _, foo in pairs(value) do
                if type(foo) == "table" then
                    for rule, value in pairs(foo) do
                        Spring.SetUnitRulesParam(objectID, rule, value)
                    end
                end
            end
        end,
        commands = function(objectID, value)
            for _, command in pairs(value) do
                if command.name ~= "BUILD_COMMAND" then
                    Spring.GiveOrderToUnit(objectID, CMD[command.name], command.params, {"shift"})
                else
                    Spring.GiveOrderToUnit(objectID, -UnitDefNames[command.buildUnitDef].id, command.params, {"shift"})
                end
            end
        end,
        armored = function(objectID, value)
            Spring.SetUnitArmored(objectID, value.armored, value.armorMultiple)
        end,
        gravity = function(objectID, value)
            Spring.MoveCtrl.SetGravity(objectID, value)
        end,
        movectrl = function(objectID, value)
            if value then
                Spring.MoveCtrl.Enable(objectID)
            else
                Spring.MoveCtrl.Disable(objectID)
            end
        end
    }
end

function _UnitBridge:CreateObject(object)
    local objectID = Spring.CreateUnit(object.defName, object.pos.x, object.pos.y, object.pos.z, 0, object.team, false, true)
    return objectID
end