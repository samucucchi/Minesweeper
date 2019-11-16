local grid = require('Minesweeper\\src\\Grid')
local gridController = require('Minesweeper\\src\\GridController')
local nRow = 10
local nCol = 8
local nMines = 10
grid.generateGrid(nRow, nCol, nMines)
mines = grid.getGrid()
grid.printGrid()
gridController.startVisualizationGrid(nRow, nCol)

while(true) do
  gridController.printGrid(mines)
  print("insert row number ")
  row = io.read("*n")
  print("insert column number ") 
  col = io.read("*n")
  if gridController.checkInput(grid.getGrid(), row, col) == false then
    print("hai perso")
    break 
  end
  if(gridController.checkWin(nMines) == true) then 
    print("hai vinto") 
    break
  end
end