function save_density_matrix_results(rho_final, first_chi2, final_chi2, purity1, purity2, output_path, base_number)
    % 保存密度矩阵和计算结果到指定路径
    % 输入参数:
    %   rho_final - 最终的密度矩阵
    %   first_chi2 - 线性求解的chi^2值
    %   final_chi2 - 最大似然法的chi^2值
    %   purity1 - 线性求解的纯度
    %   purity2 - 最大似然法的纯度
    %   output_path - 输出路径
    %   base_number - 文件编号
    
    try
        % 创建文件前缀
        file_prefix = ['rho_matrix_' num2str(base_number)];
        
        % 1. 保存密度矩阵为MATLAB格式
        mat_filename = fullfile(output_path, [file_prefix '.mat']);
        save(mat_filename, 'rho_final', 'first_chi2', 'final_chi2', 'purity1', 'purity2');
        
        % 2. 保存密度矩阵为Excel格式
        excel_filename = fullfile(output_path, [file_prefix '.xlsx']);
        
        % 分离实部和虚部
        real_part = real(rho_final);
        imag_part = imag(rho_final);
        
        % 创建表格数据
        [rows, cols] = size(rho_final);
        
        % 实部数据
        real_table = array2table(real_part);
        real_table.Properties.VariableNames = arrayfun(@(x) ['Col_' num2str(x)], 1:cols, 'UniformOutput', false);
        
        % 虚部数据
        imag_table = array2table(imag_part);
        imag_table.Properties.VariableNames = arrayfun(@(x) ['Col_' num2str(x)], 1:cols, 'UniformOutput', false);
        
        % 写入Excel文件的不同sheet
        writetable(real_table, excel_filename, 'Sheet', 'Real_Part');
        writetable(imag_table, excel_filename, 'Sheet', 'Imaginary_Part');
        
        % 3. 保存结果文本文件
        txt_filename = fullfile(output_path, ['results_' num2str(base_number) '.txt']);
        fid = fopen(txt_filename, 'w');
        
        if fid ~= -1
            fprintf(fid, '========== 量子态层析结果 ==========\n');
            fprintf(fid, '文件编号: %d\n', base_number);
            fprintf(fid, '处理时间: %s\n\n', datestr(now));
            
            fprintf(fid, '========== Chi^2 值 ==========\n');
            fprintf(fid, '线性求解 chi^2: %.8e\n', first_chi2);
            fprintf(fid, '最大似然法 chi^2: %.8e\n\n', final_chi2);
            
            fprintf(fid, '========== 纯度值 ==========\n');
            fprintf(fid, '线性求解纯度: %.8e\n', purity1);
            fprintf(fid, '最大似然法纯度: %.8e\n\n', purity2);
            
            fprintf(fid, '========== 密度矩阵 (最大似然法) ==========\n');
            fprintf(fid, '实部:\n');
            for i = 1:rows
                for j = 1:cols
                    fprintf(fid, '%12.6f', real(rho_final(i,j)));
                    if j < cols
                        fprintf(fid, '\t');
                    end
                end
                fprintf(fid, '\n');
            end
            
            fprintf(fid, '\n虚部:\n');
            for i = 1:rows
                for j = 1:cols
                    fprintf(fid, '%12.6f', imag(rho_final(i,j)));
                    if j < cols
                        fprintf(fid, '\t');
                    end
                end
                fprintf(fid, '\n');
            end
            
            fprintf(fid, '\n复数形式 (a+bi):\n');
            for i = 1:rows
                for j = 1:cols
                    real_val = real(rho_final(i,j));
                    imag_val = imag(rho_final(i,j));
                    if imag_val >= 0
                        fprintf(fid, '%8.4f+%8.4fi', real_val, imag_val);
                    else
                        fprintf(fid, '%8.4f%8.4fi', real_val, imag_val);
                    end
                    if j < cols
                        fprintf(fid, '\t');
                    end
                end
                fprintf(fid, '\n');
            end
            
            fclose(fid);
        end
        
        disp(['结果已保存到: ', output_path]);
        disp(['- MATLAB文件: ', mat_filename]);
        disp(['- Excel文件: ', excel_filename]);
        disp(['- 文本文件: ', txt_filename]);
        
    catch ME
        warning('保存文件时出错: %s', ME.message);
    end
end
