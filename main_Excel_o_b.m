%% 参数配置
% 1. 数据路径
base_path = 'D:\BaiduNetdiskWorkspace\研究生\matlab代码\1.SLM\1.SLM正式\1.高维叠加态相位图\1.高维量子层析\1.最新版本\实验室层析\1.bell基层析\';

% 2. 维度设置
dimension = 2;  % 请根据实际情况修改

% 3. 文件编号范围（根据文件名的最后两位数字选择）
base_number_start = 1; % 文件名最后两位数字的起始值
base_number_end = 1;   % 文件名最后两位数字的结束值

% 4. 输出文件设置
filename_F = 'test.xlsx';  % 输出保真度的Excel文件名

% 5. 要读取的列号
k = 1;  % 假设要读取的列号，请根据实际需求修改

%% 主程序
% 检查输入维度是否有效
if dimension < 2 || mod(dimension, 1) ~= 0
    disp('请输入有效的维度（必须为大于等于2的整数）。');
    return;
end

% 获取路径下所有的.csv文件
file_list = dir(fullfile(base_path, '*.csv'));

% 提取文件名并根据最后两位数字排序
file_numbers = [];
file_names = {};
for i = 1:length(file_list)
    % 提取文件名
    file_name = file_list(i).name;
    file_names{end+1} = file_name;
    
    % 提取文件名的数字部分并取最后两位
    num_str = str2double(file_name(1:end-4));  % 提取去掉后缀的数字部分并转换为数字
    last_two_digits = mod(num_str, 100);  % 获取最后两位数字
    file_numbers(end+1) = last_two_digits;  % 存储最后两位数字
end

% 根据最后两位数字范围筛选文件
selected_files = [];
for i = 1:length(file_numbers)
    if file_numbers(i) >= base_number_start && file_numbers(i) <= base_number_end
        selected_files{end+1} = file_names{i};  % 选择满足范围条件的文件
    end
end

% 按照文件编号的最后两位排序
[~, sorted_indices] = sort(file_numbers);

% 按照文件编号的排序逐个处理文件
for i = 1:length(selected_files)
    % 获取当前文件的索引
    file_name = selected_files{i};
    
    % 获取文件编号的最后两位数字
    base_number = str2double(file_name(1:end-4));  % 提取去掉后缀的数字部分
    row_to_write = mod(base_number, 100);  % 使用文件编号的最后两位作为行数

    % 拼接新的文件名和扩展名
    full_filename = fullfile(base_path, file_name);

    % 检查文件是否存在
    if exist(full_filename, 'file')
        % 读取对应文件夹的数据
        dataTable = readtable(full_filename, 'ReadVariableNames', false);

        % 读取列数据
        PnD = dataTable{:, k};

        % 将数据转换为向量（如果它还不是向量形式）
        PnD = PnD';

        % 测量值归一化处理
        PnD = PnD / sum(PnD(1:dimension));

        % 初步线性重构
        rho_first = reconstruct_density_matrix_nD(PnD, dimension);

        % 评估初步求解精度
        first_chi2 = likelihood_function([], PnD, rho_first, dimension); % t 参数为空，使用 rho_first
        purity1 = sum(diag(rho_first * rho_first));

        % 进一步使用最大似然法求解
        [rho_final, final_chi2] = reconstruct_density_matrix_nD_MLE(PnD, rho_first, dimension);
        purity2 = sum(diag(rho_final * rho_final));

        % 绘制相图或其他图形（根据维度调整绘图方式）
        phase_final = mapmap(rho_final, dimension);

        % 输出结果
        disp(['正在处理文件编号：', num2str(base_number)]);
        disp('chi^2 结果：');
        disp(['线性求解 chi^2 value:', sprintf('%.8e', first_chi2)]);
        disp(['最大似然法 chi^2 value:', sprintf('%.8e', final_chi2)]);

        disp('纯度结果：');
        disp(['线性求解 purity:', sprintf('%.8e', purity1)]);
        disp(['最大似然法 purity:', sprintf('%.8e', purity2)]);

        % 求保真度
        rho2 = rho_first;
        rho3 = rho_final;

 
        

        % 求保真度值
        [fidelity_values, P_values] = Bell_state(rho_final, dimension, filename_F, row_to_write);

    else
        disp(['文件 ', full_filename, ' 不存在，跳过该文件']);
    end
           F1 = fidelity(rho_th, rho3);
           disp(['相对理论态的 保真度: ', sprintf('%.8e', F1)]);

end
