function analyze_4x4_matrix(matrix_data, matrix_name)
    % 分析4×4量子态矩阵数据
    % 输入:
    %   matrix_data - 4×4矩阵数据
    %   matrix_name - 矩阵名称（可选）
    
    if nargin < 2
        matrix_name = '未知矩阵';
    end
    
    fprintf('===========================================\n');
    fprintf('  4×4量子态矩阵数据分析\n');
    fprintf('===========================================\n');
    fprintf('矩阵名称: %s\n', matrix_name);
    fprintf('矩阵维度: %d×%d\n', size(matrix_data, 1), size(matrix_data, 2));
    
    % 1. 基本矩阵属性分析
    fprintf('\n=== 基本矩阵属性 ===\n');
    fprintf('矩阵范围: [%.6f, %.6f]\n', min(matrix_data(:)), max(matrix_data(:)));
    fprintf('矩阵均值: %.6f\n', mean(matrix_data(:)));
    fprintf('矩阵标准差: %.6f\n', std(matrix_data(:)));
    
    % 2. 对称性检查
    fprintf('\n=== 对称性检查 ===\n');
    is_symmetric = isequal(matrix_data, matrix_data');
    fprintf('对称性: %s\n', ternary(is_symmetric, '满足', '不满足'));
    
    if is_symmetric
        % 计算对称性误差
        sym_error = max(abs(matrix_data - matrix_data'), [], 'all');
        fprintf('最大对称性误差: %.2e\n', sym_error);
    end
    
    % 3. 厄米性检查（对于复数矩阵）
    fprintf('\n=== 厄米性检查 ===\n');
    is_hermitian = ishermitian(matrix_data);
    fprintf('厄米性: %s\n', ternary(is_hermitian, '满足', '不满足'));
    
    % 4. 正定性检查
    fprintf('\n=== 正定性检查 ===\n');
    try
        eigenvals = eig(matrix_data);
        min_eigenval = min(eigenvals);
        max_eigenval = max(eigenvals);
        fprintf('最大本征值: %.6f\n', max_eigenval);
        fprintf('最小本征值: %.6f\n', min_eigenval);
        fprintf('正定性: %s\n', ternary(min_eigenval >= 0, '满足', '不满足'));
        
        % 本征值分布
        fprintf('本征值分布:\n');
        for i = 1:length(eigenvals)
            fprintf('  λ%d = %.6f\n', i, eigenvals(i));
        end
        
    catch ME
        fprintf('本征值计算失败: %s\n', ME.message);
    end
    
    % 5. 迹分析
    fprintf('\n=== 迹分析 ===\n');
    trace_val = trace(matrix_data);
    fprintf('迹值: %.6f\n', trace_val);
    fprintf('归一化: %s\n', ternary(abs(trace_val - 1) < 1e-6, '满足', '不满足'));
    
    % 6. 密度矩阵物理性检查
    fprintf('\n=== 密度矩阵物理性检查 ===\n');
    if is_symmetric && is_hermitian
        % 检查是否可能是密度矩阵
        is_positive = min_eigenval >= -1e-10;  % 允许小的数值误差
        is_normalized = abs(trace_val - 1) < 1e-6;
        is_physical = is_positive && is_normalized;
        
        fprintf('物理性: %s\n', ternary(is_physical, '满足', '不满足'));
        
        if is_physical
            % 计算纯度
            purity = trace(matrix_data^2);
            fprintf('纯度: %.6f\n', purity);
            fprintf('纯度范围: [0, 1]\n');
            fprintf('态类型: %s\n', ternary(purity == 1, '纯态', '混合态'));
        end
    else
        fprintf('非厄米矩阵，无法进行密度矩阵物理性检查\n');
    end
    
    % 7. 矩阵可视化
    fprintf('\n=== 矩阵可视化 ===\n');
    try
        % 创建图形窗口
        fig = figure('Position', [100, 100, 1200, 400]);
        fig.Name = sprintf('4×4矩阵分析 - %s', matrix_name);
        
        % 子图1: 矩阵热图
        subplot(1, 3, 1);
        imagesc(matrix_data);
        colorbar;
        title('矩阵热图');
        xlabel('列索引');
        ylabel('行索引');
        
        % 子图2: 本征值分布
        subplot(1, 3, 2);
        if exist('eigenvals', 'var')
            bar(1:length(eigenvals), eigenvals);
            title('本征值分布');
            xlabel('本征值索引');
            ylabel('本征值');
            grid on;
        end
        
        % 子图3: 矩阵元素分布
        subplot(1, 3, 3);
        histogram(matrix_data(:), 20);
        title('矩阵元素分布');
        xlabel('元素值');
        ylabel('频次');
        grid on;
        
        % 保存图形
        saveas(fig, sprintf('4x4_matrix_analysis_%s.png', datestr(now, 'yyyymmdd_HHMMSS')));
        fprintf('分析结果已保存为图像文件\n');
        
    catch ME
        fprintf('可视化失败: %s\n', ME.message);
    end
    
    % 8. 量子态层析建议
    fprintf('\n=== 量子态层析建议 ===\n');
    if is_symmetric && is_hermitian && exist('eigenvals', 'var')
        if min_eigenval >= -1e-10 && abs(trace_val - 1) < 1e-6
            fprintf('✓ 该矩阵可以作为密度矩阵进行量子态层析\n');
            fprintf('✓ 建议使用最大似然估计(MLE)进行精确重构\n');
            fprintf('✓ 线性重构可作为MLE的初始值\n');
        else
            fprintf('⚠ 该矩阵不满足密度矩阵的物理约束\n');
            fprintf('⚠ 建议使用makephysical函数进行物理化处理\n');
        end
    else
        fprintf('⚠ 该矩阵不是厄米矩阵，需要进一步处理\n');
    end
    
    fprintf('\n===========================================\n');
    fprintf('分析完成！\n');
    fprintf('===========================================\n');
end

function result = ternary(condition, true_value, false_value)
    % 三元运算符函数
    if condition
        result = true_value;
    else
        result = false_value;
    end
end
