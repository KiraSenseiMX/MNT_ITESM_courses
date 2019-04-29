% ************************************************************************
% * AUTHOR(S) :
% *     Bruno Gonz�lez Soria          (A01169284)
% *     Antonio Osamu Katagiri Tanaka (A01212611)
% *
% * FILENAME :
% *     HW03.m
% *
% * DESCRIPTION :
% *     Computaci�n Aplicada (Ene 19 Gpo 1)
% *     Homework on Simulated Annealing
% *
% * NOTES :
% *
% *
% * START DATE :
% *     25 Apr 2019
% ************************************************************************

warning('off')
clc;
clear all;
close all;

%% ************************************************************************
% Problem 1:
% Using simulated annealing in the global optimization toolbox, solve the
% traveling salesman problem for 70 cities with coordinates generated in the
% following way:
N = 70;
rng(123);
coordinates = rand(N,2);
% Upload to Blackboard a pdf file that contains the folowing:
%   A script of your solution
%   A plot of the best route found

distances = TSPtable(coordinates);
objFcnTSP(distances);
route0 = randperm(N)';
TSPplot(route0,coordinates,'b',2)
xlabel('x')
ylabel('y')
title(sprintf('TSP?with?%d?cities',N))
options = optimoptions(@simulannealbnd,'DataType','custom',...
    'AnnealingFcn',@TSPinversion);
r0 = randperm(N);
TSPplot(r0,coordinates,'-')
title(sprintf('initial?random?route,?cost=%f',objFcnTSP(r0)))
r = simulannealbnd(@objFcnTSP,r0,[],[],options);
TSPplot(r,coordinates,'-')
title(sprintf('cost=%f',objFcnTSP(r)))


function distances = TSPtable(coordinates)
    [nCities,nx] = size(coordinates);
    
    if nx ~= 2
        error('coordinates?should?be?an?(nCities)?x?2?matrix')
    end
    
    distances = zeros(nCities);
    
    for i=1:nCities
        for j=i: nCities
            distances(i,j) = ...
                sqrt( (coordinates(i,1)-coordinates(j,1))^2 + ...
                (coordinates(i,2)-coordinates(j,2))^2);
            
            distances(j,i) = distances(i,j);
        end
    end
end

function f = objFcnTSP(varargin)
% f = objFcnTSP(distances)
% Loads distance matrix.
% f = objFcnTSP(route)
% Evaluates a route given a distances matrix.
    persistent distances
    
    if isempty(varargin)
        clear distances
    else
        [n,m] = size(varargin{1});
        
        if n==m
            distances = varargin{1};
        else
            route = varargin{1};
            n = length(route);
            % Initialize with distance between last a first city
            f = distances(route(n), route(1));
            
            for i=2:n
                % Add distance from city i to city i-1
                f = f + distances(route(i-1), route(i));
            end
        end
    end
end

function neighbor = TSPinversion(optimValues,varargin)
    route = optimValues.x;
    n = length(route);
    m1 = floor(rand*n)+1;
    m2 = mod(floor(rand*(n-1))+m1, n)+1;
    n1 = min([m1 m2]);
    n2 = max([m1 m2]);
    neighbor = route;
    neighbor(n1:n2) = route(n2:-1:n1);
end

function TSPplot(route, coordenates, s, varargin)
% plotTSP(route, coordenates, s, flag=0)
%
% Plots a TSP route given their coordinates. flag specifies how
% the cities are enumerated:
%    0: no numbers
%    1: order in which they are visited
%    2: original numbers

    if length(varargin)>=1
       flag = varargin{1};
    else
       flag = 1;
    end

    n = length(route);
    xy = [];
    for i=1:n
       xy = [xy;coordenates(route(i),:)];
    end
    xy = [xy; xy(1,:)];
    axis([0 1 0 1])
    if flag==0
       plot(xy(:,1),xy(:,2),s)
       axis([0 1 0 1])
    end
    if flag==1
       % Order in which they are visited
       plot(xy(:,1),xy(:,2),s,...
          xy(:,1),xy(:,2),'.r',...
          xy(1,1),xy(1,2),'ok',...
          xy(2,1),xy(2,2),'sb')
       axis([0 1 0 1])
       for i=1:n
          text(coordenates(route(i),1)+0.01,coordenates(route(i),2),...
             sprintf('%d',i), 'FontSize', 8)
       end
    end
    if flag==2
       % Original numbers
       plot(xy(:,1),xy(:,2),s,...
          xy(:,1),xy(:,2),'.r',...
          xy(1,1),xy(1,2),'ok',...
          xy(2,1),xy(2,2),'sb')
       axis([0 1 0 1])
       for i=1:n
          text(coordenates(route(i),1)+0.01,coordenates(route(i),2),...
             sprintf('%d',route(i)), 'FontSize', 8)
       end
    end
end

%% ************************************************************************
% Problem 2:
% Using function Tiiago, download the adjusted closing prices for the following DJI stocks from
% January 1, 2018 through January 1, 2019.

% KO Coca-Cola                     DIS Disney
% PG Procter & Gamble              MCD McDonald�s
% PFE Pfizer                       WMT WalMart
% MRK Merck                        V Visa
% VZ Verizon

% Weights must be in the range [0:1; 0:5].
% There must be at least 3 and no more than 5 securities in the portfolio.
% Obtain the daily returns for these securities. Plot their expected return versus variance.
% Using command simulated annealing, obtain the optimal portfolios for
% k = 1; 2; 2:5; 4; 7; 9; 11; 20; 50; 1000
% For each value of k, report optimal weights, expected return and variance.
% Plot this data on the previous graph.
% Upload to Blackboard a pdf file that contains a MATLAB script, any MATLAB functions that you
% implemented, and the required plots and results.

% load('Tiingo_data.mat')
% % Let's convert the closing prices into returns
%
% % CLOSING PRICES
% CP_KO  = res.KO;
% CP_PG  = res.PG;
% CP_PFE = res.PFE;
% CP_MRK = res.MRK;
% CP_VZ  = res.VZ;
% CP_DIS = res.DIS;
% CP_MCD = res.MCD;
% CP_WMT = res.WMT;
% CP_V   = res.V;
%
% % RETURNS
% R_KO  = (CP_KO(2:end)-CP_KO(1:end-1))./CP_KO(1:end-1);
% R_PG  = (CP_PG(2:end)-CP_PG(1:end-1))./CP_PG(1:end-1);
% R_PFE = (CP_PFE(2:end)-CP_PFE(1:end-1))./CP_PFE(1:end-1);
% R_MRK = (CP_MRK(2:end)-CP_MRK(1:end-1))./CP_MRK(1:end-1);
% R_VZ  = (CP_VZ(2:end)-CP_VZ(1:end-1))./CP_VZ(1:end-1);
% R_DIS = (CP_DIS(2:end)-CP_DIS(1:end-1))./CP_DIS(1:end-1);
% R_MCD = (CP_MCD(2:end)-CP_MCD(1:end-1))./CP_MCD(1:end-1);
% R_WMT = (CP_WMT(2:end)-CP_WMT(1:end-1))./CP_WMT(1:end-1);
% R_V   = (CP_V(2:end)-CP_V(1:end-1))./CP_V(1:end-1);
%
% Returns = [R_KO R_PG R_PFE R_MRK R_VZ R_DIS R_MCD R_WMT R_V];