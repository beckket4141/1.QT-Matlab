function [rho_th, P_th] = theoretical_measurement_powers_nD_fun(n, a, b)
    % theoretical_measurement_powers_nD 计算密度矩阵和理论测量功率值
    % 输入:
    %   n - 系统维度
    %   a - 输入态的系数数组 (大小为 n)
    %   b - 输入态的相位数组 (大小为 n)
    % 输出:
    %   rho_th - 归一化后的理论密度矩阵
    %   P_th - 理论测量功率值数组 (大小为 n^2)

    % 验证输入数组的长度是否与维度 n 一致
    if length(a) ~= n || length(b) ~= n
        error('系数数组 a 和相位数组 b 的长度必须与系统维度 n 相等');
    end

    % 计算态矢量 psi
    psi = zeros(n, 1);
    for i = 1:n
        psi(i) = a(i) * exp(1i *pi* b(i)); % 使用复指数生成复数态
    end

    % 归一化态矢量
    psi = psi / norm(psi);

    % 计算理论密度矩阵
    rho_th = psi * psi';

    % 调用生成投影算符的函数
    [bases, mu] = generate_projectors_and_operators(n);

    % 计算理论测量功率值
    P_th = zeros(1, n^2);
    for j = 1:n^2
        P_th(j) = trace(rho_th * mu{j}); % 计算每个投影算符的测量功率值
    end

    % 返回密度矩阵和理论测量功率值
end
