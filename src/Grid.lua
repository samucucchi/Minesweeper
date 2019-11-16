  local Grid = {}
  
  local grid = {}
  
  local function generateHints(grid, row, col) --increments of 1 all the adjacent cells of a passed mine
    if grid[row][col] ~= 10 then 
      grid[row][col] = grid[row][col] + 1
    end
  end 
  Grid.generateHints = generateHints
  
  local function generateMines(nMines) --creates all the mines wanted and decides where to place them
    math.randomseed(os.time())
    for i = 1, nMines do
      local row
      local col
      repeat
        row = math.random(1, #grid) 
        col = math.random(1, #grid[1])
      until(grid[row][col] ~= 10)
      grid[row][col] = 10
      for i = -1, 1 do 
        for r = -1, 1 do 
          if i ~= 0 or r ~= 0 then 
            --pcall(generateHints, grid, row, col, i, r) 
            pcall(generateHints, grid, row + i, col + r)
          end
        end
      end
    end
  end 
  Grid.generateMines = generateMines
  
  local function generateGrid(nRow, nCol, nMines) --generates a new empty grid
    for row = 1, nRow do 
      grid[row] = {}
      for col = 1, nCol do 
        grid[row][col] = 0
      end 
    end
    generateMines(nMines)
    return grid
  end 
  Grid.generateGrid = generateGrid
  
  local function getRow() 
    return #grid
  end
  Grid.getRow = getRow
  
  local function getCol()
    return #grid[1]
  end
  Grid.getCol = getCol
  
  local function getGrid() 
    return grid
  end 
  Grid.getGrid = getGrid
  
  return Grid