function y0 = gen_y0(grade9Population,grade10Population, grade11Population, grade12Population, vaccCoverage)
%y0 = gen_y0(grade9Population,  ...
%            grade10Population, ...
%            grade11Population, ... 
%            grade12Population, ...
%            vaccCoverage);

gradePopulations = [grade9Population grade10Population grade11Population grade12Population];
gradeForInfectionStart = randi([1 4], 1, 1);

I0 = 1 / gradePopulations(gradeForInfectionStart);
S0 = 1 - I0;
V0 = S0 * vaccCoverage;
VN = vaccCoverage;
SN = 1 - VN;
S0 = S0 - V0;

% If infection should start in grade 9 (1):
if gradeForInfectionStart == 1
    y0 = [S0, SN, SN, SN, ... % Susceptible
          V0, VN, VN, VN, ... % Vaccinated
          I0,  0,  0,  0, ... % Exposed
           0,  0,  0,  0, ... % Infected
           0,  0,  0,  0, ... % At Home
           0,  0,  0,  0, ... % Recovered
           0];                % Washroom
elseif gradeForInfectionStart == 2
    y0 = [SN, S0, SN, SN, ... % Susceptible
          VN, V0, VN, VN, ... % Vaccinated
           0, I0,  0,  0, ... % Exposed
           0,  0,  0,  0, ... % Infected
           0,  0,  0,  0, ... % At Home
           0,  0,  0,  0, ... % Recovered
           0];                % Washroom
elseif gradeForInfectionStart == 3
    y0 = [SN, SN, S0, SN, ... % Susceptible
          VN, VN, V0, VN, ... % Vaccinated
           0,  0, I0,  0, ... % Exposed
           0,  0,  0,  0, ... % Infected
           0,  0,  0,  0, ... % At Home
           0,  0,  0,  0, ... % Recovered
           0];                % Washroom
elseif gradeForInfectionStart == 4
    y0 = [SN, SN, SN, S0, ... % Suscpetible
          VN, VN, VN, V0, ... % Vaccinated
           0,  0,  0, I0, ... % Exposed
           0,  0,  0,  0, ... % Infected
           0,  0,  0,  0, ... % At Home
           0,  0,  0,  0, ... % Recovered
           0];                % Washroom
end
y0 = y0(:);
end
  

