local e = 2.71828;

local neuron = {};
neuron.inputs = {};
neuron.active = false;
neuron.threshold = 0;

neuron.activationFunction = function(value)
    return 1 / (1 + e ^ (-1 * value));
end

return neuron;