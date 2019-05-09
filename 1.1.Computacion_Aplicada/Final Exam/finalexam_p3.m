%% ************************************************************************
% * AUTHOR(S) :
% *     Bruno González Soria          (A01169284)
% *     Antonio Osamu Katagiri Tanaka (A01212611)
% *
% * FILENAME :
% *     HW03.m
% *
% * DESCRIPTION :
% *     Computación Aplicada (Ene 19 Gpo 1)
% *     Final Exam
% *
% * NOTES :
% *     In submitting the solution to this final exam, I (we) your name(s)
% *     affirm my (our) awareness of the standards of the Tecnológico de
% *     Monterrey Ethics Code.
% *
% * START DATE :
% *     02 May 2019
% ************************************************************************

close all, clear all, clc, format compact

%% ************************************************************************
% Problem 3: LEARNING
% The age of a specific species of shellfish is related to several physical
% characteristics. The sheet data of the Excel file shellfish.xlsx contains
% data of 4077 individuals, and their ages

% shellfish.xlsx data description:
% ---------------+------------+-------+----------------------------
% Name           | Data Type  | Meas. | Description
% ---------------+------------+-------+----------------------------
% Sex            | nominal    |       | M, F, and I (infant)
% Length         | continuous | mm    | Longest shell measurement
% Diameter       | continuous | mm    | perpendicular to length
% Height         | continuous | mm    | with meat in shell
% Whole weight   | continuous | grams | whole shellfish
% Shucked weight | continuous | grams | weight of meat
% Viscera weight | continuous | grams | gut weight (after bleeding)
% Shell weight   | continuous | grams | after being dried
% Age            | integer    |       | years
% ---------------+------------+-------+----------------------------

% load shellfish data
ssds = spreadsheetDatastore('./shellfish.xlsx');

% store the 1st sheet - DATA **********************************************
ssds.Sheets = 1;
data = read(ssds);
data_arr = zeros(height(data),width(data));

% convert cell matrix to ordinary matrix
for k=1:width(data)
    data_varNames = data.Properties.VariableNames(k);
    data_varNames = cell2mat(data_varNames);
    %data_varNames % debugging purposes
    
    table_col = table2array(data(1:height(data),k));
    %class(table_col) % debugging purposes
    
    %try % debugging purposes
    if isa(table_col,'cell')
        % convert data.Sex values to integers:
        % F = 70, M = 77, I = 73
        data_arr(1:height(data),k) = cell2mat(table_col);
    else
        data_arr(1:height(data),k) = table_col;
    end
    %catch % debugging purposes
    %    warning(varName); % debugging purposes
    %end % debugging purposes

    %class(data_arr) % debugging purposes
end

% data_arr shall be used for the neural training

%% ************************************************************************
% a) Train a neural network using the information of these 4077.
%     1) This data must be divided into training, testing, and possibly
%        validation examples. Explain your decision when choosing these
%        data sets.
%     2) Explain any pre-processing done to the data.

% let's train the neuron/perceptron with the known training data in
% data_arr - Through a SUPERVISED LEARNING ALGORITHM
%    1) Provide the perceptron with inputs for which there is a known
%       answer
%    2) Ask the perceptron to guess an answer
%    3) Compute the error (Did it get the answer right or wrong?)
%    4) Adjust all the weights according to the error
%    5) Return to step 1) and repeat!


% let's feed our neuron/perceptron some intputs to get a guess.
inputs = data_arr(1,1:width(data)-1);
% initialize the weights randomly
nInputs = size(inputs,2);
weights = zeros(1,nInputs);
for k=1:nInputs
    weights(1,k) = randi([-10 10]);
end
% set the known target to compute the error
target = data_arr(1,width(data));
% let's create a neuron
neuron = perceptron(inputs,weights,target);
%neuron.train;
% disp(neuron); % debugging purposes

%% ************************************************************************
% b) Using your trained neural network, determine the age of the 100
%    individuals in sheet predict. Write the results to as a column of an
%    Excel worksheet.

% store the 2nd sheet - PREDICT *******************************************
ssds.Sheets = 2;
predict = read(ssds);
predict_arr = zeros(height(predict),width(predict));

% convert cell matrix to ordinary matrix
for k=1:width(predict)
    predict_varNames = predict.Properties.VariableNames(k);
    predict_varNames = cell2mat(predict_varNames);
    %predict_varNames % debugging purposes
    
    table_col = table2array(predict(1:height(predict),k));
    %class(table_col) % debugging purposes
    
    %try % debugging purposes
    if isa(table_col,'cell')
        % convert data.Sex values to integers:
        % F = 70, M = 77, I = 73
        predict_arr(1:height(predict),k) = cell2mat(table_col);
    else
        predict_arr(1:height(predict),k) = table_col;
    end
    %catch % debugging purposes
    %    warning(varName); % debugging purposes
    %end % debugging purposes

    %class(data_arr) % debugging purposes
end

% data from predict_arr shall be used to predict the Age

%% ************************************************************************
% c) Give an estimate of the expected error of your neural network on new
%    data. Explain your answer.



