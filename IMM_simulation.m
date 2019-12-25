classdef IMM_simulation
    %IMM_SIMULATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        model
        
        f
        Q
        
        h
        R
    end
    
    methods
        function obj = IMM_simulation(inputArg1,inputArg2)
            %IMM_SIMULATION Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

