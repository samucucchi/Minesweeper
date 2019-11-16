local GridController = {}

local visualizationGrid = {} --used to decide which cells need to be shown or not

local function startVisualizationGrid(nRow, nCol) --instantiates the visualization grid with all cells hidden
  --visualizationGrid = {}
  for row = 1, nRow do 
    visualizationGrid[row] = {}
    for col = 1, nCol do 
      visualizationGrid[row][col] = 'H'
    end
  end
end
GridController.startVisualizationGrid = startVisualizationGrid

local function findHints(grid, row, col) --shows the hints near all the zeros
  --searchs around the passed cell
  for r = -1, 1 do 
    for c = -1, 1 do 
      --checks that the index are inside the grid 
      if row + r >= 1 and row + r <= #visualizationGrid then 
        if col + c >= 1 and col + c <= #visualizationGrid[1] then
          if grid[row + r][col + c] > 0 and grid[row + r][col + c] < 10 then --checks if the found cell is a hint 
            visualizationGrid[row + r][col + c] = 'S'
          end
        end
      end
    end
  end
end

local function showEmptyCells(grid, row, col) --shows all the adjacent zeros
  if grid[row][col] == 0 then 
    visualizationGrid[row][col] = 'S'
    if row - 1 >= 1 and grid[row - 1][col] < 10 and visualizationGrid[row - 1][col] == 'H' then
      findHints(grid, row, col)
      showEmptyCells(grid, row - 1, col) end 
    if col - 1 >= 1 and grid[row][col - 1] < 10 and visualizationGrid[row][col - 1] == 'H' then 
      findHints(grid, row, col)
      showEmptyCells(grid, row, col - 1) end 
    if row + 1 <= #visualizationGrid and grid[row + 1][col] < 10 and visualizationGrid[row + 1][col] == 'H' then 
      findHints(grid, row, col)
      showEmptyCells(grid, row + 1, col) end 
    if col + 1 <= #visualizationGrid[1] and grid[row][col + 1] < 10 and visualizationGrid[row][col + 1] == 'H' then 
      findHints(grid, row, col)
      showEmptyCells(grid, row, col + 1) end
  end
end

local function checkWin(nMines) --true if all the bombs have been marked, false instead 
  local counter = 0
  for row = 1, #visualizationGrid do 
    for col = 1, #visualizationGrid[1] do 
      if visualizationGrid[row][col] == 'M' then counter = counter + 1 end
    end
  end
  if counter == nMines then 
    print('Hai vinto')
    return true 
  else return false end 
end
GridController.checkWin = checkWin

local function checkInput(grid, row, col) --checks the content of a selected cell
  if grid[row][col] == 10 then return false --if a cell containing a bomb have been selected
  else if grid[row][col] ~= 0 then --if a cell containing a number have been selected
    visualizationGrid[row][col] = 'S'
    return true
  else --if an empty cell have been selected -> showEmptyCells 
    visualizationGrid[row][col] = 'S'
    showEmptyCells(grid, row, col) 
    return true
    end
  end
end 
GridController.checkInput = checkInput

local function attempt(grid, row, col) --true if the selected cell has never been selected yet, false if it has been alreay selected 
  if visualizationGrid[row][col] == 'S' then return true
  else return false
  end
end
GridController.attempt = attempt

local function printGrid(grid) --prints the grid basing on the visualizationGrid and the starting grid 
  for row = 1, #grid do 
    for col = 1, #grid[1] do 
      if visualizationGrid[row][col] == 'S' then io.write(grid[row][col] .. ' ') 
      else io.write(visualizationGrid[row][col] .. ' ') end
    end
    print()
  end  
  print()
end
GridController.printGrid = printGrid

local function checkAroundCell(grid, row, col) 
  --selects all the hidden cells around a number touching a bomb
  for r = -1, 1 do 
    for c = -1, 1 do 
      if row + r >= 1 and row + r <= #grid then 
        if col + c >= 1 and col + c <= #grid[1] then 
          if visualizationGrid[row + r][col + c] == 'H' then 
            checkInput(grid, row + r, col + c)
            found = true 
          end
        end
      end
    end
  end 
end

local function checkAroundBomb(grid, row, col) 
  --searchs for '1' around a bomb
  for r = -1, 1 do 
    for c = -1, 1 do 
      if row + r >= 1 and row + r <= #grid then 
        if col + c >= 1 and col + c <= #grid[1] then 
          if grid[row + r][col + c] == 1 then 
          --found a "1" cell, so I pass the coordinates to checkAroundCell
          checkAroundCell(grid, row + r, col + c)
          end
        end
      end
    end
  end
end

local function searchBomb(grid) 
  --scans the grid looking for a bomb
  for row = 1, #grid do 
    for col = 1, #grid[1] do 
      if visualizationGrid[row][col] == 'M' then --found a bomb, check around it
        checkAroundBomb(grid, row, col)
      end
    end
  end
end

local function uploadGrid(grid, row, col) 
  --decrements the value of all the uncovered cell near a marked bomb
  for r = -1, 1 do 
    for c = -1, 1 do 
      if row + r >= 1 and row + r <= #visualizationGrid then 
        if col + c >= 1 and col + c <= #visualizationGrid[1] then 
          if visualizationGrid[row + r][col + c] == 'S' and grid[row + r][col + c] ~= 0 and grid[row + r][col + c] ~= 10 then
            grid[row + r][col + c] = grid[row + r][col + c] - 1
          end
        end
      end
    end
  end
end

local function checkAdjacent(grid, row, col, startGrid)  --check if some bomb can be near the passed cell
  local adjacent = 0 --used to count the unmarked cells near grid[row][col]
  for r = -1, 1 do 
    for c = -1, 1 do 
      if row + r >= 1 and row + r <= #visualizationGrid then 
        if col + c >= 1 and col + c <= #visualizationGrid[1] then
          if visualizationGrid[row + r][col + c] == 'H' then 
            adjacent = adjacent + 1
            lastRow = row + r
            lastCol = col + c
          end
        end
      end
    end
  end
  if adjacent == 1 then 
    visualizationGrid[lastRow][lastCol] = 'M'
    uploadGrid(grid, lastRow, lastCol)
    printGrid(startGrid)
  end
  searchBomb(grid)
end

local function getNumbers(grid, startGrid) --examines the grid and decides where there could be a bomb
  found = false
  for r = 1, #grid do 
    for c = 1, #grid[1] do 
      if visualizationGrid[r][c] == 'S' and grid[r][c] ~= 0 then 
        --I found a cell discovered containing a number
        checkAdjacent(grid, r, c, startGrid)
      end
    end
  end
end
GridController.getNumbers = getNumbers

return GridController