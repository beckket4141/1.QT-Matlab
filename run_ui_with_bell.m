% 量子态层析数据处理工具启动脚本 (含Bell态分析)
%
% 使用说明:
% 1. 在MATLAB命令行中运行: run_ui_with_bell
% 2. 或者直接运行: quantum_tomography_ui_with_bell
%
% 功能说明:
% - 数据路径选择: 选择包含CSV或XLSX数据文件的文件夹
% - 文件类型: 选择要处理的文件类型 (CSV/XLSX)
% - 列号: 指定要读取的数据列
% - 维度: 设置量子态的维度
% - Bell态分析: 启用/禁用Bell态保真度分析 (支持维度: 4, 9, 16)
% - 文件编号范围: 设置要处理的文件编号范围
% - 保存路径: 选择结果保存位置
%
% 输出文件:
% - rho_matrix_[编号].mat: 密度矩阵MATLAB格式
% - rho_matrix_[编号].xlsx: 密度矩阵Excel格式
% - file_[编号]_amplitude.png: 振幅图
% - file_[编号]_phase.png: 相位图
% - results_[编号].txt: 计算结果文本文件
% - file_[编号]_bell_fidelity.xlsx: Bell态保真度Excel文件 (如果启用Bell态分析)
% - file_[编号]_bell_analysis.mat: Bell态分析结果MATLAB格式
% - file_[编号]_bell_analysis.txt: Bell态分析结果文本格式

fprintf('===========================================\n');
fprintf('  量子态层析数据处理工具 (含Bell态分析)\n');
fprintf('===========================================\n');
fprintf('正在启动UI界面...\n');

try
    % 检查必要的函数是否存在
    required_functions = {'reconstruct_density_matrix_nD', ...
                         'likelihood_function', ...
                         'reconstruct_density_matrix_nD_MLE', ...
                         'Bell_state', ...
                         'fidelity', ...
                         'theoretical_measurement_powers_nD_fun', ...
                         'matrix_square_root'};
    
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
    end
    
    % 启动UI
    quantum_tomography_ui_with_bell();
    
    fprintf('UI界面已启动成功!\n');
    fprintf('===========================================\n');
    
catch ME
    fprintf('启动UI时出现错误: %s\n', ME.message);
    fprintf('请检查MATLAB版本和必要文件是否存在\n');
    fprintf('===========================================\n');
end
