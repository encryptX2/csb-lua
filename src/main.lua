-- Auto-generated code below aims at helping you parse
-- the standard input according to the problem statement.
local gParams = {};

function initGlobalParams()
  gParams.laps = tonumber(io.read());
  gParams.checkpointCount = tonumber(io.read());
  gParams.checkPoint = {};
  for i = 1, gParams.checkpointCount do
    local next_token = string.gmatch(io.read(), "[^%s]+");
    gParams.checkPoint[i] = {};
    gParams.checkPoint[i].x = tonumber(next_token());
    gParams.checkPoint[i].y = tonumber(next_token());
  end
end

function initRoundParams()
  local roundParams = {};
  roundParams.playerPods = {};
  roundParams.opponentPods = {};

  for i=1, 2 do
    local next_token = string.gmatch(io.read(), "[^%s]+");
    roundParams.playerPods[i] = {};
    roundParams.playerPods[i].x = tonumber(next_token());
    roundParams.playerPods[i].y = tonumber(next_token());
    roundParams.playerPods[i].vx = tonumber(next_token());
    roundParams.playerPods[i].vy = tonumber(next_token());
    roundParams.playerPods[i].angle = tonumber(next_token());
    roundParams.playerPods[i].nextCheckPointId = tonumber(next_token());
  end
  for i=1,2 do
    local next_token = string.gmatch(io.read(), "[^%s]+");
    roundParams.opponentPods[i] = {};
    roundParams.opponentPods[i].x = tonumber(next_token());
    roundParams.opponentPods[i].y = tonumber(next_token());
    roundParams.opponentPods[i].vx = tonumber(next_token());
    roundParams.opponentPods[i].vy = tonumber(next_token());
    roundParams.opponentPods[i].angle = tonumber(next_token());
    roundParams.opponentPods[i].nextCheckPointId = tonumber(next_token());
  end
end

function processStage()
  local roundParams = initRoundParams();

  -- Write an action using print()
  -- To debug: io.stderr:write("Debug message\n")


  -- You have to output the target position
  -- followed by the power (0 <= thrust <= 100)
  -- i.e.: "x y thrust"
  io.stderr:write("Debug message\n");
  print("8000 4500 100");
  print("8000 4500 100");
end


function main()
  initGlobalParams();
  -- game loop
  while true do
    processStage();
  end
end

main();
