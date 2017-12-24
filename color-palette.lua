function ColorPalette(pxSize, xOff, yOff) 
    local this = {
      xOffset = xOff,
      yOffset = yOff,
      
      cursor = {
        x = 0,
        y = 0
      },

      colorGrid = {},

      pixelSize = pxSize,

      gridHeight = pxSize,
      gridWidth = pxSize,

      cursorColor = {0, 255, 0, 255},
      gridColor = {0, 0, 0, 255},
      
      hasFocus = false,
      
      onCursorOutOfBounds = nil,
      onColorSelected = nil
    }
    
    --Callback for when a color is selected
    function this.setOnColorSelected(callback)
      this.onColorSelected = callback
    end
    
    --Callback for when the user tries to move the cursor beyond the area
    function this.setOnCursorOutOfBounds(callback)
      this.onCursorOutOfBounds = callback
    end
    
    --Enables or disables the Input
    function this.setFocus(focus)
      this.hasFocus = focus
    end
    
    --Saves the selected color in the grid
    function this.selectColor() 
      if (this.onColorSelected ~= nil) then this.onColorSelected(this.colorGrid[this.cursor.x][this.cursor.y]) end
    end
    
    
    --Draws the cursor in the cursor.x and cursor.y position
    function this.drawCursor()      
      love.graphics.setColor(this.cursorColor)
      love.graphics.rectangle("line", 
        this.xOffset + this.cursor.x * this.pixelSize, 
        this.yOffset + this.cursor.y * this.pixelSize, 
        this.gridWidth, 
        this.gridHeight)
    end
    
    
    function this.keypressed(key)
      if (this.hasFocus) then 
        if (key == "up") then
          if (this.cursor.y == 0) then
            if (this.onCursorOutOfBounds ~= nil) then this.onCursorOutOfBounds() end
          else
            this.cursor.y = this.cursor.y - 1
          end
        elseif (key == "down") then
          if (this.cursor.y == this.gridHeight) then
            if (this.onCursorOutOfBounds ~= nil) then this.onCursorOutOfBounds() end
          else
            this.cursor.y = this.cursor.y + 1
          end
        elseif (key == "left") then
          if (this.cursor.x == 0) then
            if (this.onCursorOutOfBounds ~= nil) then this.onCursorOutOfBounds() end
          else
            this.cursor.x = this.cursor.x - 1
          end
        elseif (key == "right") then
          if (this.cursor.x == this.gridWidth) then
            if (this.onCursorOutOfBounds ~= nil) then this.onCursorOutOfBounds() end
          else
            this.cursor.x = this.cursor.x + 1
          end
        elseif (key == "space") then
          this.selectColor()
        end
      end
    end

    function this.drawGrid(x, y, gridWidth, gridHeight)
      love.graphics.setColor(this.gridColor)
      love.graphics.rectangle("line",
        this.xOffset + x,
        this.yOffset + y,
        this.gridWidth,
        this.gridHeight)
    end
    
    function this.drawColor(x, y, gridWidth, gridHeight)
      love.graphics.setColor(this.colorGrid[x/this.pixelSize][y/this.pixelSize])
      love.graphics.rectangle("fill", 
        this.xOffset + x,
        this.yOffset + y, 
        this.gridWidth, 
        this.gridHeight)
    end

    
    --Initializes the empty grid
    function this.load()
      for x = 0, this.gridWidth do
        this.colorGrid[x] = {}
        for y = 0, this.gridHeight do
            this.colorGrid[x][y] = {x, x * 7, y * 7, 255}
        end
      end
    end
    
    
    function this.draw()
      for x = 0, this.gridWidth * this.pixelSize, this.pixelSize do
        for y = 0, this.gridHeight * this.pixelSize, this.pixelSize do
          this.drawColor(x, y, this.gridWidth, this.gridHeight)
          this.drawGrid(x, y, this.gridWidth, this.gridHeight)
        end
      end
      this.drawCursor()
    end
    
    return this
end