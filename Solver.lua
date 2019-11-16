local grid = require('Minesweeper\\src\\Grid')
local gridController = require('Minesweeper\\src\\GridController')
local nRow = 10
local nCol = 8
local nMines = 10
local startGrid = {}
local found = false

local function setStartGrid(grid) --makes a content copy of the starting grid 
  startGrid = {}
  for r = 1, #grid do 
    startGrid[r] = {}
    for c = 1, #grid[1] do 
      startGrid[r][c] = grid[r][c]
    end
  end
end  

local function randomAttempt() --makes a random attempt, used as first move and when there are no more logical choices to take
  math.randomseed(os.time())
  math.random(); math.random(); math.random()
  repeat
    row = math.random(1, grid.getRow())
    col = math.random(1, grid.getCol())
  until not gridController.attempt(grid.getGrid(), row, col)
  if not gridController.checkInput(grid.getGrid(), row, col) then 
    print("Hai perso")
    return false
  end 
  return true
end

local function solve()
  setStartGrid(grid.generateGrid(nRow, nCol, nMines))
  gridController.startVisualizationGrid(nRow, nCol)
  while not gridController.checkWin(nMines) and randomAttempt()--until i don't win or lose
  do
    gridController.getNumbers(grid.getGrid(), startGrid)
    while found do 
      gridController.getNumbers(grid.getGrid(), startGrid)
    end
    gridController.printGrid(startGrid)
  end
end

solve()