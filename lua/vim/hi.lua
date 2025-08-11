local registry = {}
registry.__index = registry

function registry:__call(name, val)
  -- Force links
  val.force = true

  -- Make sure that `cterm` attribute is not populated from `gui`
  val.cterm = val.cterm or {} ---@type vim.api.keyset.highlight

  -- Define highlight
  rawset(self, name, val)
end

local hi = {}
hi.__index = hi

local function new()
  return setmetatable({
    using = 'both',
    dark = setmetatable({}, registry),
    light = setmetatable({}, registry),
  }, hi)
end

function hi:__newindex(key, value)
  assert(key == 'using', 'can only mutate property "using"')
  assert(
    value == 'dark' or value == 'light' or value == 'both',
    '"using" can only be either "dark" or "light"'
  )
  rawset(self, key, value)
end

function hi:__call(name, val)
  if self.using == 'both' then
    self.dark(name, val)
    self.light(name, val)
    return
  end
  self[self.using](name, val)
end

return setmetatable({}, { __call = new })
