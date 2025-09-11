% function theoretical_measurement_powers_nD()
    % 清除工作区和命令行窗口
%     clc; clear;

    % 定义系统的维度 n
    n = input('请输入系统的维度 n: ');

    % 输入态的系数
    disp('请输入输入态的系数 (c0, c1, ..., cn-1)');
    c = zeros(n, 1); % 创建大小为 n 的系数数组
    for i = 1:n
        c(i) = input(['输入态的系数 c' num2str(i-1) ': ']);
    end

    % 输入态的相位信息
    disp('请输入输入态的相位信息 (不输pi)(phi0, phi1, ..., phin-1)');
    phi = zeros(n, 1); % 创建大小为 n 的相位数组
    for i = 1:n
        phi(i) = input(['输入态的相位 phi' num2str(i-1) ': ']);
    end

    % 态矢量
    psi = zeros(n, 1);
    for i = 1:n
        psi(i) = c(i) * exp(1i * pi*phi(i)); % 使用复指数生成复数态
    end

    % 归一化态矢量
    psi = psi / norm(psi);

    % 理论密度矩阵
    rho_th = psi * psi';

    % 调用生成投影算符的函数
    [bases, mu] = generate_projectors_and_operators(n);

    % 计算理论测量功率值
    P_th = zeros(1, n^2);
    for j = 1:n^2
        P_th(j) = trace(rho_th * mu{j}); % 计算每个投影算符的测量功率值
    end

    % 显示结果
    disp('理论测量功率值:');
    disp(P_th);
    
    % 将密度矩阵和测量功率值存储到工作区
    assignin('base', 'P_th', P_th);
    assignin('base', 'rho_th', rho_th);
    
    % 显示理论密度矩阵
    disp('理论密度矩阵 rho_th:');
    disp(rho_th);
 phase=mapmap(rho_th, 4);
% end

