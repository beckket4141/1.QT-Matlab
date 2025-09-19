function quantum_tomography_ui_with_bell()
    % 集成Bell态分析的量子态层析数据处理UI界面
    
    % 获取屏幕尺寸并计算合适的窗口尺寸
    screen_size = get(0, 'ScreenSize');
    screen_width = screen_size(3);
    screen_height = screen_size(4);
    
    % 计算合适的窗口尺寸（不超过屏幕的80%）
    window_width = min(1200, screen_width * 0.8);
    window_height = min(800, screen_height * 0.8);
    
    % 居中显示
    x_pos = max(50, (screen_width - window_width) / 2);
    y_pos = max(50, (screen_height - window_height) / 2);
    
    % 创建主窗口
    fig = uifigure('Position', [x_pos y_pos window_width window_height]);
    fig.Name = '量子态层析数据处理工具';
    fig.Resize = 'on';
    
    % 创建UI组件
    createComponentsWithBell(fig);
end

function createComponentsWithBell(fig)
    % 创建所有UI组件（包含Bell态分析选项和实时可视化）
    
    % 获取窗口尺寸
    fig_pos = fig.Position;
    window_width = fig_pos(3);
    window_height = fig_pos(4);
    
    % 计算组件尺寸（响应式设计）
    left_panel_width = round(window_width * 0.33);
    right_panel_width = window_width - left_panel_width - 30; % 30px间距
    panel_height = window_height - 60; % 60px用于标题和边距
    
    % 标题
    title_label = uilabel(fig);
    title_label.Position = [20 window_height-40 window_width-40 30];
    title_label.Text = '量子态层析数据处理工具';
    title_label.FontSize = 16;
    title_label.FontWeight = 'bold';
    title_label.HorizontalAlignment = 'center';
    
    % ========== 左侧控制面板 ==========
    control_panel = uipanel(fig);
    control_panel.Position = [20 20 left_panel_width panel_height];
    control_panel.Title = '控制面板';
    control_panel.FontWeight = 'bold';
    control_panel.FontSize = 12;
    
    % 输入设置组 - 调整位置，确保完全可见
    input_panel = uipanel(control_panel);
    input_panel.Position = [10 panel_height-150 left_panel_width-20 140];
    input_panel.Title = '输入设置';
    input_panel.FontWeight = 'bold';
    
    % 数据路径
    uilabel(input_panel, 'Position', [10 90 60 22], 'Text', '数据路径:');
    data_path_edit = uieditfield(input_panel, 'text');
    data_path_edit.Position = [80 90 left_panel_width-120 22];
    data_path_edit.Tag = 'data_path';
    
    data_path_btn = uibutton(input_panel, 'push');
    data_path_btn.Position = [left_panel_width-30 90 20 22];
    data_path_btn.Text = '...';
    data_path_btn.ButtonPushedFcn = @(btn,event) selectDataPath(data_path_edit);
    
    % 文件类型和列号
    uilabel(input_panel, 'Position', [10 60 50 22], 'Text', '文件类型:');
    file_type_dropdown = uidropdown(input_panel);
    file_type_dropdown.Position = [70 60 50 22];
    file_type_dropdown.Items = {'CSV', 'XLSX'};
    file_type_dropdown.Value = 'CSV';
    file_type_dropdown.Tag = 'file_type';
    
    uilabel(input_panel, 'Position', [130 60 30 22], 'Text', '列号:');
    column_edit = uieditfield(input_panel, 'numeric');
    column_edit.Position = [170 60 30 22];
    column_edit.Value = 1;
    column_edit.Tag = 'column_number';
    
    % 维度设置
    uilabel(input_panel, 'Position', [10 30 30 22], 'Text', '维度:');
    dimension_edit = uieditfield(input_panel, 'numeric');
    dimension_edit.Position = [50 30 30 22];
    dimension_edit.Value = 2;
    dimension_edit.Tag = 'dimension';
    
    % Bell态分析选项
    bell_analysis_checkbox = uicheckbox(input_panel);
    bell_analysis_checkbox.Position = [90 30 100 22];
    bell_analysis_checkbox.Text = 'Bell态分析';
    bell_analysis_checkbox.Tag = 'bell_analysis';
    bell_analysis_checkbox.Value = false;
    
    % 文件编号范围
    uilabel(input_panel, 'Position', [10 0 70 22], 'Text', '文件编号:');
    uilabel(input_panel, 'Position', [90 0 15 22], 'Text', '从');
    start_number_edit = uieditfield(input_panel, 'numeric');
    start_number_edit.Position = [110 0 25 22];
    start_number_edit.Value = 1;
    start_number_edit.Tag = 'start_number';
    
    uilabel(input_panel, 'Position', [145 0 15 22], 'Text', '到');
    end_number_edit = uieditfield(input_panel, 'numeric');
    end_number_edit.Position = [165 0 25 22];
    end_number_edit.Value = 1;
    end_number_edit.Tag = 'end_number';
    
    % 输出设置组 - 调整位置
    output_panel = uipanel(control_panel);
    output_panel.Position = [10 panel_height-240 left_panel_width-20 80];
    output_panel.Title = '输出设置';
    output_panel.FontWeight = 'bold';
    
    % 保存路径
    uilabel(output_panel, 'Position', [10 30 60 22], 'Text', '保存路径:');
    save_path_edit = uieditfield(output_panel, 'text');
    save_path_edit.Position = [80 30 left_panel_width-120 22];
    save_path_edit.Tag = 'save_path';
    
    save_path_btn = uibutton(output_panel, 'push');
    save_path_btn.Position = [left_panel_width-30 30 20 22];
    save_path_btn.Text = '...';
    save_path_btn.ButtonPushedFcn = @(btn,event) selectSavePath(save_path_edit);
    
    % 操作控制组 - 调整位置
    button_panel = uipanel(control_panel);
    button_panel.Position = [10 panel_height-310 left_panel_width-20 60];
    button_panel.Title = '';
    button_panel.BorderType = 'none';
    
    % 按钮
    save_config_btn = uibutton(button_panel, 'push');
    save_config_btn.Position = [10 20 60 30];
    save_config_btn.Text = '保存配置';
    save_config_btn.ButtonPushedFcn = @(btn,event) saveDefaultConfig(fig);
    
    start_btn = uibutton(button_panel, 'push');
    start_btn.Position = [80 20 60 30];
    start_btn.Text = '开始处理';
    start_btn.ButtonPushedFcn = @(btn,event) startProcessingWithBell(fig);
    start_btn.BackgroundColor = [0.2 0.8 0.2];
    
    clear_btn = uibutton(button_panel, 'push');
    clear_btn.Position = [150 20 50 30];
    clear_btn.Text = '清空';
    clear_btn.ButtonPushedFcn = @(btn,event) clearVisualization(fig);
    
    % 进度显示组 - 调整位置，给更多空间
    progress_panel = uipanel(control_panel);
    progress_panel.Position = [10 20 left_panel_width-20 panel_height-340];
    progress_panel.Title = '处理进度';
    progress_panel.FontWeight = 'bold';
    
    % 计算进度面板内部尺寸
    progress_width = left_panel_width - 40;
    progress_height = panel_height - 350;
    
    % 当前文件显示
    uilabel(progress_panel, 'Position', [10 progress_height-30 50 22], 'Text', '当前文件:');
    current_file_label = uilabel(progress_panel, 'Position', [70 progress_height-30 progress_width-70 22], 'Text', '等待开始...');
    current_file_label.Tag = 'current_file';
    
    % 进度条
    progress_gauge = uigauge(progress_panel, 'linear');
    progress_gauge.Position = [10 progress_height-60 progress_width-20 20];
    progress_gauge.Limits = [0 100];
    progress_gauge.Value = 0;
    progress_gauge.Tag = 'progress_gauge';
    
    % 处理日志 - 缩小高度，支持滚动
    uilabel(progress_panel, 'Position', [10 progress_height-90 50 22], 'Text', '处理日志:');
    log_textarea = uitextarea(progress_panel);
    log_textarea.Position = [10 10 progress_width-20 progress_height-120];
    log_textarea.Value = {'准备就绪，请配置参数后开始处理...'};
    log_textarea.Tag = 'log_textarea';
    log_textarea.Editable = 'off';
    
    % ========== 右侧可视化区域 ==========
    visualization_panel = uipanel(fig);
    visualization_panel.Position = [left_panel_width+30 20 right_panel_width panel_height];
    visualization_panel.Title = '实时可视化显示';
    visualization_panel.FontWeight = 'bold';
    visualization_panel.FontSize = 12;
    
    % 计算可视化区域尺寸
    viz_width = right_panel_width - 20;
    viz_height = panel_height - 20;
    top_height = round(viz_height * 0.5);  % 顶部三图区域高度 - 50%
    bottom_height = viz_height - top_height - 10;  % 底部谱分解区域高度 - 50%
    
    % 数值结果显示区域
    results_panel = uipanel(visualization_panel);
    results_panel.Position = [10 viz_height-top_height+10 round(viz_width/3)-5 top_height-20];
    results_panel.Title = '计算结果';
    results_panel.FontWeight = 'bold';
    
    % 创建数值显示文本框
    results_textarea = uitextarea(results_panel);
    results_textarea.Position = [10 10 results_panel.Position(3)-20 results_panel.Position(4)-30];
    results_textarea.Tag = 'results_display';
    results_textarea.Editable = 'off';
    results_textarea.FontSize = 10;
    results_textarea.Value = {'等待计算...'};
    
    % 振幅图显示区域 - 使用mapmap绘制
    amplitude_panel = uipanel(visualization_panel);
    amplitude_panel.Position = [round(viz_width/3)+15 viz_height-top_height+10 round(viz_width/3)-5 top_height-20];
    amplitude_panel.Title = '振幅图 (mapmap)';
    amplitude_panel.FontWeight = 'bold';
    
    % 振幅图轴
    amplitude_axes = uiaxes(amplitude_panel);
    amplitude_axes.Position = [10 10 amplitude_panel.Position(3)-20 amplitude_panel.Position(4)-30];
    amplitude_axes.Tag = 'amplitude_axes';
    amplitude_axes.Title.String = '振幅分布';
    amplitude_axes.XLabel.String = '实部';
    amplitude_axes.YLabel.String = '虚部';
    
    % 相位图显示区域 - 使用mapmap绘制
    phase_panel = uipanel(visualization_panel);
    phase_panel.Position = [round(2*viz_width/3)+20 viz_height-top_height+10 round(viz_width/3)-5 top_height-20];
    phase_panel.Title = '相位图 (mapmap)';
    phase_panel.FontWeight = 'bold';
    
    % 相位图轴
    phase_axes = uiaxes(phase_panel);
    phase_axes.Position = [10 10 phase_panel.Position(3)-20 phase_panel.Position(4)-30];
    phase_axes.Tag = 'phase_axes';
    phase_axes.Title.String = '相位分布';
    phase_axes.XLabel.String = '实部';
    phase_axes.YLabel.String = '虚部';
    
    % 谱分解显示区域
    spectral_panel = uipanel(visualization_panel);
    spectral_panel.Position = [10 10 viz_width bottom_height];
    spectral_panel.Title = '谱分解结果';
    spectral_panel.FontWeight = 'bold';
    
    % 谱分解轴
    spectral_axes = uiaxes(spectral_panel);
    spectral_axes.Position = [10 10 spectral_panel.Position(3)-20 spectral_panel.Position(4)-30];
    spectral_axes.Tag = 'spectral_axes';
    spectral_axes.Title.String = '密度矩阵谱分解';
    spectral_axes.XLabel.String = '本征态';
    spectral_axes.YLabel.String = '概率';
    
    % 初始化可视化显示
    initializeVisualization(fig);
    
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
        processSingleFileWithBell(file_name, params, @updateLog, fig);
        
        drawnow;
    end
    
    % 完成处理
    progress_gauge.Value = 100;
    current_file_label.Text = '处理完成';
    updateLog('所有文件处理完成！');
    
    uialert(fig, '数据处理完成！', '完成', 'Icon', 'success');
end

function processSingleFileWithBell(file_name, params, updateLog, fig)
    % 处理单个文件（包含Bell态分析和实时可视化）
    
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
        
        % 更新可视化显示
        updateLog('  更新可视化显示...');
        updateAllVisualizations(fig, rho_final, first_chi2, final_chi2, purity1, purity2);
        
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
            % 子维度字段已移除
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
    % 不再校验子维度（已移除）
    
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

% ========== 可视化相关函数 ==========

function initializeVisualization(fig)
    % 初始化可视化显示
    try
        % 获取所有轴对象和文本框
        results_textarea = findobj(fig, 'Tag', 'results_display');
        amplitude_axes = findobj(fig, 'Tag', 'amplitude_axes');
        phase_axes = findobj(fig, 'Tag', 'phase_axes');
        spectral_axes = findobj(fig, 'Tag', 'spectral_axes');
        
        % 清空所有轴
        cla(amplitude_axes);
        cla(phase_axes);
        cla(spectral_axes);
        
        % 设置默认显示
        results_textarea.Value = {'等待计算...'};
        amplitude_axes.Title.String = '振幅分布 (mapmap)';
        phase_axes.Title.String = '相位分布 (mapmap)';
        spectral_axes.Title.String = '密度矩阵谱分解';
        
        % 添加等待提示
        text(amplitude_axes, 0.5, 0.5, '等待计算...', 'HorizontalAlignment', 'center', ...
             'VerticalAlignment', 'middle', 'FontSize', 12, 'Color', [0.5 0.5 0.5]);
        text(phase_axes, 0.5, 0.5, '等待计算...', 'HorizontalAlignment', 'center', ...
             'VerticalAlignment', 'middle', 'FontSize', 12, 'Color', [0.5 0.5 0.5]);
        text(spectral_axes, 0.5, 0.5, '等待计算...', 'HorizontalAlignment', 'center', ...
             'VerticalAlignment', 'middle', 'FontSize', 12, 'Color', [0.5 0.5 0.5]);
        
        % 设置轴范围
        axis(amplitude_axes, [0 1 0 1]);
        axis(phase_axes, [0 1 0 1]);
        axis(spectral_axes, [0 1 0 1]);
        
    catch ME
        fprintf('初始化可视化时出错: %s\n', ME.message);
    end
end

function clearVisualization(fig)
    % 清空可视化显示
    try
        initializeVisualization(fig);
        
        % 更新日志
        log_area = findobj(fig, 'Tag', 'log_textarea');
        current_log = log_area.Value;
        current_log{end+1} = ['[' datestr(now, 'HH:MM:SS') '] 可视化显示已清空'];
        log_area.Value = current_log;
        
    catch ME
        fprintf('清空可视化时出错: %s\n', ME.message);
    end
end

function updateResultsDisplay(fig, rho, first_chi2, final_chi2, purity1, purity2)
    % 更新数值结果显示
    try
        results_textarea = findobj(fig, 'Tag', 'results_display');
        
        % 计算额外指标
        dimension = size(rho, 1);
        trace_rho = trace(rho);
        max_eigenvalue = max(real(eig(rho)));
        min_eigenvalue = min(real(eig(rho)));
        
        % 构建显示文本
        results_text = {
            '=== 量子态层析计算结果 ===';
            '';
            sprintf('维度: %d×%d', dimension, dimension);
            sprintf('迹: %.6f', trace_rho);
            '';
            '=== 重构精度 ===';
            sprintf('线性重构 chi²: %.3e', first_chi2);
            sprintf('最大似然法 chi²: %.3e', final_chi2);
            sprintf('精度提升: %.1f倍', first_chi2/final_chi2);
            '';
            '=== 量子态特性 ===';
            sprintf('线性重构纯度: %.6f', purity1);
            sprintf('最大似然法纯度: %.6f', purity2);
            sprintf('最大本征值: %.6f', max_eigenvalue);
            sprintf('最小本征值: %.6f', min_eigenvalue);
            '';
            '=== 物理约束检查 ===';
            sprintf('正定性: %s', ternary(max_eigenvalue >= 0, '满足', '不满足'));
            sprintf('归一化: %s', ternary(abs(trace_rho - 1) < 1e-6, '满足', '不满足'));
            sprintf('厄米性: %s', ternary(ishermitian(rho), '满足', '不满足'));
        };
        
        % 更新显示
        results_textarea.Value = results_text;
        
    catch ME
        fprintf('更新数值结果显示时出错: %s\n', ME.message);
    end
end

function updateAmplitudePhasePlots(fig, rho)
    % 使用mapmap绘制振幅和相位图
    try
        amplitude_axes = findobj(fig, 'Tag', 'amplitude_axes');
        phase_axes = findobj(fig, 'Tag', 'phase_axes');
        
        % 清空轴
        cla(amplitude_axes);
        cla(phase_axes);
        
        % 获取维度
        dimension = size(rho, 1);
        
        % 使用mapmap绘制振幅图
        try
            % 设置当前轴为振幅图轴
            axes(amplitude_axes);
            mapmap_copy(rho, dimension, 'amplitude');
            amplitude_axes.Title.String = sprintf('振幅分布 (维度: %d)', dimension);
            amplitude_axes.XLabel.String = '实部';
            amplitude_axes.YLabel.String = '虚部';
        catch
            % 如果mapmap失败，使用备用方法
            amplitude = abs(rho);
            imagesc(amplitude_axes, amplitude);
            colorbar(amplitude_axes);
            colormap(amplitude_axes, 'hot');
            amplitude_axes.Title.String = '振幅分布 (备用)';
        end
        
        % 使用mapmap绘制相位图
        try
            % 设置当前轴为相位图轴
            axes(phase_axes);
            mapmap_copy(rho, dimension, 'phase');
            phase_axes.Title.String = sprintf('相位分布 (维度: %d)', dimension);
            phase_axes.XLabel.String = '实部';
            phase_axes.YLabel.String = '虚部';
        catch
            % 如果mapmap失败，使用备用方法
            phase = angle(rho);
            imagesc(phase_axes, phase);
            colorbar(phase_axes);
            colormap(phase_axes, 'hsv');
            phase_axes.Title.String = '相位分布 (备用)';
        end
        
    catch ME
        fprintf('更新振幅相位图时出错: %s\n', ME.message);
    end
end

function updateSpectralDecomposition(fig, rho)
    % 更新谱分解显示
    try
        spectral_axes = findobj(fig, 'Tag', 'spectral_axes');
        
        % 清空轴
        cla(spectral_axes);
        
        % 进行特征值分解
        [eigenvectors, eigenvalues] = eig(rho);
        eigenvalues = diag(eigenvalues);
        
        % 按特征值大小排序
        [eigenvalues, idx] = sort(eigenvalues, 'descend');
        eigenvectors = eigenvectors(:, idx);
        
        % 只显示非零特征值
        nonzero_idx = eigenvalues > 1e-10;
        eigenvalues = eigenvalues(nonzero_idx);
        eigenvectors = eigenvectors(:, nonzero_idx);
        
        % 绘制特征值（概率）
        bar(spectral_axes, 1:length(eigenvalues), eigenvalues, 'FaceColor', [0.2 0.6 0.8]);
        spectral_axes.Title.String = sprintf('谱分解结果 (非零本征值: %d)', length(eigenvalues));
        spectral_axes.XLabel.String = '本征态';
        spectral_axes.YLabel.String = '概率';
        spectral_axes.YLim = [0, max(eigenvalues) * 1.1];
        
        % 添加数值标注
        for i = 1:length(eigenvalues)
            text(spectral_axes, i, eigenvalues(i) + max(eigenvalues) * 0.02, ...
                 sprintf('%.3f', eigenvalues(i)), 'HorizontalAlignment', 'center', ...
                 'FontSize', 8, 'Color', 'red');
        end
        
        % 设置网格
        grid(spectral_axes, 'on');
        
    catch ME
        fprintf('更新谱分解显示时出错: %s\n', ME.message);
    end
end

function updateAllVisualizations(fig, rho, first_chi2, final_chi2, purity1, purity2)
    % 更新所有可视化显示
    try
        % 更新数值结果显示
        updateResultsDisplay(fig, rho, first_chi2, final_chi2, purity1, purity2);
        
        % 更新振幅相位图 (使用mapmap)
        updateAmplitudePhasePlots(fig, rho);
        
        % 更新谱分解
        updateSpectralDecomposition(fig, rho);
        
        % 强制刷新显示
        drawnow;
        
    catch ME
        fprintf('更新可视化显示时出错: %s\n', ME.message);
    end
end

function result = ternary(condition, true_value, false_value)
    % 三元运算符函数
    if condition
        result = true_value;
    else
        result = false_value;
    end
end
