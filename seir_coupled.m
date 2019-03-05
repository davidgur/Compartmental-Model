% seir_coupled.m
% David Gurevich
% February 25, 2019
% Last Updated: February 26, 2019

% Implementation of the SEIR model,
% with mutliple beta values

daysToModel  = 31;
minPerDay    = (24 * 60);
totalMinutes = daysToModel * minPerDay;

g = (1 / 8) / minPerDay;
s = (1 / 4) / minPerDay;
b = (0.88)  / minPerDay;

%        S1 S2 S3 S4 E1 E2 E3 E4     I1 I2 I3 I4 R1 R2 R3 R4
y0 = [0.999, 1, 1, 1, 0, 0, 0, 0, 0.001, 0, 0, 0, 0, 0, 0, 0];

bMatHall    = csvread('beta_vals.csv', 1, 1, 'B2..E5');
bMatClass   = csvread('beta_vals.csv', 7, 1, 'B8..E11');
bMatHome    = csvread('beta_vals.csv', 13, 1, 'B14..E17');

disp("----- R0 Table - bMatHall -----");
r_nought(bMatHall, b, g);
disp("----- R0 Table - bMatClass -----");
r_nought(bMatClass, b, g);
disp("----- R0 Table - bMatHome -----");
r_nought(bMatHome, b, g);

% ----- TIME TABLE -----
% 1]  0:00 - 8:35   --> Home  (0 515)
% 2]  8:35 - 8:40   --> Hall
% 3]  8:40 - 10:00  --> Class
% 4]  10:00 - 10:05 --> Hall
% 5]  10:05 - 11:20 --> Class
% 6]  11:20 - 11:25 --> Hall
% 7]  11:25 - 12:40 --> Class
% 8]  12:40 - 12:45 --> Hall
% 9]  12:45 - 14:00 --> Class
% 10] 14:00 - 14:05 --> Hall
% 11] 14:05 - 15:20 --> Class
% 12] 15:20 - 15:25 --> Hall
% 13] 15:25 - 24:00 --> Home   (0 515)
%-----------------------
% Class: [1 75]
% Hall:  [1 5]
% ----------------------

yTotal = [];
tID    = [];

for n = 1:daysToModel
    for i = 1:13
        if (i > 1 || n > 1)
            for m = 1:16
               y0(m) = yTotal(end, m);
            end
        else
            y0 = [0.999, 1, 1, 1, ...   % S
                      0, 0, 0, 0, ...   % E
                  0.001, 0, 0, 0, ...   % I
                      0, 0, 0, 0];       % R
        end
        
        if i == 1 || i == 13     % Home
            tSpan  = linspace(1, 515, 515);
            
            [t, y] = ode45(@(t, y) model(t, y, bMatHome, g, s, b), tSpan, y0);
            yTotal = [yTotal; y];
            tID    = [tID; ones(size(t, 1), 1)];
            
        elseif mod(i, 2) == 0   % Hall
            tSpan  = linspace(1, 5, 5);
            
            [t, y] = ode45(@(t, y) model(t, y, bMatHall, g, s, b), tSpan, y0);
            yTotal = [yTotal; y];
            tID    = [tID; 2.* ones(size(t, 1), 1)];
        elseif mod(i, 2) ~= 0  % Class
            tSpan  = linspace(1, 75, 75);
            
            [t, y] = ode45(@(t, y) model(t, y, bMatClass, g, s, b), tSpan, y0);
            yTotal = [yTotal; y];
            tID    = [tID; 3.* ones(size(t, 1), 1)];
        end
    end
end

tTotal = linspace(0, daysToModel, size(yTotal, 1));

% ----- PLOTTING -----
subplot(3, 2, 1)
Gr9 = [yTotal(:, 1), yTotal(:, 5), yTotal(:, 9), yTotal(:, 13)];
h = plot(tTotal, Gr9, 'LineWidth', 2);
axis([0 daysToModel -0.1 1.2])
legend(h, 'Susceptible', 'Exposed', 'Infected', 'Recovered');
title('Grade 9');
xlabel 'Time (days)';
ylabel '% of Population';

subplot(3, 2, 2)
Gr10 = [yTotal(:, 2), yTotal(:, 6), yTotal(:, 10), yTotal(:, 14)];
h = plot(tTotal, Gr10, 'LineWidth', 2);
axis([0 daysToModel -0.1 1.2])
legend(h, 'Susceptible', 'Exposed', 'Infected', 'Recovered');
title('Grade 10');
xlabel 'Time (days)';
ylabel '% of Population';

subplot(3, 2, 3)
Gr11 = [yTotal(:, 3), yTotal(:, 7), yTotal(:, 11), yTotal(:, 15)];
h = plot(tTotal, Gr11, 'LineWidth', 2);
axis([0 daysToModel -0.1 1.2])
legend(h, 'Susceptible', 'Exposed', 'Infected', 'Recovered');
title('Grade 11');
xlabel 'Time (days)';
ylabel '% of Population';

subplot(3, 2, 4)
Gr12 = [yTotal(:, 4), yTotal(:, 8), yTotal(:, 12), yTotal(:, 16)];
h = plot(tTotal, Gr12, 'LineWidth', 2);
axis([0 daysToModel -0.1 1.2])
legend(h, 'Susceptible', 'Exposed', 'Infected', 'Recovered');
title('Grade 12');
xlabel 'Time (days)';
ylabel '% of Population';

% Time Plot
% Times:
%   1: Home
%   2: Hall
%   3: Class
subplot(3, 2, 5)
h = plot(tTotal, tID, 'LineWidth', 2);
axis([0 daysToModel 0.8 3.2])
title('tSpan');

subplot(3, 2, 6)
h = plot(tTotal, tID, 'LineWidth', 2);
axis([0 daysToModel 0.8 3.2])
title('tSpan');

suptitle('Spread of measles within a secondary school');