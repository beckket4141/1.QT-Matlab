function test_ui_functions()
    % 测试UI相关函数的功能
    
    fprintf('开始测试UI相关函数...\n');
    
    % 测试1: 检查所有必要文件是否存在
    fprintf('\n1. 检查文件完整性...\n');
    
    required_files = {
        'quantum_tomography_ui.m',
        'run_ui.m',
        'mapsave.m',
        'save_density_matrix_results.m',
        'main_Excel_o_ui.m'
    };
    
    all_files_exist = true;
    for i = 1:length(required_files)
        if exist(required_files{i}, 'file')
            fprintf('  ✓ %s 存在\n', required_files{i});
        else
            fprintf('  ✗ %s 缺失\n', required_files{i});
            all_files_exist = false;
        end
    end
    
    % 测试2: 检查必要的底层函数
    fprintf('\n2. 检查底层处理函数...\n');
    
    processing_functions = {
        'reconstruct_density_matrix_nD',
        'likelihood_function',
        'reconstruct_density_matrix_nD_MLE'
    };
    
    all_functions_exist = true;
    for i = 1:length(processing_functions)
        if exist(processing_functions{i}, 'file')
            fprintf('  ✓ %s 可用\n', processing_functions{i});
        else
            fprintf('  ✗ %s 缺失\n', processing_functions{i});
            all_functions_exist = false;
        end
    end
    
    % 测试3: 测试保存函数
    fprintf('\n3. 测试保存函数...\n');
    
    try
        % 创建测试数据
        test_rho = [0.5, 0.5i; -0.5i, 0.5];
        test_path = pwd;
        test_number = 999;
        
        % 测试保存函数
        save_density_matrix_results(test_rho, 1e-6, 1e-8, 0.5, 0.5, test_path, test_number);
        
        % 检查生成的文件
        expected_files = {
            ['rho_matrix_' num2str(test_number) '.mat'],
            ['rho_matrix_' num2str(test_number) '.xlsx'],
            ['results_' num2str(test_number) '.txt']
        };
        
        save_test_passed = true;
        for i = 1:length(expected_files)
            if exist(fullfile(test_path, expected_files{i}), 'file')
                fprintf('  ✓ 成功生成 %s\n', expected_files{i});
                % 清理测试文件
                delete(fullfile(test_path, expected_files{i}));
            else
                fprintf('  ✗ 未能生成 %s\n', expected_files{i});
                save_test_passed = false;
            end
        end
        
        if save_test_passed
            fprintf('  ✓ 保存函数测试通过\n');
        end
        
    catch ME
        fprintf('  ✗ 保存函数测试失败: %s\n', ME.message);
    end
    
    % 测试4: 测试mapsave函数
    fprintf('\n4. 测试图像保存函数...\n');
    
    try
        % 创建测试数据
        test_rho = [1, 0; 0, 0];  % 简单的纯态
        test_path = pwd;
        test_prefix = 'test_ui';
        
        % 关闭图像显示（避免弹出窗口）
        set(0, 'DefaultFigureVisible', 'off');
        
        % 测试mapsave函数
        phase_result = mapsave(test_rho, 2, test_path, test_prefix);
        
        % 恢复图像显示设置
        set(0, 'DefaultFigureVisible', 'on');
        
        % 检查生成的图像文件
        image_files = {
            [test_prefix '_amplitude.png'],
            [test_prefix '_phase.png']
        };
        
        image_test_passed = true;
        for i = 1:length(image_files)
            if exist(fullfile(test_path, image_files{i}), 'file')
                fprintf('  ✓ 成功生成 %s\n', image_files{i});
                % 清理测试文件
                delete(fullfile(test_path, image_files{i}));
            else
                fprintf('  ✗ 未能生成 %s\n', image_files{i});
                image_test_passed = false;
            end
        end
        
        if image_test_passed
            fprintf('  ✓ 图像保存函数测试通过\n');
        end
        
    catch ME
        fprintf('  ✗ 图像保存函数测试失败: %s\n', ME.message);
        % 确保恢复图像显示设置
        set(0, 'DefaultFigureVisible', 'on');
    end
    
    % 总结
    fprintf('\n========== 测试总结 ==========\n');
    
    if all_files_exist
        fprintf('✓ 所有UI文件完整\n');
    else
        fprintf('✗ 部分UI文件缺失\n');
    end
    
    if all_functions_exist
        fprintf('✓ 所有处理函数可用\n');
    else
        fprintf('✗ 部分处理函数缺失，UI可能无法正常工作\n');
    end
    
    fprintf('\n要启动UI界面，请运行: run_ui\n');
    fprintf('============================\n');
end
