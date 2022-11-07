rng('default');
rng(100);
correct = 0;
total = 100;
my_iterations = 0;
their_iterations = 0;
tolerance = 0.000001;

% % % % % % % %
% FIRST TEST - FOR ALL POSSIBILITIES
% % % % % % % %

for i=1:total
    % % % % % % % %
    % My Linprog
    % % % % % % % % 
    m = randi([3, 5]);
    n = 2 * m;
    c = randi([-5, 5], n, 1);
    b = randi([1, 8], m, 1);
    A = randi([-5, 5], m, m);
    [X,FVAL,EXITFLAG, iteration] = simplex(c, A, b);
    
    % % % % % % % % 
    % Built in Linprog
    % % % % % % % % 
    
    f = -c';
    f = [f zeros([1,m])];
    A_I = [A eye(m) eye(m)];
    lb = zeros([1,3*m]);
    [X2,FVAL2,EXITFLAG2,OUTPUT] = linprog(f, [], [], A_I, b, lb, []);

    if((EXITFLAG == 1) == EXITFLAG2)
        FVAL2 = -FVAL2;
        X2(1:m,:) = -X2(1:m,:);
        if(abs(FVAL - FVAL2) < tolerance)
            correct = correct + 1;
        end
        

    elseif(EXITFLAG2 == -3 & EXITFLAG == -3)
        correct = correct + 1;
    end
    my_iterations = my_iterations + iteration;
    their_iterations = their_iterations + OUTPUT.iterations;

end

% % % % % % % %
% SECOND TEST - FOR PROBLEMS WITH OPTIMAL SOLUTION
% % % % % % % %

rng(1000);
done = 0;
correct_with_solution = 0;
while(1)
    if(done == 100)
        break;
    end
    % % % % % % % %
    % My Linprog
    % % % % % % % % 
    m = randi([3, 5]);
    n = 2 * m;
    c = randi([-5, 5], n, 1);
    b = randi([1, 8], m, 1);
    A = randi([-5, 5], m, m);
    [X,FVAL,EXITFLAG, iteration] = simplex(c, A, b);
    
    % % % % % % % % 
    % Built in Linprog
    % % % % % % % % 
    
    f = -c';
    f = [f zeros([1,m])];
    A_I = [A eye(m) eye(m)];
    lb = zeros([1,3*m]);
    [X2,FVAL2,EXITFLAG2,OUTPUT] = linprog(f, [], [], A_I, b, lb);

    if((EXITFLAG2 == 1))
        FVAL2 = -FVAL2;
        X2(1:m,:) = -X2(1:m,:);
        if(abs(FVAL - FVAL2) < tolerance & EXITFLAG == 1)
            correct_with_solution = correct_with_solution + 1;
        end
        done = done + 1;
    end
end
