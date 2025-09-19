% 测试测量数据预处理的回退策略
% 覆盖零和与近零和输入的处理流程，确保算法能够给出明确的错误或稳定的输出。

clear; clc;

fprintf('=== 测量数据预处理回退策略测试 ===\n');

dimension = 2;
identity_state = eye(dimension) / dimension;

%% 测试 1：零和输入触发均匀分布回退
options_uniform = struct();
options_uniform.verbose = false;
options_uniform.max_iterations = 5;
options_uniform.num_random_starts = 1;
options_uniform.ga_generations = 5;
options_uniform.ga_population_size = 4;
options_uniform.probability_sum_threshold = 1e-6;
options_uniform.probability_sum_fallback = 'uniform';

PnD_zero = zeros(dimension^2, 1);

try
    [~, ~, info_uniform] = reconstruct_density_matrix_nD_MLE_enhanced(PnD_zero, identity_state, dimension, options_uniform);
    assert(info_uniform.data_quality.fallback_triggered, '零和输入应触发回退策略。');
    assert(strcmp(info_uniform.data_quality.fallback_strategy, 'uniform'), '回退策略应为均匀分布。');
    assert(abs(sum(info_uniform.data_quality.processed_distribution) - 1) < 1e-9, ...
        '回退后的分布应保持归一化。');
    assert(isfinite(info_uniform.data_quality.overall_quality), '数据质量评分应为有限值。');
    fprintf('1. 零和输入触发均匀分布回退：通过\n');
catch ME
    fprintf('1. 零和输入触发均匀分布回退：失败 - %s\n', ME.message);
end

%% 测试 2：零和输入配合 error 回退策略应直接报错
options_error = options_uniform;
options_error.probability_sum_fallback = 'error';

try
    reconstruct_density_matrix_nD_MLE_enhanced(PnD_zero, identity_state, dimension, options_error);
    fprintf('2. 零和输入触发错误：失败 - 未抛出预期错误\n');
catch ME
    if strcmp(ME.identifier, 'preprocess_measurement_data:InvalidTotalProbability')
        fprintf('2. 零和输入触发错误：通过\n');
    else
        fprintf('2. 零和输入触发错误：失败 - %s\n', ME.message);
    end
end

%% 测试 3：近零和输入应稳定回退到均匀分布
PnD_near_zero = ones(dimension^2, 1) * 1e-12;

try
    [~, ~, info_near_zero] = reconstruct_density_matrix_nD_MLE_enhanced(PnD_near_zero, identity_state, dimension, options_uniform);
    assert(info_near_zero.data_quality.fallback_triggered, '近零和输入应触发回退策略。');
    assert(all(abs(info_near_zero.data_quality.processed_distribution - 1 / numel(PnD_near_zero)) < 1e-9), ...
        '近零和输入应被替换为均匀分布。');
    fprintf('3. 近零和输入触发均匀分布回退：通过\n');
catch ME
    fprintf('3. 近零和输入触发均匀分布回退：失败 - %s\n', ME.message);
end

fprintf('=== 测试结束 ===\n');
