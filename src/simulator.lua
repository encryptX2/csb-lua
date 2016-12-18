require 'fileio';
require 'constants';
require 'output';
--local math = require 'math';
local GLOBAL_PARAM_FILE = 'src/config/scenarios/5/globals.conf';
local ROUND_PARAM_FILE  = 'src/config/scenarios/5/round.conf';

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
function simulator.simulateRound(gParams, roundParams, pod1, pod2)
    local pod1Future = getNextStepCoord( roundParams.playerPods[1], pod1);
    consout('Next step coords: ' .. pod1Future.x .. '/' .. pod1Future.y);
    local pod2Future = getNextStepCoord( roundParams.playerPods[2], pod2);
    consout('Next step coords: ' .. pod2Future.x .. '/' .. pod2Future.y);
--local enemy1Future = getNextEnemyCoord( roundParams.getOpponentPods[1], getEnemyAction(gParams, roundParams.getOpponentPods[1]) );
--local enemy2Future = getNextEnemyCoord( roundParams.getOpponentPods[2], getEnemyAction(gParams, roundParams.getOpponentPods[2]) );
-- Compute one whole round with pod states, collisions and next checkpoint computation
-- + end of game recognition
end

function compensateQuadrant( vx, vy, angle )
    if(vx > 0 and vy < 0 ) then -- 1st quadrant
        return 360 + angle;
    end
    if(vx < 0) then -- 2nd and 3rd quadrant
        return 180 + angle;
    end
    -- 4th quadrant
    return angle;
end

function getNextStepCoord(playerPod, podAction)
    local speedVector = {vx = playerPod.vx, vy = playerPod.vy};
    if( podAction.action == "move"  ) then
        local desVector = { vx = podAction.x - playerPod.x, vy = podAction.y - playerPod.y };
        -- Determine current ship direction vector
        local angle;
        if( desVector.vx ~= 0 ) then
            angle = math.atan( desVector.vy / desVector.vx) * 180 / 3.141592;
            consout( "Angle: " .. angle );
            angle = compensateQuadrant( desVector.vx, desVector.vy, angle );
            consout( "Compensated angle: " .. angle );
        else
            angle = desVector.vy > 0 and 90 or 270;
        end

        -- Update current ship direction vector
        -- Update current ship acceleration
        -- Compute next coord
    end
    return {x = playerPod.x + speedVector.vx, y = playerPod.y + speedVector.vy};
end


return simulator;
