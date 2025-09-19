% 测试50%:50%布局的UI界面
% 验证顶部三图和谱分解区域的平衡显示

clear; clc; close all;

fprintf('===========================================\n');
fprintf('  测试50%%:50%%布局的UI界面\n');
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

% 计算可视化区域尺寸
left_panel_width = round(window_width * 0.33);
right_panel_width = window_width - left_panel_width - 30;
panel_height = window_height - 60;
viz_width = right_panel_width - 20;
viz_height = panel_height - 20;
top_height = round(viz_height * 0.5);  % 50%
bottom_height = viz_height - top_height - 10;  % 50%

fprintf('可视化区域尺寸:\n');
fprintf('  总宽度: %dpx\n', viz_width);
fprintf('  总高度: %dpx\n', viz_height);
fprintf('  顶部三图区域: %dpx (50%%)\n', top_height);
fprintf('  底部谱分解区域: %dpx (50%%)\n', bottom_height);

% 启动优化后的UI
fprintf('\n启动50%%:50%%布局的UI界面...\n');
try
    quantum_tomography_ui_with_bell();
    fprintf('UI界面启动成功！\n');
    fprintf('===========================================\n');
    fprintf('50%%:50%%布局优势:\n');
    fprintf('1. 视觉平衡 - 上下区域各占一半\n');
    fprintf('2. 更清晰显示 - 顶部三图有足够空间\n');
    fprintf('3. 合理利用 - 谱分解区域适中\n');
    fprintf('4. 用户体验 - 所有内容都清晰可见\n');
    fprintf('===========================================\n');
    fprintf('请检查:\n');
    fprintf('- 顶部三图是否显示清晰\n');
    fprintf('- 谱分解区域是否适中\n');
    fprintf('- 整体布局是否平衡\n');
    fprintf('- 所有功能是否正常\n');
    fprintf('===========================================\n');
catch ME
    fprintf('启动UI时出现错误: %s\n', ME.message);
    fprintf('请检查MATLAB版本和必要文件是否存在\n');
    fprintf('===========================================\n');
end
