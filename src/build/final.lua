------------------------- output.lua -------------------------

function consout(...)
    local messages = table.pack(...);
    for k, v in ipairs(messages) do
        io.stderr:write(v .. "\n");
    end
end

function dumpParams(gParams, roundParams)
    consout "--------| Global params |--------";
    consout(gParams.laps);
    consout(gParams.checkpointCount);
    for i = 0, #gParams.checkPoint do
        consout(gParams.checkPoint[i].x .. " " .. gParams.checkPoint[i].y);
    end
    consout "--------| Round params |--------";
    for i = 1, #roundParams.playerPods do
        consout(roundParams.playerPods[i].x .. " " .. roundParams.playerPods[i].y .. " "
            .. roundParams.playerPods[i].vx .. " " .. roundParams.playerPods[i].vy .. " "
            .. roundParams.playerPods[i].angle .. " " .. roundParams.playerPods[i].nextCheckPointId);
    end
    for i = 1, #roundParams.opponentPods do
        consout(roundParams.opponentPods[i].x .. " " .. roundParams.opponentPods[i].y .. " "
            .. roundParams.opponentPods[i].vx .. " " .. roundParams.opponentPods[i].vy .. " "
            .. roundParams.opponentPods[i].angle .. " " .. roundParams.opponentPods[i].nextCheckPointId);
    end
    consout "--------| END |--------";
end
------------------------- init.lua -------------------------

--simulator = require 'simulator';


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
    local roundParams = {};
    if( simulator ) then
        roundParams = simulator.getRoundParams();
        if(not roundParams) then
            roundParams = readRoundParams( simulator.getRoundParamIterator() );
            simulator.setRoundParams(roundParams);
        end
    else
        roundParams = readRoundParams(io);
    end
    return roundParams;
end

function readRoundParams(input)
    local roundParams = {};
    roundParams.playerPods = {};
    roundParams.opponentPods = {};

    for i = 1, 2 do
        local next_token = string.gmatch(input.read(), "[^%s]+");
        roundParams.playerPods[i] = {};
        roundParams.playerPods[i].x = tonumber(next_token());
        roundParams.playerPods[i].y = tonumber(next_token());
        roundParams.playerPods[i].vx = tonumber(next_token());
        roundParams.playerPods[i].vy = tonumber(next_token());
        roundParams.playerPods[i].angle = tonumber(next_token());
        roundParams.playerPods[i].nextCheckPointId = tonumber(next_token());
    end
    for i= 1, 2 do
        local next_token = string.gmatch(input.read(), "[^%s]+");
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

------------------------- main.lua -------------------------
--require "output";
--require "init";
--require "neuralNetwork";

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
    dumpParams(gParams, roundParams);

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
        
        --break;
    end
end

main();

