function [lp_combinations, index_map] = generateOAMIndex(l_dim, p_dim)
    % 输入参数:
    % l_dim: l 自由度的维度（取值个数，如 ±1, ±2, ±3,...）
    % p_dim: p 自由度的维度（取值个数，如 0, 1, 2,...）
    %
    % 输出参数:
    % lp_combinations: 存储所有编号后的 |l, p⟩ 组合（数组形式）
    % index_map: 映射 l 和 p 的编号到标准基态 |0⟩, |1⟩, ..., |n-1⟩

   % 定义 l 和 p 的取值范围
    % l 的取值范围，如 [1, -1, 2, -2,...]
    l_values = zeros(1, l_dim);
    for i = 1:ceil(l_dim/2)
        l_values(2*i-1) = i;      % 正数部分
        if 2*i <= l_dim
            l_values(2*i) = -i;   % 负数部分
        end
    end
    
    p_values = 0:p_dim-1;  % p 的取值范围，如 [0, 1, 2, ...]
    
    % 计算组合系统的总维度
    n = l_dim * p_dim;
    
    % 初始化存储所有组合 |l, p⟩ 的数组
    lp_combinations = zeros(n, 2);  % 使用矩阵存储每个编号的组合 |l, p⟩
    index_map = zeros(n, 1);  % 初始化标准基态索引的映射
    l_number = zeros(1, n);   % 初始化 l_number
    
    % 生成 l 和 p 组合的编号，并映射到标准基态
    index = 1;  % 编号索引，从 1 开始计数
    for p_idx = 1:p_dim  % 遍历 p 自由度的所有取值
        for l_idx = 1:l_dim  % 在每个 p 值下遍历 l 自由度的所有取值
            % 当前的 |l, p⟩ 组合
            lp_combinations(index, :) = [l_values(l_idx), p_values(p_idx)];
    
            % 对应的标准基态编号 |0⟩, |1⟩, ..., |n-1⟩
            index_map(index) = index - 1;  % 将 MATLAB 中的索引（从 1 开始）映射到标准基态（从 0 开始）
            
            % 计算 l_number
            l_number(index) = find(l_values == l_values(l_idx)) - 1;  % 获取 l 的索引并转换为从 0 开始
    
            % 更新索引
            index = index + 1;
        end
    end
        

    % 显示所有编号后的 |l, p⟩ 组合
    disp('所有编号后的 |l, p⟩ 组合:');
    for i = 1:n
        fprintf('|%d⟩ = |%d%d⟩ = |p=%d,l=%d⟩\n', index_map(i), lp_combinations(i, 2), l_number(i), lp_combinations(i, 2),lp_combinations(i, 1));
    end

    % 显示组合系统的总维度
    disp(['组合系统的总维度 n = ', num2str(n)]);
end
