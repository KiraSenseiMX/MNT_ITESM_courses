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
dx1 = (max(xb1) - min(xb1)) / nx1;
dy2 = (max(yb2) - min(yb2)) / ny2;
dx3 = (max(xb3) - min(xb3)) / nx3;
dy4 = (max(yb4) - min(yb4)) / ny4;

% External and internal heat transfer coefficient [W/m2-K]
ho = 10;
hi = 50;

% External and internal temperature
To = 25;
Ti = 500;

% Loop to calculate heat rate per unit length at each time
t    = zeros(m,1);
Qo   = zeros(m,1);
Qi   = zeros(m,1);
for i = 1:m
    tref(i) = i - 1;
    T = u(:, i);
    Tb1 = tri2grid(p, t, T, xb1, yb1);
    Tb2 = tri2grid(p, t, T, xb2, yb2);
    Tb3 = tri2grid(p, t, T, xb3, yb3);
    Tb4 = tri2grid(p, t, T, xb4, yb4);
    Qb1 =   ho * dx1 * (sum(Tb1 - To) ...
          - (1/2) * (Tb1(1) + Tb1(end) - 2 * To));
    Qb2 =   ho * dy2 * (sum(Tb2 - To) ...
          - (1/2) * (Tb2(1) + Tb2(end) - 2 * To));
    Qb3 = - hi * dx3 * (sum(Tb3 - Ti) ...
          - (1/2) * (Tb3(1) + Tb3(end) - 2 * Ti));
    Qb4 = - hi * dy4 * (sum(Tb4 - Ti) ...
          - (1/2) * (Tb4(1) + Tb4(end) - 2 * Ti));
    Qbo = 2 * (Qb1 + Qb2);
    Qbi = 2 * (Qb3 + Qb4);
    Qo(i) = Qbo;
    Qi(i) = Qbi;
end

plot( ...
    tref*dt/3600, (abs(Qi)), ...
    tref*dt/3600, (abs(Qo))  ...
)
set(gca, 'YScale', 'log')
legend('internal','external')
xlabel("time, (h)")
ylabel("heatRate/L [W/m]")