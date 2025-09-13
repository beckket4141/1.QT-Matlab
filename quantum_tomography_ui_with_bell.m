function quantum_tomography_ui_with_bell()
    % 集成Bell态分析的量子态层析数据处理UI界面
    
    % 创建主窗口
    fig = uifigure('Position', [100 100 700 750]);
    fig.Name = '量子态层析数据处理工具 (含Bell态分析)';
    fig.Resize = 'off';
    
    % 创建UI组件
    createComponentsWithBell(fig);
end

function createComponentsWithBell(fig)
    % 创建所有UI组件（包含Bell态分析选项）
    
    % 标题
    title_label = uilabel(fig);
    title_label.Position = [200 700 300 30];
    title_label.Text = '量子态层析数据处理工具 (含Bell态分析)';
    title_label.FontSize = 16;
    title_label.FontWeight = 'bold';
    title_label.HorizontalAlignment = 'center';
    
    % 输入设置组
    input_panel = uipanel(fig);
    input_panel.Position = [20 550 660 180];
    input_panel.Title = '输入设置';
    input_panel.FontWeight = 'bold';
    
    % 数据路径
    uilabel(input_panel, 'Position', [10 130 80 22], 'Text', '数据路径:');
    data_path_edit = uieditfield(input_panel, 'text');
    data_path_edit.Position = [100 130 400 22];
    data_path_edit.Tag = 'data_path';
    
    data_path_btn = uibutton(input_panel, 'push');
    data_path_btn.Position = [510 130 80 22];
    data_path_btn.Text = '浏览文件夹';
    data_path_btn.ButtonPushedFcn = @(btn,event) selectDataPath(data_path_edit);
    
    % 文件类型和列号
    uilabel(input_panel, 'Position', [10 100 60 22], 'Text', '文件类型:');
    file_type_dropdown = uidropdown(input_panel);
    file_type_dropdown.Position = [80 100 80 22];
    file_type_dropdown.Items = {'CSV', 'XLSX'};
    file_type_dropdown.Value = 'CSV';
    file_type_dropdown.Tag = 'file_type';
    
    uilabel(input_panel, 'Position', [200 100 40 22], 'Text', '列号:');
    column_edit = uieditfield(input_panel, 'numeric');
    column_edit.Position = [250 100 60 22];
    column_edit.Value = 1;
    column_edit.Tag = 'column_number';
    
    % 维度设置
    uilabel(input_panel, 'Position', [10 70 40 22], 'Text', '维度:');
    dimension_edit = uieditfield(input_panel, 'numeric');
    dimension_edit.Position = [60 70 60 22];
    dimension_edit.Value = 2;
    dimension_edit.Tag = 'dimension';
    
    % Bell态分析选项
    bell_analysis_checkbox = uicheckbox(input_panel);
    bell_analysis_checkbox.Position = [150 70 120 22];
    bell_analysis_checkbox.Text = '启用Bell态分析';
    bell_analysis_checkbox.Tag = 'bell_analysis';
    bell_analysis_checkbox.Value = false;
    
    % 文件编号范围
    uilabel(input_panel, 'Position', [10 40 80 22], 'Text', '文件编号范围:');
    uilabel(input_panel, 'Position', [100 40 20 22], 'Text', '从');
    start_number_edit = uieditfield(input_panel, 'numeric');
    start_number_edit.Position = [130 40 60 22];
    start_number_edit.Value = 1;
    start_number_edit.Tag = 'start_number';
    
    uilabel(input_panel, 'Position', [200 40 20 22], 'Text', '到');
    end_number_edit = uieditfield(input_panel, 'numeric');
    end_number_edit.Position = [230 40 60 22];
    end_number_edit.Value = 1;
    end_number_edit.Tag = 'end_number';
    
    % 输出设置组
    output_panel = uipanel(fig);
    output_panel.Position = [20 450 660 80];
    output_panel.Title = '输出设置';
    output_panel.FontWeight = 'bold';
    
    % 保存路径
    uilabel(output_panel, 'Position', [10 30 80 22], 'Text', '保存路径:');
    save_path_edit = uieditfield(output_panel, 'text');
    save_path_edit.Position = [100 30 400 22];
    save_path_edit.Tag = 'save_path';
    
    save_path_btn = uibutton(output_panel, 'push');
    save_path_btn.Position = [510 30 80 22];
    save_path_btn.Text = '浏览文件夹';
    save_path_btn.ButtonPushedFcn = @(btn,event) selectSavePath(save_path_edit);
    
    % 操作控制组
    control_panel = uipanel(fig);
    control_panel.Position = [20 380 660 50];
    control_panel.Title = '';
    control_panel.BorderType = 'none';
    
    % 按钮
    save_config_btn = uibutton(control_panel, 'push');
    save_config_btn.Position = [10 10 100 30];
    save_config_btn.Text = '保存配置';
    save_config_btn.ButtonPushedFcn = @(btn,event) saveDefaultConfig(fig);
    
    start_btn = uibutton(control_panel, 'push');
    start_btn.Position = [230 10 80 30];
    start_btn.Text = '开始处理';
    start_btn.ButtonPushedFcn = @(btn,event) startProcessingWithBell(fig);
    start_btn.BackgroundColor = [0.2 0.8 0.2];
    
    exit_btn = uibutton(control_panel, 'push');
    exit_btn.Position = [570 10 60 30];
    exit_btn.Text = '退出';
    exit_btn.ButtonPushedFcn = @(btn,event) close(fig);
    
    % 进度显示组
    progress_panel = uipanel(fig);
    progress_panel.Position = [20 50 660 320];
    progress_panel.Title = '处理进度';
    progress_panel.FontWeight = 'bold';
    
    % 当前文件显示
    uilabel(progress_panel, 'Position', [10 275 60 22], 'Text', '当前文件:');
    current_file_label = uilabel(progress_panel, 'Position', [80 275 560 22], 'Text', '等待开始...');
    current_file_label.Tag = 'current_file';
    
    % 进度条
    progress_gauge = uigauge(progress_panel, 'linear');
    progress_gauge.Position = [10 240 630 20];
    progress_gauge.Limits = [0 100];
    progress_gauge.Value = 0;
    progress_gauge.Tag = 'progress_gauge';
    
    % 处理日志
    uilabel(progress_panel, 'Position', [10 210 60 22], 'Text', '处理日志:');
    log_textarea = uitextarea(progress_panel);
    log_textarea.Position = [10 10 630 190];
    log_textarea.Value = {'准备就绪，请配置参数后开始处理...'};
    log_textarea.Tag = 'log_textarea';
    log_textarea.Editable = 'off';
    
    % 加载默认配置
    loadDefaultConfig(fig);
end

function startProcessingWithBell(fig)
    % 开始处理数据（包含Bell态分析）
    try
        % 获取参数
        params = getUIParameters(fig);
        
        % 获取Bell态分析选项
        bell_analysis_enabled = findobj(fig, 'Tag', 'bell_analysis').Value;
        params.bell_analysis = bell_analysis_enabled;
        
        % 验证参数
        if ~validateParameters(params, fig)
            return;
        end
        
        % 检查Bell态分析维度支持
        if bell_analysis_enabled && ~ismember(params.dimension, [4, 9, 16])
            uialert(fig, 'Bell态分析仅支持维度 4, 9, 16', '参数错误', 'Icon', 'warning');
            return;
        end
        
        % 禁用开始按钮
        start_btn = findobj(fig, 'Text', '开始处理');
        start_btn.Enable = 'off';
        start_btn.Text = '处理中...';
        
        % 调用处理函数
        processQuantumTomographyWithBell(params, fig);
        
        % 恢复开始按钮
        start_btn.Enable = 'on';
        start_btn.Text = '开始处理';
        
    catch ME
        % 恢复开始按钮
        start_btn = findobj(fig, 'Text', '处理中...');
        if ~isempty(start_btn)
            start_btn.Enable = 'on';
            start_btn.Text = '开始处理';
        end
        
        log_area = findobj(fig, 'Tag', 'log_textarea');
        current_log = log_area.Value;
        current_log{end+1} = ['[' datestr(now, 'HH:MM:SS') '] 错误: ' ME.message];
        log_area.Value = current_log;
        
        uialert(fig, ['处理过程中出现错误: ' ME.message], '错误', 'Icon', 'error');
    end
end

function processQuantumTomographyWithBell(params, fig)
    % 调用量子层析处理程序（包含Bell态分析）
    
    % 获取UI组件
    current_file_label = findobj(fig, 'Tag', 'current_file');
    progress_gauge = findobj(fig, 'Tag', 'progress_gauge');
    log_area = findobj(fig, 'Tag', 'log_textarea');
    
    % 更新日志
    function updateLog(message)
        current_log = log_area.Value;
        current_log{end+1} = ['[' datestr(now, 'HH:MM:SS') '] ' message];
        log_area.Value = current_log;
        drawnow;
        
        % 自动滚动到底部
        if length(current_log) > 10
            log_area.Value = current_log(max(1, end-9):end);
        end
    end
    
    % 开始处理
    updateLog('开始量子态层析数据处理...');
    if params.bell_analysis
        updateLog('Bell态分析已启用');
    end
    
    % 设置文件扩展名
    if strcmp(params.file_type, 'csv')
        file_extension = '*.csv';
    else
        file_extension = '*.xlsx';
    end
    
    % 获取文件列表
    file_list = dir(fullfile(params.data_path, file_extension));
    
    if isempty(file_list)
        updateLog(['在指定路径中未找到' upper(params.file_type) '文件']);
        uialert(fig, ['在指定路径中未找到' upper(params.file_type) '文件'], '错误', 'Icon', 'error');
        return;
    end
    
    % 筛选文件
    selected_files = {};
    for i = 1:length(file_list)
        file_name = file_list(i).name;
        num_str = str2double(file_name(1:end-4));
        if ~isnan(num_str)
            last_two_digits = mod(num_str, 100);
            if last_two_digits >= params.start_number && last_two_digits <= params.end_number
                selected_files{end+1} = file_name;
            end
        end
    end
    
    if isempty(selected_files)
        updateLog('没有找到符合编号范围的文件');
        uialert(fig, '没有找到符合编号范围的文件', '警告', 'Icon', 'warning');
        return;
    end
    
    updateLog(['找到 ' num2str(length(selected_files)) ' 个文件待处理']);
    
    % 处理每个文件
    total_files = length(selected_files);
    for i = 1:total_files
        file_name = selected_files{i};
        
        % 更新当前文件显示
        current_file_label.Text = file_name;
        
        % 更新进度条
        progress = (i-1) / total_files * 100;
        progress_gauge.Value = progress;
        
        updateLog(['处理文件 ' num2str(i) '/' num2str(total_files) ': ' file_name]);
        
        % 调用处理函数（包含Bell态分析）
        processSingleFileWithBell(file_name, params, @updateLog);
        
        drawnow;
    end
    
    % 完成处理
    progress_gauge.Value = 100;
    current_file_label.Text = '处理完成';
    updateLog('所有文件处理完成！');
    
    uialert(fig, '数据处理完成！', '完成', 'Icon', 'success');
end

function processSingleFileWithBell(file_name, params, updateLog)
    % 处理单个文件（包含Bell态分析）
    
    try
        % 获取文件编号
        base_number = str2double(file_name(1:end-4));
        
        % 构建完整文件路径
        full_filename = fullfile(params.data_path, file_name);
        
        % 检查文件是否存在
        if ~exist(full_filename, 'file')
            updateLog(['文件不存在，跳过: ' file_name]);
            return;
        end
        
        % 读取数据
        if strcmp(params.file_type, 'csv')
            dataTable = readtable(full_filename, 'ReadVariableNames', false);
        else
            dataTable = readtable(full_filename);
        end
        
        % 检查列号是否有效
        if params.column_number > width(dataTable)
            updateLog(['列号超出范围，跳过: ' file_name]);
            return;
        end
        
        % 读取列数据
        PnD = dataTable{:, params.column_number};
        PnD = PnD';
        
        % 测量值归一化处理
        PnD = PnD / sum(PnD(1:params.dimension));
        
        % 初步线性重构
        rho_first = reconstruct_density_matrix_nD(PnD, params.dimension);
        
        % 评估初步求解精度
        first_chi2 = likelihood_function([], PnD, rho_first, params.dimension);
        purity1 = sum(diag(rho_first * rho_first));
        
        % 进一步使用最大似然法求解
        [rho_final, final_chi2] = reconstruct_density_matrix_nD_MLE(PnD, rho_first, params.dimension);
        purity2 = sum(diag(rho_final * rho_final));
        
        % 绘制相图并保存
        phase_final = mapsave(rho_final, params.dimension, params.save_path, ['file_' num2str(base_number)]);
        
        % 保存密度矩阵和结果
        save_density_matrix_results(rho_final, first_chi2, final_chi2, purity1, purity2, params.save_path, base_number);
        
        % Bell态分析（如果启用）
        if params.bell_analysis
            updateLog('  开始Bell态分析...');
            bell_analysis_tool(rho_final, params.dimension, params.save_path, ['file_' num2str(base_number)]);
            updateLog('  Bell态分析完成');
        end
        
        % 更新日志
        updateLog(['  线性求解 chi^2: ' sprintf('%.3e', first_chi2)]);
        updateLog(['  最大似然法 chi^2: ' sprintf('%.3e', final_chi2)]);
        updateLog(['  纯度: ' sprintf('%.6f', purity2)]);
        
    catch ME
        updateLog(['处理文件出错 ' file_name ': ' ME.message]);
    end
end

% 其他辅助函数（复用原有函数）
function selectDataPath(edit_field)
    folder = uigetdir('', '选择数据文件夹');
    if folder ~= 0
        edit_field.Value = folder;
    end
end

function selectSavePath(edit_field)
    folder = uigetdir('', '选择保存文件夹');
    if folder ~= 0
        edit_field.Value = folder;
    end
end

function saveDefaultConfig(fig)
    try
        config = struct();
        config.data_path = findobj(fig, 'Tag', 'data_path').Value;
        config.file_type = findobj(fig, 'Tag', 'file_type').Value;
        config.column_number = findobj(fig, 'Tag', 'column_number').Value;
        config.dimension = findobj(fig, 'Tag', 'dimension').Value;
        config.start_number = findobj(fig, 'Tag', 'start_number').Value;
        config.end_number = findobj(fig, 'Tag', 'end_number').Value;
        config.save_path = findobj(fig, 'Tag', 'save_path').Value;
        config.bell_analysis = findobj(fig, 'Tag', 'bell_analysis').Value;
        
        save('quantum_tomography_config_with_bell.mat', 'config');
        
        log_area = findobj(fig, 'Tag', 'log_textarea');
        current_log = log_area.Value;
        current_log{end+1} = ['[' datestr(now, 'HH:MM:SS') '] 配置已保存'];
        log_area.Value = current_log;
        
        uialert(fig, '配置已成功保存', '保存成功', 'Icon', 'success');
    catch ME
        uialert(fig, ['保存配置失败: ' ME.message], '错误', 'Icon', 'error');
    end
end

function loadDefaultConfig(fig)
    if exist('quantum_tomography_config_with_bell.mat', 'file')
        try
            load('quantum_tomography_config_with_bell.mat', 'config');
            
            if ~isempty(config.data_path)
                findobj(fig, 'Tag', 'data_path').Value = config.data_path;
            end
            findobj(fig, 'Tag', 'file_type').Value = config.file_type;
            findobj(fig, 'Tag', 'column_number').Value = config.column_number;
            findobj(fig, 'Tag', 'dimension').Value = config.dimension;
            findobj(fig, 'Tag', 'start_number').Value = config.start_number;
            findobj(fig, 'Tag', 'end_number').Value = config.end_number;
            if ~isempty(config.save_path)
                findobj(fig, 'Tag', 'save_path').Value = config.save_path;
            end
            if isfield(config, 'bell_analysis')
                findobj(fig, 'Tag', 'bell_analysis').Value = config.bell_analysis;
            end
            
            log_area = findobj(fig, 'Tag', 'log_textarea');
            current_log = log_area.Value;
            current_log{end+1} = ['[' datestr(now, 'HH:MM:SS') '] 已加载默认配置'];
            log_area.Value = current_log;
        catch
            % 如果加载失败，使用默认值
        end
    end
end

function params = getUIParameters(fig)
    params = struct();
    params.data_path = findobj(fig, 'Tag', 'data_path').Value;
    params.file_type = lower(findobj(fig, 'Tag', 'file_type').Value);
    params.column_number = findobj(fig, 'Tag', 'column_number').Value;
    params.dimension = findobj(fig, 'Tag', 'dimension').Value;
    params.start_number = findobj(fig, 'Tag', 'start_number').Value;
    params.end_number = findobj(fig, 'Tag', 'end_number').Value;
    params.save_path = findobj(fig, 'Tag', 'save_path').Value;
end

function isValid = validateParameters(params, fig)
    isValid = true;
    
    if isempty(params.data_path) || ~exist(params.data_path, 'dir')
        uialert(fig, '请选择有效的数据文件夹', '参数错误', 'Icon', 'warning');
        isValid = false;
        return;
    end
    
    if isempty(params.save_path) || ~exist(params.save_path, 'dir')
        uialert(fig, '请选择有效的保存文件夹', '参数错误', 'Icon', 'warning');
        isValid = false;
        return;
    end
    
    if params.dimension < 2 || mod(params.dimension, 1) ~= 0
        uialert(fig, '维度必须为大于等于2的整数', '参数错误', 'Icon', 'warning');
        isValid = false;
        return;
    end
    
    if params.column_number < 1 || mod(params.column_number, 1) ~= 0
        uialert(fig, '列号必须为正整数', '参数错误', 'Icon', 'warning');
        isValid = false;
        return;
    end
    
    if params.start_number > params.end_number
        uialert(fig, '起始编号不能大于结束编号', '参数错误', 'Icon', 'warning');
        isValid = false;
        return;
    end
end
