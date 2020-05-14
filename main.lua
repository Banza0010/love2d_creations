require "collision"
--800 x 600

function love.load()
  math.randomseed(os.time())  --randomiser

  --player table
  player = {}
  player.x = 50
  player.y = 300
  player.w = 50
  player.h = 50
  player.direction = "down"

  playerSpeed = 3
  --item
  coins = {}

  score = 0 
  -- sound 
  sounds = {}
  sounds.coin = love.audio.newSource("sounds/coin.ogg", "static")
  --font
  fonts = {}
  fonts.large = love.graphics.newFont("font.ttf", 36)
  --player = love.graphics.newImage("/images/player.png")

  --images
  images = {}
  images.background = love.graphics.newImage("images/ground1.png")
  images.coin = love.graphics.newImage("images/coin.png")
  --player 
  images.player_down = love.graphics.newImage("images/player_down.png")
  images.player_up = love.graphics.newImage("images/player_up.png")
  images.player_left = love.graphics.newImage("images/player_left.png")
  images.player_right = love.graphics.newImage("images/player_right.png")
end

function love.update(dt)
  --player movement
  if love.keyboard.isDown("right") then
    player.x = player.x + playerSpeed
    player.direction = "right"
  elseif love.keyboard.isDown("left") then
    player.x = player.x - playerSpeed
    player.direction = "left" 
  elseif love.keyboard.isDown("down") then
    player.y = player.y + playerSpeed
    player.direction = "down"
  elseif love.keyboard.isDown("up") then
    player.y = player.y - playerSpeed
    player.direction = "up"
  end
   --collision detection
  for i=#coins, 1, -1 do  --for loop in lua start,end,increment  --loops strat at 1
    local coin = coins[i]
    if AABB(player.x, player.y, player.w, player.h, coin.x, coin.y, coin.w, coin.h) then
      table.remove(coins, i) 
      score = score + 1
      sounds.coin:play()
    end
  end

  --genrate random coin
  if math.random() < 0.01 then 
    local coin = {}
    coin.w = 30
    coin.h = 30
    coin.x = math.random(0, 800 - coin.w)
    coin.y = math.random(0, 600 - coin.h)
    table.insert(coins, coin)
  end

end

function love.draw() 

  for  x=0, love.graphics.getWidth(), images.background:getWidth() do
    for y=0, love.graphics.getHeight(), images.background:getHeight() do 
      love.graphics.draw(images.background, x, y)
    end
  end

  local playerImg = images.player_down

  if player.direction == "down" then
    playerImg = images.player_down
  elseif player.direction == "up" then
    playerImg = images.player_up
  elseif player.direction == "right" then
    playerImg = images.player_right
  elseif player.direction == "left" then
    playerImg = images.player_left
  end

  love.graphics.draw(playerImg, player.x, player.y) -- render player

  for i=1, #coins, 1 do  --for loop in lua start,end,increment  --loops strat at 1
    local coin = coins[i]
    love.graphics.draw(images.coin, coin.x, coin.y)
    --love.graphics.draw(images.coin, coin.x, coin.y)
  end

  love.graphics.setFont(fonts.large)
  love.graphics.print("SCORE: " .. score, 10,10)

end

function love.keypressed(key)
  if key == 'escape' then
      love.event.quit()
  end
end

