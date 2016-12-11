require 'fileio';
local GLOBAL_PARAM_FILE = 'src/config/scenarios/1/globals.conf';
local ROUND_PARAM_FILE  = 'src/config/scenarios/1/round.conf';

local nextGlobalParams;
local nextRoundParams;

local simulator = {};
-- Global params
function simulator.getGlobalParams()
    return nextGlobalParams;
end

function simulator.setGlobalParams(gParams)
    nextGlobalParams = gParams;
end
-- Round params
function simulator.getRoundParams()
    return nextRoundParams;
end

function simulator.setRoundParams(roundParams)
    nextRoundParams = roundParams;
end
-- Input iterators
function simulator.getGlobalParamIterator()
    return getFileLineIterator( GLOBAL_PARAM_FILE );
end

function simulator.getRoundParamIterator()
    return getFileLineIterator( ROUND_PARAM_FILE );
end
function simulator.stopSimulation()
    return false;
end

-- Time to compute next round params
function simulator.simulateRound()

end

return simulator;