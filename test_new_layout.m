% 测试重新设计后的UI布局
% 验证数值显示、mapmap绘图和谱分解功能

clear; clc; close all;

fprintf('===========================================\n');
fprintf('  测试重新设计后的UI布局\n');
fprintf('===========================================\n');

% 检查必要函数是否存在
required_functions = {'quantum_tomography_ui_with_bell', 'mapmap'};

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

% 启动重新设计后的UI
fprintf('\n启动重新设计后的UI界面...\n');
try
    quantum_tomography_ui_with_bell();
    fprintf('UI界面启动成功！\n');
    fprintf('===========================================\n');
    fprintf('重新设计内容:\n');
    fprintf('1. 密度矩阵 → 数值结果显示\n');
    fprintf('   - chi²值 (线性重构 vs 最大似然法)\n');
    fprintf('   - 纯度值 (线性重构 vs 最大似然法)\n');
    fprintf('   - 物理约束检查 (正定性、归一化、厄米性)\n');
    fprintf('   - 本征值范围\n');
    fprintf('2. 振幅图 → mapmap 3D振幅图\n');
    fprintf('   - 专业3D显示\n');
    fprintf('   - 颜色编码\n');
    fprintf('   - 立体效果\n');
    fprintf('3. 相位图 → mapmap 3D相位图\n');
    fprintf('   - 专业3D显示\n');
    fprintf('   - 相位颜色编码\n');
    fprintf('   - 立体效果\n');
    fprintf('4. 谱分解 → 优化显示\n');
    fprintf('   - 柱状图显示本征值概率\n');
    fprintf('   - 数值标注\n');
    fprintf('   - 非零本征值筛选\n');
    fprintf('===========================================\n');
    fprintf('请检查:\n');
    fprintf('- 数值结果显示是否清晰\n');
    fprintf('- mapmap绘图是否正常\n');
    fprintf('- 谱分解是否直观\n');
    fprintf('- 整体布局是否专业\n');
    fprintf('===========================================\n');
catch ME
    fprintf('启动UI时出现错误: %s\n', ME.message);
    fprintf('请检查MATLAB版本和必要文件是否存在\n');
    fprintf('===========================================\n');
end
