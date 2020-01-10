%% Initialization

n = 7;
m = 2;

K = 1000;
T = 0.05;
t = 0:T:(K-1)*T;

q_cv = 0.001;
q_ct = [0.005; 0.01];
q_ca = 0.005;

r = 0.6;

models = cell(3,1);
models{1} = CV(q_cv);
models{2} = CT(q_ct);
models{3} = CA(q_ca);

h = @(x) x(1:2);
R = r * eye(2);
sqrtR = chol(R)';

x0 = [0 0 1 0 0 0 0]';

x = zeros(size(x0, 1), K);
z = zeros(m, K);
x(:, 1) = x0;
z(:, 1) = h(x(:,1)) + sqrtR*randn(m,1);

s = 3;


%% Simulation

for k = 2:K
    x(:, k) = models{s}.f(x(:, k - 1), T) + models{s}.sqrtQ(x(:, k - 1), T) * randn(n, 1);
    z(:, k) = h(x(:, k))+ sqrtR * randn(m, 1);
end

%% Plotting

figure(2); clf; hold on; grid on;
scatter(z(1, :), z(2, :), 'MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha', 0.1,'MarkerEdgeAlpha', 0.1);

plot(x(1, :), x(2, :), 'r', 'LineWidth', 3);

figure(3); clf; hold on; grid on;
subplot(2, 1, 1);
plot(t, x(3, :));

subplot(2, 1, 2);
plot(t, x(4, :));

xmin = min(x(1, :));
xmax = max(x(1, :));
ymin = min(x(2, :));
ymax = max(x(2, :));

c1 = [66, 80, 207] / 256;
c3 = [168, 56, 201] / 256;
write_gif = false;

fig = figure(4); clf;
set(gcf,'color','w');
filename = 'fip.gif';
for k = 1:K 
    plot(x(1, k), x(2, k), 'Marker', 'o', 'Color', c1, 'MarkerFaceColor', c1);

    hold on; grid on;
    
    traj_plot = plot(x(1, 1:k), x(2, 1:k), 'LineStyle', '-', 'LineWidth', 1, 'Color', c3);
    traj_plot.Color(4) = 0.75;
    
    axis([xmin, xmax, ymin, ymax]);
    drawnow
    hold off
    
    if write_gif
        % Capture the plot as an image 
        frame = getframe(fig); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 

        % Write to the GIF File 
        if k == 1 
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf, 'DelayTime', h); 
        else 
            imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime', h); 
        end
    end
end
