% 定义生成 n 维系统投影基态和投影算符的函数
function [bases, projectors] = generate_projectors_and_operators(n)
    % 创建一个大小为 n^2 的元胞数组，用于存储基态
    bases = cell(1, n^2);  

    % 定义 n 维系统的 n^2 个投影基态
    index = 1;  % 用于跟踪基态的索引

    % 先定义标准基态 |0>, |1>, ..., |n-1>
    for i = 0:n-1
        basis = zeros(n, 1);  % 创建一个 n 维列向量
        basis(i + 1) = 1;     % 第 i 个分量为 1，其余为 0
        bases{index} = basis; % 存入基态数组中
        index = index + 1;
    end

    % 定义 n 维系统的组合基态 (|i> + |j>) 和 (|i> - i|j>)
    for i = 1:n-1
        for j = i+1:n
            % 组合基态: (|i-1> + |j-1>)
            basis_plus = zeros(n, 1);
            basis_plus(i) = 1;
            basis_plus(j) = 1;
            bases{index} = (1/sqrt(2)) * basis_plus;
            index = index + 1;
% 
            % 组合基态: (|i-1> - i|j-1>)
            basis_minus_i = zeros(n, 1);
            basis_minus_i(i) = 1;
            basis_minus_i(j) = -1i;
            bases{index} = (1/sqrt(2)) * basis_minus_i;
            index = index + 1;

%             % 组合基态: (|i-1> + i|j-1>)
%             basis_minus_i = zeros(n, 1);
%             basis_minus_i(i) = 1; 
%             basis_minus_i(j) = 1i;
%             bases{index} = (1/sqrt(2)) * basis_minus_i;
%             index = index + 1;
        end
    end

    % 计算每个基态的投影算符 P_i = |ψ_i><ψ_i|
    projectors = cell(1, n^2);
    for i = 1:n^2
        projectors{i} = bases{i} * bases{i}';
    end
    
end
