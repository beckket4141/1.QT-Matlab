function [rho_opt, final_chi2, optimization_info] = reconstruct_density_matrix_nD_MLE_improved(PnD, rho_r, dimension)
    % 改进的最大似然估计方法，解决局部最优问题
    % 输入:
    % PnD - 测量的功率值向量，大小为 dimension^2
    % rho_r - 初始重构的密度矩阵
    % dimension - 系统的维度 n（2, 3, 4,...）
    % 输出:
    % rho_opt - 优化后的 n 维密度矩阵
    % final_chi2 - 最终的 chi^2 值
    % optimization_info - 优化过程信息

    % 读取测量概率
    p = PnD;
    
    % 优化参数设置
    max_steps = 1e6;
    chi2_threshold = 10e-4;
    num_random_starts = 10; % 随机起点数量
    
    % 存储所有优化结果
    all_results = [];
    
    % 1. 使用原始线性重构结果作为起点
    rho_initial = rho_r;
    if ~isempty(rho_initial)
        rho_initial = makephysical(rho_initial);
    end
    initial_guess_linear = FindInitialT(rho_initial, dimension);
    [rho_linear, chi2_linear] = optimize_single_start(initial_guess_linear, p, dimension, max_steps);
    all_results = [all_results; struct('rho', rho_linear, 'chi2', chi2_linear, 'method', 'linear')];
    
    % 2. 生成多个随机起点进行优化
    disp('开始多起点优化...');
    for i = 1:num_random_starts
        % 生成随机初始点
        random_guess = generate_random_initial_guess(dimension, rho_r);
        
        % 优化
        [rho_random, chi2_random] = optimize_single_start(random_guess, p, dimension, max_steps);
        all_results = [all_results; struct('rho', rho_random, 'chi2', chi2_random, 'method', 'random')];
        
        if mod(i, 2) == 0
            fprintf('已完成 %d/%d 个随机起点优化\n', i, num_random_starts);
        end
    end
    
    % 3. 使用遗传算法进行全局优化
    disp('开始遗传算法优化...');
    [rho_ga, chi2_ga] = optimize_with_genetic_algorithm(p, dimension, rho_r);
    all_results = [all_results; struct('rho', rho_ga, 'chi2', chi2_ga, 'method', 'genetic')];
    
    % 4. 选择最佳结果
    [best_chi2, best_idx] = min([all_results.chi2]);
    rho_opt = all_results(best_idx).rho;
    final_chi2 = best_chi2;
    
    % 5. 输出优化信息
    optimization_info = struct();
    optimization_info.all_results = all_results;
    optimization_info.best_method = all_results(best_idx).method;
    optimization_info.improvement = chi2_linear - best_chi2;
    
    % 显示结果
    disp('=== 优化结果比较 ===');
    for i = 1:length(all_results)
        fprintf('%s方法: chi2 = %.8e\n', all_results(i).method, all_results(i).chi2);
    end
    fprintf('最佳方法: %s, chi2 = %.8e\n', optimization_info.best_method, best_chi2);
    fprintf('相比线性方法改进: %.8e\n', optimization_info.improvement);
    
    % 检查是否满足条件
    if final_chi2 < chi2_threshold
        disp('测量值有真实密度矩阵近似对应');
    else
        disp('测量值无真实密度矩阵近似对应');
    end
    
    % 存储到工作区
    assignin('base', 'rho_reconstructed', rho_opt);
    assignin('base', 'final_chi2', final_chi2);
    assignin('base', 'optimization_info', optimization_info);
end

function [rho_opt, chi2] = optimize_single_start(initial_guess, p, dimension, max_steps)
    % 单起点优化函数
    options = optimoptions('fmincon', ...
                           'Display', 'off', ...
                           'Algorithm', 'sqp', ...
                           'MaxIterations', max_steps, ...
                           'MaxFunctionEvaluations', max_steps, ...
                           'OptimalityTolerance', 1e-12, ...
                           'StepTolerance', 1e-12, ...
                           'ConstraintTolerance', 1e-12);
    
    num_params = length(initial_guess);
    lb = -inf(num_params, 1);
    ub = inf(num_params, 1);
    
    try
        [params, ~] = fmincon(@(params) likelihood_function(params, p, [], dimension), ...
                              initial_guess, [], [], [], [], ...
                              lb, ub, [], options);
        rho_opt = construct_density_matrix(params, dimension);
        chi2 = likelihood_function(params, p, [], dimension);
    catch
        % 如果优化失败，返回原始密度矩阵
        rho_opt = construct_density_matrix(initial_guess, dimension);
        chi2 = likelihood_function(initial_guess, p, [], dimension);
    end
end

function random_guess = generate_random_initial_guess(dimension, rho_r)
    % 生成随机初始点
    num_parameters = dimension * (dimension + 1) / 2;
    num_params = num_parameters * 2 - dimension;
    
    % 基于线性重构结果添加随机扰动
    rho_for_guess = rho_r;
    if ~isempty(rho_for_guess)
        rho_for_guess = makephysical(rho_for_guess);
    end
    base_guess = FindInitialT(rho_for_guess, dimension);
    
    % 添加高斯噪声
    noise_scale = 0.1; % 噪声强度
    random_guess = base_guess + noise_scale * randn(size(base_guess));
    
    % 确保对角线元素为正数
    idx = 1;
    for i = 1:dimension
        random_guess(idx) = abs(random_guess(idx));
        idx = idx + 1;
        for j = i+1:dimension
            idx = idx + 2; % 跳过复数元素的实部和虚部
        end
    end
end

function [rho_opt, chi2] = optimize_with_genetic_algorithm(p, dimension, rho_r)
    % 使用遗传算法进行全局优化
    num_parameters = dimension * (dimension + 1) / 2;
    num_params = num_parameters * 2 - dimension;
    
    % 遗传算法参数
    options = optimoptions('ga', ...
                          'Display', 'off', ...
                          'MaxGenerations', 100, ...
                          'PopulationSize', 50, ...
                          'FunctionTolerance', 1e-8);
    
    % 参数边界
    lb = -10 * ones(num_params, 1);
    ub = 10 * ones(num_params, 1);
    
    try
        [params, ~] = ga(@(params) likelihood_function(params, p, [], dimension), ...
                        num_params, [], [], [], [], lb, ub, [], options);
        rho_opt = construct_density_matrix(params, dimension);
        chi2 = likelihood_function(params, p, [], dimension);
    catch
        % 如果遗传算法失败，返回线性重构结果
        rho_opt = rho_r;
        chi2 = likelihood_function([], p, rho_r, dimension);
    end
end
