local json = require "util/dkjson"

function file_exists(file)
    local f ,a ,b = io.open(file, "rb");
    if f then f:close() end;
    return f ~= nil;
end

function lines_from(file)
    if not file_exists(file) then return {} end;
    local lines = {};
    for line in io.lines(file) do
        if( not string.match(line,"^#.*") ) then
            lines[#lines + 1] = line;
        end
    end
    return lines;
end

function getFileLineIterator( filePath )
    local iterator = {};
    iterator.lines = lines_from(filePath);
    iterator.crtLine = 0;
    iterator.read = function()
        iterator.crtLine = iterator.crtLine +1;
        return iterator.lines[ iterator.crtLine ];
    end

    return iterator;
end

function getSerializedObject( filePath )
    local lines = lines_from(filePath);
    local fullDoc = "";
    for k, v in ipairs(lines) do
        fullDoc = fullDoc .. v;
    end
    return json.decode(fullDoc);
end
