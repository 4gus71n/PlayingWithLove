function SpriteGrid(pxSize, xOff, yOff) 
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

      currentSelectedColor = {255, 0, 0, 255},

      alphaLightGrayColor = {192, 192, 192, 255},
      alphaDarkGrayColor = {160, 160, 160, 255},
      
      hasFocus = false,
      
      onCursorOutOfBounds = nil
    } 
    
    --Sets the current selected color
    function this.setSelectedColor(color)
        this.currentSelectedColor = color
    end
    
    --Callback for when the user tries to move the cursor beyond the area
    function this.setOnCursorOutOfBounds(callback)
      this.onCursorOutOfBounds = callback
    end
    
    --Enables or disables the Input
    function this.setFocus(focus)
      this.hasFocus = focus
    end
    
    --Returns the width of the component
    function this.getWidth()
      return this.xOffset + this.gridWidth * this.pixelSize
    end
    
    --Saves the selected color in the grid
    function this.paintGrid() 
      this.colorGrid[this.cursor.x][this.cursor.y] = this.currentSelectedColor
    end
    
    
    --Draws the cursor in the cursor.x and cursor.y position
    function this.drawCursor()
      love.graphics.setColor(this.currentSelectedColor)
      love.graphics.rectangle("fill", 
        this.xOffset + this.cursor.x * this.pixelSize, 
        this.yOffset + this.cursor.y * this.pixelSize,
        this.gridWidth, 
        this.gridHeight)
      
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
          this.paintGrid()
        end
      end
    end

    
    function this.drawAlphaGrid(x, y, width, height)
      love.graphics.setColor(this.alphaLightGrayColor)
      love.graphics.rectangle("fill",
        this.xOffset + x,
        this.yOffset + y,
        this.gridWidth/2,
        this.gridHeight/2)
      love.graphics.rectangle("fill",
        this.xOffset + x + this.pixelSize/2,
        this.yOffset + y + this.pixelSize/2,
        this.gridWidth/2,
        this.gridHeight/2)
      
      love.graphics.setColor(this.alphaDarkGrayColor)
      love.graphics.rectangle("fill", 
        this.xOffset + x + this.pixelSize/2,
        this.yOffset + y,
        this.gridWidth/2, 
        this.gridHeight/2)
        
      love.graphics.rectangle("fill",
        this.xOffset + x,
        this.yOffset + y + this.pixelSize/2,
        this.gridWidth/2,
        this.gridHeight/2)
    end

    
    function this.drawGrid(x, y, gridWidth, gridHeight)
      love.graphics.setColor(this.gridColor)
      love.graphics.rectangle("line",
        this.xOffset + x,
        this.yOffset + y,
        this.gridWidth,
        this.gridHeight)
    end

    
    function this.hasColorSet(x, y)
      return (this.colorGrid[x] ~= nil and this.colorGrid[x][y] ~= nil)
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
            this.colorGrid[x][y] = nil
        end
      end
    end
    
    
    function this.draw()
      for x = 0, this.gridWidth * this.pixelSize, this.pixelSize do
        for y = 0, this.gridHeight * this.pixelSize, this.pixelSize do
          if (this.hasColorSet(x/this.pixelSize, y/this.pixelSize)) then
            this.drawColor(x, y, this.gridWidth, this.gridHeight)
          else
            this.drawAlphaGrid(x, y, this.gridWidth, this.gridHeight)
          end
          this.drawGrid(x, y, this.gridWidth, this.gridHeight)
        end
      end
      this.drawCursor()
    end
    
    return this
end