------------------------- output.lua -------------------------

function debug(...)
    local messages = table.pack(...);
    for k, v in ipairs(messages) do
        io.stderr:write(v .. "\n");
    end
end

function dumpParams(gParams, roundParams)
    debug "--------| Global params |--------";
    debug(gParams.laps);
    debug(gParams.checkpointCount);
    for i = 0, #gParams.checkPoint do
        debug(gParams.checkPoint[i].x .. " " .. gParams.checkPoint[i].y);
    end
    debug "--------| Round params |--------";
    for i = 1, #roundParams.playerPods do
        debug(roundParams.playerPods[i].x .. " " .. roundParams.playerPods[i].y .. " "
            .. roundParams.playerPods[i].vx .. " " .. roundParams.playerPods[i].vy .. " "
            .. roundParams.playerPods[i].angle .. " " .. roundParams.playerPods[i].nextCheckPointId);
    end
    for i = 1, #roundParams.opponentPods do
        debug(roundParams.opponentPods[i].x .. " " .. roundParams.opponentPods[i].y .. " "
            .. roundParams.opponentPods[i].vx .. " " .. roundParams.opponentPods[i].vy .. " "
            .. roundParams.opponentPods[i].angle .. " " .. roundParams.opponentPods[i].nextCheckPointId);
    end
    debug "--------| END |--------";
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

