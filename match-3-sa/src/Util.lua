--[[
    GD50
    Match-3 Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Helper functions for writing Match-3.
]]

--[[
    Given an "atlas" (a texture with multiple sprites), generate all of the
    quads for the different tiles therein, divided into tables for each set
    of tiles, since each color has 6 varieties.
]]
function GenerateTileQuads(atlas)
    local tiles = {}

    local x = 0
    local y = 0

    local counter = 1

    -- 9 rows of tiles
    for row = 1, 6 do
        
        tiles[counter] = {}
            
        for col = 1, 6 do
            table.insert(tiles[counter], love.graphics.newQuad(
                x, y, 32, 32, atlas:getDimensions()
            ))
            x = x + 32
        end

        counter = counter + 1
        y = y + 32
        x = 0
    end

    return tiles
end

--[[
  We will select a tile variety using a weighted random number
  taking into account level. higher varieties are only available at
  level/VARIETY_MODIFIER > Variety#
  There are 6 varieties, without level consideration the weights should be:
  
  Variety 1: 50%
  Variety 2: 20%
  Variety 3: 14%
  Variety 4: 8%
  Variety 5: 5%
  Variety 6: 3%
  
  When level is taken into account, the chance for the missing varieties will be added to variety 1.
--]]
function selectVariety(level) 
  local maxVariety = math.min(math.floor(level/VARIETY_MODIFIER + 1), 6)
  local variety = 1
  local randomNum = math.random()
  if maxVariety >= 2 and randomNum < .5 and randomNum >= .3 then
    variety = 2
  elseif maxVariety >= 3 and randomNum < .3 and randomNum >= .16 then
    variety = 3
  elseif maxVariety >= 4 and randomNum < .16 and randomNum >= .08 then
    variety = 4
  elseif maxVariety >= 5 and randomNum < .08 and randomNum >= .03 then
    variety = 5
  elseif maxVariety >= 6 and randomNum < .03 then
    variety = 6
  end
  
  return variety
end


--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end