function outT = FindInitialT(rho, dimension)
    % 输入:
    % rho - 初始重构的密度矩阵
    % dimension - 系统的维度 n
    % 输出:
    % outT - 用于优化的初始参数向量

    % 初始化参数向量 outT
    num_parameters = dimension * (dimension + 1) / 2; % 上三角矩阵参数个数（含复数元素）
    outT = zeros(1, num_parameters * 2 - dimension); % 每个复数包含两个参数（实部和虚部）

    % 提取密度矩阵的对角元素和非对角元素，并将其转换为参数向量
    index = 1;
    for i = 1:dimension
        % 计算对角线元素的初始值（实数）
        outT(index) = real(sqrt(rho(i, i)));
        index = index + 1;
        
        % 计算非对角线元素的初始值（复数）
        for j = i+1:dimension
            % 提取复数元素的实部和虚部
            temp = rho(i, j) / sqrt(rho(i, i) * rho(j, j));
            outT(index) = real(temp);
            index = index + 1;
            outT(index) = imag(temp);
            index = index + 1;
        end
    end
end
