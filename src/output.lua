------------------------- output.lua -------------------------

function error(...)
  local messages = table.pack(...);
  for k, v in ipairs(messages) do
    io.stderr:write("[" .. k .. "] " .. v .. "\n");
  end
end