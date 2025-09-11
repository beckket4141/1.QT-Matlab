function sqrt_A = matrix_square_root(A)
    % 特征值分解
    [V, D] = eig(A);
    
    % 计算平方根特征值矩阵
    sqrt_D = sqrt(D);
    
    % 计算平方根矩阵
    sqrt_A = V * sqrt_D / V;
end

% 示例矩阵

