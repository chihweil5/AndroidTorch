require 'torchandroid'
require 'torch'
require 'nn'

torch.setdefaulttensortype('torch.FloatTensor')
model = nil;

function init(netPath)
    print('Load net from dynamic path')
    -- I don't actually have a working net to ship, so this is commented out
    -- model=torch.load(netPath,'ascii')

    print('<torch> set nb of threads to ' .. torch.getnumthreads())
    model = nn.Sequential();  -- make a multi-layer perceptron
    inputs = 2; outputs = 1; HUs = 20; -- parameters
    model:add(nn.Linear(inputs, HUs))
    model:add(nn.SoftMax())
    model:add(nn.Linear(HUs, outputs))
    print('Net loaded successfully')
end

function call(tensor)
    -- Since my net is only an empty stub I won't return the actual result but just a mock value
    -- local result = model:forward(tensor)
    print('Begin training')
    dataset={};
    function dataset:size() return 10000 end -- 100 examples
    for i=1,dataset:size() do
        local input = torch.randn(2);     -- normally distributed example in 2d
        local output = torch.Tensor(1);
        if input[1]*input[2]>0 then     -- calculate label for XOR function
            output[1] = -1;
        else
            output[1] = 1
        end
        dataset[i] = {input, output}
    end

    criterion = nn.MSECriterion()
    trainer = nn.StochasticGradient(model, criterion)
    trainer.learningRate = 0.01
    trainer:train(dataset)

    return 1
end
