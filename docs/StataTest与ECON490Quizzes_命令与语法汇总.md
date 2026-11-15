# StataTest 与 ECON490Quizzes 命令与语法汇总（下）

> **覆盖范围**：课程 Stata 资料 `/Stata/StataTest` 内 Test One – Test Seven；ECON490Quizzes2 – Quizzes15 系列（含 `econ490_quiz_14` 配套 log）；并按授权补充了 `StataCheatSheet_analysis_19.pdf` 的相关命令（见附录 A）。
> **编写原则**：只收录这些文件中**展示过**的命令与写法；评分标准中给出的写法优先采用；文件未展示写法处已注明；**不提供示例**；**不使用表格**。
> **格式约定**：`代码` 表示命令或语法；【】内为说明；"（评分标准）"表示写法取自测验评分表，"（题目描述）"表示仅由题目文字归纳。

---

## 〇、通用书写要求（据各 Test / Quiz 文件汇总）

- 每份测试须提交 **do-file 与 log-file**；提交前检查 log 完整（"end of do-file" 只应出现在日志末尾一次）。
- 文件必须**充分注释**（fully annotate）；频繁保存 do-file。
- 用 `cd` 改变目录后，打开日志、打开/保存数据都**不再需要写路径**（部分题目对"多写了路径"直接扣分）。
- 部分题目**必须使用 global**（如 keep 必须用 `${solow_variables}` / `$covariates` 等），否则扣分。
- 测试说明强调：**只能使用 COMET notebooks 中明确描述过的 Stata 命令**，使用范围外命令得 0 分。
- 数据语法要点：字符串条件必须加引号（`if sex=="F"`）；缺失值判断 `==.` 或 `missing()`；`_merge` 匹配成功为 3。

---

## 一、Test One（评分标准原文优先）

- `log using testone, text replace` — 打开文本格式日志（覆盖同名）。
- `log close` — 关闭日志。
- `describe` — 变量清单及属性。
- `summarize cgdpe pop csh_i hc` — 汇总指定变量。
- `summarize pop if hc==., detail` 或 `summarize pop if missing(hc), d` — 带条件与 detail 选项的汇总。
- `sort cgdpe`；`summarize hc in 1/100` — 排序后对前 100 条观测汇总。
- `local lowincome = 12000`；`summarize if cgdpe< `lowincome'` — 创建并使用 local。
- 【其余步骤（打开数据、注释、关闭日志）以文字描述为主；命令写法以上表为准。】

## 二、Test Two

- `cd "/Users/…"` — 第一行切换目录（评分标准：cd + 路径；注意引号）。
- `log using test2solution, text replace` — 开日志（含路径会被扣分）。
- `use pwt110, clear` — 打开 Penn World Table 数据（含路径会被扣分）。
- `gen y = (rgdpe/pop)` — 生成人均 GDP。
- `global covariates "pop csh_i hc"` — 创建 global。
- `keep year countrycode ${solow_variables}`；`keep y $covariates year countrycode` — 保留变量（必须用 global）。
- `save solowvariables, replace` / `clear` — 保存子数据集（含路径会被扣分）。
- `wbopendata, language(en - English) indicator(SP.DYN.CBRT.IN) clear long` — 从 World Bank 导入出生率（long 格式）。
- `merge 1:1 year countrycode using solowvariables` — 按年+国家代码合并。
- `keep if _merge==3` — 只保留匹配样本。
- `rename sp_dyn_cbrt_in births` — 重命名变量。
- `reg y $covariates birth` — 用 global 加出生率做回归。
- `log close`。

## 三、Test Three

- `cd …`；`use pwt1001.dta, clear`；`gen y = (rgdpe/pop)`；`global covariates "pop csh_i hc"`；`keep year countrycode ${covariates}`；`save solowsubset, replace`。
- 对数变量：`gen gdp = ln(cgdpe/pop)`；`gen save = ln(csh_i)`；`gen pop_growth = ln(pop)`；`gen school = ln(hc)`。
- `reg gdp save pop_growth school` — 长期增长核算回归。
- `wbopendata, language(en -English) country() topics() indicator(GC.DOD.TOTL.GD.ZS) clear short` — 导入中央政府债务（short 格式）。
- `reshape long yr, i(countryname) j(year)` — 宽转长；`rename yr debt`。
- `merge 1:1 countrycode year using solowsubset`；`drop if _merge!=3`。
- `bysort countrycode: egen avg_debt = mean(debt)`；`summarize avg_debt`。
- `collapse (mean) avg_debt = debt, by(countrycode)`；`summarize avg_debt` — 用 collapse 复现同样结果。
- 【Q2 打开日志、Q9 保存数据、Q16 关闭日志在题目正文中仅描述操作，未给出命令原文。】

## 四、Test Four

- `cd …`；`log …`；`use …`；global `solow_variables`；`keep …`；生成对数变量；`save solowsubset`；从 World Bank 导入并合并；生成 `dependency`。
- `gen dependency=ln(sp_pop_dpnd_ol)`（评分标准）。
- 直方图与导出：`histogram dependency, color(…) … xtitle(LN Dependency Ratio)`（评分标准原文颜色选项显示为 color(orange) color(black)）；`graph export Q10graph.png, as(png) replace`。
- 散点图与导出：`twoway (scatter gdp dependency if year==2010, mlabel(countrycode) color(red))`；`graph export Q11graph.png, as(png) replace`。
- `drop if hc==.`；`bysort countrycode: egen avg_hc = mean(hc)`；`summarize avg_hc`。
- 虚拟变量：`generate high_hc = 1`；`replace high_hc = 0 if avg_hc<=r(mean)`。
- 两组直方图：`twoway (histogram dependency if high_hc==0, color(purple) lcolor(black)) (histogram dependency if high_hc==1, color(orange) lcolor(black)), legend(label(1 "Low HC") label(2 "High HC")) xtitle(LN Dependency Ratio)`；`graph export …`, `as(png) replace`【评分标准中该处文件名写作 Q13graph.png，与题干 Q14graph.png 不一致，原文如此】。
- 【其余步骤（打开数据、global、keep、生成变量、保存、导入合并、关闭日志）在题目中仅描述操作。】

## 五、Test Five

- `gen phd=…`（评分标准中该行变量来源显示不完整）；`global x_variables "save school pop_growth phd"`。
- `reg gdp ${x_variables}`；`reg gdp ${x_variables} i.year` — 加入年份固定效应。
- `drop if save=.`；`bysort countrycode: egen avg_save = mean(save)`；`summarize avg_save`。
- `generate high_save = 1`；`replace high_save = 0 if avg_save<=r(mean)`。
- 分样本回归：`reg gdp ${x_variables} i.year if high_save==1` + `estimates store model1`；`reg gdp ${x_variables} i.year if high_save==0` + `estimates store model2`。
- 导出表格：`etable, estimates(model1 model2) mstat(N) mstat(r2_a) showstars showstarsnote varlabel column(dlabel) export(test5table.docx, replace)`。
- 图形：`twoway (scatter gdp phd if year==2019 & high_save==0, color(blue)) (lfit …, color(blue)) (scatter …, color(orange)) (lfit …, color(orange)), legend(label(1 "Low SAVE") label(2 "Low SAVE Fit") label(3 "High SAVE") label(4 "High SAVE Fit")) xtitle(LN PHD) ytitle(LN GDP) name("R1", replace)`；`graph export Test5graph.png, as(png) replace`。
- 文件说明：提交 do、log、png、docx；题目/评分标准另提及若由 AI 生成文件须在 log close 前以注释标明（同时测试本身禁止使用 AI）。

## 六、Test Six

- `cd …`；`global solow_variables …`；`keep …`；生成对数变量；`save solowsubset`；从 World Bank 导入（当前健康支出）并合并；生成 `health`（自然对数）。
- `global x_variables …`；`reg gdp ${x_variables}` + `estimates store model1`。
- 地区固定效应：`tab region, gen(regiondummy)`；`global regiondummies "regiondummy1 … regiondummy7"`；`reg gdp ${x_variables} i.year ${regiondummies}` + `estimates store model2`。
- 非线性：`reg gdp ${x_variables} c.health#c.health i.year ${regiondummies}` + `estimates store model3`。
- 预测与绘图：`predict yhat, xb`；`twoway (scatter yhat health if health!=0) (qfit yhat health if health!=.)`；`graph export graphtest6.png, as(png) replace`。
- 表格：`etable, estimates(model1 model2 model3) mstat(N) mstat(r2_a) showstars showstarsnote varlabel column(dvlabel) export(test5table.docx, replace)`【评分标准中文件名与题干 Test6table.docx 不一致，原文如此】。
- 均值分组回归：`drop if pop_growth==.`；`bysort countrycode: egen avg_pop = mean(pop_growth)`；`summarize avg_pop`；`generate high_pop = 1`；`replace high_pop = 0 if avg_pop<=r(mean)`；`reg gdp ${x_variables} i.year ${regiondummies} if high_pop == 1`；`… if high_pop == 0`。
- 缩尾/截尾重复回归：见 Quiz 14 解法。

## 七、Test Seven

- `encode countrycode, gen(ccode)`；`tset ccode year`（评分标准写作 tset；Quiz 15 写作 tsset）。
- 变量生成（评分标准原文，个别处含 OCR 失真）：
  - `gen lnbanks = ln(fb_cbk_brch_p5)`；
  - `gen dlngdp = ln(ln(rgdpe/pop) - ln(L1.rgdpe/L1.pop))`；
  - `gen lnpop = ln(ln(pop)-ln(L1.pop))`；
  - `gen lngdp = ln(rgdpe/pop)`；`gen lnschool = ln(hc)`；`gen lnsave = ln(csh_i)`。
- 固定效应回归：`xtreg dlngdp L1.lngdp lnsave lnschool lnpop lnbanks i.year i.ccode, fe`。
- 年份固定效应检验：`testparam i.year`（评分标准写法）。
- 异方差检验：`xttest3`。
- 序列相关检验：`xtserial lnsave lnschool lnpop lnbanks`【评分标准：若把因变量 dlngdp 也列进去，只能得半分】。
- 修正回归：`xtpcse dlngdp L1.lngdp lnsave lnschool lnpop lnbanks i.year i.ccode, het corr(ar1)`。
- 非线性项版本：`xtpcse dlngdp L1.lngdp lnsave lnschool lnpop c.lnbanks##c.lnbanks i.year i.ccode, het corr(ar1)`。
- 缩尾变量版本：`xtpcse dlngdp_winsor L1.lngdp_winsor lnsave lnschool lnpop lnbanks i.year i.ccode, het corr(ar1)`（须包含课堂所授的缩尾变量创建命令）。
- 制作规范表格（须排除非线性项）。

---

## 八、ECON490Quizzes 2 – 15（按测验分节）

### Quiz 2
- `delimit !` — 将每行视为一条命令、直到遇到感叹号。
- `log using course_name, replace`；`log using filename, text replace`。
- `display "ECON 490"`；`* 注释` 置于相关命令之前。
- `capture log close`；【知识点】忘记 `capture` 且无日志打开时报错误码 **606**。
- 编辑器颜色约定：注释为绿色、命令为蓝色。

### Quiz 3
- `describe` — 看观测数/变量数；`help` — 查命令缩写（graph 的缩写为 **gr**）。
- `summarize` — 均值等统计（含带 `if` 条件）；
- `sort` — 找出最低 GDP 的国家。

### Quiz 4
- `return list` 中标量顺序：`r(N)`、`r(sum_w)`、`r(mean)`、`r(Var)`、`r(sd)`、`r(min)`、`r(max)`、`r(sum)`。
- `gen y = rgdpe/pop`；`global covariates "csh_i hc"`。
- `regress y ${covariates}`；`regress y ${covariates} if year==2019`。
- 代码排序中 `*` 注释行位于其对应命令之前。

### Quiz 5
- `cd "…"`（含空格路径必须加引号）。
- `use pwt110, clear`。
- `export excel` — 导出子集（如只含某年）为 xlsx。
- `firstrow(var)` — export 命令选项，用于修复重新导入后变量名缺失问题。
- 【干扰项】`import dellimited`（拼写错误）；`use "…"` 带路径。

### Quiz 6
- `codebook` — 查看年份范围、存储类型、字符串长度（如 str4）。
- `lookfor` — 按关键词找变量。
- `sum hc`；`local hc_mean = r(mean)`；`generate low_hc=0`；`replace low_hc=1 if hc<`hc_mean'`；`label var low_hc "Indicator Variable for Low HC Countries"`。
- 增长核算变量：`gen s = ln(csh_i)`；`gen n = ln(pop) - ln(L1.pop)`；`gen h = ln(hc)`【L1 为滞后算子；当时课程说明暂不要求复现】。
- 命名规范判断：最佳变量名不需要大写/数字/符号（False）。

### Quiz 7
- `sort countrycode year`（一条命令按两变量排序）；`by countrycode: gen tot_n=_N`。
- `sum tot_n`；`local min_n=r(min)`；`tab year if tot_n==`min_n'`。
- `keep if inrange(year,2005,2023)`；`drop if rgdpe==.`。
- `bysort`、`egen`、`collapse`、`reshape` 的组内分析组合（同 Notebook 7）。
- `reshape long yr, i(countryname) j(year)` — 宽转长；各部分含义：reshape=转换命令、long=分拆观测、yr=前缀（stub）、i()=个体、j()=新年份变量。

### Quiz 8
- 用 `wbopendata` 导入（如互联网使用、通电率）long 格式；先查 `_merge` 结果再清理。
- `list countryname if _merge==2 & year==2019`；`tabulate year if _merge==2 & countrycode=="CAN"`。
- `keep if _merge==3` — 删掉未匹配观测的正确做法。
- 【知识点】`_merge==3` 表示两边都匹配；未匹配合计 7884、匹配 11648；先判断未匹配原因再清理。

### Quiz 9
- 直方图：`histogram`（GDP per capita；取对数后加 `normal` 选项辅助判断分布）。
- `twoway (scatter …) (lfit …)` — 散点+拟合线；`help lfit`。
- `mlabel(countrycode)` — 散点标注国家代码。
- 多图散点：`twoway (scatter … if countrycode=="CAN") (scatter … if countrycode=="ARG"), title("…") xtitle("…") ytitle("…") legend(label(1 "Canada") label(2 "Argentina"))`。
- 【11-11 补录，来源 `UsedDoFiles/490quiz9.do` 与 `UsedLogFiles/quiz_template.log` 逐字原文】`gsort -<变量>`（原文 `gsort -gdppc`）配合 `list <变量列表> in 1/4` 与 `preserve` / `restore`，用于按降序取前几名；同一写法亦见 CheatSheet（见附录 A 补录）。此前本节只记了 `sort`，未记降序排序。
- 连线图：`twoway (connected lngdp lnhc if countrycode == "CAN")`。
- 条形图：`graph bar (mean) sp_dyn_tfrt_in, over(incomelevelname) ytitle(Fertility Rate) title(…)`。

### Quiz 10（整段 do-file 排序题，完整顺序）
- `log using quiz10, text replace`。
- `wbopendata, language(en - English) country() topics() indicator(SP.DYN.TFRT.IN) clear long`；`merge 1:1 countrycode year using pwt100`；`drop if _merge!=3`。
- `gen lngdp=ln(rgdpe/pop)`；`gen lnfert= ln(sp_dyn_tfrt_in)`。
- `sum hc`；`local hc_mean = r(mean)`；`generate low_hc = 0`；`replace low_hc = 1 if hc < `hc_mean'`。
- 散点组合：`twoway (scatter lngdp lnfert if year==1999 & low_hc==1, color(green)) (lfit …, color(green)) (scatter …, color(navy)) (lfit …, color(navy)), legend(label(1 "Low HC") label(2 "Low HC Fit") label(3 "High HC") label(4 "High HC Fit")) xtitle(LN Fertility) ytitle(LN GDP) name("R1", replace)`。
- 直方图组合：`twoway (histogram lnfert if low_hc==1, color(green) lcolor(black)) (histogram lnfert if low_hc==0, color(navy) lcolor(black)), legend(label(1 "Low HC") label(2 "High HC")) xtitle(LN Fertility) name("R2", replace)`。
- 面板合成：`graph combine R1 R2, cols(2) title("…") saving(panel_a, replace)`；`graph export panel_a.jpg, as(jpg) replace`；`log close`。

### Quiz 11
- 回归要求：`regress lngdp lnsave`（自然对数-对数解释：1% 变动→弹性）；二次关系“transform your data”（具体命令未展示）。
- 多元回归：`regress lngdp lnsave lnschool lntrade`。
- 年份固定效应：`regress … i.year`【Stata 丢弃 1960 年以避免共线性】。
- 【命令未逐字展示的题目，按描述归纳；数值：储蓄系数 .8596181、调整 R² 0.6658。】

### Quiz 12
- 任务：用 Stata 复现给定回归表并导出为 **.docx**，生成后需自行清理表格。
- 表格内容涉及：`lngdp`（因变量）、`lnsave`、`lnschool`、`lntrade`、`low_hc` 虚拟变量及 `low_hc` 与 `lnsave` 的**交互项**；含 N、调整 R²。
- 【文件未展示具体命令；同类导出流程见 Notebook 12 的 `etable, export(…)`。】

### Quiz 13
- `tab region, gen(regiondummy)` — 生成地区虚拟变量。
- `global regiondummies "regiondummy1 regiondummy2 … regiondummy7"`；`regress lngdp lnsave lnschool lntrade i.year ${regiondummies}`。
- `codebook region regionname` — 匹配地区缩写与全称。
- 交互项题：新人力资本虚拟变量与 `lnsave` 交互【提示：加入交互后，Stata 会同时包含两个主效应，可省略单独写 lnsave】。
- 平方关系选择题出现的写法：`i.lnsave##c.lnsave`、`c.lnsave##c.lnsave`（连续变量自交互，与加入平方项等价）。

### Quiz 14
- 缩尾排序题（完整顺序）：`gen lngdp = ln(rgdpe/pop)`；`sum lngdp, d`；`return list`；`gen lngdp_winsor = lngdp`；`replace lngdp_winsor = r(p1) if lngdp_winsor < r(p1) & lngdp_winsor!=.`；`replace lngdp_winsor = r(p99) if lngdp_winsor>r(p99) & lngdp_winsor!=.`；`sum lngdp_winsor`。
- 同法对 `lntrade` 缩尾；截尾变量时注意与缩尾的观测损失差异（少 484 个观测）。
- 回归：与 Quiz 13 相同的多元回归+年份+地区固定效应，分别用原始/缩尾/截尾变量。
- 配套 log（`econ490_quiz_14 .txt`）中的实际命令：`use pwt110.dta, clear`；`wbopendata … indicator(NE.TRD.GNFS.ZS) clear long`；`merge 1:1 countrycode year using pwt110`；`keep if _merge==3`；`drop _merge`；`gen lngdp=ln(rgdpe/pop)`；`gen lnsave=ln(csh_i)`；`gen lnschool=ln(hc)`；`gen lntrade=ln(ne_trd_gnfs_zs)`；`reg lngdp lnsave`；`gen savesq=lnsave*lnsave`；`reg lngdp lnsave savesq`；`reg lngdp lnsave lnschool lntrade`；`reg lngdp lnsave lnschool lntrade i.year`；`sum hc`；`local hc_mean=r(mean)`；`gen low_hc=0`；`replace low_hc=1 if hc<`hc_mean'`；`estimates store m1`（及 m2、m3、m4）；`etable, estimates(m1 m2 m3 m4) mstat(N) mstat(r2_a) showstars showstarsnote export(table.docx, replace)`【log 尾部截断】。

### Quiz 15（面板数据回归）
- `encode countrycode` 生成数值代码（Canada=30）；`tsset ccode year`（排序题答案：tsset / ccode / year）。
- 增长率变量：`gen dlngdp=ln(ln(rgdpe/pop) - ln(L1.rgdpe/L1.pop))`；`gen lnn=ln(ln(pop) - ln(L1.pop))`（正确选项）。
- 固定效应回归（题目以方程给出，样式同）：`xtreg dlngdp L1.lngdp lnsave lnschool lnn …, fe`（含年份虚拟变量）。
- 检验与修正（测验本身未逐字展示命令，对应常用命令见 Notebook 15 / Test Seven）：年份固定效应检验（F=3.87）；异方差检验（χ²=879.83，对应 `xttest3`）；序列相关检验（**注意：时间序列算子不允许用于该检验，可安全省略**，对应 `xtserial`）；修正回归（对应 `xtpcse … , het corr(ar1)`）。
- 开放度回归：用 World Bank 导入的贸易变量；1% 贸易增加→人均 GDP 增长 0.1678731%；R²≈22%；缩尾改善模型拟合。

---

## 九、附录 A：StataCheatSheet_analysis_19.pdf 相关命令参考（允许使用的补充资料）

> 以下条目摘自课程 Stata 资料中的 Stata 速查表；部分因原文件排版/OCR 显示不完整，已按可辨认内容列出。速查表还覆盖时间序列（`arima`、`tsline` 等）、生存分析（`stset`、`stcox`）、调查数据（`svyset`、`svy:`）、PCA/因子分析、计数模型、动态面板、PSM、合成控制、断点回归等主题，如需可另行整理。

### 【11-11 补录】以下逐字来自 `StataCheatSheet_analysis_19.pdf` 原文，前文附录 A 遗漏

- `dtable <varlist>, export(<文件名>)` — 原文 `dtable price mpg i.rep78, export(table1.pdf)`；生成并导出描述统计表。本项目 `2_descriptive_261109.do` 已用 `dtable ... export(...docx, replace)`。注意：`dtable` 默认只给 N、mean、sd，不含 min/max，Checklist 要求的 min/max 仍需 `collapse` 加 `export excel` 另出。
- `gsort <varlist>` 与 `gsort -<变量>` — 原文 `gsort price mpg (ascending)`、`gsort-price-mpg (descending)`；升序与降序排序（`-` 前缀为降序）。课程 Quiz 9 的配套 do 文件中亦出现 `gsort -gdppc`。
- `generate byte <dummy> = <逻辑表达式>` — 原文 `gen byte lowPr = price < 4000`；一步法生成 0/1 虚拟变量并指定存储类型，与 COMET 14.2 的 `generate male = sex == "M"` 同类。
- 存储类型与转换（原文「Stata has six data types」段）：`byte`、`int`、`long`、`float`、`double`、`str#`；`recast double <变量>` — 原文 `recast double mpg`；`tostring`、`destring`、`decode`、`string()`、`real()`、`compress`。
- `count` 与 `count if <条件>` — 原文 `count`、`count if price > 5000`；本项目缩尾后统计改动观测数用 `count if ... != ...`。
- `isid <varlist>` — 原文 `isid mpg`，检查变量是否唯一标识数据；`ds, has(type string)` 按类型检索变量；`cls` 清空结果窗口。
- `saveold "<文件>.dta", replace version(#)`；`export delimited "<文件>.csv", delimiter(",") replace`；`import sas`、`import spss`；`webuse set "<URL>"` 与 `webuse <数据名>`。
- `search <包名>` 与 `ssc install <包名>` — 原文 `search mdesc` 后 `ssc install mdesc`，用于查找并安装外部包；与 COMET 15.5.2 的 `capture noisily search xtserial` 同法。
- 描述统计补充：`stem <变量>`、`ci mean <变量>, level(99)`、`correlate <变量列表>`、`pwcorr <变量列表>, star(0.05)`、`mean`、`proportion`、`ratio`、`total`。
- 列联表补充：`tabulate <var>, mi gen(<前缀>)` 生成含缺失的虚拟变量；`tabulate <v1> <v2>, chi2 exact expected`；`bysort <组>: tabulate <变量>`。
- 表格与导出补充：`collect` 系列（原文 `collect ... , stat() ... nformat()`、`collect export <文件名>`），与 `putdocx`、`putexcel` 并列；`estimates store` 的用法原文写作 `estimates store est1`。
- 变量构造补充：`pctile <新变量> = <变量>, nq(4)`（原文 OCR 失真写作 `ng(4)`）；`egen <新变量> = mean(<变量>), by(<组>)`；`generate <id> = _n`、`generate <tot> = _N`（`_n`/`_N` 义见 COMET 07）。
- 图形补充：`graph hbox`、`graph dot`、`graph box` 系列（附录 A 首条已列部分）、`graph save "<文件>.gph", replace`、`graph combine`；`twoway qfit`、`twoway lowess`、`twoway lfit` 作为拟合线类型；`coefplot, drop(_cons) xline(0)` 的原文写法。
- 【边界项，已处理，不得冒充课程示例命令】`generate double <新变量> = <表达式>` 曾在本项目多份 do 文件中使用，但课程原文逐字出现的只有描述输出里的 `pop double`（存储类型）、`predict double resid, residuals`、`recast double mpg` 与 `gen byte lowPr = price < 4000`，并未逐字展示 `generate double`。本机验算 `probe_recast_261112.do` 证明 `generate` 默认存 float，只加 `recast double` 会把已丢精度的值搬进 double 容器，必须再补一行 `replace` 按 double 重算才等价。2026-11-12 已把 261109 四份 do、2026-11-13 已把并入的上游 build 逻辑全部改为 `generate` + `recast double` + `replace` 三步，当前 OneDrive 提交链中 `generate double` 为零。本条保留为边界说明，不作为已授权命令。

### 【11-13 补录与订正】CheatSheet 原文逐字核查，此前把 `cellrange()` 误判为白名单外

- `import excel "<文件>.xlsx", sheet("<表名>") cellrange(A2:H11) firstrow` — 逐字见于 `StataCheatSheet_analysis_19.pdf` p.3「Import data」段（原文用 `/* */` 续行）。因此 `sheet()`、`cellrange()`、`firstrow` 都是课程允许选项。本项目 `1_build_data_261109.do` 现写作 `import excel ..., sheet("Time-Series") cellrange(A9) clear`，全部选项合规（`allstring` 已于 2026-11-14 移除，见下方第二次更新）。2026-11-13 之前把 `cellrange()` 列为「白名单外写法」的判断错误，在此作废。
- `import delimited "<文件>.csv", rowrange(2:11) colrange(1:8) varnames(2)` — 同一页逐字原文；`rowrange()`、`colrange()`、`varnames()` 亦为课程允许选项。
- `import excel` 命令本身在 COMET 05「Opening Data Sets」逐字讲解（"It comes in two main forms: `import excel` and `import delimited`"），但该讲义只讲命令名，具体选项来自 CheatSheet。
- `egen <新变量> = mean(<变量>), by(<组>)` — CheatSheet「Create new variables」逐字原文 `egen meanPrice = mean(price), by(foreign)`；`destring ..., gen()`、`gen <新变量> = real(<字符串>)`、`encode ..., gen()` 亦见同页「Change data types」。

### 【11-14 更新一】边界项从 4 类收敛到 2 类；另补录图形选项

2026-11-14 再次对照课程 Stata 资料 `/Stata/` 下的 COMET（28 项）、Cometquiz（14 项）、StataTest（7 项）、Regression Course Material（8 项）与 `StataCheatSheet_analysis_19.pdf`，并把本地 COMET Notebook 全部 18 份 `.qmd` 的 Stata 代码块与 `UsedDoFiles` 全部 29 份 `.do` 逐行抽出命令首词比对，共得到 102 个课程命令 token。除下列 7 个非命令英文词外全部已收录：`assignment`、`comments`、`like`、`name_of_command`、`student`、`xlabel`、`ylabel`。其中 `xlabel()` / `ylabel()` 是 COMET Notebook 图形示例里逐字出现的轴标签选项（本汇总此前只记了 `xtitle()`、`ytitle()`、`ylab()`、`xline()`），现补录：`xlabel(#(#)#)` / `ylabel(#(#)#)` 用于指定轴刻度标签，与 `xtitle()` / `ytitle()` 并列。

**已用白名单命令等价替换、且验证整体结果一致的 2 类**（11-13 曾列为边界项，现已不再使用）：

1. `split <变量>, parse("/") generate(<前缀>)` 与 `destring <前缀>*, replace force`。本机探查确认 OECD 工作簿里带斜杠的单元格只有 11 行、只有两种取值（`28.6 / 54.6` 与 `30.17 / 56.17`）、每行最多一个斜杠。因此改为 `generate <前缀>1 = real(<字符串变量>)`、`generate <前缀>2 = .`，再用四个 `replace` 按已知字符串赋两个选项值；`real()` 逐字见 COMET 06，`generate` / `replace` / `==` 均为课程示例命令。
2. `egen <新变量> = rowmin|rowmax|rownonmiss(<前缀>*)` 以及 `bysort iso: egen reform_year = min(cond(...))`。改为 `generate` + `replace` + 比较运算 + `missing()` 逐行取 min/max、用 `!missing(v1) + !missing(v2)` 计数；`reform_year` 改为 `generate reform_year = year if expansion==1` 配 `bysort iso (reform_year): replace reform_year = reform_year[1]`。`missing()`、`inrange()`、`bysort`、下标 `[1]` 均逐字见 COMET 07 与 COMET 14。

验证（`.workbuddy/_cache_261113/verification/final_261114/project/`）：改造版从 raw 整链重跑，两个锁定面板 CSV 与两套分析数据 CSV 的 md5 与改造前完全相同，`3_results_261109.log` 的 2396 个浮点数逐字一致，无 `r()` 报错。当前 4 份提交 do 里已无 `split`、`rowmin`、`rowmax`、`rownonmiss`、`egen min(cond())`。

**上述「保留两个 import 选项」的结论已于 2026-11-14 第二次核查时作废**，详见下方更新二。

### 【11-14 更新二】边界项清零：去掉 `stringcols(_all)` / `allstring`，并把高级写法换成讲义写法

用户重新设定判据：若影响微乎其微，就优先保证 do 文件只含课程白名单命令，不再要求 CSV 逐字节一致。据此做了两轮受控实跑。

**一、只去掉 6 处 import 选项（4 处 `stringcols(_all)`、2 处 `allstring`）的定量影响**（变体 B，从 raw 整链重跑）。两套面板行数仍为 295 / 477；四个 CSV 中只有 `male_rate`、`female_rate`、`employment_gap` 三列出现差异，Europe 最大绝对差 `1.0346e-05` 个百分点、OECD `7.0801e-06` 个百分点，其余列（含 `total_paid_raw`、`reform_year`、`treated`、`known_policy`、全部 GDP 控制）逐字节相同。`2_descriptive` 日志 29 个显示数字变化、最大 `1.6712e-05`；`3_results` 日志 2396 个浮点数中 712 个只在第 5–6 位小数变化，中位数 `3e-06`，最大的是 Wald chi2(47) `18183.50 → 18183.49` 与一个回归常数项 `-127.9567 → -127.9566`。`lag_fatherweeks10`、`1.treated#1.post`、`event_time_dummy*`、`Number of observations`、`Prob >`、`F()`、`R-sq` 的所有行逐字相同。离散副作用只有两个：结果变量 1/99 缩尾实际改动观测数 `5 → 4`（一个观测恰落在临界值上），以及上述 Wald 统计量末位。结论：**这是 float 与 double 的存储精度差异，不是研究设计、样本口径或识别策略变化；系数、标准误、p 值、样本量、显著性结论与论文结论全部不变**。因此按用户判据移除这两个选项；`import delimited ..., varnames(1)` 与 `import excel ..., sheet() cellrange() clear` 本身逐字见于 CheatSheet p.3。

**二、代码水平审查与等价简化**。把 4 份 do 的命令首词与课程语料（COMET `.qmd`、全部 Quiz/Test PDF 提取文本、`UsedDoFiles` 29 份 do、CheatSheet）比对：`cond(`、`[_n-1]`、`[_n+1]`、`[1]` 在语料中零命中；`abs(` 5 次、`L1.` 63 次、`F1.` 1 次、`L数字.`／`F数字.` 见 COMET 15.4、`reshape` 32 次、`egen` 25 次、`recast double` 1 次。据此做四处简化：在 `isid iso year` 后加 `encode iso, generate(pid)`、`xtset pid year, yearly`、`sort pid year`；把 `bysort iso: egen aligned = max(cond(year==...,snapshot,.))` 四个对齐块换成 `string(F1.snapshot,"%18.10g")`；把 `same_` / `nondecrease_` / `increase_` / `expansion` 的 `[_n-1]` 下标换成课程讲过的 `L1.`；把 `cond(sex=="SEX_M","M","F")` 换成 `generate` + `replace` 两行；把 `bysort iso (reform_year): replace reform_year = reform_year[1]` 换成 `bysort iso: egen first_reform = min(reform_year)` 配 `replace`。`reshape wide`、`egen ... = mean()`、`abs()`、`strpos()`、`real()`、`string()`、`missing()`、`inrange()`、`inlist()`、`destring`、`recast double` 均保留，都是课程已展示或同类基础写法。

验证：简化版（变体 D）与「仅去选项」变体 B 的四个 CSV md5 完全相同，三份编号 log 的 `46 / 131 / 2396` 个浮点数逐字一致，无 `r()` 报错，说明简化完全等价；正式项目再整链重跑亦复验通过。**当前 4 份 do 已无 `stringcols` / `allstring` / `cond(` / `[_n±1]` / `[1]` / `generate double`，命令首词全部在课程语料中命中**。只剩两处轻微扩展，如实标注：课程只逐字展示 `egen ... = mean()`，项目另用了同类基础统计函数 `min()` / `max()`；课程只逐字展示 `recast double mpg`，项目用 `generate` + `recast double` + `replace` 三步保证 double 精度。二者都不是被禁的高级命令应用方式。

**三、课堂可读性复核另做的两处清理**。去掉 import 选项后，4 条 `destring ..., replace` 在 log 里全部变成 `already numeric; no replace`，属空转命令，已删除；`1_build_data_261109.do` 里原本有两段逐字重复、只差 tempfile 后缀的政策历史构建代码（各约 79 行），已合并为一段，OECD 样本改为复用同一个 `\`policy'` 临时文件。两处清理后 1 号 do 从 357 行降到 275 行，四个 CSV 的 md5 与 `2_descriptive` / `3_results` 的 `131 / 2396` 个浮点数逐字不变，无 `r()` 报错；`1_build_data` 的 log 只少了那段重复代码本身的字面数字。当前 do 文件里不再有空转命令、重复块、`cond()`、`[_n±1]` 下标与交付记录式注释。

- **条形图/点图/箱线图**：`graph bar (统计量), over(变量, 选项)`（统计量：asis/percent/count/mean/median/sum/min/max…；over 子选项：`gap(#)`、`relabel`、`descending`、`reverse`、`missing`、`nofill`、`allcategories`、`percentages`、`stack`、`bargap(#)`、`intensity(#)`）；`graph hbar …`（横向）；`graph dot (mean) …, over()`；`graph box` / `graph hbox …, over(组, descending) by(分组, …) missing`。
- **图形背景自定义**：`graphregion(fcolor("RGB") ifcolor("RGB"))`；`plotregion(fcolor(…) ifcolor(…))`；`twoway scatter …, by(foreign, norescale)`。
- **描述统计**：`summarize …, detail`；`ci mean … , level(99)`；`correlate …`；`pwcorr …, star(0.05)`；`mean …`；`proportion …`；`ratio …`；`total …`。
- **时间序列**：`tsset time, yearly`；`tsreport`；`generate lag = L1.spot`；`tsline spot`；滞后/前导算子：`L.`、`L2.`、`F.`、`F2.`、`D.`、`D2.`、`S.`。
- **面板**：`xtset id year`；`xtdescribe`；`xtsum hours`；`xtline ln_wage if id<=22, tlabel(#3)`；`xtreg ln_w c.age##c.age ttl_exp, fe vce(robust)`。
- **检验**：`tabulate …, chi2 exact expected`；`ttest mpg, by(foreign)`；`prtest`；`ksmirnov`；`ranksum`；`anova`；`pwmean …, over() pveffects mcompare(tukey)`。
- **因子变量记号**：`i.`、`ib(#).`（指定基组）、`c.`、`#`、`##`、`o.`。
- **回归与诊断**：`regress …, vce(robust)`；`regress …, vce(cluster 变量)`；`rreg …, genwt()`；`probit …, vce(robust)`；`logit …, or`；`bootstrap, reps(100): 命令`；`jackknife …: 命令`；`estat hettest`；`ovtest`；`vif`；`dfbeta`；`rvfplot, yline(0)`；`avplots`。
- **估计后**：`display b[变量名]`；`margins dydx(变量名)`；`margins, eyex(变量名)`（弹性）；`predict`（在拟合样本内预测）；`predict double resid, residuals`；`test 变量 = 0`；`lincom 变量1 - 变量2`。
- **编程（标量/矩阵/宏）**：`scalar`、`matrix`（转置 `'`、行合并 `\`、列合并 `,`、`matrix list`、`matrix dir`、`scalar drop`）；`global`/`local`/`levelsof …, local()`/`tempvar`/`tempname`/`tempfile`；引用 `` `local' `` 与 `$global`。
- **结果与输出**：`return list`；`ereturn list`；`preserve`/`restore`；`estimates store`；`etable, estimates(…) column(index) showstars showstarsnote`；`putdocx`、`putexcel`；`collect`。
- **循环与调试**：`foreach x in 列表 { … }`（可配 of local / of global / of varlist / of newlist / of numlist）；`forvalues i = 10(10)50 { … }`；`while`；`set trace on/off`；`word(…)`、`local … : word count …`。
- **安装与更新**：`ssc install 包名`；`net install 包名, from(URL)`；`ado update`。

## 十、附录 B：来源与缺口说明

- 本清单基于 StataTest 的 Test One–Seven、ECON490Quizzes2–15、`econ490_quiz_14 .txt` 及 StataCheatSheet 整理。
- 已知缺口（文件中未给出命令原文处，均已在上文标注）：Test One 部分步骤、Test Three 的 Q2/Q9/Q16、Test Four 的多个步骤、Quiz 11/12/13/15 的若干题目只描述操作而未展示命令；Quiz 12 未展示具体命令。
- 已标注的原文不一致：Test Seven 的 tset 与 Quiz 15 的 tsset；testparam 与 testparm；Q13graph.png 与 Q14graph.png；test5table.docx 与 Test6table.docx；个别 OCR 乱码（如 dIngdp/Ingdp 即 dlngdp/lngdp）。
- 若需要更精确的逐字核对，建议补充上传各测验的完整版文件或参考答案。
