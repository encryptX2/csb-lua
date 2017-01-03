function getLineIntersection(o1x1, o1y1, o1x2, o1y2, o2x1,
    o2y1, o2x2, o2y2)
    local denom = (o2y2 - o2y1) * (o1x2 - o1x1) - (o2x2 - o2x1) * (o1y2 - o1y1);
    if (denom > -0.01 and denom < 0.01) then
        return nil;
    end
    local ua = ((o2x2 - o2x1) * (o1y1 - o2y1) - (o2y2 - o2y1) * (o1x1 - o2x1)) / denom;
    local ub = ((o1x2 - o1x1) * (o1y1 - o2y1) - (o1y2 - o1y1) * (o1x1 - o2x1)) / denom;
    if (ua >= 0.0 and ua <= 1.0 and ub >= 0.0 and ub <= 1.0) then
        -- Get the intersection point.
        return {x = o1x1 + ua * (o1x2 - o1x1), y = o1y1 + ua * (o1y2 - o1y1)};
    end

    return nil;
end

function getSegmentIntersection(segment1, segment2)
    return getLineIntersection(segment1.x1, segment1.y1, segment1.x2, segment1.y2,
    segment2.x1, segment2.y1, segment2.x2, segment2.y2);
end