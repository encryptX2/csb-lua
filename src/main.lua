------------------------- main.lua -------------------------
--[[del]]require "output";
--[[del]]require "init";
--[[del]]require "neuralNetwork";

local gParams;
local round = 0;

function processStage()
    local roundParams = initRoundParams();
    dumpParams(gParams, roundParams);

    --io.stderr:write("Debug message\n");

    local firstCheckPoint = gParams.checkPoint[ roundParams.playerPods[1].nextCheckPointId ];
    local secondCheckPoint = gParams.checkPoint[ roundParams.playerPods[2].nextCheckPointId ];

    if(simulator) then
        simulator.simulateRound();
    else
        print(firstCheckPoint.x .. " " .. firstCheckPoint.y .. " 100");
        print(secondCheckPoint.x .. " " .. secondCheckPoint.y .. " 100");
    end
end

function main()
    gParams = initGlobalParams();
    while true do
        if( simulator and simulator.stopSimulation() ) then
            break;
        end
        processStage();
        
        --break;
    end
end

main();
