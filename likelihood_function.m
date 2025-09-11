function L = likelihood_function(t, p, rho_r, dimension)
    % 输入:
    % t - 优化参数向量（如果为空，则使用 rho_r）
    % p - 测量概率向量
    % rho_r - 初始或现有的密度矩阵（如果 t 为空，则使用此矩阵）
    % dimension - 系统的维度 n（2, 4 或任意其他维度）
    % 输出:
    % L - 似然函数值（chi^2）

    % 检查输入参数数量
    if nargin < 4
        error('输入参数数量不足，请提供 t, p, rho_r 和 dimension。');
    end

    % 判断是否提供了 t 参数（t 为空时，使用 rho_r 作为密度矩阵）
    if isempty(t)
        rho_p = rho_r;  % 使用传入的密度矩阵
    else
        % 使用 t 构造密度矩阵
        rho_p = construct_density_matrix(t, dimension);
    end

    % 定义投影算符
    [~, mu] = generate_projectors_and_operators(dimension);

    % 计算理论概率分布 p_theory
    p_theory = zeros(dimension^2, 1);
    for k = 1:dimension^2
        p_theory(k) = real(trace(rho_p * mu{k}));
    end

%    % 检查 p 和 p_theory 的大小是否一致
%     assignin('base', 'p_size', size(p));  % 存储 p 的大小到工作区
%     assignin('base', 'p_value', p);       % 存储 p 的值到工作区
%     
%     assignin('base', 'p_theory_size', size(p_theory));  % 存储 p_theory 的大小到工作区
%     assignin('base', 'p_theory_value', p_theory);       % 存储 p_theory 的值到工作区
% 检查并调整 p_theory 的形状，确保其为列向量
    if size(p_theory, 1) == 1  % 如果 p_theory 是行向量
        p_theory = p_theory';  % 转置为列向量
    end

    % 检查 p 的形状，确保其为列向量
    if size(p, 1) == 1  % 如果 p 是行向量
        p = p';  % 转置为列向量
    end

    % 计算似然函数
    L = sum((p - p_theory).^2 ./ sqrt(p + 1));  % 统一的 chi^2 计算方式

    % 输出调试信息（可选）
%     disp(['p 的大小：', num2str(size(p))]);
%     disp(['p 的值：']);
%     disp(['p_theory 的大小：', num2str(size(p_theory))]);
%     disp(['p_theory 的值：']);
%     disp(p_theory);
end
