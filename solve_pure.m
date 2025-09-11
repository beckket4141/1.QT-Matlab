% 假设您已经有了实验得到的密度矩阵 rho_final（4x4）
% rho_final = rho_th;

% 进行特征值分解
[eigVec, eigVal] = eig(rho_final);

% 找到对应特征值为 1 的本征向量（即纯态）
[~, idx] = max(diag(eigVal));  % 获取特征值最大的位置

% 对应的本征向量即为纯态的态矢量
pure_state_vector = eigVec(:, idx);

% 输出纯态的态矢量
disp('纯态的态矢量：');
disp(pure_state_vector);

% 假设四个基态列向量 b1, b2, b3, b4 是 4x1 向量
b1 = [1; 0; 0; 0];
b2 = [0; 1; 0; 0];
b3 = [0; 0; 1; 0];
b4 = [0; 0; 0; 1];

% 将基态表示为列向量（4x1）
basis = [b1, b2, b3, b4];

% 计算系数 c1, c2, c3, c4
c = zeros(4, 1);
for i = 1:4
    % 计算每个系数 c_i，即基态 b_i 与纯态矢量的内积
    c(i) = dot(basis(:, i), pure_state_vector);
end

% 输出系数 c1, c2, c3, c4
disp('系数 c1, c2, c3, c4：');
disp(c);

% 提取每个系数的模长 r 和相位 phi
r = abs(c); % 模长
phi = angle(c); % 相位

% 输出模长和相位（以 pi 为单位）
disp('模长和相位（以 pi 为单位）：');
for i = 1:4
    disp(['c' num2str(i) ': r' num2str(i) ' = ', num2str(r(i)), ', phi' num2str(i) ' = ', num2str(phi(i)/pi), 'π']);
end

% 将模长和相位保存在表格中
coeff_table = table(r, phi/pi, 'VariableNames', {'Modulus (r)', 'Phase (phi/pi)'}, 'RowNames', {'c1', 'c2', 'c3', 'c4'});

% 输出结果表格
disp('模长和相位的表格：');
disp(coeff_table);
