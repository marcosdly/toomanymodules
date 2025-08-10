local Symbol = {}
Symbol.__index = Symbol

local function new(value)
  return setmetatable({ value = value or '' }, Symbol)
end

function Symbol:__eq()
  return false
end

function Symbol:__tostring()
  return 'Symbol(' .. self.value .. ')'
end

function Symbol:__newindex()
  error 'Symbol object is frozen'
end

function Symbol:__index(key)
  if key ~= 'value' then error('property ' .. key .. ' do not exist') end
  return rawget(self, key)
end

return setmetatable({}, { __call = new })
