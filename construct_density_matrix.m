function rho_p = construct_density_matrix(t, dimension)
    % 输入:
    % t - 参数向量，表示上三角矩阵的自由参数
    % dimension - 密度矩阵的维度（n = 2, 3, 4,...）
    % 输出:
    % rho_p - n 维物理密度矩阵

    % 检查输入参数 t 的大小是否与维度 n 匹配
    num_parameters = dimension * (dimension + 1) / 2; % 上三角矩阵（包含实部和虚部的复数元素）
    if length(t) ~= num_parameters * 2 - dimension
        error(['输入参数 t 的长度不匹配。对于 ', num2str(dimension), ' 维矩阵，需要 ', num2str(num_parameters * 2 - dimension), ' 个参数。']);
    end
    
    % 构造上三角矩阵 T（n 维）
    T = zeros(dimension, dimension); % 初始化 n x n 零矩阵
    idx = 1; % t 参数索引起始位置

    % 填充上三角矩阵（包括对角线）
    for i = 1:dimension
        for j = i:dimension
            if i == j
                % 对角线元素只取实数部分
                T(i, j) = t(idx);
                idx = idx + 1;
            else
                % 非对角线元素为复数
                T(i, j) = t(idx) + 1i * t(idx + 1);
                idx = idx + 2;
            end
        end
    end
    
    % 构造密度矩阵 rho_p = (T' * T) / trace(T' * T)
    rho_p = (T' * T) / trace(T' * T);
end
