% 快速测试4×4矩阵数据
matrix_data = [
    0.471639378,  0.068401643, -0.084376885, -0.463480972;
    0.068401643,  0.015500474, -0.021995724, -0.071601944;
   -0.084376885, -0.021995724,  0.038544605,  0.097723356;
   -0.463480972, -0.071601944,  0.097723356,  0.474315543
];

fprintf('=== 4×4矩阵数据分析 ===\n');
fprintf('矩阵维度: %d×%d\n', size(matrix_data, 1), size(matrix_data, 2));
fprintf('数值范围: [%.6f, %.6f]\n', min(matrix_data(:)), max(matrix_data(:)));
fprintf('对称性: %s\n', isequal(matrix_data, matrix_data') ? '满足' : '不满足');
fprintf('厄米性: %s\n', ishermitian(matrix_data) ? '满足' : '不满足');

% 本征值分析
eigenvals = eig(matrix_data);
fprintf('本征值: [%.6f, %.6f, %.6f, %.6f]\n', eigenvals(1), eigenvals(2), eigenvals(3), eigenvals(4));
fprintf('正定性: %s\n', min(eigenvals) >= 0 ? '满足' : '不满足');

% 迹分析
trace_val = trace(matrix_data);
fprintf('迹值: %.6f\n', trace_val);
fprintf('归一化: %s\n', abs(trace_val - 1) < 1e-6 ? '满足' : '不满足');

fprintf('分析完成！\n');
