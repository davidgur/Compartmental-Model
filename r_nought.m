function outputArg = r_nought(bMat,bBase, g)
    bMat = bMat.* bBase;
    
    grades = [9; 10; 11; 12];
    
    for i = 1:size(bMat, 1)
        for j = 1:size(bMat, 2)
            R_nought = bMat(i, j) / (g * 24 * 60);
            fprintf('R0 %d -> %d = %d\n', grades(i), grades(j), R_nought);
        end
    end
end

