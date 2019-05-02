function dydt = model(t, y, paramPack, contactMatrixFriends, contactMatrixClass)
    % ----- Unpack Parameters ----- %
    infectionProbability    = paramPack(1);
    minutesExposed          = paramPack(2);
    minutesAtSchoolInfected = paramPack(3);
    minutesAtHomeInfected   = paramPack(4);
    grade9Population        = paramPack(5);
    grade10Population       = paramPack(6);
    grade11Population       = paramPack(7);
    grade12Population       = paramPack(8);
    
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
    
    N = [grade9Population grade10Population grade11Population grade12Population];
    
    % ----- Differential Equations ----- %
    dayState = getDayState();
    
    dydt(1) = resolveSusceptible(dayState, 1); % Grade 9  S
    dydt(2) = resolveSusceptible(dayState, 2); % Grade 10 S
    dydt(3) = resolveSusceptible(dayState, 3); % Grade 11 S
    dydt(4) = resolveSusceptible(dayState, 4); % Grade 12 S
    
    dydt(5) = 0; % Grade 9  V
    dydt(6) = 0; % Grade 10 V
    dydt(7) = 0; % Grade 11 V
    dydt(8) = 0; % Grade 12 V
    
    dydt(9)  = resolveExposed(dayState, 1); % Grade 9  E
    dydt(10) = resolveExposed(dayState, 2); % Grade 10 E
    dydt(11) = resolveExposed(dayState, 3); % Grade 11 E
    dydt(12) = resolveExposed(dayState, 4); % Grade 12 E
    
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
        % Check if weekend
        dayCount = floor(t / 24*60);
        if (mod(dayCount, 6) == 0 || mod(dayCount, 7) == 0)
            dayState = 1;
        else
            tDay = mod(t, 24*60);

            if (0 <= tDay) && (tDay < 500)
                dayState = 1;
            elseif (500 <= tDay) && (tDay < 520)
                dayState = 2;
            elseif (520 <= tDay) && (tDay < 600)
                dayState = 3;
            elseif (600 <= tDay) && (tDay < 605)
                dayState = 2;
            elseif (605 <= tDay) && (tDay < 680)
                dayState = 3;
            elseif (680 <= tDay) && (tDay < 685)
                dayState = 2;
            elseif (685 <= tDay) && (tDay < 760)
                dayState = 3;
            elseif (760 <= tDay) && (tDay < 765)
                dayState = 2;
            elseif (765 <= tDay) && (tDay < 840)
                dayState = 3;
            elseif (840 <= tDay) && (tDay < 845)
                dayState = 2;
            elseif (845 <= tDay) && (tDay < 920)
                dayState = 3;
            elseif (920 <= tDay) && (tDay < 940)
                dayState = 2;
            elseif (940 <= tDay) && (tDay < 24 * 60)
                dayState = 1;
            end
        end
    end
    
    function s_i = resolveSusceptible(dayState, i)
        if dayState == 1 % Weekend or at home
            s_i = 0;
        elseif dayState == 2 % Before / After Class
            B = 0;
            for j = 1:4
                B = B + (2/20) * infectionProbability * contactMatrixFriends(i, j) * I(j) / N(i);
            end
            
            w = (1/6) * washroomVisitRate * infectionProbability * pulmonaryVentilation * W;
            s_i = -(B + w) * S(i);
        elseif dayState == 3 % In Class
            B = 0;
            for j = 1:4
                B = B + (3 / 75) * infectionProbability * contactMatrixClass(i, j) * I(j) / N(i);
            end
            
            w = (1/6) * washroomVisitRate * infectionProbability * pulmonaryVentilation * W;
            s_i = -(B + w) * S(i);
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

