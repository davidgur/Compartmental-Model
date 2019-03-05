function dydt = model(~, y, bMat, g, s, bBase)
    bMat = bMat.*bBase;
    
    % ----- IDs -----
    % 1  - S1 - Grade 9     ----
    % 2  - S2 - Grade 10
    % 3  - S3 - Grade 11
    % 4  - S4 - Grade 12
    % 5  - E1 - Grade 9     ----
    % 6  - E2 - Grade 10
    % 7  - E3 - Grade 11
    % 8  - E4 - Grade 12
    % 9  - I1 - Grade 9     ----
    % 10 - I2 - Grade 10
    % 11 - I3 - Grade 11
    % 12 - I4 - Grade 12
    % 13 - R1 - Grade 9     ----
    % 14 - R2 - Grade 10
    % 15 - R3 - Grade 11
    % 16 - R4 - Grade 12
    I = [y(9), y(10), y(11), y(12)];
    
    % ----- S_i -----
    dydt(1) = -(B(1, 4, I, bMat) * y(1));
    dydt(2) = -(B(2, 4, I, bMat) * y(2));
    dydt(3) = -(B(3, 4, I, bMat) * y(3));
    dydt(4) = -(B(4, 4, I, bMat) * y(4));

    % ----- E_i -----
    dydt(5) = (B(1, 4, I, bMat) * y(1)) - (s * y(5));
    dydt(6) = (B(2, 4, I, bMat) * y(2)) - (s * y(6));
    dydt(7) = (B(3, 4, I, bMat) * y(3)) - (s * y(7));
    dydt(8) = (B(4, 4, I, bMat) * y(4)) - (s * y(8));
    
    % ----- I_i -----
    dydt(9)  = (s * y(5)) - (g * y(9));
    dydt(10) = (s * y(6)) - (g * y(10));
    dydt(11) = (s * y(7)) - (g * y(11));
    dydt(12) = (s * y(8)) - (g * y(12));
    
    % ----- R_i -----
    dydt(13) = (g * y(9));
    dydt(14) = (g * y(10));
    dydt(15) = (g * y(11));
    dydt(16) = (g * y(12));
    
    dydt = dydt(:);

    function retVal = B(i, N, I, bMat)
        retVal = 0;
        for j = 1:N
            retVal = retVal + (bMat(i, j) * I(j));
        end
    end
end