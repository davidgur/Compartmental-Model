% measles.m
% David Gurevich
% May 2, 2019
% Last Updated: May 6, 2019

% Modelling the spread of measles within secondary schools


% ---------- Simulation Params ---------- %
daysToModel  = 90;
minPerDay    = 24 * 60;
totalMinutes = daysToModel * minPerDay;
vaccCoverage = 0.9;

infectionProbability = 0.91;

minutesExposed          = 11 * minPerDay;
minutesInfected         = 6 * minPerDay;
minutesAtSchoolInfected = 4 * minPerDay;
minutesAtHomeInfected   = 2 * minPerDay;

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
             1 / minutesExposed, ...
             1 / minutesAtSchoolInfected, ...
             1 / minutesAtHomeInfected, ...
             grade9Population, ...
             grade10Population, ...
             grade11Population, ...
             grade12Population];
        
[t, y] = ode45(@(t, y) model(t, y, paramPack, contactMatrixFriends, contactMatrixClass), tSpan, y0);

% ---------- Plotting ---------- %
tPlotting = linspace(0, daysToModel, totalMinutes);

figure('DefaultAxesFontSize',20)

subplot(2, 2, 1)
Gr9 = round([y(:, 1), y(:, 5), y(:, 9), y(:, 13) + y(:, 17), y(:, 21)]);
h = plot(tPlotting, Gr9, 'LineWidth', 2);
legend(h, 'Susceptible', 'Vaccinated', 'Exposed', 'Infected', 'Recovered');
title('Grade 9');
xlabel 'Time (days)';
ylabel '# of people';

subplot(2, 2, 2)
Gr10 = round([y(:, 2), y(:, 6), y(:, 10), y(:, 14) + y(:, 18), y(:, 22)]);
h = plot(tPlotting, Gr10, 'LineWidth', 2);
legend(h, 'Susceptible', 'Vaccinated', 'Exposed', 'Infected', 'Recovered');
title('Grade 10');
xlabel 'Time (days)';
ylabel '# of people';

subplot(2, 2, 3)
Gr11 = round([y(:, 3), y(:, 7), y(:, 11), y(:, 15) + y(:, 19), y(:, 23)]);
h = plot(tPlotting, Gr11, 'LineWidth', 2);

legend(h, 'Susceptible', 'Vaccinated', 'Exposed', 'Infected', 'Recovered');
title('Grade 11');
xlabel 'Time (days)';
ylabel '# of people';

subplot(2, 2, 4)
Gr12 = round([y(:, 4), y(:, 8), y(:, 12), y(:, 16) + y(:, 20), y(:, 24)]);
h = plot(tPlotting, Gr12, 'LineWidth', 2);
legend(h, 'Susceptible', 'Vaccinated', 'Exposed', 'Infected', 'Recovered');
title('Grade 12');
xlabel('Time (days)');
ylabel('# of people');

%suptitle({['Compartmentalization of student population over the course of a measles outbreak'], ['50% Vaccination Coverage']});