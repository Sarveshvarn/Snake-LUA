
GameStates = {pause='pause', running='running', game_over='game over'}
state = GameStates.running

--local variables
local snakeX = 15
local snakeY = 15
local dirX = 0
local dirY = 0

local SIZE = 30
local appleX = 0
local appleY = 0
local tail = {}

--global variables
tail_length = 0
up = false
down = false
left = false
right = false

--game functions
function add_apple()
  math.randomseed(os.time())
  appleX = math.random(SIZE-1)  
  appleY = math.random(SIZE-1)
end

function game_draw()
  --drawing the snake head
  love.graphics.setColor(2.0, 0.4, 0.1, 1.0)
  love.graphics.rectangle('fill', snakeX*SIZE, snakeY*SIZE, SIZE, SIZE, 10, 10)
  
  --drawing the snake tail
  love.graphics.setColor(1.5, 0.4, 0.1, 0.5)
  for _, v in ipairs(tail) do
    love.graphics.rectangle('fill', v[1]*SIZE, v[2]*SIZE, SIZE, SIZE, 15, 15)
  end
  
  --drawing the apple
  love.graphics.setColor(0.0, 0.0, 1.0, 1.0)
  love.graphics.rectangle('fill', appleX*SIZE, appleY*SIZE, SIZE, SIZE, 10, 10)
  
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.print('Collected apples: '.. tail_length, 10, 10, 0, 1.5, 1.5)
end

function game_update()
  if up and dirY == 0 then
    dirX, dirY = 0, -1
  elseif down and dirY == 0 then
    dirX, dirY = 0, 1
  elseif left  and dirX == 0 then
    dirX, dirY = -1, 0
  elseif right and dirX == 0 then
    dirX, dirY = 1, 0
  end
  
  local oldX = snakeX
  local oldY = snakeY
  
  snakeX = snakeX + dirX
  snakeY = snakeY + dirY
  
  if snakeX == appleX and snakeY == appleY then
    add_apple()
    tail_length = tail_length + 1
    table.insert(tail, {0,0})
  end
  
  --Checking for collision of snake on the left and right of the window
  if snakeX < 0 then
    snakeX = SIZE - 1
  elseif snakeX > SIZE - 1 then
    snakeX = 0
  --Checking for collision of snake on the top and bottom of the window
  elseif snakeY < 0 then
    snakeY = SIZE - 1
  elseif snakeY > SIZE - 1 then
    snakeY = 0
  end
  
  if tail_length > 0 then
    for _, v in ipairs(tail) do
      -- Following the (c=a, a=b, b=c) logic
      local x, y = v[1], v[2]
      v[1], v[2] = oldX, oldY
      oldX, oldY = x, y
    end
  end
  
  for _, v in ipairs(tail) do
    if snakeX == v[1] and snakeY == v[2] then
      state = GameStates.game_over
    end
  end
end

function game_restart()
  snakeX, snakeY = 15, 15
  dirX, dirY = 0, 0
  tail = {}
  up, down, left, right = false, false, false, false
  tail_length = 0
  state = GameStates.running
  add_apple()
end
