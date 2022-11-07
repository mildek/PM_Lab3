function [X,FVAL,EXITFLAG, iteration] = simplex(c, A, b)
m = size(A, 1);
I = eye(m);
simp_matrix = [A I I];
iteration = 1;
base_indeces = [2*m+1:3*m]';
c = [c' zeros([1, m])];
new_n = size(simp_matrix, 2);

while(1)
    if(iteration > 10*(m+new_n))
        disp("Solution is unbounded");
        FVAL = [];
        X = [];
        EXITFLAG = -3;
        return
    end
    base = c(base_indeces)';
    fprintf("iteration %d\n", iteration);
    disp("c:")
    disp(c)
    disp("base indeces:")
    disp(base);
    disp("Simplex Matrix:")
    disp(simp_matrix);
    disp("b");
    disp(b);

    sol = dot(base, b');
    z = sum(base .* simp_matrix);
    disp("Current solution:")
    disp(sol);
    disp("z:")
    disp(z);
    z_c = z - c;
    disp("z - c:")
    disp(z_c);
    
    for col = 1:new_n
        if(z_c(col) < 0)
            if(max(simp_matrix(:,col)) <= 0)
                disp("Solution is unbounded");
                FVAL = [];
                X = [];
                EXITFLAG = -3;
                return
            end
        end
    end

    [min_z_c, min_index]= min(z_c);
    fprintf("Minimum value found in z - c vector: %d\n", min_z_c);
    if(min_z_c < 0)
        disp("Solution is not optimal")
        sub_column = simp_matrix(:, min_index);
        sub_column = b ./ sub_column;
        sub_column(sub_column < 0) = inf;        
        [min_val, another_min_index] = min(sub_column);
        old_base_member = base_indeces(another_min_index);
        base_indeces(another_min_index) = min_index;
        fprintf("Smallest value found for x%d, which will be new base variable substituting x%d\n", min_index, old_base_member);
        reference_value = simp_matrix(another_min_index, min_index);
        b(another_min_index) = b(another_min_index) / reference_value;
        simp_matrix(another_min_index,:) = simp_matrix(another_min_index,:) / reference_value;
        for row=1:m
            if(row ~= another_min_index)
                b(row) = b(row) - b(another_min_index) * simp_matrix(row, min_index);
                simp_matrix(row,:) = simp_matrix(row,:) - simp_matrix(another_min_index,:) * simp_matrix(row, min_index);
            end
        end
        iteration = iteration + 1;
    else
        disp("Solution is optimal");
        FVAL = double(sol);
        X = zeros([2*m, 1]);
        X(base_indeces) = b;
        X(1:m,:) = -X(1:m,:);
        X = double(X);
        EXITFLAG = 1;
        return
    end
end
end