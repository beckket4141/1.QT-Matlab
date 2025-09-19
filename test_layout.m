% 测试优化后的UI布局
% 验证排布是否合理，显示是否完整

clear; clc; close all;

fprintf('===========================================\n');
fprintf('  测试优化后的UI布局\n');
fprintf('===========================================\n');

% 检查必要函数是否存在
required_functions = {'quantum_tomography_ui_with_bell', ...
                     'reconstruct_density_matrix_nD', ...
                     'likelihood_function', ...
                     'reconstruct_density_matrix_nD_MLE'};

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

% 获取屏幕信息
screen_size = get(0, 'ScreenSize');
fprintf('屏幕尺寸: %dx%d\n', screen_size(3), screen_size(4));

% 计算推荐窗口尺寸
window_width = min(1200, screen_size(3) * 0.8);
window_height = min(800, screen_size(4) * 0.8);
fprintf('推荐窗口尺寸: %dx%d\n', window_width, window_height);

% 启动优化后的UI
fprintf('\n启动优化后的UI界面...\n');
try
    quantum_tomography_ui_with_bell();
    fprintf('UI界面启动成功！\n');
    fprintf('===========================================\n');
    fprintf('布局优化说明:\n');
    fprintf('1. 响应式设计 - 根据屏幕尺寸自动调整\n');
    fprintf('2. 左右比例 - 左侧33%%, 右侧67%%\n');
    fprintf('3. 组件优化 - 紧凑布局，避免重叠\n');
    fprintf('4. 字体调整 - 根据窗口大小调整字体\n');
    fprintf('5. 居中显示 - 窗口在屏幕中央显示\n');
    fprintf('===========================================\n');
    fprintf('请检查:\n');
    fprintf('- 所有组件是否完整显示\n');
    fprintf('- 左右比例是否协调\n');
    fprintf('- 按钮和输入框是否可操作\n');
    fprintf('- 可视化区域是否完整\n');
    fprintf('===========================================\n');
catch ME
    fprintf('启动UI时出现错误: %s\n', ME.message);
    fprintf('请检查MATLAB版本和必要文件是否存在\n');
    fprintf('===========================================\n');
end
