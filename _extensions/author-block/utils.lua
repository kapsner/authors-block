local List = require 'pandoc.List'
local utils = require 'pandoc.utils'
local stringify = utils.stringify

local M = {}

-- from @kapsner
local function normalize_affiliations(affiliations)
  local affiliations_norm = List:new(affiliations):map(
    function(affil, i)
      affil.index = pandoc.MetaInlines(pandoc.Str(tostring(i)))
      affil.id = pandoc.MetaString(stringify(affil.id))
      return affil
    end
  )
  return affiliations_norm
end
M.normalize_affiliations = normalize_affiliations

-- taken from https://github.com/pandoc/lua-filters/blob/1660794b991c3553968beb993f5aabb99b317584/scholarly-metadata/scholarly-metadata.lua
--- Returns a function which checks whether an object has the given ID.
local function has_id(id)
  return function(x) return x.id == id end
end

-- from https://stackoverflow.com/a/2282547
local function has_key(set, key)
  return set[key] ~= nil
end
M.has_key = has_key

-- taken from https://github.com/pandoc/lua-filters/blob/1660794b991c3553968beb993f5aabb99b317584/scholarly-metadata/scholarly-metadata.lua
--- Resolve institute placeholders to full named objects
local function resolve_institutes(institute, known_institutes)
  local unresolved_institutes
  if institute == nil then
    unresolved_institutes = {}
  elseif type(institute) == "string" or type(institute) == "number" then
    unresolved_institutes = {institute}
  else
    unresolved_institutes = institute
  end

  local result = List:new{}
  for i, inst in ipairs(unresolved_institutes) do
    -- this has been modified by @kapsner
    --result[i] =
    --  known_institutes[tonumber(inst)] or
    --  known_institutes:find_if(has_id(pandoc.utils.stringify(inst))) or
    --  to_named_object(inst)
    intermed_val = known_institutes:find_if(has_id(pandoc.utils.stringify(inst)))
    result[i] = pandoc.MetaString(stringify(intermed_val.index))
  end
  return result
end
M.resolve_institutes = resolve_institutes

-- from @kapsner
local function normalize_authors(affiliations)
  return function(auth)
    auth.id = pandoc.MetaString(stringify(auth.name))
    auth.affiliations = resolve_institutes(
      auth.affiliations,
      affiliations
    )
    return auth
  end
end
M.normalize_authors = normalize_authors

local function create_authors(authors)
  local outlist = List:new(authors):map(
    function(author)
      return stringify(author.name.literal)
    end
  )
  return outlist
end
M.create_authors = create_authors

return M