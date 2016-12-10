------------------------- main.lua -------------------------
require "output";
require "init";
--require "neuralNetwork";

function processStage()
  local roundParams = initRoundParams();

  -- Write an action using print()
  -- To debug: io.stderr:write("Debug message\n")


  -- You have to output the target position
  -- followed by the power (0 <= thrust <= 100)
  -- i.e.: "x y thrust"
  io.stderr:write("Debug message\n");
  print("8000 4500 100");
  print("8000 4500 100");
end


function main()
  --error( "This still works", "surprisingly" );
  initGlobalParams();
  while true do
    processStage();
  end
end

main();