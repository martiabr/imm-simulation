%% Initialization

n = 5;
m = 2;

K = 1000;
T = 0.05;
t = 0:T:(K-1)*T;

q_cv = 0.001;
q_ct = [0.005; 0.01];
q_cvh = 0.5;

r = 0.6;

models = cell(3,1);
models{1} = CV(q_cv);
models{2} = CT(q_ct);
models{3} = CV(q_cvh);

PI11 = 0.992;
PI22 = 0.992;
PI33 = 0.98;

PI = [PI11,         (1 - PI22)/2,   (1 - PI33)/2; 
      (1 - PI11)/2, PI22,           (1 - PI33)/2; 
      (1 - PI11)/2, (1 - PI22)/2,   PI33];

h = @(x) x(1:2);
R = r * eye(2);
sqrtR = chol(R)';

x0 = [0 0 1 0 0]';
s0 = 1;

x = zeros(size(x0, 1), K);
z = zeros(m, K);
x(:, 1) = x0;
z(:, 1) = h(x(:,1)) + sqrtR*randn(m,1);

s = zeros(K);
s(1) = s0;


%% Simulation

for k = 2:K
    % Generate next mode:
    cum_dist = cumsum(PI(:, s(k - 1)));
    r = rand();
    s(k) = find(cum_dist > r, 1);
    
    % Simulate one step of generated mode:
    x(:, k) = models{s(k)}.f(x(:, k - 1), T) + models{s(k)}.sqrtQ(x(:, k - 1), T) * randn(n, 1);
    z(:, k) = h(x(:, k))+ sqrtR * randn(m, 1);
end

%% Plotting
colours = [[1, 0, 0]; [0, 1, 0]; [0, 0, 1]]; 

figure(2); clf; hold on; grid on;
scatter(z(1, :), z(2, :), 'MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha', 0.1,'MarkerEdgeAlpha', 0.1);

i_start = s0; 
k_start = 1; 
for k = 2:K
    i = s(k); 
    if i ~= i_start
        plot(x(1, k_start:k), x(2, k_start:k), 'r', 'LineWidth', 3, "Color", colours(i_start, :));
        k_start = k; 
        i_start = i; 
    end
end
plot(x(1, k_start:K), x(2, k_start:K), 'r', 'LineWidth', 3, "Color", colours(i_start, :));

figure(3); clf; hold on; grid on;
subplot(2, 1, 1);
plot(t, x(3, :));

subplot(2, 1, 2);
plot(t, x(4, :));

figure(4); clf; hold on; grid on;
plot(t, s);