%%
chimneyTransientTemperature = u;
chimneyMeshEdges            = e;
chimneyMeshPoints           = p;
chimneyMeshTriangles        = t;
%chimneyMovie                = M;

% whos
%
% % Temperature of all points at the initial time
% chimneyTransientTemperature(:, 1)
%
% % Temperature of all points at the final time
% chimneyTransientTemperature(:, end)
%
% % Location of the Temperatures
% x = chimneyMeshPoints(1, :);
% y = chimneyMeshPoints(2, :);
% % First point/coordinate
% [x(1), y(1)]
%
% % Temperature of the 1st coordinate at the final time
% chimneyTransientTemperature(1, end)

%%
[n, m] = size(u);

% Time increment specified in the solver
dt = 500;

% Number of points to estimate temperature at the boundary
% nx1 = number of increments in the x-axis, boundary 1 (external points)
% ny2 = number of increments in the y-axis, boundary 2 (external points)
% nx3 = number of increments in the x-axis, boundary 3 (internal points)
% ny4 = number of increments in the y-axis, boundary 4 (internal points)
nx1 = 100;
ny2 = 100;
nx3 = 100;
ny4 = 100;

% Specifying the coordinates of the points at boundary 1
xb1 = linspace(0.00, 4.00, nx1 + 1);
yb1 = 0.00;

% Specifying the coordinates of the points at boundary 2
xb2 = 0.00;
yb2 = linspace(0.00, 1.00, ny2 + 1);

% Specifying the coordinates of the points at boundary 3
xb3 = linspace(0.20, 3.80, nx3 + 1);
yb3 = 0.20;

% Specifying the coordinates of the points at boundary 4
xb4 = 0.20;
yb4 = linspace(0.20, 0.80, ny4 + 1);

% Increment of distance between points at each boundary
dx1 = distanceIncrement(xb1, nx1);
dy2 = distanceIncrement(yb2, ny2);
dx3 = distanceIncrement(xb3, nx3);
dy4 = distanceIncrement(yb4, ny4);

% External and internal heat transfer coefficient [W/m2-K]
ho = 10;
hi = 50;

% External and internal temperature
To = 25;
Ti = 500;

% Loop to calculate heat rate per unit length at each time
time = linspace(0, m, m);
Qo   = zeros(m,1);
Qi   = zeros(m,1);
for i = 1:m
    T = u(:, i);
    Qb1 = Q_boundery(p, t, T, xb1, yb1,  ho, dx1, To);
    Qb2 = Q_boundery(p, t, T, xb2, yb2,  ho, dy2, To);
    Qb3 = Q_boundery(p, t, T, xb3, yb3, -hi, dx3, Ti);
    Qb4 = Q_boundery(p, t, T, xb4, yb4, -hi, dy4, Ti);
    Qo(i) = 2 * (Qb1 + Qb2);
    Qi(i) = 2 * (Qb3 + Qb4);
end

plot( ...
    time*dt/3600, (abs(Qi)), ...
    time*dt/3600, (abs(Qo))  ...
)
set(gca, 'YScale', 'log')
legend('internal','external')
xlabel("time [h]")
ylabel("heatRate/L [W/m]")

%%
function dxy = distanceIncrement(xyb, nxy)
    dxy = (max(xyb) - min(xyb)) / nxy;
end

function Qb = Q_boundery(p, t, T, xb, yb, h, dxy, Tref)
    Tb = tri2grid(p, t, T, xb, yb);
    Qb = h * dxy * (sum(Tb - Tref) - (1/2) * (Tb(1) + Tb(end) - 2 * Tref));
end

% function ave = average(x)
%     ave = sum(x(:))/numel(x); 
% end
