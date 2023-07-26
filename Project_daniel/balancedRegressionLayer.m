classdef balancedRegressionLayer < nnet.layer.RegressionLayer
    % Example custom regression layer with mean-absolute-error loss.
    
    methods
        function layer = balancedRegressionLayer(name)
            % layer = maeRegressionLayer(name) creates a
            % mean-absolute-error regression layer and specifies the layer
            % name.
			
            % Set layer name.
            layer.Name = name;

            % Set layer description.
            layer.Description = 'Mean absolute error balanced batches';
        end
        
        function loss = forwardLoss(layer, Y, T)
            % loss = forwardLoss(layer, Y, T) returns the MAE loss between
            % the predictions Y and the training targets T.
            T = squeeze(T);
            Y = squeeze(Y);
            Y = equalizeDataSet(Y,floor(T),'max',1);
            T = equalizeDataSet(T,floor(T),'max',1);
            % Calculate MAE.
            R = size(Y,1);
            meanAbsoluteError = sum(abs(Y-T))/R;
            
            % Take mean over mini-batch.
            loss = meanAbsoluteError;
        end
    end
end

