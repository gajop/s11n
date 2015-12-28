_FeatureBridge = _ObjectBridge:extends{}

function _FeatureBridge:init()
    self.getFuncs = {
        pos = function(objectID)
            local px, py, pz = Spring.GetFeaturePosition(objectID)
            return {x = px, y = py, z = pz}
        end,
        midAimPos = function(objectID)
            local _, _, _, mpx, mpy, mpz, apx, apy, apz = Spring.GetFeaturePosition(objectID, true, true)
            return {mid = {x = mpx, y = mpy, z = mpz},
                    aim = {x = apx, y = apy, z = apz}}
        end,
        blocking = function(objectID)
            local isBlocking, isSolidObjectCollidable, isProjectileCollidable,
              isRaySegmentCollidable, crushable, blockEnemyPushing, blockHeightChanges = Spring.GetFeatureBlocking(objectID)
            return { isBlocking = isBlocking, isSolidObjectCollidable = isSolidObjectCollidable, isProjectileCollidable = isProjectileCollidable,
              isRaySegmentCollidable = isRaySegmentCollidable, crushable = crushable, blockEnemyPushing = blockEnemyPushing, blockHeightChanges = blockHeightChanges }
        end,
        radiusHeight = function(objectID)
            return { height = Spring.GetFeatureHeight(objectID),
                     radius = Spring.GetFeatureRadius(objectID) }
        end,
        collision = function(objectID)
            local scaleX, scaleY, scaleZ,
                  offsetX, offsetY, offsetZ,
                  vType, testType, axis, disabled = Spring.GetFeatureCollisionVolumeData(objectID)
            return {
                scaleX = scaleX, scaleY = scaleY, scaleZ = scaleZ,
                offsetX = offsetX, offsetY = offsetY, offsetZ = offsetZ,
                vType = vType, testType = testType, axis = axis, disabled = disabled,
            }
        end,
        team = function(objectID)
            return Spring.GetFeatureTeam(objectID)
        end,
        defName = function(objectID)
            return FeatureDefs[Spring.GetFeatureDefID(objectID)].name
        end,
        health = function(objectID)
            return Spring.GetFeatureHealth(objectID)
        end,
        maxHealth = function(objectID)
            local _, maxHealth = Spring.GetFeatureHealth(objectID)
            return maxHealth
        end,
        stockpile = function(objectID)
            return Spring.GetFeatureStockpile(objectID)
        end,
        experience = function(objectID)
            return Spring.GetFeatureExperience(objectID)
        end,
        neutral = function(objectID)
            return Spring.GetFeatureNeutral(objectID)
        end,
    }
    self.setFuncs = {
        pos = function(objectID, value)
            Spring.SetFeaturePosition(objectID, value.x, value.y, value.z)
        end,
        midAimPos = function(objectID, value)
            Spring.SetFeatureMidAndAimPos(objectID, value.mid.x, value.mid.y, value.mid.z,
                                                    value.aim.x, value.aim.y, value.aim.z, true)
        end,
        blocking = function(objectID, value)
            Spring.SetFeatureBlocking(objectID, value.isBlocking, value.isSolidObjectCollidable, value.isProjectileCollidable, value.isRaySegmentCollidable, value.crushable, value.blockEnemyPushing, value.blockHeightChanges)
        end,
        radiusHeight = function(objectID, value)
            Spring.SetFeatureRadiusAndHeight(objectID, value.radius, value.height)
        end,
        collision = function(objectID, value)
            Spring.SetFeatureCollisionVolumeData(objectID,
                value.scaleX, value.scaleY, value.scaleZ,
                value.offsetX, value.offsetY, value.offsetZ,
                value.vType, 1, value.axis)
        end,
        health = function(objectID, value)
            Spring.SetFeatureHealth(objectID, value)
        end,
        maxHealth = function(objectID, value)
            Spring.SetFeatureMaxHealth(objectID, value)
        end,
        stockpile = function(objectID, value)
            Spring.SetFeatureStockpile(objectID, value)
        end,
        experience = function(objectID, value)
            Spring.SetFeatureExperience(objectID, value)
        end,
        neutral = function(objectID, value)
            Spring.SetFeatureFuel(objectID, value)
        end,
    }
end