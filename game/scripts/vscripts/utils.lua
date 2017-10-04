function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function WrapObjectFunction(instance, functionName)
    if type(instance[functionName]) ~= "function" then
        error(functionName.." is not a function of the given instance.");
    end
    return function (...)
        instance[functionName](...);
    end
end

function string.split(str)
    local result = {}
    for i in string.gmatch(str, "%S+") do
        table.insert(result, i);
    end
    return result;
end
