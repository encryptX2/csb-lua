------------------------- main.lua -------------------------
--[[del]]require "output";
--[[del]]require "init";
--[[del]]require "neuralNetwork";

local gParams;
local round = 0;

function getPodActions(gParams, roundParams)

    local firstCheckPoint = gParams.checkPoint[ roundParams.playerPods[1].nextCheckPointId ];
    local secondCheckPoint = gParams.checkPoint[ roundParams.playerPods[2].nextCheckPointId ];

    local pod1 = {};
    pod1.action = "move";
    pod1.x = firstCheckPoint.x;
    pod1.y = firstCheckPoint.y;
    pod1.thrust = 100;
    
    local pod2 = {};
    pod2.action = "move";
    pod2.x = secondCheckPoint.x;
    pod2.y = secondCheckPoint.y;
    pod2.thrust = 100;

    return pod1, pod2;
end

function processStage()
    local roundParams = initRoundParams();
    --dumpParams(gParams, roundParams);

    --io.stderr:write("Debug message\n");
    --consout('Pod 1 x / y: ' .. roundParams.playerPods[1].x .. '/' .. roundParams.playerPods[1].y);
    --consout('Pod 2 x / y: ' .. roundParams.playerPods[2].x .. '/' .. roundParams.playerPods[2].y);
    local pod1, pod2 = getPodActions( gParams, roundParams );
    
    if(simulator) then
        simulator.simulateRound(gParams, roundParams, pod1, pod2);
    else
        print( pod1.x .. " " .. pod1.y .. " " .. pod1.thrust);
        print( pod2.x .. " " .. pod2.y .. " " .. pod2.thrust);
    end
end

function main()
    gParams = initGlobalParams();
    while true do
        if( simulator and simulator.stopSimulation() ) then
            break;
        end
        processStage();
        
        --[[del]]break;
    end
end

main();
