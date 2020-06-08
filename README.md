# Avorion-Wikify-Factory-Optimization

Avorion-Wikify-Factory-Optimization generates a list of goods that are currently in the game with the factories that produce them, the production capacity required to produce this good at full capacity (with the minimum 15 or 30 second production time) and lists the variables that would be needed to calculate this value. 

a page that contains the table can be found on [on the wiki] (https://avorion.gamepedia.com/Optimal_factory_production_capacity).

## Setup

in the src folder, create the following folder: data
Then you need to copy the following files from the Avorion install directory to the indicated location:

    Avorion/data/scripts/lib/goodsindex.lua --> avorion-wikify-factory-optimization/src/data/goods.lua
    Avorion/data/scripts/lib/productionsindex.lua --> avorion-wikify-factory-optimization/src/data/productions.lua
   
These files provide the necessary information for avorion-wikify.

