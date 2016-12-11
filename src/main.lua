------------------------- main.lua -------------------------
--[[del]]require "output";
--[[del]]require "init";
--[[del]]require "neuralNetwork";
--[[del]]local json = require "util/dkjson"

local gParams;

function processStage()
  local roundParams = initRoundParams();
  error( json.encode(roundParams, {indent = true}) );
  
  io.stderr:write("Debug message\n");

  local firstCheckPoint = gParams.checkPoint[ roundParams.playerPods[1].nextCheckPointId .. "" ];
  local secondCheckPoint = gParams.checkPoint[ roundParams.playerPods[2].nextCheckPointId .. "" ];

  print(firstCheckPoint.x .. " " .. firstCheckPoint.y .. " 100");
  print(secondCheckPoint.x .. " " .. secondCheckPoint.y .. " 100");
end

function main()
  gParams = initGlobalParams();
  error( json.encode(gParams, {indent = true}) );
  while true do
    processStage();
  end
end

main();



