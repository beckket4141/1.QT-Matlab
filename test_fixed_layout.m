% 测试修复后的UI布局
% 验证左侧控制面板所有组件是否可见

clear; clc; close all;

fprintf('===========================================\n');
fprintf('  测试修复后的UI布局\n');
fprintf('===========================================\n');

% 检查必要函数是否存在
required_functions = {'quantum_tomography_ui_with_bell'};

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

% 计算组件尺寸
left_panel_width = round(window_width * 0.33);
panel_height = window_height - 60;

fprintf('左侧控制面板尺寸: %dx%d\n', left_panel_width, panel_height);
fprintf('组件布局:\n');
fprintf('  输入设置: 位置 [10 %d %d 130]\n', panel_height-140, left_panel_width-20);
fprintf('  输出设置: 位置 [10 %d %d 80]\n', panel_height-230, left_panel_width-20);
fprintf('  操作控制: 位置 [10 %d %d 60]\n', panel_height-300, left_panel_width-20);
fprintf('  处理进度: 位置 [10 20 %d %d]\n', left_panel_width-20, panel_height-330);

% 启动修复后的UI
fprintf('\n启动修复后的UI界面...\n');
try
    quantum_tomography_ui_with_bell();
    fprintf('UI界面启动成功！\n');
    fprintf('===========================================\n');
    fprintf('修复内容:\n');
    fprintf('1. 输入设置 - 现在在顶部可见\n');
    fprintf('2. 输出设置 - 在输入设置下方\n');
    fprintf('3. 操作控制 - 在输出设置下方\n');
    fprintf('4. 处理进度 - 在底部，高度缩小\n');
    fprintf('5. 日志区域 - 支持滚动查看\n');
    fprintf('===========================================\n');
    fprintf('请检查:\n');
    fprintf('- 左侧所有控制组件是否可见\n');
    fprintf('- 输入设置、输出设置、操作控制是否在顶部\n');
    fprintf('- 处理进度区域是否在底部\n');
    fprintf('- 日志区域是否支持滚动\n');
    fprintf('===========================================\n');
catch ME
    fprintf('启动UI时出现错误: %s\n', ME.message);
    fprintf('请检查MATLAB版本和必要文件是否存在\n');
    fprintf('===========================================\n');
end
