# COMET Notebook 命令与语法汇总（上）

> **覆盖范围**：课程 Stata 资料 `/Stata/Comet` 文件夹内的全部 COMET 材料——Notebook 02 至 18，以及 3 个附加文件（详见附录 A）。
> **编写原则**：只收录这些文件中**展示或讲解过**的命令与语法；不加入文件之外的高级用法；**不提供示例**；**不使用表格**。
> **格式约定**：`代码` 表示命令或语法结构；【】内为必要说明；个别处已标注原文的拼写/截断情况。

---

## 〇、通用语法与书写风格要点（跨 Notebook 汇总）

- 命令基本格式：`命令 变量列表, 选项`——**选项一律写在逗号之后**；条件限定写在变量列表之后、逗号之前：`命令 变量列表 if 条件, 选项`。
- 条件运算符：`==`、`!=`、`>`、`<`、`>=`、`<=`；逻辑运算：`&`（与）、`|`（或）、`!`（亦写作 `~`，非）；相关函数：`inlist()`、`inrange()`、`missing()`；缺失值写作 `.`（字符串为 `""`）。
- 范围限定：`in <范围>`，如 `in 1/10`、`in 1/100`。
- 注释共三种：`*`（整行注释）、`//`（行内注释）、`/* … */`（多行注释）。
- 命令跨行续写：使用 `///`（文档中个别处以 `//` 结尾续行）。
- 宏：局部宏 `local 名称 = 值`，引用写作 `\`名称'`（反引号+单引号）；全局宏 `global 名称 值`，引用写作 `${名称}`（也见 `$名称`）。
- 前缀命令（pre-command）：`by 分组变量:`、`bysort 分组变量:`；`capture`（忽略报错）、`noisily`（显示报错过程）、`capture noisily`（两者结合）。
- 因子记号与滞后算子：`i.变量`（类别虚拟变量）、`c.变量`（连续变量）、`#`（交互项）、`##`（交互项+主效应）；`L1.变量`、`L数字.变量`（滞后）；`F1.变量`、`F数字.变量`（前导）。
- 安装外部命令：`ssc install 包名`（如 `ssc install reghdfe`、`ssc install xttest3`、`ssc install coefplot`）。
- 命名与文件习惯：变量名小写、描述性强；do-file 文件名简短、无空格、无大写；日志文件名清晰；文件名采用序号前缀与版本/日期后缀。

---

## 一、02 – Working with Do-Files（do 文件与日志）

- `do <dofile_name>.do` — 运行 do 文件（命令 `do` 后接 do 文件的路径/文件名）。
- `display <表达式或字符串>` — 在结果窗口显示内容。
- `log using <filename>, text replace` — 打开日志文件；`text` 生成文本格式日志、`replace` 覆盖已有同名日志。
- `log close` — 关闭日志文件。
- `capture log close` — 加 `capture` 前缀，避免没有打开日志时报错。
- 注释写法：`* 整行注释`；`display 5 // 行内注释`；`/* 多行注释 */`。
- 执行 do 文件的三种方式：命令行/另一个 do 文件中用 `do` 运行、编辑器右上角运行按钮、选中部分代码后运行。

## 二、03 – Stata Essentials（基础命令与循环）

- `sysuse auto.dta, clear` — 载入 Stata 自带示例数据。
- `describe` — 查看数据集变量清单与属性。
- `help <command>`（如 `help summarize`、`help rename`）— 打开命令帮助。
- `summarize [varlist] [if] [in] [weight] [, options]` — 描述统计；常用选项：`detail`（或 `d`）、`meanonly`、`format`、`separator(#)`（文档处显示为 operator(#)，含义为每隔几个变量插入分隔线）。
- 条件限定：`summarize <var> if <条件> / in <范围>`；条件运算符 `== > < >= <= !=`、逻辑 `& | ! ~`；函数 `inlist()`、`inrange()`、`missing()`。
- `sort <varlist>` — 排序。
- `local <name> = <值>`（如 `local i = 95`），引用 `` `i' ``；`display \`i'`。
- `forvalues counter = 1(1)10 { … }` — 数值循环；注意：`{` 必须与第一行同写且其后不能有注释，`}` 必须单独一行。
- `while <条件> { … }` — 条件循环（循环体内用 `local counter = \`counter'+1` 递增）。
- `forecast local_var_name in "list of variables"` — 遍历变量名清单的循环【原文 3.3.2 写作 forecast；Wrap-up 表与后续模块将其称为 `foreach`】。
- Wrap-up 表提及：`describe`、`help`、`summarize`、`display`、`search`（查找可用命令）、`while`、`forvalues`、`foreach`。

## 三、04 – Working with Locals and Globals（宏）

- `describe`、`help`、`help format`、`sysuse auto, clear`、`summarize`（`su`）— 复习命令。
- `return list` — 列出最近命令返回的 r() 结果；`ereturn list` — 列出 e() 结果。
- `display r(mean)` — 显示 r() 标量（如均值）。
- `local <name> = <值或表达式>` — 存数值（如把 `r(mean)` 存入 local）；`local <name> : display <格式> r(...)` — 存格式化结果。
- `levelsof <var>, local(<name>)` — 把变量的所有不同取值存入一个 local。
- `generate <newvar> = <表达式>`；`replace <var> = <值> if <条件>`。
- `global <name> <内容>` — 定义全局宏（如 `global covariates "rep78 foreign"`、`global controls trunk foreign`）；引用 `${name}` 或 `$name`；路径类：`global datadirectory …`。
- `use "…", clear`、`save "…", replace`；`capture noisily use "…", clear`、`capture noisily save using "…", replace`。
- 循环：`foreach x in \`levels_rep' { … }`、`forvalues`、`while`、`for`。
- 要点：local 只存在于代码执行期间、结束后消失；global 常驻内存直到关闭 Stata，常用于存路径。

## 四、05 – Opening Data Sets（打开数据）

- `clear` — 清空工作区；`help clear`。
- `cd`（改变工作目录）的多种写法：`cd "<路径>"`、`cd ..`、`cd ...`、`cd <文件夹名>`、单用 `cd` 返回默认目录；`pwd` — 显示当前工作目录。
- `capture noisily cd "<路径>"` — 切换目录并显示过程。
- `import delimited using "<文件>.csv", clear` — 导入 csv；选项如 `varnames(#|nonames)`、`clear`；`import excel` — 导入 Excel；`help import delimited`。【11-13 补录】具体 Excel 选项 `sheet("<表名>")`、`cellrange(A2:H11)`、`firstrow` 逐字见于 `StataCheatSheet_analysis_19.pdf` p.3；CSV 选项 `rowrange(2:11) colrange(1:8) varnames(2)` 同页。COMET 05 只讲 `import excel` / `import delimited` 两个命令名，选项以 CheatSheet 为准。
- `use "<文件>.dta", clear` — 打开 Stata 格式数据；`save "insert_directory/dataset_name.dta", replace`（`capture noisily save …`）。
- `export delimited using "<文件>.csv", replace`；`export excel` — 导出为 csv / Excel。
- `list in 1/3` — 查看前面几行数据；`describe`；`browse`、`%browse` — 数据编辑器；`codebook <var>`；`tabulate <var>`；`lookfor <关键词>`。
- `wbopendata`、`sdmxuse` — 直接从网站/数据库导入数据（文档提及）。
- 常见错误示范：`tabulate sex if sex==F` ✗ 与 `tabulate sex if sex=="F"` ✓——字符串条件必须加引号。
- Wrap-up 表：`clear`、`cd`、`pwd`、`use`、`import delimited`、`import excel`、`list`、`describe`、`browse`、`codebook`、`tabulate`、`lookfor`、`export excel`、`save`（配 `capture noisily`）。

## 五、06 – Generating Variables（生成变量）

- `clear *`；`cd "<路径>"`；`capture noisily import delimited using "<文件>.csv", clear`。
- `describe <变量模式>`（如 `describe reg*`）；`browse`、`%browse`；`summarize`。
- `generate <newvar> = <条件/表达式>` — 生成变量（基本语法：命令 + 变量名 + 条件）。
- 虚拟变量：`generate <dummy> = 1 if <条件>`（字符串条件如 `sex=="F"`）；再用 `replace <dummy> = 0 if missing(<dummy>)` 补齐另一类别。【报错说明】变量已存在时 Stata 会报"already defined"，改用 `replace`。
- 表达式变换：`generate log_earnings = log(earnings)`（取自然对数）；文档还展示 `real()`、`string()` 等转换函数。
- `capture drop <var>` — 删除变量且忽略报错；`drop`。
- `codebook`、`lookfor` — 查看/检索变量；`rename <旧名> <新名>`；`label variable <var> "<标签>"`。

## 六、07 – Conducting Within Group Analysis（组内分析）

- `clear *`；`use "fake_data.dta", clear`；`browse`、`%browse 10`。
- `sort <varlist>`（如 `sort workerid year`、`sort year`）。
- `by <分组变量>: <命令>` — 对子集重复命令（要求数据已按分组变量排序）；
- `bysort <分组变量>: <命令>`（或 `bysort <组1> <组2>: …`）— 一步完成排序+分组。
- `capture drop <var>`；`capture noisily by year: generate var_one = 1`（观察 "not sorted" 报错）。
- `generate <var> = _n` — 组内观测序号；`generate <var> = _N` — 组内观测总数（配合 `bysort` 使用）。
- `keep if <条件>` — 保留满足条件的观测（如 `keep if tot_obs==8`、`keep if !missing(earnings)`）。
- `egen`：基本语法 `bysort groupvar: egen new_var = function(), options`；文档示例函数：`mean()`、`total()`、`rowtotal()`（按行对多个变量求和、自动忽略缺失值，与直接 `+` 相加不同）；`help egen` 查看全部函数。
- `collapse`：语法 `collapse (统计量1) 新名 = 变量1 (统计量2) 新名2 = 变量2 …, [pweight = 权重变量]`；统计量如 `(mean)`、`(sd)`、`(count)`；`help collapse`、`help weight`；注意 collapse 会替换内存中的数据（先保存原数据）；`sd` 不允许与 `pweight` 同时使用。
- `reshape wide <stubs>, i(<i变量>) j(<j变量>)`；`reshape long <stubs>, i(<i变量>) j(<j变量>)`；`reshape error` — 诊断 reshape 报错。
- 概念：balanced panel（平衡面板）；`_n`、`_N` 的使用规则。
- Wrap-up 表：`by`、`generate`、`sort`、`summarize`、`_n`、`_N`、`drop`、`keep`、`egen`、`rowtotal()`、`collapse`、`reshape`。

## 七、08 – Combining Datasets（合并数据集）

- `clear *`；`use "fake_data.dta", clear`；`%browse 10`。
- `duplicates report <varlist>` — 检查唯一标识组合是否有重复。
- `generate`、`collapse`（生成合并用的组级数据）；`label var <var> "<标签>"`；`save <名称>, replace`。
- `merge 1:1 <关键变量> using <using数据名>` / `merge m:1 …` / `merge 1:m …` — 按数据结构选择匹配类型；主数据放在内存中。
- `capture drop _merge`；`keep if _merge==3` — 只保留匹配成功的观测。
- `append using <数据名>` — 纵向追加合并。
- 【_merge 取值说明：1=仅主数据、2=仅 using 数据、3=匹配成功】。

## 八、09 – Creating Meaningful Visuals（可视化）

- `clear *`；`cd`；`use fake_data, clear`；`generate log_earnings = log(earnings)`；`label var`。
- `preserve` / `restore` — 临时保存/还原数据（便于先用 `collapse (mean) log_earnings, by(year)` 汇总出图再还原）。
- `twoway (图形类型 x变量 y变量)` — 双变量图总格式；类型：`scatter`、`connected`、`line`、`histogram`、`lfit`（拟合线，作为第二个图加入）。
- 图形选项：`color()`、`lcolor()`、`if` 条件、`xtitle()`、`ytitle()`、`title()`、`xlabel()`、`ylabel()`、`legend(label(1 "…") label(2 "…"))`、`graphregion(color(white))`。【11-14 补录】`xlabel()` / `ylabel()` 逐字见于 COMET Notebook 图形示例，与此前已记的 `ylab()` / `xline()` 同族。
- 直方图：`histogram <var>`；分组对比：`twoway (histogram <var> if <条件1>, color() lcolor()) (histogram <var> if <条件2>, …), legend(…)`。
- 条形图：`graph bar (statistic) x变量, over(分组变量)`（如 `(mean)`）；横向条形图用 `graph hbar` 替代 `bar`；两组分类：连续写两个 `over(…)`；选项：`over(分组变量, relabel(1 "标签1" 2 "标签2" …))`、`title()`、`ytitle()`、`graphregion(color(white))`、`bar(1, fcolor(dkgreen))`（第 1 个被绘变量条形填充色）。条形图必须从 0 开始。
- 导出：`graph export <文件名>.<后缀>, as(jpg|png|svg|pdf) replace`。
- 要点：拟合线用 lfit 类型加入 twoway 图。Wrap-up 表：`twoway scatter`、`twoway connected`、`twoway line`、`twoway histogram`、`graph bar, over(varname)`。

## 九、10 – Combining Graphs（组合图形）

- `clear *`；`cd`；`use`；`generate`；`label var`；`preserve`；`collapse (mean) log_earnings, by(region treated year)`；`restore`。
- 多图叠加：`twoway (connected … ) || (connected … )`（或 `///` 换行书写）。
- 常用选项：`xline(2002, lpattern(dash))`、`ylab()`、`xtitle()`、`ytitle()`、`legend(label(1 "Treated") label(2 "Control"))`、`aspectratio(1)`、`title()`、`name("R1", replace)`。
- 单图：`histogram <var> if <条件>, aspectratio(1) name("histogram1", replace)`。
- `graph combine R1 R2, cols(2) title("…") saving(panel_a, replace)` — 合成面板图；也可在同一命令中加 `name(<新名>, replace)`。
- `graph export`；`help graph combine`；`||` 与 `///` 的书写方式。

## 十、11 – Conducting Regression Analysis（回归）

- `clear *`；`cd`；`use`；`generate logearn = log(earnings)`。
- `regress dep_varname indep_varname` — 一元 OLS；`regress depvar indepvar1 indepvar2` — 多元（变量可直接追加）。
- 二次项/变换：先生成新变量（如平方项 `generate <x2> = <x>^2` 或对数），再放进 `regress`。
- 权重：Stata 有 4 种权重——`fw`（频数）、`aw`（分析）、`pw`（概率/抽样）、`iw`（重要性）；回归加权写法：`regress y x [pw = weight_pct]`（写在自变量列表之后）；`help weight`。
- 预测：回归后用 `predict <newvar>` — 生成保存因变量预测值的变量。
- Wrap-up 表：`regress dep_varname indep_varname1 indep_varname2 … [pw= weight_pct]`；`predict varname`。

## 十一、12 – Exporting Regression Output（导出回归结果）

- `clear *`；`cd`；`use`。
- `generate logearn = log(earnings)`；`generate logage = log(age)`；`generate sexdummy = 1 if sex == "F"`；`replace sexdummy = 0 if missing(sexdummy)`。
- `label var logearn "Earnings (ln)"` 等标签设置。
- `regress logearn logage sexdummy`。
- `estimates store model1`（把回归结果存为模型对象 model1/model2/model3…）。
- `etable`（Stata 17 起内置）：`etable, export(<文件名>)`；支持 Word/Excel/LaTeX/Markdown/PDF（按扩展名区分）；常用选项：`export(table.docx, replace)`、`estimates(model1 model2 model3)`、`mstat(N)`、`mstat(r2)`、`mstat(r2_a)`、`mstat(F)`、`title()`、`showstars`、`showstarsnote`、`varlabel`（显示变量标签）、`column(dvlabel)`（因变量显示标签）、`keep(logage sexdummy)`（只显示指定系数）。
- 系数图：`ssc install coefplot`（首次安装）；`coefplot`（回归后直接运行）；选项：`drop(_cons)`（去掉常数项）、`graphregion(color(white))`、`levels(99.9 95)`（多个置信水平）、`vertical`（纵向排列）；配合 `graph export graph1.jpg, as(jpg) replace`。

## 十二、13 – Using Dummy Variables and Interactions（虚拟变量与交互项）

- `clear *`；`cd`；`use fake_data, clear`；`generate logearnings = log(earnings)`；`%browse 10`。
- 构造虚拟变量：`generate female`（条件基于 `sex=="F"`；两步法同前模块：`=1 if` + `replace = 0 if missing()`）。
- `regress logearnings female`；`regress logearnings female age`。
- `tabulate region, generate(regdummy)` — 为每个类别生成虚拟变量。
- `regress logearnings i.region` — 直接用 `i.` 加入类别虚拟变量。
- `fvset base 3 region` — 设定某类别为基组。
- `global regiondummies "…"`；`regress … ${regiondummies}` — 用全局宏管理一组虚拟变量。
- 高维固定效应：`ssc install reghdfe`；语法 `reghdfe depvar indepvars, absorb(fixedeffects)`（depvar=因变量、indepvars=解释变量、absorb 内为要为其生成虚拟变量的变量）；与 `reg … i.region` 等价，默认不显示被吸收的虚拟变量系数。
- 交互项：`regress logearnings i.female##c.age` — 分类变量须加 `i.`、连续变量须加 `c.`、交互用 `##`；【注意】`##` 会自动把两个主效应也放入回归；只用 `#` 时需要自己加入两个变量作控制。
- Wrap-up 表：`reg depvar indepvar i.var`；`reghdfe depvar indepvar, absorb(vars)`；`reg depvar var1#var2`（须另加 var1、var2）；`reg depvar var1##var2`。

## 十三、14 – Good Regression Practices（回归良好实践）

- `clear all`；`use fake_data, clear`。
- `summarize earnings, detail`；`return list`；`local <name> = r(p1) / r(p99)`；`display`；`round()`。
- 缩尾（winsorize）：`generate <var>_winsor = <var>`；`replace <var>_winsor = r(p1) if <var>_winsor < r(p1) & <var>_winsor != .`；`replace <var>_winsor = r(p99) if <var>_winsor > r(p99) & <var>_winsor != .`。
- 【11-11 补录，来源 14.1 逐字原文】`local <name> = round(r(p1)/r(min))` 与 `local <name> = round(r(max)/r(p99))` — 用两个 r() 标量做比值判断异常值量级。
- 【11-11 补录，来源 14.1 逐字原文】`display "文字 \`r(p1)' 文字"` — 在字符串内部直接引用 r() 标量；同段还有 `summarize <原变量> <缩尾变量>` 并列对比缩尾前后的均值、标准差、最小值、最大值。
- 【11-11 补录，来源 14.2 逐字原文】`generate <dummy> = <逻辑表达式>` — 用一步法生成 0/1 虚拟变量，例如 `generate male = sex == "M"`、`generate female = sex == "F"`；与 06 节的两步法（`= 1 if` 加 `replace = 0 if missing()`）并列，原文用这一步法演示完全共线性时 Stata 自动 omit 一个变量。
- 【11-11 补录，来源 14.4 逐字原文】`local <name> : display <格式> _b[<变量名>]` — 把估计出的系数按显示格式存进 local，例如 `local agemean : display %2.0fc r(mean)`、`local beta1 : display %5.3fc _b[age]`、`local beta2 : display %5.3fc _b[agesq]`；格式记号 `%2.0fc`、`%5.3fc` 亦出自此处。原文说明「Stata automatically stores the estimated coefficients in locals with syntax _b[regressor name]」。
- 【11-11 补录，来源 14.4 逐字原文】`local <name> = \`local1' + (2 * \`local2' * \`local3')` — 用多个 local 计算 nonlinear 项的 marginal effect at the means；配合 `generate agesq = age*age`、`regress logearnings age agesq` 手工构造平方项、`display "…\`local'…"` 输出结果。
- 截尾（trim）：`capture drop <var>_trim`；`generate <var>_trim = <var>`；`replace <var>_trim = . if <var>_trim < r(p1) & <var>_trim != .`；`replace <var>_trim = . if <var>_trim > r(p99) & <var>_trim != .`（缺失值会被 regress 自动剔除）。
- 稳健标准误（异方差处理）：`regress logearnings age, robust` — 在 regress 末尾加 `robust` 选项；【文档建议：自己的研究中默认使用稳健标准误】。
- 非线性：`regress logearnings c.age##c.age`（连续变量自交互=加入平方项）；`predict yhat, xb`（保存拟合值）；`twoway scatter yhat age`（散布图观察关系）。

## 十四、15 – Panel Data Regressions（面板数据回归）

- `clear*`；`use pwt100.dta, clear`；`describe …`。
- `encode countrycode, gen(ccode)` — 把字符串国家代码转为数值变量；`label var ccode "…"`。
- `xtset ccode year, yearly` — 声明面板：先面板变量、后时间变量、再加观测间隔选项；间隔也可用 `delta(2)`（每两年一期）；输出会显示 strongly balanced/unbalanced 等信息，务必检查。
- `generate lngdp = ln(rgdpe/pop)`（文档一处写作 rgdpo）；`generate lnhc = ln(hc)`。
- `xtreg lngdp lnhc` — 基本面板回归（相当于把 regress 换成 xtreg）。
- 固定效应两种做法：① `xtreg lngdp lnhc i.ccode`（显式加入国家虚拟变量）；② `xtreg lngdp lnhc, fe`（加 `fe` 选项）。
- 随机效应：`xtreg lngdp lnhc, re`（加 `re` 选项）。
- Hausman 检验：先运行固定效应模型并 `estimates store fixed`；再运行随机效应模型（同样存储）；然后 `hausman fixed random`；【结论：拒绝原假设则应采用固定效应模型】。
- `testparm i.varname` — 检验多个系数是否同时为 0（Test Seven 同题写作 testparam i.year，两处拼写以原文为准）。
- 滞后/前导：`L1.变量`（一期滞后）、`L数字.变量`；`F1.变量`、`F数字.变量`（前导）。
- 【11-11 补录，来源 15.4 逐字原文】`generate <新变量> = L1.<变量>`、`generate <新变量> = L10.<变量>` — 显式生成一期与十期滞后变量；同一节把滞后算子直接写进回归变量表，例如 `xtreg lngdp L1.lngdp L10.lngdp lnhc i.year, fe`，即不预先生成变量也能用 `L数字.` 参与回归。
- 【11-11 补录，来源 15.4 逐字原文】增长率变量构造：`generate lnn = ln(ln(pop)-ln(L1.pop))`、`generate dlngdp = ln(lngdp - L1.lngdp)` — 原文用这两个式子演示由水平值构造增长率与增长率对数。
- 异方差检验：`ssc install xttest3`；`xtreg … , fe` 后运行 `xttest3`（修正 Wald 统计量）。
- 序列相关检验：`capture noisily xtserial lngdp lnhc`；命令形式 `xtserial <变量列表>`。
- 【11-11 补录，来源 15.5.2 逐字原文】`capture noisily search xtserial` — 用 `search <命令名>` 检索可安装的 Stata 包（原文输出列出 st0039、xtserial、xtserialpm 等），再按 `ssc install` 或 `net install` 安装；本汇总前文只把 `search` 记作「查找可用命令」，未记这一用法。原文该处还直接出现 `command xtserial is unrecognized` 作为未安装时的报错示例。
- 修正：`xtpcse lngdp lnhc, het corr(ar1)` — Prais-Winsten 方法 GLS 回归，`het` 处理异方差、`corr(ar1)` 处理一阶序列相关。
- 【11-11 补录，来源 15.5.1 逐字原文】`xtpcse lngdp lnhc, het` — 只加 `het`、不加 `corr(ar1)` 的独立用法（原文先单独演示异方差修正，再演示加 `corr(ar1)` 同时处理序列相关）；此前本汇总只记了含 `corr(ar1)` 的合并写法。
- 【11-11 补录，来源 15.5.2 逐字警告，非命令】原文警示「The Prais-Winsten approach does not control for panel and time fixed-effects」，并要求用 `testparm` 分别检验年份与国家固定效应是否必要、显式把 `i.ccode` 写进回归。这是 `xtpcse` 设定时的必要语法动作，不是可选项。
- 【11-11 补录，来源 15.5.3 逐字原文】`drop if <var>==.` — 原文用 `drop if hc==.` 删除含缺失的观测以构造 balanced panel，再运行 `xtgcause`。
- Granger 因果检验：`xtgcause 因变量 解释变量`。
- Wrap-up 表：`xtset`、`xtreg`（含 `fe`/`re`）、`hausman`、`testparm`、`L数字.变量`/`F数字.变量`、`xttest3`、`xtpcse …, het`（可加 `corr(ar1)`）、`xtserial`、`xtgcause`。

## 十五、16 – Differences-in-Differences（双重差分）

- `clear*`；`use fake_data, clear`；`xtset workerid year, yearly`；`summarize treated, detail`。
- `generate logearn = log(earnings)`。
- 趋势图：`bysort year treated: egen meanarn = mean(logearn)`；`twoway (line meanarn year if 处理组条件, lcolor(gs12) lpattern(solid)) || (line meanarn year if 对照组条件, lcolor(gs6) lpattern(dash)), graphregion(color(white)) legend(label(1 "Treated") label(2 "Control")) ytitle(…) xtitle(…) xline(2002, lpattern(dash) lcolor(black))`；`graph export graph1.jpg, as(jpg) replace`。
- 多期 DID 回归：`generate post2003 = year>=2003`（政策后虚拟变量）；`areg logearn 1.treated#1.post2003 i.year, absorb(workerid)`（`areg` 或 `reghdfe`，`absorb()` 吸收个体固定效应）。
- 两期简化版：`keep if year==2002 | year==2003`；有效写法 `areg logearn treated#2003.year i.year, absorb(workerid)`；文中还演示了错误设定 `capture noisily areg logearn treated#2003.year i.year sex, absorb(workerid)`（time-invariant 变量会被吸收）。
- 事件研究：`capture drop time_entering_treatment`；`generate time_entering_treatment = 2003 if treated==1`；`replace time_entering_treatment = . if treated==0`；`capture drop event_time`；`generate event_time = year - time_entering_treatment`；`tabulate event_time, missing`；分箱：`replace event_time = -2 if event_time<-2 & treated==1`、`replace event_time = 2 if event_time>2 & treated==1`；生成虚拟变量 `tabulate event_time, gen(event_time_dummy)`；回归 `areg logearn event_time_dummy1 event_time_dummy3 event_time_dummy4 event_time_dummy5 i.year, absorb(workerid)`（省略基线期 k=-1）。
- 事件研究图：`coefplot, keep(event_time_*) vertical graphregion(color(white)) yline(0) rename(event_time_dummy1="k=-2" …)`；`graph export graph2.jpg, as(jpg) replace`。
- 概念：平行趋势假设、参照期 k=-1、只保留时变协变量的注意事项。

## 十六、17 – Instrumental Variable Analysis（工具变量）

- `clear*`；`use fake_data, clear`；`describe, detail`。
- 2SLS 两种命令（语法相同）：`ivregress 2sls <Y> (<X> = <Z>)`；`ivreg2 <Y> (<X> = <Z>)`（分别写因变量、内生自变量、工具变量）。
- `, first` 选项 — 显示第一阶段回归结果（检验工具相关性）。
- Wrap-up 表：`ivregress 2sls`、`ivreg2`、`, first`。

## 十七、18 – Stata Workflow Guide（工作流）

- `clear`；块注释 `/* … */` 用于项目信息区。
- 目录设置（全局宏）：`global proj_name "…"`；`global proj_main "$file_path/projects/${proj_name}"`；`global datadir "${proj_main}/data"`；同理 `figdir`、`tabledir`、`do_dir`、`log_dir`。
- `capture noisily cd "<路径>"`；`capture noisily dir` — 切换目录并列出文件。
- 导入：`capture noisily import delimited using "${datadir}/raw/fake_data.csv", clear`（原文该行显示为 import delimit）。
- 标签：`capture noisily la var birth_year "Year of Birth"`（`la var` 为 label variable 缩写）。
- 运行子 do 文件：`capture noisily do "${do_dir}/1_build_data.do"`、`…/2_description.do`、`…/3_results.do`（按序号顺序）。
- 条件运行设置：`global run_build = 1`；`if ${run_build}==1 { capture noisily do "…" }`（0=跳过、1=运行；另有 store_log_* 等设置）。
- 长命令跨行书写、文件命名规范（序号前缀+版本/日期后缀）。

---

## 附录 A：Comet 文件夹中的非 Stata（R 语言）材料须知

以下 3 个文件位于 Comet 文件夹，但内容为 **R 语言**材料，未纳入上述 Stata 命令清单（如需要可另行整理其命令）：

- `COMET - 2.2 - Intermediate - Working with Stargazer.pdf` — R 教程；出现 `library()`、`read_csv()`、`select()`、`lm()`、`sqrt(diag(vcovHC(…, type = "HC1")))`、`stargazer()`（含 type、title、digits、covariate.labels、out、no_space、dep.var.labels、omit.stat、keep.stat、align、single.row、order、ci、ci.level、se、column.labels 等选项）、`source()`。
- `Projects - Example Project for ECON 326 – COMET.pdf` — R 项目示例；出现 `library()`（ggplot2、haven、stargazer、tidyverse、car、vtable、sandwich、corrplot、lmtest）、`read_csv()`、`head()`、`str()`、`summary()`、`view()`、`read_dta()`、`source()` 等。
- `Projects - Example Project for ECON 325 – COMET.pdf` — R 项目示例；出现 `read_dta()`、`filter()`、`subset()`、`rename()`、`as.numeric()/as.character()/as_factor()`、`mutate()+case_when()`、`sumtable()`、`ggplot()+geom_bar()/geom_histogram()/geom_boxplot()`、`t.test()`、`quantile()`、`round()` 等。

## 附录 B：来源与缺口说明（何时需要回查原文）

- 本清单基于以下文件整理：Comet 文件夹内 Notebook 02–18 的 pdf/md/html 版本。
- 部分文件在课程 Stata 资料中存在截断或 OCR 失真（如 09 的个别小节、10 的 help 输出、16 的 rename 列表、18 的 import 行、个别变量拼写如 rgdpe/rgdpo 不一致等），本清单已按可核实内容整理并标注；如需逐字核对，请参考原文件。
- Notebook 11 的加权回归、Notebook 14 的 robust/非线性、Notebook 15 的面板检验、Notebook 16 的事件研究等细节均已经检索补齐；若你的原始文件版本更完整，欢迎补充上传以便进一步校准。
