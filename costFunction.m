function J = costFunction(x, y, m, b)
    J = (1/(2*length(x))) * sum((m*x + b - y).^2);
end