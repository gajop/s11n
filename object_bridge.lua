_ObjectBridge = LCS.class{}

function _ObjectBridge:init()
end

function _ObjectBridge:_GetField(objectID, name)
    assert(self.getFuncs[name] ~= nil, "No such field: " .. name)
    return self.getFuncs[name](objectID)
end

function _ObjectBridge:_SetField(objectID, name, value)
    assert(self.setFuncs[name] ~= nil, "No such field: " .. name)
    self.setFuncs[name](objectID, value)
end

function _ObjectBridge:Get(...)
    local params = {...}
    local objectID = params[1]
    local name = params[2]
    return self:_GetField(objectID, name)
end

function _ObjectBridge:Set(...)
    local params = {...}
    local objectID = params[1]
    local name = params[2]
    local value = params[3]
    return self:_SetField(objectID, name, value)
end