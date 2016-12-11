------------------------- init.lua -------------------------

--[[del]]local simulator = require 'simulator';


function initGlobalParams()
  local gParams = {};
  if( simulator ) then
    gParams = simulator.getGlobalParams();
    if(not gParams) then
      gParams = readGlobalParams( simulator.getGlobalParamIterator() );
      simulator.setGlobalParams(gParams);
    end
  else
    gParams = readGlobalParams(io);
  end
  return gParams;
end

function readGlobalParams(input)
  local gParams = {};
  gParams.laps = tonumber(input.read());
  gParams.checkpointCount = tonumber(input.read());
  gParams.checkPoint = {};
  for i = 0, gParams.checkpointCount-1 do
    local next_token = string.gmatch(input.read(), "[^%s]+");
    gParams.checkPoint[i] = {};
    gParams.checkPoint[i].x = tonumber(next_token());
    gParams.checkPoint[i].y = tonumber(next_token());
  end
  return gParams;
end

function initRoundParams()
  if( simulator ) then
    return simulator.getRoundParams();
  end

  local roundParams = {};
  roundParams.playerPods = {};
  roundParams.opponentPods = {};

  for i = 1, 2 do
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
  return roundParams;
end
