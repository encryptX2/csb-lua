------------------------- output.lua -------------------------

function error(...)
  local messages = table.pack(...);
  for k, v in ipairs(messages) do
    io.stderr:write("> " .. v .. "\n");
  end
end