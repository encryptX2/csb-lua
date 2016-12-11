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
    for i = 1, #gParams.checkPoint do
        debug(gParams.checkPoint[i].x .. " " .. gParams.checkPoint[i].y);
    end
    debug "--------| Round params |--------";
    
    
    debug "--------| END |--------";
end