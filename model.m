function dydt = model(t, y, paramPack, contactMatrixFriends, contactMatrixClass)
    % ----- Unpack Parameters ----- %
    infectionProbability    = paramPack(1);
    minutesExposed          = paramPack(2);
    minutesAtSchoolInfected = paramPack(3);
    minutesAtHomeInfected   = paramPack(4);
    
    % ----- Constants ----- %
    washroomVisitRate = 0.00047;
    washroomConcentrationIncrease = 2.2 * 144;
    washroomAirVentilation = 5;
    washroomSize = 35;
    pulmonaryVentilation = 0.00556;
    
    % ----- Identifying Values -----
    S = [y(1) y(2) y(3) y(4)];
    V = [y(5) y(6) y(7) y(8)];
    E = [y(9) y(10) y(11) y(12)];
    I = [y(13) y(14) y(15) y(16)];
    H = [y(17) y(18) y(19) y(20)];
    W = y(21);
    
    % ----- Differential Equations ----- %
    dydt(1) = resolveSusceptible(getDayState(), 1); % Grade 9  S
    dydt(2) = resolveSusceptible(getDayState(), 2); % Grade 10 S
    dydt(3) = resolveSusceptible(getDayState(), 3); % Grade 11 S
    dydt(4) = resolveSusceptible(getDayState(), 4); % Grade 12 S
    
    dydt(5) = 0; % Grade 9  V
    dydt(6) = 0; % Grade 10 V
    dydt(7) = 0; % Grade 11 V
    dydt(8) = 0; % Grade 12 V
    
    dydt(9)  = resolveExposed(getDayState(), 1); % Grade 9  E
    dydt(10) = resolveExposed(getDayState(), 2); % Grade 10 E
    dydt(11) = resolveExposed(getDayState(), 3); % Grade 11 E
    dydt(12) = resolveExposed(getDayState(), 4); % Grade 12 E
    
    dydt(13) = resolveInfected(1); % Grade 9  I
    dydt(14) = resolveInfected(2); % Grade 10 I
    dydt(15) = resolveInfected(3); % Grade 11 I
    dydt(16) = resolveInfected(4); % Grade 12 I
    
    dydt(17) = resolveAtHome(1); % Grade 9  H
    dydt(18) = resolveAtHome(2); % Grade 10 H
    dydt(19) = resolveAtHome(3); % Grade 11 H
    dydt(20) = resolveAtHome(4); % Grade 12 H
    
    dydt(21) = resolveRecovered(1); % Grade 9  R
    dydt(22) = resolveRecovered(2); % Grade 10 R
    dydt(23) = resolveRecovered(3); % Grade 11 R
    dydt(24) = resolveRecovered(4); % Grade 12 R
    
    dydt(25) = resolveWashroom(getDayState()); % Washroom :)
    
    dydt = dydt(:);
    
    function dayState = getDayState()
        if (0 <= t) && (t < 500)
            dayState = 1;
        elseif (500 <= t) && (t < 520)
            dayState = 2;
        elseif (520 <= t) && (t < 600)
            dayState = 3;
        elseif (600 <= t) && (t < 605)
            dayState = 2;
        elseif (605 <= t) && (t < 680)
            dayState = 3;
        elseif (680 <= t) && (t < 685)
            dayState = 2;
        elseif (685 <= t) && (t < 760)
            dayState = 3;
        elseif (760 <= t) && (t < 765)
            dayState = 2;
        elseif (765 <= t) && (t < 840)
            dayState = 3;
        elseif (840 <= t) && (t < 845)
            dayState = 2;
        elseif (845 <= t) && (t < 920)
            dayState = 3;
        elseif (920 <= t) && (t < 940)
            dayState = 2;
        elseif (940 <= t) && (t < 24 * 60)
            dayState = 1;
        end
    end
    
    function s_i = resolveSusceptible(dayState, i)
        if dayState == 1 % Weekend or at home
            s_i = 0;
        elseif dayState == 2 % Before / After Class
            B = 0;
            for j = 1:4
                B = B + (2/20) * infectionProbability * contactMatrixFriends(i, j) * I(j);
            end
            
            W = (1/6) * washroomVisitRate * infectionProbability * pulmonaryVentilation * y(W);
            s_i = -(B + W) * y(S(i));
        elseif dayState == 3 % In Class
            B = 0;
            for j = 1:4
                B = B + (3 / 75) * infectionProbability * contactMatrixClass(i, j) * I(j);
            end
            
            W = (1/6) * washroomVisitRate * infectionProbability * pulmonaryVentilation * W;
            s_i = -(B + W) * y(S(i));
        end
    end

    function e_i = resolveExposed(dayState, i)
        if dayState == 1 % Weekend or at home
            e_i = -(minutesExposed * E(i));
        elseif dayState == 2 % Before / After class
            e_i = (-resolveSusceptible(dayState, i) - (minutesExposed * E(i)));
        elseif dayState == 3 % In Class
            e_i = (-resolveSusceptible(dayState, i) - (minutesExposed * E(i)));
        end
        
    end

    function i_i = resolveInfected(i)
        i_i = (minutesExposed * E(i)) - (minutesAtSchoolInfected * I(i));
    end

    function h_i = resolveAtHome(i)
        h_i = (minutesAtSchoolInfected * I(i)) - (minutesAtHomeInfected * H(i));
    end

    function r_i = resolveRecovered(i)
        r_i = (minutesAtHomeInfected * H(i));
    end

    function w = resolveWashroom(dayState)
        if dayState == 1 % Weekend or at home
            w = W * exp(-washroomAirVentilation * 2.2 / washroomSize);
        elseif dayState == 2 || dayState == 3
            wrDecay = W * exp(-washroomAirVentilation * 2.2 / washroomSize);
            newInfectionWR = (1/6) * washroomVisitRate * washroomConcentrationIncrease * sum(I);
            w = wrDecay + newInfectionWR;
        end
    end
            
end

