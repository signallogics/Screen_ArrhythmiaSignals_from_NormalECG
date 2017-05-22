classdef MultiGaussClassify
    properties
        all_class, class_prior, mean_class, cov_class;
    end
    methods
        function obj = fit( obj, X, y )
            [all_class_count, obj.all_class] = hist(y, unique(y));
            num_class = size(obj.all_class,1);
            
            % Compute number of feautures, prior
            % Also mean vector and covariance matrix
            
            num_features = size(X,2);
            obj.class_prior = all_class_count/size(X,1);
            obj.mean_class = zeros(num_class, num_features);
            obj.cov_class = zeros(num_class, num_features, num_features);
            
            for i = 1: num_class
                
                %             # Get the input samples corresponding to the class concerned
                X_class = X(obj.all_class(i) == y, :);
                %             # Get mean of the current input
                obj.mean_class(i, :) = mean(X_class);
                %             # Get covariance matrix of the current input
                % cov_class(i, :, :) = (np.matmul(np.transpose(X_class - self.mean_class[i, :]), X_class - self.mean_class[i, :]))/(self.all_class_count[i])
                temp_mean = repmat(obj.mean_class(i,:), [size(X_class, 1), 1]);
                obj.cov_class(i, :, :) = ((X_class-temp_mean)'*(X_class-temp_mean))/all_class_count(i);
                
            end
        end
        
        function save_model(obj, save_path, model_name, data_name)
            pwd_path = pwd;
            
            all_class = obj.all_class;
            class_prior = obj.class_prior;
            mean_class = obj.mean_class;
            cov_class = obj.cov_class;
            
            cd(save_path);
            save([model_name,'_',data_name], 'all_class', ...
                'class_prior', 'mean_class', 'cov_class');
            cd(pwd_path);
        end
        
        function y = predict(obj, X)
            num_class = size(obj.all_class, 1);
            num_sample = size(X,1);
            g = zeros(num_class, num_sample);
            
            %     # Compute discriminant function for each classes
            for i = 1:num_class
                
                mean_temp = obj.mean_class(i, :);
                cov_temp = squeeze(obj.cov_class(i, :, :));
                
                cov_class_det = det(cov_temp) + 1e-6;
                cov_class_inv = pinv(cov_temp);
                
                const1 = -0.5*log10(cov_class_det);
                const2 = log10(obj.class_prior(i));
                
                %         # Compute discriminant function for each samples belonging to the current class
                for j = 1:num_sample
                    
                    %             # Evaluate the discriminant value and store it
                    %self.g(i, j) = -0.5*(np.matmul((X[j, :] - mean_temp), (np.matmul(cov_class_inv, (np.transpose(X[j, :] - mean_temp))))))
                    
                    g(i, j) = -0.5*((X(j, :) - mean_temp)*(cov_class_inv * (X(j, :) - mean_temp)'));
                end
                g(i, :) = g(i, :) + const1 + const2;
            end
            %             # Get the index of the class which gives maximum value
            [~, gmax_indices] = max(g);
            y = obj.all_class(gmax_indices);
        end
    end
end