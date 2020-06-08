require("data/goods")
require("data/productions")
require("util/table")

local inspect = require('lib/inspect')

-- Format for a table entry.
--|-
--|<factory>
--|<production capacity cap>
--|<produces> (<quantity>, <price>, <level>)
--|<requires> (<quantity>)

-- Given the data of a good, calculate its contribution to the production capacity of the factory producing it.
-- 
-- It is unclear if Toxic waste actually contributes to the production time of Fertilizer, Paint and Rubber Factories.
-- If it does, we are talking about a difference of 70 milli seconds, which will arguably make no noticable difference even
-- If the user is in the area. (and if they are not, the reported max update delay of an additional 4 or 5 seconds will have 
-- a much bigger impact that makes the 70 ms negligible in comparison). 
-- However the cost of that 1pc it might add in credits is around the 1k. Since these blocks can become expensive, 
-- Toxic Waste is left out of the calculation.
local function pcValue(quantity, price, level)
    -- nil or 0 is treated as a value of 1 for calculating the optimal pc value. 
    if level ==0 then
        return (price * quantity) / 15
    else
        return (price * quantity * level) / 15    
    end
end


-- Calculate the amount of production capacity required to run at max capacity. 
-- I honestly hope this formula is correct.
local function optimalProductionCapacity(outputList)
    local result = 0
    for k, good in pairs(outputList) do --k:int, good:{name, amount, price, level}
        if good.level ~= nil and good.level ~= "-" then
            result = result + pcValue(good.quantity, good.price, good.level)
        end
    end
    -- better have 1 pc to much than to little, otherwise you might get a time of slightly over 15 seconds. 
    return math.ceil(result) 
end

-- based on the function above, takes a single string and applies the "wiki-link" formatting to it.
local function wikifyName(item)
	return "[[" .. item .. "]]" 
end

--Adds all results and garbages to one list of what a factory produces.
local function genOutputList(production)
    local list = {} -- list:{k1:{name, amount, price, level}}
    -- All the information I need to know about a good to calculate the optimal pc. 
    -- Level can be nil!       
    local function value(name, amount)
        return {good = name, quantity = amount, price=goods[name].price, level=goods[name].level} 
    end
    
    for k, good in pairs(production.results) do--results:{ k:int=good:{name, amount} }
        table.insert(list, value(good.name, good.amount))
    end
            
    -- Its hard to measure, but it appears to matter for
    for k, good in pairs(production.garbages) do--garbage:{ k:int=good:{name, amount} }
        table.insert(list, value(good.name, good.amount))
    end
                    
    return list
end
    
-- Pulls the factories from the productions file and organizes them by name.
local function extractFactoriesData()
  local factories = {} -- factories:{ factory:string = {k:int = {quantity, good, level, price}}}
  i = 1
  
  for key, production in pairs(productions) do
	-- We don't want to organize per size, since the size doesn't matter for the input and output goods.
    if (production.factory:find(" ${size}")) then
      production.factory = production.factory:gsub(" ${size}", "")
    end
    
    -- Some factories have a ${good} template that needs to be filled. Luckily, 
    -- almost all factories only produce one good.
    if (production.factory:find("${good}")) then
            production.factory = production.factory:gsub("${good}", production.results[1].name)
    end
      
     local factory = {}
     factory.name = production.factory
     factory.output = genOutputList(production)
     factory.input = production.ingredients
     
     factories[i] = factory

     
     i = i + 1
  end
  return factories 
end

-- Prints the outputList 
-- filters out the nill of toxic waste.
local function printProductionCell(outputList) do
    for k, good in pairs(outputList) do -- k is unused.
        if good.level == nil then
            good.level = "-" 
        end
        print(string.format(" %s (%s, %s, %s) ", good.good, good.quantity, good.price, good.level))
        end 
    end
end     -- It feels like there is one end to many here, but I do not know where it is coming from.    
    
-- simple for loop that prints the data for the input list
-- Added it so it would be easier for people to see which factory is which.
local function printInput(list)
    for k, good in pairs(list) do
        print(string.format("%s (%s)", good.name, good.amount))
    end
end

-- Prints a list of factories with their PC cap and products.
local function printList(factories)    
    for k, factory in sortByName(factories) do
        print("|-")
        print("|" .. wikifyName(factory.name))
        print("|" .. optimalProductionCapacity(factory.output))
        print("|")
        printProductionCell(factory.output)
        print("|")
        printInput(factory.input)
    end
end    

-- Prints the information at the top of the table
local function printHeader()
   print("{| class=\"wikitable sortable\"")
   print("! style=\"text-align:left;\"| Factory")
   print("! Production Capacity cap")
   print("! Produces (quantity, Price, Level)")
   print("! Ingredients (quantity)")
end

local function main()
  local factories = extractFactoriesData()
  --print(inspect(factories))
  printHeader()
  printList(factories)
  print("|}")
end

main()
