classdef IMM_simulation
    %IMM_SIMULATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        models
    end
    
    methods
        function obj = IMM_simulation(models)
            obj = obj.setModels(models);
        end
        
        function obj = setModels(obj, models)
           % sets the internal functions from model
           obj.models = models;
        end
    end
end

