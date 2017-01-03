require 'fileio';
require 'constants';
require 'output';
require 'util/geometryutil';
--local math = require 'math';
local GLOBAL_PARAM_FILE = 'src/config/scenarios/5/globals.conf';
local ROUND_PARAM_FILE  = 'src/config/scenarios/5/round.conf';

local nextGlobalParams;
local nextRoundParams;

math.round = function (num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0);
  return math.floor(num * mult + 0.5) / mult;
end

simulator = {};
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
function getEnemyAction(gParams, opponentPod)
    local pod = {};
    pod.action = "move";
    pod.thrust = 100;
    local checkPoint = gParams.checkPoint[ opponentPod.nextCheckPointId ];
    pod.x = checkPoint.x;
    pod.y = checkPoint.y;
    
    return pod;
end

function addCoords(pod, podAction)
    pod.x = podAction.x;
    pod.y = podAction.y;
    pod.vx = podAction.vx;
    pod.vy = podAction.vy;
end

function getSegment(coord1, coord2)
    local segment = {};
    segment.x1 = coord1.x;
    segment.y1 = coord1.y;
    segment.x2 = coord2.x;
    segment.y2 = coord2.y;
    
    return segment;
end

-- Time to compute next round params
function simulator.simulateRound(gParams, roundParams, pod1, pod2, round)
    local pod1Future = getNextStepCoord( roundParams.playerPods[1], pod1, round);
    consout('Next step coords: ' .. pod1Future.x .. '/' .. pod1Future.y);
    local pod2Future = getNextStepCoord( roundParams.playerPods[2], pod2, round);
    consout('Next step coords: ' .. pod2Future.x .. '/' .. pod2Future.y);
    local enemy1Future = getNextStepCoord( roundParams.opponentPods[1], getEnemyAction(gParams, roundParams.opponentPods[1]), round );
    local enemy2Future = getNextStepCoord( roundParams.opponentPods[2], getEnemyAction(gParams, roundParams.opponentPods[2]), round );
    
    consout('Enemy 1 next: ' .. enemy1Future.x .. '/' .. enemy1Future.y);
    consout('Enemy 2 next: ' .. enemy2Future.x .. '/' .. enemy2Future.y);
    -- update next round info
    -- Update coords after collisions and stuff
    -- ** DETECT COLLISIONS AND ORDER THEM **
    local collisionsPresent = false;
    local playerPod2 = roundParams.playerPods[2];
    local unresolvedCollisions = {};
    local intersectTimes = {};
    repeat
        -- Get segments for all pods
        local player1seg = getSegment(roundParams.playerPods[1], pod1Future);
        local player2seg = getSegment(roundParams.playerPods[2], pod2Future);
        -- pod 1 to pod 2 collision check
        local intersection = getSegmentIntersection(player1seg, player2seg);
        if intersection then
            local collision = {};
            collision.x = intersection.x;
            collision.y = intersection.y;
            collisionTime = should be completed;
            unresolvedCollisions[ #unresolvedCollisions +1 ] = '';
        end
        
    until not collisionsPresent;
    
    -- ** RESOLVE COLLISIONS ** 
    
    -- Update speed after applying friction + determine angle + nextCheckpoint
    addCoords(nextRoundParams.playerPods[1], pod1Future);
    addCoords(nextRoundParams.playerPods[2], pod2Future);
    
    addCoords(nextRoundParams.opponentPods[1], enemy1Future);
    addCoords(nextRoundParams.opponentPods[2], enemy2Future);
    
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

function getTrueAngle( desAngle, playerPod )
    if( math.abs(desAngle - playerPod.angle) > 18 ) then
        local reflectedDesAngle = desAngle > 270 and (desAngle -360) or (desAngle +360);
        
        -- The angle might still be lower than 18. E.g. desired angle 350 deg, current angle 5 deg
        if( math.abs(reflectedDesAngle - playerPod.angle) > 18 ) then -- angle is definitely gt 18 deg
            local directionMultiplier = desAngle - playerPod.angle > 0 and 1 or -1;
            directionMultiplier = math.abs(desAngle - playerPod.angle) < 180 and directionMultiplier or -directionMultiplier;
            return playerPod.angle + directionMultiplier * 18;
        end
    end
    
    return desAngle;
end

function getNextStepCoord(playerPod, podAction, round)
    local speedVector = {vx = playerPod.vx, vy = playerPod.vy};
    if( podAction.action == "move"  ) then
        local desVector = { vx = podAction.x - playerPod.x, vy = podAction.y - playerPod.y };
        -- Determine current ship direction vector
        local desAngle;
        if( desVector.vx ~= 0 ) then
            desAngle = math.atan( desVector.vy / desVector.vx) * 180 / 3.141592;
            desAngle = compensateQuadrant( desVector.vx, desVector.vy, desAngle );
        else
            desAngle = desVector.vy > 0 and 90 or 270;
        end
        
        if( round == 1 ) then 
            playerPod.angle = desAngle;
        end  

        local trueAngle = getTrueAngle( desAngle, playerPod );
        
        local nextSpeed = {};
        -- new acceleration this round
        local angleInRads = trueAngle * (3.141592 / 180);
        nextSpeed.vx = podAction.thrust * math.cos(angleInRads);
        nextSpeed.vy = podAction.thrust * math.sin(angleInRads);
        -- existing inertia
        nextSpeed.vx = nextSpeed.vx + playerPod.vx;
        nextSpeed.vy = nextSpeed.vy + playerPod.vy;
        
        local nextCoord = {};
        nextCoord.x = math.round(playerPod.x + nextSpeed.vx);
        nextCoord.y = math.round(playerPod.y + nextSpeed.vy);
        nextCoord.vx = math.floor( 0.85 * nextSpeed.vx );
        nextCoord.vy = math.floor( 0.85 * nextSpeed.vy );
        
        return nextCoord;
    end
    return {x = playerPod.x + speedVector.vx, y = playerPod.y + speedVector.vy};
end


return simulator;