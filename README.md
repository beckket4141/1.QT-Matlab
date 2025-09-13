# 量子态层析数据处理工具

[![MATLAB](https://img.shields.io/badge/MATLAB-R2018b+-blue.svg)](https://www.mathworks.com/products/matlab.html)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0-orange.svg)](CHANGELOG.md)

一个完整的量子态层析数据处理工具，支持图形界面、命令行和Bell态分析功能。

## ✨ 主要功能

- 🔬 **量子态密度矩阵重构** - 线性重构 + 最大似然法优化
- 📊 **多维度支持** - 2D, 3D, 4D, 9D, 16D等
- 🎯 **Bell态分析** - 专门的Bell态保真度计算
- 📈 **结果可视化** - 振幅图和相位图
- 📁 **批量处理** - 支持大量文件自动处理
- 💾 **多格式输出** - MAT, XLSX, PNG, TXT

## 🚀 快速开始

### 方法1：图形界面（推荐）

```matlab
% 启动标准UI
run_ui

% 启动Bell态分析UI
run_ui_with_bell
```

### 方法2：命令行

```matlab
% 编辑参数后运行
main_Excel_o_ui
```

## 📋 环境要求

- **MATLAB**: R2018b或更高版本
- **工具箱**: Optimization Toolbox, Statistics and Machine Learning Toolbox
- **内存**: 建议8GB以上

## 📖 使用指南

详细使用说明请参考：[使用指南](docs/使用指南.md)

## 🔧 功能模块

### 核心算法
- `reconstruct_density_matrix_nD.m` - 线性重构
- `reconstruct_density_matrix_nD_MLE.m` - 最大似然法
- `likelihood_function.m` - 似然函数

### Bell态分析
- `Bell_state.m` - Bell态保真度计算
- `fidelity.m` - 保真度计算
- `bell_analysis_tool.m` - Bell态分析工具

### 结果处理
- `mapsave.m` - 图像保存
- `save_density_matrix_results.m` - 结果保存

## 📁 输出文件

### 标准输出
- `rho_matrix_[编号].mat` - 密度矩阵(MATLAB格式)
- `rho_matrix_[编号].xlsx` - 密度矩阵(Excel格式)
- `file_[编号]_amplitude.png` - 振幅图
- `file_[编号]_phase.png` - 相位图
- `results_[编号].txt` - 计算结果

### Bell态分析输出
- `file_[编号]_bell_fidelity.xlsx` - Bell态保真度
- `file_[编号]_bell_analysis.mat` - Bell态分析结果
- `file_[编号]_bell_analysis.txt` - Bell态分析报告

## 🎯 使用场景

### 1. 日常研究使用
```matlab
run_ui  % 启动图形界面，适合交互式使用
```

### 2. Bell态研究
```matlab
run_ui_with_bell  % 启动Bell态分析版本
```

### 3. 批量数据处理
```matlab
% 修改main_Excel_o_ui.m中的参数
base_path = '你的数据路径';
dimension = 4;
base_number_start = 1;
base_number_end = 100;
main_Excel_o_ui;
```

## ❓ 常见问题

### Q: 程序启动失败？
A: 检查MATLAB版本和工具箱是否安装完整。

### Q: Bell态分析支持哪些维度？
A: 目前支持4, 9, 16维度。

### Q: 如何验证结果正确性？
A: 检查chi²值（<1e-4）、纯度（0-1）和保真度（0-1）。

## 📚 文档

- [使用指南](docs/使用指南.md) - 详细使用说明
- [依赖关系分析](docs/依赖关系分析文档.md) - 技术文档
- [UI说明](docs/README_UI.md) - 界面说明

## 🔄 版本历史

- **v1.0** - 初始版本，包含完整的量子态层析功能

## 📞 技术支持

如有问题或建议，请联系开发团队。

---

**开发团队**: 量子层析项目组  
**最后更新**: 2024年  
**许可证**: MIT
