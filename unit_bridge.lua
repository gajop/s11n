_UnitBridge = _ObjectBridge:extends{}

function _UnitBridge:init()
    self.getFuncs = {
        pos = function(objectID)
            local px, py, pz = Spring.GetUnitPosition(objectID)
            return {x = px, y = py, z = pz}
        end,
        midAimPos = function(objectID)
            local _, _, _, mpx, mpy, mpz, apx, apy, apz = Spring.GetUnitPosition(objectID, true, true)
            return {mid = {x = mpx, y = mpy, z = mpz},
                    aim = {x = apx, y = apy, z = apz}}
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
    }
    self.setFuncs = {
        pos = function(objectID, value)
            Spring.SetUnitPosition(objectID, value.x, value.y, value.z)
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
            Spring.SetUnitFuel(objectID, value)
        end,
    }
end