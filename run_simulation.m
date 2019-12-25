%% Initialization

n = 5;
m = 2;

K = 1000;
T = 0.01;
t = 0:T:(K-1)*T;

q_cv = 0.1;
q_ct = [0.1; 0.0001];

r = 0.1;

models = cell(2,1);
models{1} = CV(q_cv);
models{2} = CT(q_ct);

h = @(x) x(1:2);
R = r * eye(2);
sqrtR = chol(R)';

x0 = [0 0 1 0 0]';

x = zeros(size(x0, 1), K);
z = zeros(m, K);
x(:, 1) = x0;
z(:, 1) = h(x(:,1)) + sqrtR*randn(m,1);

s = 2;


%% Simulation

figure(1); clf; hold on; grid on;

for k = 2:K
    x(:,k) = models{s}.f(x(:, k - 1), T) + models{s}.sqrtQ(x(:, k - 1), T) * randn(n, 1);
    z(:, k) = h(x(:, k))+ sqrtR * randn(m, 1);
    
    %scatter(z(1, k), z(2, k));
    %plot(x(1, k), x(2, k), 'r');
    %drawnow;
    %pause(0.01);
end

figure(2); clf; hold on; grid on;
scatter(z(1, :), z(2, :), 'MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha', 0.1,'MarkerEdgeAlpha', 0.1);
plot(x(1, :), x(2,:), 'r', 'LineWidth', 3);

figure(3); clf; hold on; grid on;
subplot(2, 1, 1);
plot(t, x(3, :));

subplot(2, 1, 2);
plot(t, x(4, :));