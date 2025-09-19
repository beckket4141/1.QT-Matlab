% 快速测试UI启动
clear; clc; close all;

fprintf('测试UI启动...\n');
try
    quantum_tomography_ui_with_bell();
    fprintf('UI启动成功！\n');
catch ME
    fprintf('UI启动失败: %s\n', ME.message);
end
