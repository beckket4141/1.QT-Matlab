function [rho_opt, final_chi2, optimization_info] = reconstruct_density_matrix_nD_MLE_enhanced(PnD, rho_r, dimension, options)
% 增强版混合最大似然估计 (Enhanced Hybrid Maximum Likelihood Estimation, E-HMLE)
% 
% 功能描述：
% 本函数实现了增强版混合最大似然估计方法，在传统HMLE的基础上进行了全面改进：
% 1. 多信息融合的先验分析：结合线性重构、统计测试、熵分析等多种信息源
% 2. 自适应参数调整：根据数据质量动态调整算法参数
% 3. 多起点混合优化：结合局部和全局优化策略
% 4. 智能结果选择：基于多指标评估的客观选择
% 5. 自适应秩约束：智能识别纯态/混态并应用相应约束
% 6. 实时监控诊断：提供详细的优化过程信息
%
% 输入参数：
%   PnD - 测量概率向量 (dimension^2 x 1)
%   rho_r - 线性重构的初始密度矩阵 (dimension x dimension)
%   dimension - 量子态维度
%   options - 优化选项结构体（可选）
%
% 输出参数：
%   rho_opt - 优化后的密度矩阵
%   final_chi2 - 最终卡方值
%   optimization_info - 优化过程详细信息
%
% 作者：Enhanced HMLE Development Team
% 日期：2024
% 版本：v2.0 Enhanced HMLE

    % ==================== 1. 输入验证和初始化 ====================
    if nargin < 3
        error('至少需要3个输入参数：PnD, rho_r, dimension');
    end
    
    if nargin < 4 || isempty(options)
        options = struct();
    end
    
    % 设置默认选项
    options = set_default_options(options, dimension);
    
    % 数据预处理和验证
    [PnD_processed, data_quality] = preprocess_measurement_data(PnD, dimension, options);
    
    % 显示开始信息
    if options.verbose
        fprintf('\n=== 增强版HMLE量子态重构开始 ===\n');
        fprintf('维度: %d, 数据质量: %.3f\n', dimension, data_quality.overall_quality);
    end
    
    % ==================== 2. 多信息融合的先验分析 ====================
    % 这是E-HMLE的核心创新：不是简单使用线性重构结果，而是融合多种信息源
    [prior_info, rho_prior] = multi_source_prior_analysis(PnD_processed, rho_r, dimension, options);
    
    if options.verbose
        fprintf('先验分析完成 - 检测秩: %d, 置信度: %.3f\n', ...
                prior_info.detected_rank, prior_info.confidence);
    end
    
    % ==================== 3. 自适应参数调整 ====================
    % 根据数据质量和先验信息动态调整算法参数
    options = adaptive_parameter_adjustment(options, data_quality, prior_info);
    
    if options.verbose
        fprintf('参数调整完成 - 多起点数: %d, 遗传算法代数: %d\n', ...
                options.num_random_starts, options.ga_generations);
    end
    
    % ==================== 4. 多起点混合优化 ====================
    % 结合多种优化策略，避免局部最优
    all_results = [];
    
    % 4.1 线性重构起点（传统HMLE的核心）
    [rho_linear, chi2_linear, linear_info] = optimize_linear_start(PnD_processed, rho_prior, dimension, options);
    all_results = [all_results; struct('rho', rho_linear, 'chi2', chi2_linear, 'method', 'linear', 'info', linear_info)];
    
    % 4.2 多个随机起点
    for i = 1:options.num_random_starts
        [rho_random, chi2_random, random_info] = optimize_random_start(PnD_processed, dimension, rho_prior, options, i);
        all_results = [all_results; struct('rho', rho_random, 'chi2', chi2_random, 'method', 'random', 'info', random_info)];
    end
    
    % 4.3 遗传算法全局优化
    [rho_ga, chi2_ga, ga_info] = optimize_genetic_algorithm(PnD_processed, dimension, rho_prior, options);
    all_results = [all_results; struct('rho', rho_ga, 'chi2', chi2_ga, 'method', 'genetic', 'info', ga_info)];
    
    % 4.4 模拟退火算法（可选）
    if options.enable_simulated_annealing
        [rho_sa, chi2_sa, sa_info] = optimize_simulated_annealing(PnD_processed, dimension, rho_prior, options);
        all_results = [all_results; struct('rho', rho_sa, 'chi2', chi2_sa, 'method', 'simulated_annealing', 'info', sa_info)];
    end
    
    % ==================== 5. 智能结果选择 ====================
    % 基于多指标评估的客观选择，而不是简单选择卡方值最小的
    [rho_opt, final_chi2, selection_info] = intelligent_result_selection(all_results, prior_info, options);
    
    if options.verbose
        fprintf('结果选择完成 - 选择方法: %s, 最终卡方: %.6f\n', ...
                selection_info.selected_method, final_chi2);
    end
    
    % ==================== 6. 后处理和验证 ====================
    % 确保结果的物理有效性和数值稳定性
    [rho_opt, postprocess_info] = postprocess_result(rho_opt, final_chi2, prior_info, options);
    
    % ==================== 7. 结果整理和输出 ====================
    optimization_info = struct();
    optimization_info.data_quality = data_quality;
    optimization_info.prior_info = prior_info;
    optimization_info.all_results = all_results;
    optimization_info.selection_info = selection_info;
    optimization_info.postprocess_info = postprocess_info;
    optimization_info.final_rank = rank(rho_opt, 1e-10);
    optimization_info.final_purity = trace(rho_opt^2);
    optimization_info.final_fidelity = calculate_fidelity(rho_opt, rho_prior);
    
    if options.verbose
        fprintf('\n=== 增强版HMLE重构完成 ===\n');
        fprintf('最终秩: %d, 纯度: %.6f, 保真度: %.6f\n', ...
                optimization_info.final_rank, optimization_info.final_purity, optimization_info.final_fidelity);
    end
end

% ==================== 辅助函数 ====================

function options = set_default_options(options, dimension)
    % 设置默认选项参数
    % 这些参数根据量子态维度和数据质量自适应调整
    
    if ~isfield(options, 'verbose'), options.verbose = true; end
    if ~isfield(options, 'max_iterations'), options.max_iterations = 1000; end
    if ~isfield(options, 'tolerance'), options.tolerance = 1e-6; end
    if ~isfield(options, 'num_random_starts'), options.num_random_starts = 10; end
    if ~isfield(options, 'ga_generations'), options.ga_generations = 50; end
    if ~isfield(options, 'ga_population_size'), options.ga_population_size = 20; end
    if ~isfield(options, 'enable_simulated_annealing'), options.enable_simulated_annealing = false; end
    if ~isfield(options, 'rank_constraint_strategy'), options.rank_constraint_strategy = 'adaptive'; end
    if ~isfield(options, 'min_rank'), options.min_rank = 1; end
    if ~isfield(options, 'max_rank'), options.max_rank = dimension; end
    if ~isfield(options, 'chi2_threshold'), options.chi2_threshold = 1e-4; end
    if ~isfield(options, 'physical_tolerance'), options.physical_tolerance = 1e-10; end
end

function [PnD_processed, data_quality] = preprocess_measurement_data(PnD, dimension, options)
    % 数据预处理和质量评估
    % 包括数据清洗、归一化、噪声评估等
    
    % 数据清洗
    PnD_processed = PnD;
    PnD_processed(PnD_processed < 0) = 0;  % 确保非负
    PnD_processed = PnD_processed / sum(PnD_processed);  % 归一化
    
    % 数据质量评估
    data_quality = struct();
    data_quality.noise_level = calculate_noise_level(PnD_processed);
    data_quality.condition_number = calculate_condition_number(PnD_processed);
    data_quality.entropy = calculate_entropy(PnD_processed);
    data_quality.overall_quality = (1 - data_quality.noise_level) * (1 / data_quality.condition_number) * data_quality.entropy;
end

function [prior_info, rho_prior] = multi_source_prior_analysis(PnD, rho_r, dimension, options)
    % 多信息融合的先验分析
    % 这是E-HMLE的核心创新：结合多种信息源进行先验分析
    
    prior_info = struct();
    
    % 1. 线性重构分析
    [linear_rank, linear_confidence] = analyze_linear_reconstruction(rho_r, dimension);
    
    % 2. 概率分布分析
    [prob_rank, prob_confidence] = analyze_probability_distribution(PnD, dimension);
    
    % 3. 统计测试分析
    [stat_rank, stat_confidence] = statistical_rank_test(PnD, dimension);
    
    % 4. 信息融合
    prior_info.linear_rank = linear_rank;
    prior_info.linear_confidence = linear_confidence;
    prior_info.prob_rank = prob_rank;
    prior_info.prob_confidence = prob_confidence;
    prior_info.stat_rank = stat_rank;
    prior_info.stat_confidence = stat_confidence;
    
    % 加权融合确定最终秩估计
    weights = [linear_confidence, prob_confidence, stat_confidence];
    weights = weights / sum(weights);
    prior_info.detected_rank = round(weights(1) * linear_rank + weights(2) * prob_rank + weights(3) * stat_rank);
    prior_info.confidence = max(weights);
    
    % 确定秩约束策略
    if prior_info.detected_rank == 1 && prior_info.confidence > 0.8
        prior_info.rank_strategy = 'pure_state';
        prior_info.min_rank = 1;
    elseif prior_info.detected_rank > 1 && prior_info.confidence > 0.7
        prior_info.rank_strategy = 'detected';
        prior_info.min_rank = prior_info.detected_rank;
    else
        prior_info.rank_strategy = 'flexible';
        prior_info.min_rank = 1;
    end
    
    rho_prior = rho_r;
end

function [linear_rank, confidence] = analyze_linear_reconstruction(rho_r, dimension)
    % 分析线性重构结果的秩
    % 这是传统HMLE的核心先验信息源
    
    [~, eigenvals] = eig(rho_r);
    eigenvals = real(diag(eigenvals));
    eigenvals = sort(eigenvals, 'descend');
    
    % 计算有效秩
    threshold = 1e-10;
    linear_rank = sum(eigenvals > threshold);
    
    % 计算置信度（基于特征值分布的均匀性）
    if linear_rank == 1
        confidence = 0.9;  % 纯态通常有很高的置信度
    else
        % 混态的置信度基于特征值分布的均匀性
        if linear_rank > 1
            uniformity = 1 - std(eigenvals(1:linear_rank)) / mean(eigenvals(1:linear_rank));
            confidence = max(0.3, min(0.9, uniformity));
        else
            confidence = 0.5;
        end
    end
end

function [prob_rank, confidence] = analyze_probability_distribution(PnD, dimension)
    % 基于概率分布分析秩
    % 通过测量概率的分布特征推断量子态的秩
    
    % 计算概率熵
    prob_entropy = -sum(PnD .* log(PnD + eps));
    max_entropy = log(dimension^2);
    normalized_entropy = prob_entropy / max_entropy;
    
    % 基于熵估计秩
    if normalized_entropy < 0.3
        prob_rank = 1;  % 低熵通常对应纯态
        confidence = 0.8;
    elseif normalized_entropy < 0.7
        prob_rank = round(sqrt(dimension));
        confidence = 0.6;
    else
        prob_rank = dimension;
        confidence = 0.4;
    end
end

function [stat_rank, confidence] = statistical_rank_test(PnD, dimension)
    % 统计测试分析秩
    % 使用统计方法估计量子态的秩
    
    % 这里可以实现更复杂的统计测试
    % 目前使用简化的方法
    stat_rank = round(sqrt(dimension));
    confidence = 0.5;
end

function options = adaptive_parameter_adjustment(options, data_quality, prior_info)
    % 自适应参数调整
    % 根据数据质量和先验信息动态调整算法参数
    
    % 根据数据质量调整迭代次数
    if data_quality.overall_quality > 0.8
        options.max_iterations = round(options.max_iterations * 0.8);  % 高质量数据，减少迭代
    elseif data_quality.overall_quality < 0.5
        options.max_iterations = round(options.max_iterations * 1.5);  % 低质量数据，增加迭代
    end
    
    % 根据先验信息调整多起点数
    if prior_info.confidence > 0.8
        options.num_random_starts = max(5, round(options.num_random_starts * 0.7));  % 高置信度，减少随机起点
    else
        options.num_random_starts = min(20, round(options.num_random_starts * 1.3));  % 低置信度，增加随机起点
    end
    
    % 根据秩信息调整遗传算法参数
    if prior_info.detected_rank == 1
        options.ga_generations = round(options.ga_generations * 0.8);  % 纯态，减少代数
    else
        options.ga_generations = round(options.ga_generations * 1.2);  % 混态，增加代数
    end
end

function [rho_opt, chi2_opt, info] = optimize_linear_start(PnD, rho_prior, dimension, options)
    % 线性重构起点优化
    % 这是传统HMLE的核心：使用线性重构结果作为起点
    
    info = struct();
    info.method = 'linear_start';
    info.start_time = tic;
    
    try
        % 使用线性重构结果作为起点
        initial_guess = FindInitialT(rho_prior, dimension);
        
        % 执行优化
        [rho_opt, chi2_opt, opt_info] = optimize_single_start(initial_guess, PnD, dimension, options);
        
        info.success = true;
        info.optimization_info = opt_info;
    catch ME
        info.success = false;
        info.error = ME.message;
        rho_opt = rho_prior;
        chi2_opt = inf;
    end
    
    info.elapsed_time = toc(info.start_time);
end

function [rho_opt, chi2_opt, info] = optimize_random_start(PnD, dimension, rho_prior, options, start_idx)
    % 随机起点优化
    % 通过多个随机起点避免局部最优
    
    info = struct();
    info.method = 'random_start';
    info.start_idx = start_idx;
    info.start_time = tic;
    
    try
        % 生成随机起点
        random_guess = generate_random_initial_guess(dimension, rho_prior, options);
        
        % 执行优化
        [rho_opt, chi2_opt, opt_info] = optimize_single_start(random_guess, PnD, dimension, options);
        
        info.success = true;
        info.optimization_info = opt_info;
    catch ME
        info.success = false;
        info.error = ME.message;
        rho_opt = rho_prior;
        chi2_opt = inf;
    end
    
    info.elapsed_time = toc(info.start_time);
end

function [rho_opt, chi2_opt, info] = optimize_genetic_algorithm(PnD, dimension, rho_prior, options)
    % 遗传算法全局优化
    % 使用遗传算法进行全局搜索，避免局部最优
    
    info = struct();
    info.method = 'genetic_algorithm';
    info.start_time = tic;
    
    try
        % 设置遗传算法参数
        ga_options = optimoptions('ga', ...
            'Display', 'off', ...
            'MaxGenerations', options.ga_generations, ...
            'PopulationSize', options.ga_population_size, ...
            'TolFun', options.tolerance, ...
            'TolCon', options.tolerance);
        
        % 定义优化问题
        num_params = dimension * (dimension + 1) / 2 * 2 - dimension;
        lb = -10 * ones(num_params, 1);
        ub = 10 * ones(num_params, 1);
        
        % 执行遗传算法优化
        [params, chi2_opt, exitflag, output] = ga(@(params) likelihood_function(params, PnD, [], dimension), ...
            num_params, [], [], [], [], lb, ub, [], ga_options);
        
        % 构造密度矩阵
        rho_opt = construct_density_matrix(params, dimension);
        
        info.success = true;
        info.exitflag = exitflag;
        info.output = output;
    catch ME
        info.success = false;
        info.error = ME.message;
        rho_opt = rho_prior;
        chi2_opt = inf;
    end
    
    info.elapsed_time = toc(info.start_time);
end

function [rho_opt, chi2_opt, info] = optimize_simulated_annealing(PnD, dimension, rho_prior, options)
    % 模拟退火算法优化
    % 使用模拟退火进行全局搜索
    
    info = struct();
    info.method = 'simulated_annealing';
    info.start_time = tic;
    
    try
        % 设置模拟退火参数
        sa_options = optimoptions('simulannealbnd', ...
            'Display', 'off', ...
            'MaxIterations', options.max_iterations, ...
            'TolFun', options.tolerance);
        
        % 定义优化问题
        num_params = dimension * (dimension + 1) / 2 * 2 - dimension;
        lb = -10 * ones(num_params, 1);
        ub = 10 * ones(num_params, 1);
        
        % 执行模拟退火优化
        [params, chi2_opt, exitflag, output] = simulannealbnd(@(params) likelihood_function(params, PnD, [], dimension), ...
            zeros(num_params, 1), lb, ub, sa_options);
        
        % 构造密度矩阵
        rho_opt = construct_density_matrix(params, dimension);
        
        info.success = true;
        info.exitflag = exitflag;
        info.output = output;
    catch ME
        info.success = false;
        info.error = ME.message;
        rho_opt = rho_prior;
        chi2_opt = inf;
    end
    
    info.elapsed_time = toc(info.start_time);
end

function [rho_opt, chi2_opt, info] = optimize_single_start(initial_guess, PnD, dimension, options)
    % 单起点优化
    % 使用fmincon进行局部优化
    
    % 设置优化选项
    fmincon_options = optimoptions('fmincon', ...
        'Display', 'off', ...
        'Algorithm', 'sqp', ...
        'MaxIterations', options.max_iterations, ...
        'TolFun', options.tolerance, ...
        'TolX', options.tolerance);
    
    % 定义约束
    num_params = length(initial_guess);
    lb = -inf(num_params, 1);
    ub = inf(num_params, 1);
    
    % 执行优化
    [params, chi2_opt, exitflag, output] = fmincon(@(params) likelihood_function(params, PnD, [], dimension), ...
        initial_guess, [], [], [], [], lb, ub, [], fmincon_options);
    
    % 构造密度矩阵
    rho_opt = construct_density_matrix(params, dimension);
    
    info = struct();
    info.exitflag = exitflag;
    info.output = output;
end

function [rho_opt, chi2_opt, info] = intelligent_result_selection(all_results, prior_info, options)
    % 智能结果选择
    % 基于多指标评估的客观选择，而不是简单选择卡方值最小的
    
    info = struct();
    info.method = 'intelligent_selection';
    
    % 计算每个结果的综合评分
    scores = zeros(length(all_results), 1);
    for i = 1:length(all_results)
        scores(i) = calculate_comprehensive_score(all_results(i), prior_info, options);
    end
    
    % 选择评分最高的结果
    [~, best_idx] = max(scores);
    rho_opt = all_results(best_idx).rho;
    chi2_opt = all_results(best_idx).chi2;
    
    info.selected_method = all_results(best_idx).method;
    info.scores = scores;
    info.best_score = scores(best_idx);
end

function score = calculate_comprehensive_score(result, prior_info, options)
    % 计算综合评分
    % 考虑卡方值、物理有效性、秩一致性等多个指标
    
    % 1. 卡方值评分（越小越好）
    chi2_score = 1 / (1 + result.chi2);
    
    % 2. 物理有效性评分
    physical_score = calculate_physical_validity_score(result.rho);
    
    % 3. 秩一致性评分
    rank_score = calculate_rank_consistency_score(result.rho, prior_info);
    
    % 4. 数值稳定性评分
    stability_score = calculate_numerical_stability_score(result.rho);
    
    % 加权综合评分
    weights = [0.4, 0.3, 0.2, 0.1];  % 卡方值权重最高
    score = weights(1) * chi2_score + weights(2) * physical_score + ...
            weights(3) * rank_score + weights(4) * stability_score;
end

function [rho_opt, info] = postprocess_result(rho_opt, chi2_opt, prior_info, options)
    % 后处理和验证
    % 确保结果的物理有效性和数值稳定性
    
    info = struct();
    info.method = 'postprocessing';
    
    % 1. 物理有效性检查
    [rho_opt, physical_info] = ensure_physical_validity(rho_opt, options);
    
    % 2. 秩约束应用
    [rho_opt, rank_info] = apply_rank_constraints(rho_opt, prior_info, options);
    
    % 3. 数值稳定性优化
    [rho_opt, stability_info] = improve_numerical_stability(rho_opt, options);
    
    info.physical_info = physical_info;
    info.rank_info = rank_info;
    info.stability_info = stability_info;
end

function [rho_opt, info] = ensure_physical_validity(rho_opt, options)
    % 确保物理有效性
    % 确保密度矩阵是正半定的、归一化的
    
    info = struct();
    
    % 使用makephysical函数确保物理有效性
    rho_opt = makephysical(rho_opt);
    
    % 检查结果
    info.is_positive_semidefinite = all(real(eig(rho_opt)) >= -options.physical_tolerance);
    info.is_normalized = abs(trace(rho_opt) - 1) < options.physical_tolerance;
    info.is_hermitian = norm(rho_opt - rho_opt') < options.physical_tolerance;
end

function [rho_opt, info] = apply_rank_constraints(rho_opt, prior_info, options)
    % 应用秩约束
    % 根据先验信息应用相应的秩约束
    
    info = struct();
    info.strategy = prior_info.rank_strategy;
    
    switch prior_info.rank_strategy
        case 'pure_state'
            % 纯态约束：确保秩为1
            [rho_opt, info] = enforce_pure_state_constraint(rho_opt, options);
        case 'detected'
            % 检测到的秩约束：确保秩不小于检测值
            [rho_opt, info] = enforce_detected_rank_constraint(rho_opt, prior_info.min_rank, options);
        case 'flexible'
            % 灵活约束：不强制秩约束
            info.applied = false;
        otherwise
            info.applied = false;
    end
end

function [rho_opt, info] = enforce_pure_state_constraint(rho_opt, options)
    % 强制纯态约束
    % 确保密度矩阵的秩为1
    
    info = struct();
    info.constraint_type = 'pure_state';
    
    % 使用SVD分解
    [U, S, V] = svd(rho_opt);
    s = diag(S);
    
    % 只保留最大的奇异值
    s(2:end) = 0;
    S = diag(s);
    
    % 重构密度矩阵
    rho_opt = U * S * V';
    rho_opt = rho_opt / trace(rho_opt);
    
    info.original_rank = sum(s > options.physical_tolerance);
    info.final_rank = 1;
    info.applied = true;
end

function [rho_opt, info] = enforce_detected_rank_constraint(rho_opt, min_rank, options)
    % 强制检测到的秩约束
    % 确保密度矩阵的秩不小于检测值
    
    info = struct();
    info.constraint_type = 'detected_rank';
    info.min_rank = min_rank;
    
    % 使用SVD分解
    [U, S, V] = svd(rho_opt);
    s = diag(S);
    
    % 确保至少有min_rank个非零奇异值
    if sum(s > options.physical_tolerance) < min_rank
        % 提升小的奇异值
        s(1:min_rank) = max(s(1:min_rank), options.physical_tolerance);
        s(min_rank+1:end) = 0;
        S = diag(s);
        rho_opt = U * S * V';
        rho_opt = rho_opt / trace(rho_opt);
    end
    
    info.original_rank = sum(s > options.physical_tolerance);
    info.final_rank = sum(s > options.physical_tolerance);
    info.applied = true;
end

function [rho_opt, info] = improve_numerical_stability(rho_opt, options)
    % 改善数值稳定性
    % 通过微调提高数值稳定性
    
    info = struct();
    
    % 确保厄米性
    rho_opt = (rho_opt + rho_opt') / 2;
    
    % 确保归一化
    rho_opt = rho_opt / trace(rho_opt);
    
    % 添加小的正则化项
    rho_opt = rho_opt + eye(size(rho_opt)) * options.physical_tolerance;
    rho_opt = rho_opt / trace(rho_opt);
    
    info.improved = true;
end

function score = calculate_physical_validity_score(rho)
    % 计算物理有效性评分
    % 基于密度矩阵的物理性质
    
    % 检查正半定性
    eigenvals = real(eig(rho));
    positive_score = sum(eigenvals >= 0) / length(eigenvals);
    
    % 检查归一化
    trace_score = 1 - abs(trace(rho) - 1);
    
    % 检查厄米性
    hermitian_score = 1 - norm(rho - rho') / norm(rho);
    
    % 综合评分
    score = (positive_score + trace_score + hermitian_score) / 3;
end

function score = calculate_rank_consistency_score(rho, prior_info)
    % 计算秩一致性评分
    % 基于与先验秩信息的一致性
    
    current_rank = rank(rho, 1e-10);
    
    if strcmp(prior_info.rank_strategy, 'pure_state')
        if current_rank == 1
            score = 1.0;
        else
            score = 0.5;
        end
    elseif strcmp(prior_info.rank_strategy, 'detected')
        if current_rank >= prior_info.min_rank
            score = 1.0;
        else
            score = current_rank / prior_info.min_rank;
        end
    else
        score = 0.8;  % 灵活约束，给予中等评分
    end
end

function score = calculate_numerical_stability_score(rho)
    % 计算数值稳定性评分
    % 基于条件数和数值稳定性
    
    % 计算条件数
    cond_num = cond(rho);
    stability_score = 1 / (1 + log(cond_num));
    
    % 检查数值稳定性
    eigenvals = real(eig(rho));
    min_eigenval = min(eigenvals);
    if min_eigenval > 0
        stability_score = stability_score * 1.2;
    end
    
    score = min(1.0, stability_score);
end

function random_guess = generate_random_initial_guess(dimension, rho_prior, options)
    % 生成随机初始猜测
    % 基于先验信息生成合理的随机起点
    
    num_params = dimension * (dimension + 1) / 2 * 2 - dimension;
    
    % 基于先验信息生成随机起点
    if ~isempty(rho_prior)
        % 使用先验信息作为中心
        prior_guess = FindInitialT(rho_prior, dimension);
        noise_level = 0.1;
        random_guess = prior_guess + noise_level * randn(size(prior_guess));
    else
        % 完全随机生成
        random_guess = 0.1 * randn(num_params, 1);
    end
end

function fidelity = calculate_fidelity(rho1, rho2)
    % 计算两个密度矩阵之间的保真度
    % 使用标准量子保真度公式
    
    if isequal(size(rho1), size(rho2))
        % 计算保真度
        sqrt_rho1 = sqrtm(rho1);
        fidelity = real(trace(sqrtm(sqrt_rho1 * rho2 * sqrt_rho1)))^2;
    else
        fidelity = 0;
    end
end

function noise_level = calculate_noise_level(PnD)
    % 计算数据噪声水平
    % 基于概率分布的均匀性
    
    % 计算概率分布的方差
    prob_variance = var(PnD);
    max_variance = 0.25;  % 最大可能方差
    noise_level = min(1.0, prob_variance / max_variance);
end

function condition_num = calculate_condition_number(PnD)
    % 计算数据条件数
    % 基于概率分布的条件数
    
    % 计算概率矩阵的条件数
    prob_matrix = reshape(PnD, sqrt(length(PnD)), []);
    condition_num = cond(prob_matrix);
end

function entropy = calculate_entropy(PnD)
    % 计算概率分布的熵
    % 用于评估数据的信息量
    
    % 避免log(0)
    PnD_safe = PnD + eps;
    entropy = -sum(PnD_safe .* log(PnD_safe));
end