clc 
clear

% Open the file
fileID = fopen('DataEX08.txt','r');

% Read the data
data = fscanf(fileID,'%f,%f',[2, Inf]);

% Close the file
fclose(fileID);

% Plot the dataset
subplot(2,3,1)
scatter(data(1,:),data(2,:),'x','r'); 
grid on
xlabel('X - Population in thousands');
ylabel('Y - Profit');
title('Learning Dataset');

% Separate the input and output variables
x_t = data(1,:);
y_t = data(2,:);
x=x_t.';
y=y_t.';

% Just for 3D scatter
z_t=1:97;
z=z_t.';

alpha = 0.01; % learning rate
num_iters = 1000; % number of iterations

% Gradient descent algorithm
[m, b, J_vals,m_i,b_i] = gradDescend(x, y, alpha, num_iters);

% Plot the current regression line
subplot(2,3,2)
scatter(data(1,:),data(2,:),'x','r'); 
xlabel('X - Population in thousands');
ylabel('Y - Profit');
grid on
hold on

% Show how its learning
for i = 1:num_iters
   plot(x, m_i(i) * x + b_i(i), 'color', [1-i/num_iters, 0, i/num_iters]);
   xlim([5 25])
   ylim([-5 25])
   grid on
   title(sprintf('Actual=%.f Linear Regression',i));
   %pause(0.1);
end

% Plot the cost function vs. iteration
subplot(2,3,3)
grid on
plot(1:num_iters, J_vals);
grid on
xlabel('Iteration');
ylabel('Cost');
title('Cost Function vs. Iteration');

% subplot(2,3,6)
% x_range = linspace(min(x), max(x), 100);
% y_range = m * x_range + b;
% plot(x_range, y_range, 'b'); 
% grid on
% xlim([5 25])
% ylim([-5 25])
% title('Different method of showing linear regression');

subplot(2,3,4:6)
grid on
scatter(data(1,:),data(2,:),'x','r'); 
grid on
xlabel('X - Population in thousands');
ylabel('Y - Profit');
title('Result of Linear Regression');
hold on 
plot(x, m_i(i) * x + b_i(i), 'color', [1-i/num_iters, 0, i/num_iters]);
grid on
% Plot the cost function vs. iteration
figure;
plot(1:length(J_vals), J_vals);
xlabel('Iteration');
ylabel('Cost');
title('Cost Function vs. Iteration');

% % Plot the data and the regression plane
% figure;
% scatter3(x, y, z);
% hold on;
% 
% % Define the range of x and y values
% x_range = linspace(min(x), max(x), 100);
% y_range = linspace(min(y), max(y), 100);
% 
% % Create a grid of x and y values
% [X, Y] = meshgrid(x_range, y_range);
% 
% % Compute the predicted z values for the x-y grid using the learned m and b values
% Z = m * X + b * Y;
% 
% % Plot the regression plane
% surf(X, Y, Z);
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% title('Linear Regression by Gradient Descent');
% 
% %jaky je rpzdil mezi klasifikacnim a regresnim vystupem?
% %foto 28.03. 08:20
