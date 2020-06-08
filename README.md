# Avorion-Wikify-Factory-Optimization



Avorion-Wikify (goods-table script) generates a list of goods that are currently in the game with associated information and links to stations that buy or sell them.

The goods list generated with this script can be found [here](https://avorion.gamepedia.com/Goods).


Factory-Optimization (the factory-optimization script) generates a table of factories that are currently in the game with the production capacity required to produce this good at full capacity (with the minimum 15 or 30 second production time), the goods they produce (with the variables required to make the calculation) and the ingredients.

a page that contains the table can be found [on the wiki](https://avorion.gamepedia.com/Optimal_factory_production_capacity).

## Setup

The setup is the same for all top level scripts.

in the src folder, create the following folder: data
Then you need to copy the following files from the Avorion install directory to the indicated location:

    Avorion/data/scripts/lib/goodsindex.lua --> avorion-wikify-factory-optimization/src/data/goods.lua
    Avorion/data/scripts/lib/productionsindex.lua --> avorion-wikify-factory-optimization/src/data/productions.lua
   
These files provide the necessary information for avorion-wikify.

