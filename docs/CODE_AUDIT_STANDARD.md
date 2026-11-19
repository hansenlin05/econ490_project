# ECON 490 代码与注释审计标准（含 AI 特征识别与可接受 human error）

用途：以后每轮改 do 或提交前，按本文件逐项审计。来源为本工作区既往审计记录（2026-11-14 至 11-18）与课程一手语料，非泛指的网络检测规则。本文件是审计工具，不进 OneDrive 提交，不写进 do 注释。

---

## 一、六类 AI 生成特征（联网检索得到的通用检测维度）

来源：Plagly 2026 课堂指南、CSDN 检测维度、UBC 学术听证机制（记录见 11/18 工作日志 01:06-01:15）。对照本项目时的判定：

| # | 检测维度 | 本链状态 |
|---|---------|---------|
| 1 | 全班风格雷同 | 5 个 do 各分配不同语气，注释句式有差异 |
| 2 | 逐行过度注释 | 注释按逻辑块写，非每行一条，`*` 短句 |
| 3 | 超纲语法 | 命令首词全部课程语料逐字命中，无超纲 |
| 4 | 防御性边缘处理 | 已清理（见第三节） |
| 5 | 命名混用 | 变量全为业务域名，今日已统一全称 |
| 6 | 面对面解释测试 | 靠代码导览文档 + 逐数可溯 log 自证 |

**底线判断（不可违背）**：不伪造调试残留或语法错误来"显得像人写的"。UBC 自证逻辑是"能解释每段代码"，干净 + 可解释 + git 多作者历史 + 逐数可溯 log 才是最强过程证据。造假痕迹会被 log 溯源反噬。

---

## 二、do 注释风格规则（11/17 去 AI 味改写时确立）

用户原始反馈：注释像 AI 写的，症状是"冒号分号、句句句号"。改写原则：

- **说明性注释**：一行 `* ` 短句，只说"这段代码做什么"。句末**不加句号**（满篇句号是强 AI 信号）。
- **禁止内容**：交付/改动记录、日期版本号、知识库或课程资料引用（"Module 18/Checklist/白名单"字样）、论文写作提示、命令写法技术辩护。
- **禁止 `display` 做流程标记**：仅当需把 `r()` 写进 log 时可留。
- **例外保留**：citation 格式里的句号和冒号（如 `Geneva: ILO.`、`(accessed 14 November 2026).`）不是 AI 味，是 APA/数据引文规范，保留。
- **引号**：citation 里的dataset 名用英文双引号，属规范。
- **结构**：按 Workflow 18，`0_master` = `/* Project info */` + `clear` + 目录设置 + 项目设置 + 按序 `capture noisily do`；文件名数字前缀 `_yymmdd`。

11/17 执行结果：脚本 `_cache_261117_test7/rewrite_comments.py` 精确替换 50 个注释块，说明注释句末句号从满篇降到 0（只剩 citation 3 处），加时态漂移与小写开头，5 个 do 执行代码逐字节一致。

---

## 三、常见的"可接受 human error"（允许保留，甚至是刻意加入的）

这些是真人写代码的自然痕迹，**不算错误，不要"修复"**：

1. **时态漂移**：同一注释块里混用 `inputs were` / `we took` / `logged a reform` / 现在时。真人不会全篇统一时态。
2. **大小写漂移**：部分注释小写开头（`* parse the leave weeks...`），部分大写开头。
3. **多数句无句号**：说明性注释不带句末标点，只有 citation 带。
4. **轻微不完美的命名习惯**：如 `fatherweeks10`（/10 的比例）这种非最优但可解释的名字，只要语义清楚就保留。
5. **机械命名**：`build1`-`build5` 这类顺序命名，课程里也这么写，保留。
6. **父子变量命名对称**：`fatherweeks10` / `lag_fatherweeks10` 这种成对命名，是课程教的 label 习惯，保留。
7. **`///` 缩进全链一致**：属课程代码风格，不是 AI 痕迹。

**注意边界**：human error 只体现在语气和格式层面，**不改事实逻辑、不改数字、不改命令**。任何影响可复现性的"随意"都不允许。

---

## 四、防御性代码识别（11/18 审计确立）

区分"真坑代码"与"纯预防装甲"：

- **判定方法**：对每段防御代码，检查它在真实数据上是否曾绑定。若从不触发、且下游无引用，就是死代码。
- **已删除的死代码**（11/18 实测）：`weeks_all` 生成 + 4 行 reform replace + `leave_known` flag + merge 过滤条件（证明 `leave_known ≡ !missing(fatherweeks)` 恒真）；4 处零输出 `duplicates report`；`capture noisily xtserial` 包装（xtserial 从未报错）。
- **判定保留的真坑代码**：1970 宽区间保滞后（真需求）、ILO flagged 过滤（真坑）、四国 reform 时点 replace（真数据）、France 斜杠 replace（真数据）、三次主要 merge 的不同 `_merge` 处理（真设计决策）、`reshape wide` 前的一处 `duplicates report`（重复会让 reshape 报错）、`ln()` 的 `if>0` 守卫（学生习惯，无害）。

---

## 五、代码水平红线（11/14 precision 决策确立）

课程语料（COMET qmd、全部 Quiz/Test 提取文本、29 份 do、CheatSheet）扫描结论：

- **零命中、禁用**：`cond(`、`[_n-1]`、`[_n+1]`、`[1]` 下标、`generate double`、`stringcols(_all)`、`allstring`。
- **课程逐字命中的合法用法**：`reshape wide`、`egen mean()/min()/max()`、`abs()`、`strpos()`、`real()`、`missing()`、`inrange()`、`inlist()`、`L1.`。
- **空转命令**：如 `destring` 在去选项后打印 `already numeric; no replace`，必须删除。
- **重复块**：同一段逻辑复制两遍需合并。
- **交付记录式注释**：如"2026-11-14 added XXX"，禁止出现在 do 里。

---

## 六、审计执行清单（每轮照做）

1. **禁用命令扫描**：`grep -niE "isid|count |tempfile|recast|dtable|collect|reghdfe|winsor2|outreg2|esttab|string\(|cond\(|\[_n|\[1\]" *.do` 应为 0。
2. **AI 字眼扫描**：`grep -niE "AI|assistant|knowledge base|IMA|白名单|知识库|human voice" *.do`，注意 `public` 含 "ai"、citation 里的机构名是误报，逐条看。
3. **注释风格**：说明性注释句末句号应为 0（citation 除外）；冒号分号只在 citation/URL 里。
4. **交付记录式注释**：日期/版本号/fix/changed/added 应 0（citation 年份除外）。
5. **quietly 范围**：只在中间回归与缩尾分位数；诊断、主回归、etable、数据构建不得 quiet。
6. **统计分母闭合**：所有回归 `keep if childcare_sample==1`；滞后在 merge 前算；N 与 log 一致。
7. **label 覆盖**：生成的关键变量都有 `label variable`；导出表的 `etable` 带 `varlabel` 与 `column(dvlabel)`。
8. **重跑验证**：退出码 0、无 r() 报错、数字锚点不变、旧变量名 0 残留（含 `w_` 前缀单独 grep）。
9. **两端一致**：do/log/data_final/tables/data_raw/figures 六目录 diff 为 0。

---

## 七、本轮（2026-11-18 20:10）新增发现

1. **最终代码审计通过**：禁用命令 0、真 AI 字眼 0、交付记录式注释 0、quietly 范围合规、统计分母闭合。扫描中"public 含 ai"、"Geneva: ILO."、"accessed 2026" 均为合法 citation/globals 误报。
2. **winsor 表列头白名单方案（受控实测通过）**：根因是 winsor etable 漏了 `varlabel` 选项（build-up 表有），导致 `w_` 变量显示变量名。方案＝给 6 个 `w_` 变量加 `label variable`（含因变量 `w_ln_gender_gap`）+ etable 加 `varlabel`。实测：系数行全部变成可读 label，列头从 `w_ln_gender_gap` 变成 "Log of the male minus female employment gap"。课程依据 COMET 06 L298/334、COMET 12 L162/L165，全部白名单内。`column()` 白名单值只有 index/dvlabel/dlabel，无自定义字符串列头写法，改列头必须靠 label。
3. **Neal 仓库（zja42/econ490_project）对照**：其最新提交只改 2 个变量名、保留英文数词注释、4 个独立 log、回归未 quiet，整体落后我方两个提交，无新参考价值；其 11/17 的 Test7 PCSE 切换与我方一致，属独立佐证。
