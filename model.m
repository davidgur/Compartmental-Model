function dydt = model(~, y, bMat, g, s, r, bBase)
    bMat = bMat.*bBase;
    
    % ----- IDs -----
    % 1  - S1 - Grade 9     ----
    % 2  - S2 - Grade 10
    % 3  - S3 - Grade 11
    % 4  - S4 - Grade 12
    % 5  - V1 - Grade 9     ----
    % 6  - V2 - Grade 10
    % 7  - V3 - Grade 11
    % 8  - V4 - Grade 12
    % 9  - E1 - Grade 9     ----
    % 10 - E2 - Grade 10
    % 11 - E3 - Grade 11
    % 12 - E4 - Grade 12
    % 13 - I1 - Grade 9     ----
    % 14 - I2 - Grade 10
    % 15 - I3 - Grade 11
    % 16 - I4 - Grade 12
    % 17 - R1 - Grade 9     ----
    % 18 - R2 - Grade 10
    % 19 - R3 - Grade 11
    % 20 - R4 - Grade 12
    I = [y(13), y(14), y(15), y(16)];
    w = 1 - r;
    
    % ----- S_i -----
    dydt(1) = -(B(1, 4, I, bMat) * y(1));
    dydt(2) = -(B(2, 4, I, bMat) * y(2));
    dydt(3) = -(B(3, 4, I, bMat) * y(3));
    dydt(4) = -(B(4, 4, I, bMat) * y(4));

    % ----- V_i -----
    dydt(5) = -w*B( 1, 4, I, bMat) * y(5);
    dydt(6) = -w*B( 1, 4, I, bMat) * y(6);
    dydt(7) = -w*B( 1, 4, I, bMat) * y(7);
    dydt(8) = -w*B( 1, 4, I, bMat) * y(8);
    
    % ----- E_i -----
    dydt(9)  = (y(1) + (w * y(5)))*B(1, 4, I, bMat) - (s * y(9));
    dydt(10) = (y(2) + (w * y(6)))*B(2, 4, I, bMat) - (s * y(10));
    dydt(11) = (y(3) + (w * y(7)))*B(3, 4, I, bMat) - (s * y(11));
    dydt(12) = (y(4) + (w * y(8)))*B(4, 4, I, bMat) - (s * y(12));
    
    % ----- I_i -----
    dydt(13)  = (s * y(9)) - (g * y(13));
    dydt(14) = (s * y(10)) - (g * y(14));
    dydt(15) = (s * y(11)) - (g * y(15));
    dydt(16) = (s * y(12)) - (g * y(16));
    
    % ----- R_i -----
    dydt(17) = g * y(13);
    dydt(18) = g * y(14);
    dydt(19) = g * y(15);
    dydt(20) = g * y(16);
    
    dydt = dydt(:);

    function retVal = B(i, N, I, bMat)
        retVal = 0;
        for j = 1:N
            retVal = retVal + (bMat(i, j) * I(j));
        end
    end
end