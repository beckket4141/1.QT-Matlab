% 测试改进的最大似然法，比较原始方法和改进方法的效果
clear; clc; close all;

% 设置测试参数
dimension = 4;
fprintf('=== 测试维度: %d ===\n', dimension);

% 生成测试数据（使用已知的密度矩阵）
% 创建一个已知的4维密度矩阵用于测试
rho_true = [0.3, 0.1+0.05i, 0.05-0.02i, 0.08+0.03i;
           0.1-0.05i, 0.25, 0.06+0.04i, 0.07-0.01i;
           0.05+0.02i, 0.06-0.04i, 0.2, 0.09+0.06i;
           0.08-0.03i, 0.07+0.01i, 0.09-0.06i, 0.25];

% 确保密度矩阵是物理的
rho_true = makephysical(rho_true);

% 生成理论测量概率
[~, mu] = generate_projectors_and_operators(dimension);
P_theory = zeros(dimension^2, 1);
for k = 1:dimension^2
    P_theory(k) = real(trace(rho_true * mu{k}));
end

% 添加噪声模拟实验误差
noise_level = 0.05; % 5%的噪声
P_noisy = P_theory + noise_level * randn(size(P_theory)) .* sqrt(P_theory);
P_noisy = max(P_noisy, 0); % 确保概率非负
P_noisy = P_noisy / sum(P_noisy); % 重新归一化

fprintf('真实密度矩阵的纯度: %.6f\n', sum(diag(rho_true * rho_true)));

% 1. 使用原始线性重构
fprintf('\n--- 原始线性重构 ---\n');
rho_linear = reconstruct_density_matrix_nD(P_noisy, dimension);
fidelity_linear = fidelity(rho_true, rho_linear);
chi2_linear = likelihood_function([], P_noisy, rho_linear, dimension);
fprintf('线性重构保真度: %.6f\n', fidelity_linear);
fprintf('线性重构chi2: %.2e\n', chi2_linear);

% 2. 使用原始MLE方法
fprintf('\n--- 原始MLE方法 ---\n');
[rho_mle_original, chi2_mle_original] = reconstruct_density_matrix_nD_MLE(P_noisy, rho_linear, dimension);
fidelity_mle_original = fidelity(rho_true, rho_mle_original);
fprintf('原始MLE保真度: %.6f\n', fidelity_mle_original);
fprintf('原始MLE chi2: %.2e\n', chi2_mle_original);

% 3. 使用改进的MLE方法
fprintf('\n--- 改进MLE方法 ---\n');
[rho_mle_improved, chi2_mle_improved, opt_info] = reconstruct_density_matrix_nD_MLE_improved(P_noisy, rho_linear, dimension);
fidelity_mle_improved = fidelity(rho_true, rho_mle_improved);
fprintf('改进MLE保真度: %.6f\n', fidelity_mle_improved);
fprintf('改进MLE chi2: %.2e\n', chi2_mle_improved);

% 4. 结果比较
fprintf('\n=== 结果比较 ===\n');
fprintf('方法\t\t保真度\t\tchi2\t\t改进\n');
fprintf('线性重构\t%.6f\t%.2e\t-\n', fidelity_linear, chi2_linear);
fprintf('原始MLE\t\t%.6f\t%.2e\t%.2e\n', fidelity_mle_original, chi2_mle_original, chi2_linear - chi2_mle_original);
fprintf('改进MLE\t\t%.6f\t%.2e\t%.2e\n', fidelity_mle_improved, chi2_mle_improved, chi2_linear - chi2_mle_improved);

% 5. 可视化比较
figure('Position', [100, 100, 1200, 400]);

% 真实密度矩阵
subplot(1, 4, 1);
imagesc(real(rho_true));
colorbar;
title('真实密度矩阵');
axis square;

% 线性重构
subplot(1, 4, 2);
imagesc(real(rho_linear));
colorbar;
title(sprintf('线性重构\n保真度: %.4f', fidelity_linear));
axis square;

% 原始MLE
subplot(1, 4, 3);
imagesc(real(rho_mle_original));
colorbar;
title(sprintf('原始MLE\n保真度: %.4f', fidelity_mle_original));
axis square;

% 改进MLE
subplot(1, 4, 4);
imagesc(real(rho_mle_improved));
colorbar;
title(sprintf('改进MLE\n保真度: %.4f', fidelity_mle_improved));
axis square;

% 6. 多次运行测试稳定性
fprintf('\n=== 稳定性测试（运行10次） ===\n');
num_runs = 10;
fidelity_improved_runs = zeros(num_runs, 1);
chi2_improved_runs = zeros(num_runs, 1);

for run = 1:num_runs
    % 重新生成噪声数据
    P_noisy_run = P_theory + noise_level * randn(size(P_theory)) .* sqrt(P_theory);
    P_noisy_run = max(P_noisy_run, 0);
    P_noisy_run = P_noisy_run / sum(P_noisy_run);
    
    % 线性重构
    rho_linear_run = reconstruct_density_matrix_nD(P_noisy_run, dimension);
    
    % 改进MLE
    [rho_improved_run, chi2_improved_run] = reconstruct_density_matrix_nD_MLE_improved(P_noisy_run, rho_linear_run, dimension);
    
    fidelity_improved_runs(run) = fidelity(rho_true, rho_improved_run);
    chi2_improved_runs(run) = chi2_improved_run;
end

fprintf('改进MLE平均保真度: %.6f ± %.6f\n', mean(fidelity_improved_runs), std(fidelity_improved_runs));
fprintf('改进MLE平均chi2: %.2e ± %.2e\n', mean(chi2_improved_runs), std(chi2_improved_runs));

% 7. 分析优化过程
if isfield(opt_info, 'all_results')
    fprintf('\n=== 优化过程分析 ===\n');
    methods = {opt_info.all_results.method};
    chi2_values = [opt_info.all_results.chi2];
    
    for i = 1:length(methods)
        fprintf('%s方法: chi2 = %.2e\n', methods{i}, chi2_values(i));
    end
    
    fprintf('最佳方法: %s\n', opt_info.best_method);
    fprintf('相比线性方法改进: %.2e\n', opt_info.improvement);
end

fprintf('\n测试完成！\n');
