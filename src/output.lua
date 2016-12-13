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