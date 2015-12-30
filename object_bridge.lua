_ObjectBridge = LCS.class{}

function _ObjectBridge:_GetField(objectID, name)
    assert(self.getFuncs[name] ~= nil, "No such field: " .. tostring(name))
    return self.getFuncs[name](objectID)
end

function _ObjectBridge:_GetAllFields(objectID)
    local values = {}
    for name, _ in pairs(self.getFuncs) do
        values[name] = self:_GetField(objectID, name)
    end
    return values
end

function _ObjectBridge:_SetField(objectID, name, value)
    assert(self.setFuncs[name] ~= nil, "No such field: " .. tostring(name))
    local applyDir = nil
    if name == "pos" then
        applyDir = self:_GetField(objectID, "dir")
    end
    self.setFuncs[name](objectID, value)
    -- ENGINE BUG
    -- If buildings are moved, their direction will be reset.
    -- An additional rotation must be applied after movement.
    if applyDir then
        self:_SetField(objectID, "dir", applyDir)
    end
end

function _ObjectBridge:_SetAllFields(objectID, object)
    local values = {}
    for name, value in pairs(object) do
        if self.setFuncs[name] ~= nil then
            self:_SetField(objectID, name, value)
        end
    end
end

function _ObjectBridge:Add(object)
    local objectID = self:CreateObject(object)
    self:_SetAllFields(objectID, object)
    return objectID
end

function _ObjectBridge:Get(...)
    local params = {...}
    local objectID = params[1]
    if #params == 1 then
        if type(params[1]) ~= "table" then
            return self:_GetAllFields(objectID)
        else
            local objectIDs = params[1]
            local ret = {}
            for _, objectID in pairs(objectIDs) do
                ret[objectID] = self:_GetAllFields(objectID)
            end
            return ret
        end
    elseif #params == 2 then
        if type(params[2]) ~= "table" then
            local name = params[2]
            return self:_GetField(objectID, name)
        else
            local names = params[2]
            local ret = {}
            for _, name in pairs(names) do
                ret[name] = self:_GetField(objectID, name)
            end
            return ret
        end
    end
end

function _ObjectBridge:Set(...)
    local params = {...}
    local objectID = params[1]
    if #params == 2 then
        local object = params[2]
        self:_SetAllFields(objectID, object)
    elseif #params == 3 then
        local name = params[2]
        local value = params[3]
        self:_SetField(objectID, name, value)
    end
end