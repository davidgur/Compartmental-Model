function y0 = gen_y0(grade9Population,grade10Population, grade11Population, grade12Population, vaccCoverage)
%y0 = gen_y0(grade9Population,  ...
%            grade10Population, ...
%            grade11Population, ... 
%            grade12Population, ...
%            vaccCoverage);

gradePopulations = [grade9Population grade10Population grade11Population grade12Population];
%gradeForInfectionStart = randi([1 4], 1, 1);
gradeForInfectionStart = 2;

I0 = 1;
S0 = gradePopulations(gradeForInfectionStart) - I0;
V0 = S0 * vaccCoverage;
S0 = S0 - V0;

V1 = round(gradePopulations(1) * vaccCoverage);
S1 = gradePopulations(1) - V1;

V2 = round(gradePopulations(2) * vaccCoverage);
S2 = gradePopulations(2) - V2;

V3 = round(gradePopulations(3) * vaccCoverage);
S3 = gradePopulations(3) - V3;

V4 = round(gradePopulations(4) * vaccCoverage);
S4 = gradePopulations(4) - V4;

% If infection should start in grade 9 (1):
if gradeForInfectionStart == 1
    y0 = [S0, S2, S3, S4, ... % Susceptible
          V0, V2, V3, V4, ... % Vaccinated
          I0,  0,  0,  0, ... % Exposed
           0,  0,  0,  0, ... % Infected
           0,  0,  0,  0, ... % At Home
           0,  0,  0,  0, ... % Recovered
           0];                % Washroom
elseif gradeForInfectionStart == 2
    y0 = [S1, S0, S3, S4, ... % Susceptible
          V1, V0, V3, V4, ... % Vaccinated
           0, I0,  0,  0, ... % Exposed
           0,  0,  0,  0, ... % Infected
           0,  0,  0,  0, ... % At Home
           0,  0,  0,  0, ... % Recovered
           0];                % Washroom
elseif gradeForInfectionStart == 3
    y0 = [S1, S2, S0, S4, ... % Susceptible
          V1, V2, V0, V4, ... % Vaccinated
           0,  0, I0,  0, ... % Exposed
           0,  0,  0,  0, ... % Infected
           0,  0,  0,  0, ... % At Home
           0,  0,  0,  0, ... % Recovered
           0];                % Washroom
elseif gradeForInfectionStart == 4
    y0 = [S1, S2, S3, S0, ... % Suscpetible
          V1, V2, V3, V0, ... % Vaccinated
           0,  0,  0, I0, ... % Exposed
           0,  0,  0,  0, ... % Infected
           0,  0,  0,  0, ... % At Home
           0,  0,  0,  0, ... % Recovered
           0];                % Washroom
end
y0 = y0(:);
end
  

