function [rho_opt, final_chi2] = reconstruct_density_matrix_nD_MLE(PnD, rho_r, dimension)
    % 输入:
    % PnD - 测量的功率值向量，大小为 dimension^2
    % rho_r - 初始重构的密度矩阵
    % dimension - 系统的维度 n（2, 3, 4,...）
    % 输出:
    % rho_opt - 优化后的 n 维密度矩阵
    % final_chi2 - 最终的 chi^2 值

    % 读取测量概率
    p = PnD;

    % 最大搜索步数
    max_steps = 1e6;

    % 设定目标 chi^2 阈值
    chi2_threshold = 10e-4;

%     % 优化选项
%高精度
    options = optimoptions('fmincon', ...
                           'Display', 'off', ...
                           'Algorithm', 'sqp', ...
                           'MaxIterations', max_steps, ...
                           'MaxFunctionEvaluations', max_steps, ...
                           'OptimalityTolerance', 1e-12, ...
                           'StepTolerance', 1e-12, ...
                           'ConstraintTolerance', 1e-12);
%低精度
% options = optimoptions('fmincon', ...
%                        'Display', 'off', ...
%                        'Algorithm', 'sqp', ...
%                        'MaxIterations', 5000, ...      % 减少最大迭代次数
%                        'MaxFunctionEvaluations', 5000, ...  % 减少最大函数评估次数
%                        'OptimalityTolerance', 1e-8, ...    % 放宽最优容忍度
%                        'StepTolerance', 1e-8, ...         % 放宽步长容忍度
%                        'ConstraintTolerance', 1e-8);     % 放宽约束容忍度
    % 使用初步求解得到的密度矩阵作为初始猜测
    rho_initial = rho_r;
    if ~isempty(rho_initial)
        rho_initial = makephysical(rho_initial);
    end
    initial_guess = FindInitialT(rho_initial, dimension);

    % 优化参数的上下限（根据维度确定）
    num_params = length(initial_guess);
    lb = -inf(num_params, 1); % 下限
    ub = inf(num_params, 1);  % 上限

    % 使用 fmincon 进行优化
    [params, ~] = fmincon(@(params) likelihood_function(params, p, [], dimension), ...
                          initial_guess, [], [], [], [], ...
                          lb, ub, [], options);

    % 计算最优参数 (t1, t2, ..., tN)
    t_opt = params;

    % 重构的密度矩阵
    rho_opt = construct_density_matrix(t_opt, dimension);

    % 计算最终的 chi^2
    final_chi2 = likelihood_function(t_opt, p, [], dimension);

    % 检查是否满足条件
    if final_chi2 < chi2_threshold
        % 将重构的密度矩阵和最终的 chi^2 存储到工作区
        assignin('base', 'rho_reconstructed', rho_opt);
        assignin('base', 'final_chi2', final_chi2);

        % 显示结果
        disp('测量值有真实密度矩阵近似对应');
        disp('Reconstructed density matrix:');
        disp(rho_opt);
    else
        disp('测量值无真实密度矩阵近似对应');
        disp('Density matrix:');
        disp(rho_opt);
    end
end
