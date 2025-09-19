% 演示增强版UI的可视化功能
% 生成测试数据并展示各种可视化效果

clear; clc; close all;

fprintf('===========================================\n');
fprintf('  演示增强版UI可视化功能\n');
fprintf('===========================================\n');

% 创建测试用的密度矩阵
dimension = 4;
fprintf('生成 %d 维测试密度矩阵...\n', dimension);

% 生成随机密度矩阵
rho_test = rand(dimension) + 1i * rand(dimension);
rho_test = rho_test * rho_test';  % 确保正定
rho_test = rho_test / trace(rho_test);  % 归一化

fprintf('密度矩阵生成完成\n');
fprintf('矩阵维度: %d×%d\n', size(rho_test,1), size(rho_test,2));
fprintf('迹: %.6f\n', trace(rho_test));
fprintf('纯度: %.6f\n', trace(rho_test * rho_test));

% 启动UI
fprintf('\n启动增强版UI界面...\n');
try
    fig = quantum_tomography_ui_with_bell();
    
    % 等待UI完全加载
    pause(2);
    
    % 更新可视化显示
    fprintf('更新可视化显示...\n');
    updateAllVisualizations(fig, rho_test);
    
    fprintf('演示完成！\n');
    fprintf('===========================================\n');
    fprintf('您可以看到:\n');
    fprintf('1. 密度矩阵热图 - 显示矩阵元素的幅度\n');
    fprintf('2. 振幅分布图 - 显示复数的幅度\n');
    fprintf('3. 相位分布图 - 显示复数的相位\n');
    fprintf('4. 谱分解结果 - 显示特征值和对应的概率\n');
    fprintf('===========================================\n');
    
catch ME
    fprintf('演示过程中出现错误: %s\n', ME.message);
    fprintf('===========================================\n');
end
