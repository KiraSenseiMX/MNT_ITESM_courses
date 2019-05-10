%% ************************************************************************
% * AUTHOR(S) :
% *     Bruno González Soria          (A01169284)
% *     Antonio Osamu Katagiri Tanaka (A01212611)
% *
% * FILENAME :
% *     finalexam.m
% *
% * DESCRIPTION :
% *     Computación Aplicada (Ene 19 Gpo 1)
% *     Final Exam
% *
% * NOTES :
% *     In submitting the solution to this final exam, I (we) ?your name(s)?
% *     affirm my (our) awareness of the standards of the Tecnológico de
% *     Monterrey Ethics Code.
% *
% * START DATE :
% *     02 May 2019
%% ************************************************************************
% This script should start with the command rng(31416), and should not
% contain any other call that initializes the state of the random number
% generator. 
clc, clear
rng(31416)

%% ************************************************************************
% Problem 1: OPTIMIZATION
% Consider the following function:
% 
%                  ____6___                     2
%                  \      /             18  / ixi \
%         f(X) =    \        sin(xi) sin   | ----- |
%                   /                       \  Pi /
%                  /_______\
%                     i=1
% 
% where 0 < xi < 5.
% 
% Maximize function f (X) using the Nelder-Mead algorithm (fminsearch) and
% simulated annealing (simulannealbnd). Modify whatever parameters you deem
% necessary to produce a good performance of these algorithms, regardless
% of the state of the random number generator. Use randomly generated
% initial point in the valid range of x.
%
%% ************************************************************************
%   a) Implement f (x) as a MATLAB function.
i = 1:6;
f = @(x) -fx(x);

%% ************************************************************************
%   b) Give your best solution found (optimal x and evaluation of x) for
%   each algorithm.

% NelderMeade
x0 = rand([1 6])*5;
options = optimset('Display', 'off', 'MaxFunEvals', 10000);
disp("The optimal value of x usning NelderMeade (fminsearch) method is:")
[x,fval,exitflag,output] = fminsearch(f,x0,options)

% Simulated Annealing
disp("The optimal value of x usning Simulated Annealing (simulannealbnd) method is:")
lb = zeros([1 6]);
ub = ones([1 6])*5;
[x,fval,exitflag,output] = simulannealbnd(f,x0,lb,ub,options)

%% ************************************************************************
%   c) Which of these two algorithms has a better expected performance on
%   this problem when varying the initial point(s)? Justify your answer.

% From this two algorithms, fminsearch has a better expected performance on
% this problem. The reason is that the fval (objective function value at
% the solution) obtained is larger than the one obtained in simulannealbnd,
% thus closer to a maximum in the function. Additionally, unlike other
% solvers, fminsearch stops when it satisfies both TolFun and TolX.


%% ************************************************************************
% Problem 2: INTEGER PROGRAMMING
% An airline company is considering the purchase of new long-, medium-, and
% short-range jet passenger airplanes. The purchase price is $33.5M for
% each long-range plane, $25M for each medium-range plane, and $17.5M for
% each short-range plane. The board of directors has authorized a maximum
% of $750M for these purchases. Regardless of which planes are purchased,
% air travel of all distances is expected to be sufficiently large enough
% so that these planes would be utilized at essentially maximum capacity.
% It is estimated that the net annual profit (after subtracting capital
% recovery costs) would be $2.1M per long-range plane, $1.5M per
% medium-range plane, and $1.15M per short-range plane. Enough trained
% pilots are available to the company to crew 30 new airplanes. If only
% short-range planes were purchased, facilities would be able to handle 40
% new planes. However, each medium-plane is equivalent to 1 1/3
% short-range planes, and each long-range plane is equivalent to 1 2/3
% short-range planes in terms of their use of maintenance facilities. Using
% the preceding data, management wishes to know how many planes of each
% type should be purchased to maximize profit.
%
%% ************************************************************************
% a) Formulate the problem as an integer programming problem.
% We wish to obtain the maximum profit from the investment in a mximum of
% 30 new planes.
% Limits to be considered:
%   Budget: 750M
%   Pilots (max new planes): 30
%   Facilities:
%       Max short-range planes: 40
%       Max medium-range planes: 30
%       Max long-range planes: 24
% a = Number of long-range planes
% b = Number of medium-range planes
% c = Number of short-range planes
% You cannot buy or use half or 2/3 of a plane, only integer planes.
% Investment:
% 33.5*a + 25*b + 17.5*c <= 750
% Total Airplanes:
% a + b + c <= 30
% Handling Limitations:
% 5/3*a + 4/3*b + c) <= 40 -> as Integegers:
% Profit maximization:
% f = 2.1*a + 1.5*b + 1.15*c;


%% ************************************************************************
% b) Use intlinprog to find the solution (number of planes of each type and
% maximum profit).
% prob = optimproblem ('ObjectiveSense','maximize');
%  = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub,x0,options);


%% ************************************************************************
% Problem 3: LEARNING
% The age of a specific species of shellfish is related to several physical
% characteristics. The sheet data of the Excel file shellfish.xlsx contains
% data of 4077 individuals, and their ages.
% 
%% ************************************************************************
% a) Train a neural network using the information of these 4077.
%   1) This data must be divided into training, testing, and possibly
%   validation examples. Explain your decision when choosing these data
%   sets.
%   2) Explain any pre-processing done to the data.



%% ************************************************************************
% b) Using your trained neural network, determine the age of the 100
% individuals in sheet predict. Write the results to as a column of an
% Excel worksheet.



%% ************************************************************************
% c) Give an estimate of the expected error of your neural network on new
% data. Explain your answer.


%% ************************************************************************
%   DEFINED FUNCTIONS:
%   Problem 1 a)
function fcn = fx (x)
suma=0;
    for i = 1:6
        newterm = sin(x(i))*sin((i*x(i))^2/pi)^18;
        suma = suma + newterm;
    end
    fcn = suma;
end


%   Problem 1 b)
