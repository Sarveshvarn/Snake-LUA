require('game')

function love.load()
  font = love.graphics.newFont('MavenPro-VariableFont_wght.ttf', 16)
  love.window.setPosition(500, 50, 1)
  interval = 20
  add_apple()
end

function love.draw()
  love.graphics.setFont(font)
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.print('SNAKE', (900/2)-30, 10, 0, 1.5, 1.5)
  
  love.graphics.setBackgroundColor(0, 255, 0, 1)
  game_draw()
  if state == GameStates.game_over then
    love.graphics.print('Game Over!', 330, 350, 0, 4, 4)
    love.graphics.print('Press Space to restart!', 270, 450, 0, 3, 3)
  elseif state == GameStates.pause then
    love.graphics.print('Paused!', 330, 350, 0, 4, 4)
    love.graphics.print('Press P to start!', 270, 450, 0, 3, 3)
  end
end

function love.update()
  if state == GameStates.running then
    interval = interval - 1
    if interval < 0 then
      game_update()
      if tail_length <= 5 then
        interval = 20
      elseif tail_length > 5 and tail_length <= 10 then
        interval = 15
      elseif tail_length > 10 and tail_length <= 15 then
        interval = 10
      else
        interval = 5
      end
    end
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'left' and state == GameStates.running then
    left = true; right = false; up = false; down = false;
  elseif key == 'right' and state == GameStates.running then
    left = false; right = true; up = false; down = false;
  elseif key == 'up' and state == GameStates.running then
    left = false; right = false; up = true; down = false;
  elseif key == 'down' and state == GameStates.running then
    left = false; right = false; up = false; down = true;
  elseif key == 'space' and state == GameStates.game_over then
    game_restart()
  elseif key == 'p' then
    if state == GameStates.running then
      state = GameStates.pause
    elseif state == GameStates.pause then
      state = GameStates.running
    end
  end
end
