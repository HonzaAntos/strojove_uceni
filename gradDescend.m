function [m, b, J_vals,m_i,b_i] = gradDescend(x, y, alpha, num_iters)
    m = rand;
    b = rand;
    J_vals = zeros(num_iters, 1);

    % Gradient descent algorithm
    for i = 1:num_iters
        % Predicted values for the current parameters
        y_pred = m * x + b;

        % Errors between the predicted values and the true values
        errors = y_pred - y;

        % Update the parameters using the gradient of the cost function
        delta_m = (1 / length(x)) * sum(errors .* x);
        delta_b = (1 / length(x)) * sum(errors);
        m = m - alpha * delta_m;
        b = b - alpha * delta_b;

        % Store parameters of each iteration
        m_i(i)=m;
        b_i(i)=b;

        % Compute the cost function for iteration
        [J] = costFunction(x, y,m,b);
        J_vals(i) = J;%(1/(2*length(x))) * sum((m*x + b - y).^2);
    end
end