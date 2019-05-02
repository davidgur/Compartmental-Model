% measles.m
% David Gurevich
% May 2, 2019
% Last Updatedd: May 2, 2019

% Modelling the spread of measles within secondary schools


% ---------- Simulation Params ---------- %
daysToModel  = 0.1;
minPerDay    = 24 * 60;
totalMinutes = daysToModel * minPerDay;
vaccCoverage = 0.0;

infectionProbability = 0.91;

minutesExposed          = 11 * minPerDay;
minutesInfected         = 6 * minPerDay;
minutesAtSchoolInfected = 4 * minPerDay;
minutesAtHomeInfected   = minutesInfected - minutesAtSchoolInfected;

grade9Population  = 292;
grade10Population = 356;
grade11Population = 372;
grade12Population = 334;

contactMatrixAtHome  = csvread('contact_matrix.csv', 1, 1, 'B2..E5');
contactMatrixFriends = csvread('contact_matrix.csv', 7, 1, 'B8..E11');
contactMatrixClass   = csvread('contact_matrix.csv', 13, 1, 'B14..E17');

% ---------- ODE Solving ---------- %
tSpan = linspace(0, totalMinutes, totalMinutes);
y0 = gen_y0(grade9Population,  ...
            grade10Population, ...
            grade11Population, ... 
            grade12Population, ...
            vaccCoverage);
        
paramPack = [infectionProbability, ...
             minutesExposed, ...
             minutesAtSchoolInfected, ...
             minutesAtHomeInfected];
        
[t, y] = ode23(@(t, y) model(t, y, paramPack, contactMatrixFriends, contactMatrixClass), tSpan, y0);
