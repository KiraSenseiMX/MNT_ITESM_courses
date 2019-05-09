%% NEURON / PERCEPTRON
% let's implement a neuron, which does the following:
%     step 1 : sum of the weighted inputs
%         a) for every input, multiply that input by its weight
%         b) sum all the weighted inputs
%     step 2 : activation function
%         a) compute the output of the perceptron based on that sum passed
%            through an activation function
classdef perceptron
    properties

        Inputs;
        target;
        weights;
        Output;
        
    end
    methods
        
        function obj = perceptron(Inputs,target)
            % class constructor
            if(nargin > 0)
                
                obj.Inputs = Inputs;
                nInputs = size(Inputs,2);
                
                obj.target = target;
                
                % initialize the weights randomly
                for k=1:nInputs
                    obj.weights(k,1) = randi([-10 10]);
                end
                
                % make a guess
                obj.Output = obj.guess();
                
                obj.weights = obj.train(target);
            end
        end
        
        function guess = guess(obj)
            nInputs = size(obj.Inputs,2);
            sum = 0;
            for k=1:nInputs
                sum = sum + obj.Inputs(k)*obj.weights(k);
            end
%             disp(sum); % debugging purposes
            guess = activationFunct(sum);
        end
        
        function train(obj)
            nInputs = size(obj.Inputs,2);
            guess = obj.Output;
%             disp(target) % debugging purposes
%             disp(guess) % debugging purposes
            error = obj.target - guess;
            disp(error);
            learningRate = 10;
            
            % Tune all the weights
            for k=1:(nInputs-1)
                obj.weights(k,1) = ...
                    obj.weights(k,1) + error*obj.Inputs(k)*learningRate;
            end
        end
        
    end
end

%% The Activation Function
function res = activationFunct(sum)
    % implement a linear trendline to make a guess
    res = 0.0074*sum + 7.4145;
end

% classdef perceptron
%     % write a description of the class here.
%     properties
%         % define the properties of the class here, (like fields of a struct)
%         minute = 0;
%         hour;
%         day;
%         month;
%         year;
%     end
%     methods
%         % methods, including the constructor are defined in this block
%         function obj = perceptron(minute,hour,day,month,year)
%             % class constructor
%             if(nargin > 0)
%                 obj.minute = minute;
%                 obj.hour   = hour;
%                 obj.day    = day;
%                 obj.month  = month;
%                 obj.year   = year;
%             end
%         end
%         
%         function obj = rollDay(obj,numdays)
%             obj.day = obj.day + numdays;
%         end
%     end
% end