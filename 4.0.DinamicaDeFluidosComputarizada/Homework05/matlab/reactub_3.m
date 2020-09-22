%% TUBULAR REACTOR adapted from (jose lopez salinas)'s solution
function yprime = reactub_3(t, y, p)
    c  = y;           % Concentration in kmol/m3 of 'A'
    D  = p(1);        % Diffusion coefficient D
    k  = p(3);        % First order kinetic coefficient
    vo = p(4);        % Velocity of fluid injection
    N  = p(5);        % Number of nodes
    m  = 1;           % Chemical decomposition kinetics is first order
    dx = 1 / (N - 1); % Step size
    
    % Initially filled with an inert solvent
    yprime    = zeros(1, N-1);
    yprime(1) = 0;
    
    % centered differences with truncation error proportional to the step
    % size to the power 2
    for i = 2 : N - 1
%                 /C        - 2 . c    + c       \
%                 | (i + 1)        (i)    (i - 1)|
%       sum = D . |------------------------------|
%                 |                2             |
%                 \              dx              /
        sum0 = D * (c(i + 1) - 2*c(i) + c(i - 1)) / (dx^2);
%                  /C        - C       \
%                  | (i + 1)    (i - 1)|
%       sum1 = v . |-------------------|
%                  \      2 . dx       /
        sum1 = vo * (c(i + 1) - c(i - 1)) / (2*dx);
%                   m
%       sum2 = k . c
%                   (i)
        sum2 = k * c(i)^m;
%       d . C                        
%            (i)                     
%       -------- = sum0 - sum1 - sum2
%         d . t 
        yprime(i) = sum0 - sum1 - sum2;
    end
    
%   d . C      C        - 4 . C        + 5 . C       
%        (N)    (N - 3)        (N - 2)        (N - 1)
%   -------- = --------------------------------------
%     d . t                       2                  
    for i = N : -1 : 3
        yprime(N) = (yprime(N - 3) - 4*yprime(N - 2) + 5*yprime(N - 1)) / 2;
    end
    yprime = yprime';
end