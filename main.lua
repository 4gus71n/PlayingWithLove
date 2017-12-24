
require('mobdebug').start()
require "sprite-grid"
require "color-palette"

spriteGrid = SpriteGrid(16, 16, 16)
colorPalette = ColorPalette(16, spriteGrid.getWidth() + 32, 16)

function onColorSelected(color)
  spriteGrid.setSelectedColor(color)
end

function onColorPaletteOutOfBounds()
  spriteGrid.setFocus(true)
  colorPalette.setFocus(false)
end

function onSpriteGridOutOfBounds()
  spriteGrid.setFocus(false)
  colorPalette.setFocus(true)
end

function love.load()
	spriteGrid.load()
  colorPalette.load()
  
  colorPalette.setOnCursorOutOfBounds(onColorPaletteOutOfBounds)
  spriteGrid.setOnCursorOutOfBounds(onSpriteGridOutOfBounds)
  
  colorPalette.setOnColorSelected(onColorSelected)
  
  colorPalette.setFocus(true)
end

function love.draw()
	spriteGrid.draw()
  colorPalette.draw()
end

function love.keypressed(key)
	spriteGrid.keypressed(key)
  colorPalette.keypressed(key)
end
