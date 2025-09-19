% 测试增强版HMLE程序
% 验证所有功能是否正常工作

clear; clc; close all;

fprintf('=== 增强版HMLE测试开始 ===\n');

% 测试参数
dimension = 2;
options = struct();
options.verbose = true;
options.enable_simulated_annealing = true;

% 生成测试数据
fprintf('\n1. 生成测试数据...\n');

% 生成一个纯态（秩=1）
psi_pure = [1; 0];  % |0⟩态
rho_pure = psi_pure * psi_pure';

% 生成测量概率
[~, mu] = generate_projectors_and_operators(dimension);
PnD_pure = zeros(dimension^2, 1);
for k = 1:dimension^2
    PnD_pure(k) = real(trace(rho_pure * mu{k}));
end

% 添加噪声
noise_level = 0.05;
PnD_pure = PnD_pure + noise_level * randn(size(PnD_pure));
PnD_pure = max(PnD_pure, 0);  % 确保非负
PnD_pure = PnD_pure / sum(PnD_pure);  % 归一化

% 生成线性重构结果
rho_linear = reconstruct_density_matrix_nD(PnD_pure, dimension);

fprintf('纯态测试数据生成完成\n');
fprintf('真实秩: %d, 线性重构秩: %d\n', rank(rho_pure, 1e-10), rank(rho_linear, 1e-10));

% 测试增强版HMLE
fprintf('\n2. 运行增强版HMLE...\n');

try
    [rho_opt, final_chi2, optimization_info] = reconstruct_density_matrix_nD_MLE_enhanced(...
        PnD_pure, rho_linear, dimension, options);
    
    fprintf('\n=== 增强版HMLE测试结果 ===\n');
    fprintf('最终卡方值: %.6f\n', final_chi2);
    fprintf('最终秩: %d\n', optimization_info.final_rank);
    fprintf('最终纯度: %.6f\n', optimization_info.final_purity);
    fprintf('最终保真度: %.6f\n', optimization_info.final_fidelity);
    fprintf('选择的方法: %s\n', optimization_info.selection_info.selected_method);
    
    % 显示先验分析结果
    fprintf('\n=== 先验分析结果 ===\n');
    fprintf('线性重构秩: %d (置信度: %.3f)\n', ...
            optimization_info.prior_info.linear_rank, optimization_info.prior_info.linear_confidence);
    fprintf('概率分布秩: %d (置信度: %.3f)\n', ...
            optimization_info.prior_info.prob_rank, optimization_info.prior_info.prob_confidence);
    fprintf('统计测试秩: %d (置信度: %.3f)\n', ...
            optimization_info.prior_info.stat_rank, optimization_info.prior_info.stat_confidence);
    fprintf('融合后检测秩: %d (置信度: %.3f)\n', ...
            optimization_info.prior_info.detected_rank, optimization_info.prior_info.confidence);
    fprintf('秩约束策略: %s\n', optimization_info.prior_info.rank_strategy);
    
    % 显示所有优化结果
    fprintf('\n=== 所有优化结果对比 ===\n');
    for i = 1:length(optimization_info.all_results)
        result = optimization_info.all_results(i);
        fprintf('方法: %s, 卡方: %.6f, 秩: %d, 纯度: %.6f\n', ...
                result.method, result.chi2, rank(result.rho, 1e-10), trace(result.rho^2));
    end
    
    % 显示评分详情
    fprintf('\n=== 综合评分详情 ===\n');
    for i = 1:length(optimization_info.selection_info.scores)
        result = optimization_info.all_results(i);
        score = optimization_info.selection_info.scores(i);
        fprintf('方法: %s, 综合评分: %.4f\n', result.method, score);
    end
    
    fprintf('\n=== 增强版HMLE测试成功完成 ===\n');
    
catch ME
    fprintf('\n=== 测试失败 ===\n');
    fprintf('错误信息: %s\n', ME.message);
    fprintf('错误位置: %s (第 %d 行)\n', ME.stack(1).name, ME.stack(1).line);
end

% 测试混态情况
fprintf('\n\n=== 混态测试 ===\n');

% 生成混态
rho_mixed = 0.7 * rho_pure + 0.3 * eye(dimension) / dimension;
[~, mu] = generate_projectors_and_operators(dimension);
PnD_mixed = zeros(dimension^2, 1);
for k = 1:dimension^2
    PnD_mixed(k) = real(trace(rho_mixed * mu{k}));
end

% 添加噪声
PnD_mixed = PnD_mixed + noise_level * randn(size(PnD_mixed));
PnD_mixed = max(PnD_mixed, 0);
PnD_mixed = PnD_mixed / sum(PnD_mixed);

% 线性重构
rho_linear_mixed = reconstruct_density_matrix_nD(PnD_mixed, dimension);

fprintf('混态测试数据生成完成\n');
fprintf('真实秩: %d, 线性重构秩: %d\n', rank(rho_mixed, 1e-10), rank(rho_linear_mixed, 1e-10));

try
    [rho_opt_mixed, final_chi2_mixed, optimization_info_mixed] = reconstruct_density_matrix_nD_MLE_enhanced(...
        PnD_mixed, rho_linear_mixed, dimension, options);
    
    fprintf('\n=== 混态测试结果 ===\n');
    fprintf('最终卡方值: %.6f\n', final_chi2_mixed);
    fprintf('最终秩: %d\n', optimization_info_mixed.final_rank);
    fprintf('最终纯度: %.6f\n', optimization_info_mixed.final_purity);
    fprintf('最终保真度: %.6f\n', optimization_info_mixed.final_fidelity);
    fprintf('选择的方法: %s\n', optimization_info_mixed.selection_info.selected_method);
    fprintf('秩约束策略: %s\n', optimization_info_mixed.prior_info.rank_strategy);
    
    fprintf('\n=== 混态测试成功完成 ===\n');
    
catch ME
    fprintf('\n=== 混态测试失败 ===\n');
    fprintf('错误信息: %s\n', ME.message);
end

fprintf('\n=== 所有测试完成 ===\n');
