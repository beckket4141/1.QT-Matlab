% 测试最终调整后的UI布局
% 验证输入设置区域是否完全可见

clear; clc; close all;

fprintf('===========================================\n');
fprintf('  测试最终调整后的UI布局\n');
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
fprintf('调整后的组件布局:\n');
fprintf('  输入设置: 位置 [10 %d %d 140] (增加高度)\n', panel_height-150, left_panel_width-20);
fprintf('  输出设置: 位置 [10 %d %d 80]\n', panel_height-240, left_panel_width-20);
fprintf('  操作控制: 位置 [10 %d %d 60]\n', panel_height-310, left_panel_width-20);
fprintf('  处理进度: 位置 [10 20 %d %d]\n', left_panel_width-20, panel_height-340);

% 启动调整后的UI
fprintf('\n启动最终调整后的UI界面...\n');
try
    quantum_tomography_ui_with_bell();
    fprintf('UI界面启动成功！\n');
    fprintf('===========================================\n');
    fprintf('最终调整内容:\n');
    fprintf('1. 输入设置 - 高度增加到140px，位置调整\n');
    fprintf('2. 输出设置 - 位置下移，避免重叠\n');
    fprintf('3. 操作控制 - 位置下移，避免重叠\n');
    fprintf('4. 处理进度 - 位置调整，给更多空间\n');
    fprintf('5. 所有组件 - 确保完全可见，无遮挡\n');
    fprintf('===========================================\n');
    fprintf('请检查:\n');
    fprintf('- 输入设置区域是否完全可见\n');
    fprintf('- 所有组件是否无重叠\n');
    fprintf('- 布局是否更加合理\n');
    fprintf('- 操作是否更加顺畅\n');
    fprintf('===========================================\n');
catch ME
    fprintf('启动UI时出现错误: %s\n', ME.message);
    fprintf('请检查MATLAB版本和必要文件是否存在\n');
    fprintf('===========================================\n');
end
