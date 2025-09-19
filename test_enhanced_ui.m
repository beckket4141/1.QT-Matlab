% 测试增强版量子层析UI界面
% 用于验证新的可视化功能

clear; clc; close all;

fprintf('===========================================\n');
fprintf('  测试增强版量子层析UI界面\n');
fprintf('===========================================\n');

% 检查必要函数是否存在
required_functions = {'quantum_tomography_ui_with_bell', ...
                     'reconstruct_density_matrix_nD', ...
                     'likelihood_function', ...
                     'reconstruct_density_matrix_nD_MLE', ...
                     'Bell_state', ...
                     'fidelity', ...
                     'theoretical_measurement_powers_nD_fun', ...
                     'matrix_square_root'};

missing_functions = {};
for i = 1:length(required_functions)
    if ~exist(required_functions{i}, 'file')
        missing_functions{end+1} = required_functions{i};
    end
end

if ~isempty(missing_functions)
    fprintf('警告: 以下必要函数未找到:\n');
    for i = 1:length(missing_functions)
        fprintf('  - %s\n', missing_functions{i});
    end
    fprintf('请确保这些函数在MATLAB路径中\n');
    fprintf('===========================================\n');
    return;
end

% 启动增强版UI
fprintf('启动增强版UI界面...\n');
try
    quantum_tomography_ui_with_bell();
    fprintf('UI界面启动成功！\n');
    fprintf('===========================================\n');
    fprintf('新功能说明:\n');
    fprintf('1. 左侧控制面板 - 参数设置和进度显示\n');
    fprintf('2. 右侧可视化区域 - 实时显示计算结果\n');
    fprintf('   - 密度矩阵热图\n');
    fprintf('   - 振幅分布图\n');
    fprintf('   - 相位分布图\n');
    fprintf('   - 谱分解结果\n');
    fprintf('3. 清空显示按钮 - 重置所有可视化\n');
    fprintf('===========================================\n');
catch ME
    fprintf('启动UI时出现错误: %s\n', ME.message);
    fprintf('请检查MATLAB版本和必要文件是否存在\n');
    fprintf('===========================================\n');
end
