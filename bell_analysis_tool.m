function bell_analysis_tool(rho_final, dimension, output_path, file_prefix)
    % Bell态分析工具
    % 输入:
    %   rho_final - 重构的密度矩阵
    %   dimension - 系统维度
    %   output_path - 输出路径
    %   file_prefix - 文件前缀
    % 输出:
    %   fidelity_results - 保真度分析结果结构体
    
    fprintf('开始Bell态分析...\n');
    
    % 检查维度是否支持Bell态分析
    if ~ismember(dimension, [4, 9, 16])
        warning('当前维度 %d 不支持Bell态分析，支持的维度为: 4, 9, 16', dimension);
        return;
    end
    
    % 创建输出文件名
    excel_filename = fullfile(output_path, [file_prefix '_bell_fidelity.xlsx']);
    
    % 计算Bell态保真度
    [fidelity_values, P_values] = Bell_state(rho_final, dimension, excel_filename, 1);
    
    % 计算理论态保真度（如果有理论态）
    theoretical_fidelity = [];
    if exist('rho_th', 'var')
        theoretical_fidelity = fidelity(rho_th, rho_final);
        fprintf('理论态保真度: %.6f\n', theoretical_fidelity);
    end
    
    % 创建结果结构体
    fidelity_results = struct();
    fidelity_results.bell_fidelities = fidelity_values;
    fidelity_results.theoretical_fidelity = theoretical_fidelity;
    fidelity_results.dimension = dimension;
    fidelity_results.file_prefix = file_prefix;
    
    % 保存详细结果
    save_bell_analysis_results(fidelity_results, output_path, file_prefix);
    
    % 显示结果摘要
    display_bell_analysis_summary(fidelity_results);
    
    fprintf('Bell态分析完成，结果已保存到: %s\n', excel_filename);
end

function save_bell_analysis_results(fidelity_results, output_path, file_prefix)
    % 保存Bell态分析结果
    
    % 保存MATLAB格式
    mat_filename = fullfile(output_path, [file_prefix '_bell_analysis.mat']);
    save(mat_filename, 'fidelity_results');
    
    % 保存文本格式
    txt_filename = fullfile(output_path, [file_prefix '_bell_analysis.txt']);
    fid = fopen(txt_filename, 'w');
    
    if fid ~= -1
        fprintf(fid, '========== Bell态分析结果 ==========\n');
        fprintf(fid, '文件前缀: %s\n', file_prefix);
        fprintf(fid, '系统维度: %d\n', fidelity_results.dimension);
        fprintf(fid, '分析时间: %s\n\n', datestr(now));
        
        fprintf(fid, '========== Bell态保真度 ==========\n');
        for i = 1:length(fidelity_results.bell_fidelities)
            fprintf(fid, 'Bell态 %d: %.6f\n', i, fidelity_results.bell_fidelities(i));
        end
        
        if ~isempty(fidelity_results.theoretical_fidelity)
            fprintf(fid, '\n理论态保真度: %.6f\n', fidelity_results.theoretical_fidelity);
        end
        
        fclose(fid);
    end
end

function display_bell_analysis_summary(fidelity_results)
    % 显示Bell态分析摘要
    
    fprintf('\n========== Bell态分析摘要 ==========\n');
    fprintf('系统维度: %d\n', fidelity_results.dimension);
    fprintf('Bell态保真度:\n');
    
    for i = 1:length(fidelity_results.bell_fidelities)
        fprintf('  Bell态 %d: %.6f\n', i, fidelity_results.bell_fidelities(i));
    end
    
    if ~isempty(fidelity_results.theoretical_fidelity)
        fprintf('理论态保真度: %.6f\n', fidelity_results.theoretical_fidelity);
    end
    
    % 计算统计信息
    max_fidelity = max(fidelity_results.bell_fidelities);
    min_fidelity = min(fidelity_results.bell_fidelities);
    avg_fidelity = mean(fidelity_results.bell_fidelities);
    
    fprintf('\n统计信息:\n');
    fprintf('  最大保真度: %.6f\n', max_fidelity);
    fprintf('  最小保真度: %.6f\n', min_fidelity);
    fprintf('  平均保真度: %.6f\n', avg_fidelity);
    fprintf('=====================================\n\n');
end
