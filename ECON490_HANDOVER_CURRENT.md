# ECON 490 期末研究项目 接手文档（当前版，2026-11-14）

生成时点 2026-11-14 00:30 MST，本机 `date` 返回本地时间，不推断时区。本档是**唯一当前版**，替代 `ECON490_HANDOVER_2026-11-10.md` 的全部旧正文与其中三段更新声明，也替代 11-09 版；那两份仅作历史留档【主观判断：版本覆盖规则】。本档自包含，中文纯段落，不使用项目符号与表格；正式论文文本、表格、图注与书目必须另行用英文按课程体例撰写，两者不得互相替代【已核实的事实：Final Paper Instructions 与 Final Paper Checklist 的体例要求】。证据等级沿用既有体系：「已核实的事实」指一手原文、原始 log 或本机运行直接确认；「由事实推出的推断」「主观判断」「资料不足的不确定项」「已作废结论，禁止复活」各自限定结论强度【主观判断：沿用既有体系】。

## 一、当前状态

OneDrive 项目 `econ490_project` 的提交链为五份 do 文件：`0_master_261109.do` 设置路径并按序调用 `1_build_data_261109.do`、`2_descriptive_261109.do`、`3_results_261109.do` 与 `4_tables_261109.do`；第 4 份只放逐变量嵌套表与子集表，目的是让每份 log 都不超过 assignment 的 25 页上限【已核实的事实：逐行回读五份 do 与四份 log 行数】。1 号文件的 Step 0 直接从 `data_raw` 的六个源文件重建两个锁定面板，再产出两套分析数据，因此只需运行一次 0 号文件即可从原始数据跑到最终结果【已核实的事实：副本从 raw 整链重跑成功】。提交包另有 4 份编号 log、9 份表、5 张 PNG、data_raw 8 项与 data_final 10 项；项目根目录只有九个交付目录，没有任何中文 changelog 或说明文件【已核实的事实：目录枚举与全路径 ASCII 检查】。2026-11-14 又删掉了交付记录式注释、知识库引用式注释与全部非必需的 `display`，并把 `split` 与三个 `egen` 行函数改成基础命令；整链重跑后 `3_results_261109.log` 的 2396 个浮点数与改前逐字一致，四个 CSV 的 md5 不变，无 `r()` 报错【已核实的事实：新旧日志逐浮点数比对与 md5 比对】。同日第二次改造又移除了两个 import 选项、把 `cond()` 与下标写法换成 `L1.` / `F1.`、删掉 4 条空转 `destring`、把两段重复的政策构建块合并；这一次四个 CSV 的 md5 因存储精度而变化，但 2396 个浮点数中的核心系数、p 值与 N 全部不变，1 号 do 由 357 行降到 275 行，详见第五节【已核实的事实：变体 B / 变体 D 受控实跑与三轮整链复验】。

研究方向维持 Europe 主样本（23 个欧洲 OECD 国，2006–2019，N=295）加 OECD extension（26 国，2000–2024，N=477），两者 never pooled，不对调主次、不删 euro【已核实的事实：用户 2026-11-13 明示；主观判断：按课程公开文件判断转述不等于书面评分条款】。

## 二、已经犯过并被纠正的错误

「欧洲子样本 p 值更有意义」不成立：Test7 唯一子样本条件是 HIC，20 国里含智利与哥伦比亚，不是欧洲；早期 wage gap / 17 行业 / 26 国的显著结果属于 10/21 已作废方向【已作废结论，禁止复活】。甲新传的 Test7 do 与 11/5 交接版 md5 完全相同，不是新版本，说明不能按文件名或时间戳判版本【已核实的事实：md5 与逐行 diff】。11/4 TWFE 回归原本无控制变量、无聚类标准误，已补齐 `${controls}` 与诊断【已核实的事实：新旧 do 比对】。Test7 的四次缩尾 `replace` 都是 `0 real changes made`，却被写成「已处理异常值」，此说法作废；当前链改为 `generate` + `recast double` + `replace` 三步并显式 `count` 记录真实改动数（结果变量 4 个、滞后人均 GDP 4 个；2026-11-14 去掉 import 选项前分别为 5 与 4）【已核实的事实：原始 log 与本机验算】。GDP 滞后原在研究面板内取 `L1`，丢掉首年与缺口前一年；改为在完整 WDI 年度序列上先取滞后再合并后，Europe 覆盖 295/295、OECD 477/477，修复前的事件研究 k=+1 `+2.020 (p=0.034)` 与 DiD `+0.265 (p=0.843)` 全部作废【已作废结论，禁止复活：显著性来自样本选择】。曾误以为 OECD 第三列去掉 `leave_gdp` 能回到 N=477，实跑仍为 443，受 `lag_fatherweeks10` 限制【已核实的事实：最终 log】。曾把 CheatSheet 逐字展示的 `cellrange()` 列为白名单外，已订正【已核实的事实：CheatSheet p.3 逐字】。曾按用户 2026-11-14「checklist 只有一份」的说明，把「Canvas 另有一份 11/18 posted checklist」判定为不存在并取消待办，这是过度推演；同日 18:52 用户提供 `Econometric Files for Final Paper.pdf`，它是 Canvas assignment 页面导出，含十项交付内容与 100 分评分细则，正是 Course Outline 所指的 posted checklist【已作废结论，禁止复活：不存在另一份 11/18 要求；已核实的事实：所附 PDF 页首与第 3–4 页 rubric】。用户原话指评分清单文件只有一份，不等于作业说明与评分细则不存在【由事实推出的推断】。

## 三、硬约束与代码风格

判断任何文件版本必须先做字节或内容比对。资料优先序为一手课程原文、原始 log 与数据、联网权威原站，最后才是本对话此前的 AI 结论且须逐条复核【已核实的事实：交接指令明示】。不得用「沉默」推定知情或同意，不得把摘要或二手转述当一手证据，统计分母必须闭合，已作废结论不得重新写回成稿【主观判断：沿用既有硬约束】。

do 文件注释只说明「这一段做什么」，一行短 `* ` 即可；禁止交付记录、改动历史、日期版本号、`Module 18` / `Checklist` / 白名单一类引用、论文写作提示与命令写法的技术辩护【已核实的事实：用户 2026-11-14 明示并已自行删过一次】。`display` 不是 workflow 要求，不用于流程标记、样本说明或分隔线，只在把 `r()` 写进 log 时保留【已核实的事实：Workflow Guide 18 逐字与用户指令】。代码按本科生 / COMET 教学水平，优先 `generate`、`replace`、`missing()`、比较运算，不用高级行函数与花哨宏技巧【主观判断：审阅者友好优先】。结构按 Workflow 18 的 `/* Project info */`、`clear`、目录设置、项目设置、按序 `capture noisily do`，子 do 自带 log 块【已核实的事实：Workflow Guide 18 §18.3.1、§18.3.3、§18.5.3】。改了 do 必须重跑，使 log 与 do 一致【主观判断：避免 log 残留已删命令】。OneDrive 根目录不放中文 changelog 或说明文件，说明与交接文档一律放工作区【已核实的事实：用户 2026-11-14 明示】。

## 四、课程要求与 11/18 交付核对

Course Outline p.14 逐字为「One set of do, log, data, and image files will be uploaded per team to Canvas according to the posted checklist」；START HERE Step 6 要求出版级表图并确认 do 从头跑通重建 log、表、图与报告结果【已核实的事实：两处原文】。课程评分清单只有用户 2026-11-14 提供的 `Final Paper Checklist_ ECON_V 490 003 2026W1 Seminar in Applied Economics.pdf` 一份，其中 Stata Files 段逐字为「Log and do-files are uploaded to Canvas before the deadline」「Log file has been created by the do file」「Do file is fully annotated」「All work reported in the paper is included in the do and log file」【已核实的事实：所附 PDF 逐字】。逐条核对结论：五份 do 每段有短注释、四份编号 log 均由 do 内 `log using` 生成并正常 `log close`、0 号一条链从 raw 跑通、所有回归含滞后人均 GDP、描述统计表含 mean/sd/min/max/N、三张结果表用 `etable` 导出且无 Stata 直接输出、四张图有标题轴标签单位与来源、诊断含 `testparm`、`xttest3`、`xtserial`、稳健与聚类标准误、Hausman、二次项与缩尾讨论【已核实的事实：四份 do 与三份 log 逐行回读】。因此按 12/11 评分清单的 Stata Files 四条硬门槛，当前五份 do 及其衍生物是满足的；但这不足以覆盖 11/18 assignment 的全部要求，见下一段【由事实推出的推断：两份文件作用域不同；已作废结论，禁止复活：此前「当前四份 do 及其衍生物满足 11/18 递交要求」】。12/11 终稿另有论文正文、8 篇以上文献综述与 AER 格式书目，不属 11/18 范围【已核实的事实：Final Paper Instructions】。

同日 18:52 用户另提供 `Econometric Files for Final Paper.pdf`，这是 Canvas 11/18 assignment 页面导出，页首逐字列出「Due No Due Date Points 100」「File Types log, csv, png, do, docx, and jpeg」「Start Assignment」，第 1–2 页列十项交付内容，第 3–4 页列 100 分评分细则，因此它就是 Course Outline 所说的 posted checklist，与 12/11 的评分清单不是同一份文件【已核实的事实：所附 PDF 逐字】。按该细则逐条核对，当前提交包明确缺 do 内完整数据引用（4 分）、逐变量嵌套回归表且含年份与国家固定效应 yes/no 行（15 分）、全样本加两个子集共三列的结果表（10 分）、至少两个重叠直方图的 PNG（6 分）、单一年份且仅保留主解释变量非缺失观测的描述统计表（3 分），以及 Canvas comments 写明结果是否支持假设（5 分）；merge 未匹配观测的说明、单一完整设定回归的呈现与缩尾是否首选的注释只算部分满足【已核实的事实：四份 do、三份 log 与五份表逐项比对，详见 `ECON490_ECONOMETRIC_FILES_GAP_261114.txt`】。已满足的是变量名、异方差与序列相关检验、年份与面板固定效应检验、缩尾重复回归、四张出版级 PNG，以及三份编号 log 各自不超过 25 页且注释可见【已核实的事实：同上】。按新细则现状约只有一半分数，Canvas 100 分折算总成绩 10%【由事实推出的推断】。另 Canvas 允许类型不含 `.xlsx` 与 `.dta`，描述统计表需另导 `.docx` 或 `.csv`，数据交 `.csv` 版本；该 PDF 正文的「March 23rd」与 Course Outline 的 11 月 18 日冲突，判为旧学期模板残留，截止仍按 11 月 18 日【已核实的事实：页首 File Types 与 Course Outline p.14；主观判断：日期冲突解释】。


同日 20:50 按该细则完成代码侧补齐并整链重跑：五个实际使用的数据源以 AER / Chicago 作者-年份格式写进 `1_build_data_261109.do` 的 `* Data sources` 块；新增 2019 年且仅保留主解释变量非缺失观测的描述统计表（23 个观测，同时导出 `.xlsx` 与 `.csv`，因为 Canvas 允许类型不含 `.xlsx`）、逐变量嵌套回归表（主解释变量第一列，表注写明 Year FE: yes / Country FE: yes）、全样本 26 国加欧洲 19 国与非欧洲 7 国的三列子集表、至少两个重叠直方图的 PNG，以及 merge 未匹配、缩尾是否首选、二次项为何不纳入三类注释【已核实的事实：五份 do、四份 log 与九份表逐项回读】。子集划分按欧洲与非欧洲 OECD 成员，依据是超国家带薪假指令的制度差异；按初始假期待遇慷慨度分组曾试算，因 26 国期初数值中位数为 0 而全部落入同一组，已放弃【已核实的事实：本机 CSV 统计】。子集表统一使用不含 `leave_gdp` 的核心控制集，因为 SOCX 支出在非欧洲覆盖稀疏，用全控制会让该列只剩 33 个观测；即便如此非欧洲列仍只有 6 个聚类与 102 个观测，主系数 23.576 属小样本产物，表注已警告不得解读为政策效应【已核实的事实：`4_tables_261109.log`】。

同日还处理了 Neal 的 GitHub PR #1（commit `8efda45`，已合并为 `29eb0d3`）：该提交把 `0_master` 与 `1_build_data` 改为运行时从五个官方端点实时读取数据。本机实测 ILOSTAT 指标端点对 `.csv` 与 `.csv.gz` 两种写法均返回 HTTP 200 但 0 字节，Eurostat SDMX 3.0 响应 12.7 MB 且 20 秒未完成，其余三个端点正常【已核实的事实：本机 curl 测试】。更根本的是实时数据修订会让提交的 log 无法复现，与「log 由 do 生成」「所有报告工作都在 do 与 log 里」冲突，故不采用实时读取，只采用其官方来源清单作为引用；同时保留其可移植思路，把 `global proj_main` 改成 `"."`，换机器只需改 `capture noisily cd` 一行，但 `do_dir` 与 `capture noisily do` 仍按 Workflow 18 原文保留【由事实推出的推断：复现性优先】。最终同步包已推送 GitHub `9598fc6`，共 63 个文件【已核实的事实：远程文件树 API】。

关于 `clear`：Workflow Guide 18 的 master 结构逐字为 `/* Project info */` 后接 `clear`，并明确说 globals 存到关闭 Stata 为止；`capture noisily do` 调用编号 do 文件【已核实的事实：知识库同标题源文档 `18 - Stata Workflow Guide – COMET.pdf` 全文】。`clear all` 在课程语料中出现 19 次，但都在单文件 Test / Quiz 作业或 COMET 14 的单文件示例里；在 master 加子 do 的链条里，子 do 若用 `clear all` 会清掉 master 定义的路径 globals，链会断。`*` 是注释符，不影响执行，且注释会显示在 log 里，正是 "fully annotated log" 所需【由事实推出的推断】。在全新机器上 `clear` 与 `clear all` 对首次 master 运行没有差别，真正的风险是 `cd` 的绝对路径、未安装 `xttest3` / `xtserial` / `coefplot`、Stata 版本低于 17，以及 data_raw 未随包提供【由事实推出的推断】。

## 五、命令白名单与边界项

只允许知识库内 COMET Notebook、StataTest、Cometquiz 与 `StataCheatSheet_analysis_19.pdf` 逐字展示或讲解过的命令与语法，禁止 `reghdfe`、`csdid`、`eventdd` 一类训练数据中的高级应用【已核实的事实：用户长期指令】。2026-11-14 把 18 份 COMET `.qmd` 的 Stata 代码块与 29 份课程 do 抽出 102 个命令 token 比对两份汇总，补录 `xlabel()` / `ylabel()`，其余全部已收录【已核实的事实：脚本输出与两份汇总回读】。`split parse()`、`rowmin` / `rowmax` / `rownonmiss`、`cond()`、`[_n-1]` 下标已分别用 `generate` / `replace` / `real()` / `missing()` 与课程讲过的 `L1.` / `F1.` 算子等价替换，`stringcols(_all)` 与 `allstring` 两个 import 选项也已移除；当前四份 do 的命令首词全部在课程语料中命中，只剩 `egen ... = min()/max()`（课程只逐字展示 `mean()`）与 `generate` + `recast double` + `replace` 三步两处轻微扩展，均非被禁的高级用法【已核实的事实：变体 B 与变体 D 整链实跑、命令首词语料比对】。去掉那两个选项只改变就业率三列的存储精度：Europe 最大差 `1.03e-05` 个百分点、OECD `7.08e-06` 个百分点，所有核心系数、标准误、p 值、样本量与显著性结论逐字不变，离散副作用只有结果变量缩尾改动数由 5 变 4 与一个 Wald 统计量末位差 0.01；用户判据是「影响微乎其微就保证白名单」，因此按此执行，不再要求 CSV 逐字节一致【已核实的事实：受控实跑的逐列与逐浮点数比对；已作废结论，禁止复活：此前「必须保留这两个选项」的判断】。

## 六、当前回归结果

Europe 主表六列 N = 272 / 272 / 272 / 295 / 272 / 295，OECD 三列 N = 333 / 333 / 443【已核实的事实：最终 `3_results_261109.log`】。核心变量 `lag_fatherweeks10` 系数始终 +0.668，未调整 FE `p=0.016`、稳健 `p=0.054`、按国家聚类 `p=0.065`、AR1 PCSE 换系数 +0.560 `p=0.007`；DiD `−0.626 (p=0.653)`；事件研究四期 `p=0.878 / 0.815 / 0.817 / 0.603`；OECD 三列 `p=0.352 / 0.583 / 0.746`【已核实的事实：同上】。讲义逐字要求「Always cluster your SEs」，且 23 个国家聚类低于「a rough floor is 30–50」的经验下限，故课程口径下应写「没有稳健显著的政策效应 / conditional association」，PCSE 只作 sensitivity【由事实推出的推断：依据讲义与 COMET 15 对 Prais-Winsten 不自动控制固定效应的警告】。历史上出现过的显著 p 值分别来自未聚类标准误、滞后构造错误造成的样本选择与已作废方向，在符合课程要求与理论合理性的前提下没有任何值得回滚的设定；以拿到星号为目的改设定与 Checklist 及学术诚信冲突【主观判断：综合课程依据与本机实证】。

## 七、版本链与文件索引

早期 wage gap / 17 行业 / 26 欧洲国（10/21 作废）→ Test7 OECD 交互模型 20 国 77 obs（降级为控制变量与数据供体）→ 11/4 六份 TWFE do（Europe/OECD 两套 build 加 DiD，无控制、无聚类 SE）→ 11/9–11/13 当前链（组织基线取自 11/4，回归段重写，补控制与聚类、图表、Workflow 18 结构，并把上游构建并入 1 号 do）→ 11/14 注释与命令风格精简【已核实的事实：各版 do 与 log 回读】。变的是结果变量口径、样本、识别与推断方式，研究问题始终是父亲专属带薪假与男女就业差距【由事实推出的推断】。

专门文件索引：样本范围依据 `ECON490_SAMPLE_SCOPE_NOTE_261112.txt`；交互项决策 `ECON490_DECISION_2026-11-11.txt`；代码风格与命令白名单两份 `*命令与语法汇总.md`；给 Neal 的中文回报 `ECON490_NEAL_REPORT_261113_CN.txt`；Neal 交接包清点 `NEAL_HANDOFF_USABLE_261113.txt`；知识库文献映射 `LITERATURE_REFERENCES_IN_IMA_261113.txt`；论文英文大纲 `ECON490_PAPER_OUTLINE_EN_261112.md`；Sultana 任务 `ECON490_SULTANA_TASKS_261111.txt`；往期版本与旧文件归档在 `.workbuddy/_cache_261113/`【已核实的事实：工作区目录枚举】。

## 八、未决项、资料边界与最短执行顺序

仍未闭环：Canvas 上传与 comments 粘贴、五个数据源的精确访问日期、11/18 assignment 页面是否另有上传入口或命名要求；最终模型的组内书面冻结（含讲师「只做 OECD」建议是否有书面口径）、`literature/` 与 `paper/` 仍空、`format %10.0g` 是否获准、`egen min()/max()` 两处轻微扩展是否需要向教师说明、23 个聚类低于经验下限在论文里的措辞【主观判断：按影响排序】。资料边界：`@long-text` 文献表只传来表头，全文不可读；`@ima:"ECON 490"` 多次检索返回十万字符级结果，本档只做定向索引，不声称全文通读；知识库里的两份命令汇总是 11/4 上传的旧版，权威版本在工作区本地【已核实的事实：检索返回体量与知识库列表时间戳】。

最短执行顺序：代码侧已补齐并整链复验，现在先在 OneDrive 客户端确认九个目录已同步，再登录 Canvas 上传五份 do、四份编号 log、data_raw 与 data_final 的 csv 版本、九份表（描述统计表交 csv 或 xlsx 及 docx）与五张图，只上传 log/csv/png/do/docx/jpeg 类型，并在 comments 粘贴 `ECON490_ECONOMETRIC_FILES_GAP_261114.txt` 第四节的英文草稿；随后由 Sultana 按 Final Paper Checklist 起草 12/11 论文，文献综述所需 10 篇原文 PDF 已在 ECON 490 知识库 `Referece/` 文件夹与根目录 `703115.pdf`，不用再下载【由事实推出的推断：执行先后安排】。本档是二次文档，不得作为一手证据引用；课程页面、Canvas 公告或任何 do/log 更新后，相应结论须重新核对，不得沿用【主观判断：时点限定】。
