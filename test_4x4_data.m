% 测试4×4矩阵数据分析
% 基于用户提供的矩阵数据

% 用户提供的4×4矩阵数据
matrix_data = [
    0.471639378,  0.068401643, -0.084376885, -0.463480972;
    0.068401643,  0.015500474, -0.021995724, -0.071601944;
   -0.084376885, -0.021995724,  0.038544605,  0.097723356;
   -0.463480972, -0.071601944,  0.097723356,  0.474315543
];

fprintf('开始分析用户提供的4×4矩阵数据...\n\n');

% 调用分析函数
analyze_4x4_matrix(matrix_data, '用户提供的数据');

% 额外分析：检查是否可以作为量子态层析的输入
fprintf('\n=== 量子态层析适用性分析 ===\n');

% 检查矩阵是否可以作为测量数据
if size(matrix_data, 1) == 4 && size(matrix_data, 2) == 4
    fprintf('✓ 矩阵维度正确 (4×4)\n');
    
    % 检查数值范围
    if all(abs(matrix_data(:)) <= 1)
        fprintf('✓ 数值范围合理 (所有元素绝对值 ≤ 1)\n');
    else
        fprintf('⚠ 数值范围异常 (存在绝对值 > 1 的元素)\n');
    end
    
    % 检查对称性
    if isequal(matrix_data, matrix_data')
        fprintf('✓ 矩阵完全对称\n');
    else
        fprintf('⚠ 矩阵不对称\n');
    end
    
    % 检查对角元素
    diag_elements = diag(matrix_data);
    if all(diag_elements >= 0)
        fprintf('✓ 对角元素非负\n');
    else
        fprintf('⚠ 存在负对角元素\n');
    end
    
    fprintf('\n建议:\n');
    fprintf('1. 如果这是测量数据，请确保数据格式正确\n');
    fprintf('2. 如果这是密度矩阵，请检查物理约束\n');
    fprintf('3. 可以尝试使用量子态层析工具进行重构\n');
    
else
    fprintf('❌ 矩阵维度不正确，应为4×4\n');
end

fprintf('\n分析完成！\n');
