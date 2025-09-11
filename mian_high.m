% 主函数：输入维度选择
dimension = input('请输入维度（2、4 或其他维度）： ');

% 检查输入维度是否有效
if dimension < 2 || mod(dimension, 1) ~= 0
    disp('请输入有效的维度（必须为大于等于2的整数）。');
    return;
end

% 输入不同维度下的测量值，根据具体实验情况修改
if dimension == 2
    %% 2D 测量值
    PnD = [208, 209, 415, 151];
elseif dimension == 4
    %% 4D 测量值
%     PnD =  [167,4,2,108,45,69,57,75,197,102,1,3,79,61,37,36];%理想
    PnD  = P_th;
else
    %% 任意 n 维度（根据实际实验情况设置）
    % 这里以随机数模拟测量值为例，可以替换为实际测量值
   PnD =[17,15,408,349,20,40,19,313,14,20,3,231,284,136,179,7,25,30,1,33,19,235,127,17,36,152,236,140,141,3,15,38,8,18,20,186,181,6,20,205,731,220,263,128,195,219,134,183,55,241,218,200,122,222,302,130,219,158,553,166,96,6,33,8,2,124,154,29,9,22,46,256,236,2,20,194,110,13,32,119,210];
    %PnD =  P_th;
end

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
disp('chi^2 结果：');
disp(['线性求解 chi^2 value:', sprintf('%.8e', first_chi2)]);
disp(['最大似然法 chi^2 value:', sprintf('%.8e', final_chi2)]);

disp('纯度结果：');
disp(['线性求解 purity:', sprintf('%.8e', purity1)]);
disp(['最大似然法 purity:', sprintf('%.8e', purity2)]);

% 求保真度
rho1 = rho_th;  % 目标密度矩阵（可以替换为实际目标密度矩阵）
rho2 = rho_first;
rho3 = rho_final;

F1 = fidelity(rho1, rho2);
F2 = fidelity(rho1, rho3);

disp('保真度结果：');
disp(['线性求解 保真度: ', sprintf('%.8e', F1)]);
disp(['最大似然法 保真度: ', sprintf('%.8e', F2)]);

% 适当条件下可以增加 SDP 或其他方法进行对比
% [rho_sdp, final_chi2_sdp] = reconstruct_density_matrix_nD_SDP(PnD, rho_first, dimension);
% F3 = fidelity(rho1, rho_sdp);
% disp(['SDP重构 保真度: ', num2str(F3, '%.8f')]);
