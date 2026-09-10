# Universal Humanizer

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![skills.sh](https://skills.sh/b/irrumi/universal_humanizer)](https://skills.sh/irrumi/universal_humanizer)

Universal Humanizer is a cross-platform agent skill that rewrites AI-sounding or robotic prose so that it reads naturally, rhythmically, and authentically like human writing without altering verifiable facts.

Because it adheres to open agent standards, it installs and executes seamlessly across Google Antigravity, Gemini CLI, OpenAI Codex CLI, Claude Code, Cursor, Windsurf, OpenCode, and Claude Desktop.

---

## One-Command Installation

Run the universal installer in your terminal to automatically detect all installed AI agents and place the skill files in the proper configuration paths:

### macOS / Linux
```bash
curl -fsSL https://raw.githubusercontent.com/irrumi/universal_humanizer/main/install.sh | bash
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/irrumi/universal_humanizer/main/install.ps1 | iex
```

### Safe Inspection Alternative
If you prefer not to pipe directly into your shell, inspect the script before running:
```bash
curl -fsSL https://raw.githubusercontent.com/irrumi/universal_humanizer/main/install.sh -o install.sh
less install.sh
bash install.sh --dry-run
bash install.sh
```

---

## Installation Matrix

| Environment | Scope | Command / Method | Installed Location |
|---|---|---|---|
| **Universal Installer (macOS/Linux)** | Auto-detect all | `curl -fsSL .../install.sh \| bash` | Configures every detected agent on system |
| **Universal Installer (Windows)** | Auto-detect all | `irm .../install.ps1 \| iex` | Configures every detected agent on system |
| **Skills CLI (Any Agent)** | Global | `npx skills add irrumi/universal_humanizer --global` | `~/.agents/skills/` or agent defaults |
| **Claude Code (Plugin)** | Global | `/plugin marketplace add irrumi/universal_humanizer`<br>`/plugin install universal-humanizer@universal-humanizer` | `~/.claude/plugins/` |
| **Claude Desktop / Web** | Global | Download `universal-humanizer.zip` from [Releases](https://github.com/irrumi/universal_humanizer/releases) & upload as skill | Claude Skills interface |
| **Google Antigravity (Project)** | Project | `install.sh --agent antigravity --project` | `.agents/skills/universal-humanizer/SKILL.md` |
| **Google Antigravity (Global)** | Machine | `install.sh --agent antigravity --global` | `~/.gemini/config/skills/universal-humanizer/SKILL.md` |
| **Google Antigravity (Plugin)** | Plugin bundle | `install.sh --agent antigravity-plugin` | `~/.gemini/config/plugins/universal-humanizer/` |
| **Gemini CLI** | Machine | `install.sh --agent gemini-cli` | `~/.gemini/extensions/universal-humanizer/`<br>`~/.gemini/commands/humanizer.toml` |
| **OpenAI Codex CLI** | Machine | `install.sh --agent codex` | `~/.codex/prompts/humanizer.md`<br>`~/.codex/AGENTS.md` |
| **Cursor** | Project | `install.sh --agent cursor` | `.cursor/rules/humanizer.mdc` |
| **Windsurf** | Project | `install.sh --agent windsurf` | `.windsurf/rules/humanizer.md` |
| **OpenCode** | Global/Project | `install.sh --agent opencode` | `~/.config/opencode/skills/universal-humanizer/` |
| **Manual Installation** | Any | Copy `SKILL.md` into your agent's skills directory | Agent-dependent |

---

## Privacy & Security Guarantee

- **100% Local Processing:** Universal Humanizer runs strictly inside your local agent runtime. Your text is never routed through third-party servers, tracking APIs, or telemetric collectors.
- **Zero Hallucination Policy:** The skill is strictly instructed never to fabricate names, metrics, dates, quotes, or claims not present in your draft.
- **Prompt Injection Defense:** Input text is treated strictly as passive editorial material; embedded prompt commands within the text being edited are ignored.
- **No External Dependencies:** No Python packages, Node modules, or external API keys are required.

---

## Verifying Your Installation

Test whether the skill is loaded by running a short query in your agent chat:

```text
/humanizer

Test sentence: "It's not just an update, it's a testament to our ongoing journey toward transformative synergy."
```

If Universal Humanizer is active, it will flag the "not X, but Y" contrast (§1) and stock AI vocabulary (§12), returning a direct, clean rewrite such as:
> *"The update speeds up processing and fixes three memory leaks."*

---

## Usage

### 1. Direct Invocation
```text
/humanizer

[Paste your text here]
```

### 2. Plain Language Request
```text
Please humanize this draft using the universal humanizer guidelines:
[Paste your text here]
```

### 3. File Rewriting (Preserves Code, Tables & Metadata)
```text
Humanize the prose in docs/announcement.md
```
*Note: In file mode, Universal Humanizer updates only markdown prose. Code blocks, inline commands, URLs, YAML frontmatter, and data tables are left untouched.*

### 4. Matching Your Authentic Voice
Provide a short sample of your genuine writing to match rhythm, sentence lengths, and stylistic habits:

```text
/humanizer

Here is a sample of my writing style:
[Paste 2-3 paragraphs of text you wrote yourself]

Now rewrite this AI draft to match my voice:
[Paste text to humanize]
```

---

## The 25 patterns

The catalog organizes 25 AI writing patterns into five logical groups, ordered from highest-frequency tell to subtle stylistic leftover:

### A. Staging Instead of Stating

| # | Pattern | Tell Example | Human Fix |
|---|---|---|---|
| 1 | **Not X, but Y Formula** | *"It's not just a tool; it's a philosophy"* / *«Не просто X, а Y»* | State the factual claim directly |
| 2 | **One-Line Closers** | *"That changes everything."* / *«И это только начало»* | Remove dramatic taglines; end on the last fact |
| 3 | **Pseudo-Deep Aphorisms** | *"At its core, trust is the currency of..."* / *«По своей сути»* | State practical mechanics rather than grand metaphors |
| 4 | **Staged Run-Up** | *"Let's dive in"*, *"Here is what you need to know"* | Cut throat-clearing openers; start immediately |
| 5 | **Arguing with Phantoms** | *"This isn't to say X doesn't matter, but Y..."* | Remove defensive answers to unraised objections |

### B. Mechanical Rhythm

| # | Pattern | Tell Example | Human Fix |
|---|---|---|---|
| 6 | **Forced Triads** | *"speed, scale, and resilience"* (rigid triplets) | Use the exact number of items justified by facts |
| 7 | **Monotonous Openers** | Three sequential sentences starting with *"The system..."* | Vary syntax; combine related clauses |
| 8 | **Em Dashes Everywhere** *(weak alone)* | Unchecked em dashes (—) joining unrelated thoughts | Use periods, commas, or conjunctions; match sample |
| 9 | **Stacked Hedges** *(weak alone)* | *"It could potentially arguably be considered that..."* | Retain hedges only when factual uncertainty exists |
| 10 | **Indiscriminate Hyphens** *(weak alone)* | *"The service is cloud-native and client-facing"* | Remove hyphens in predicate adjectives |
| 11 | **Passive Obfuscation** *(weak alone)* | *"Mistakes were identified during deployment"* | Name the actor and specific malfunction directly |

### C. Inflation and Borrowed Authority

| # | Pattern | Tell Example | Human Fix |
|---|---|---|---|
| 12 | **Overused AI Words** | *delve, landscape, tapestry, robust, pivotal, bolster* / *«в современном мире»* | Substitute with plain, direct terminology |
| 13 | **Inflated Significance** | *"stands as a testament"*, *"paving the way for a bright future"* | Drop unearned historical drama; report results |
| 14 | **Vague Connections** | *"is associated with the development of"* | Name the exact role or causal relationship |
| 15 | **Shallow Participial Riders** | *"...ensuring seamless operational excellence"* | Drop trailing -ing appendages or make them concrete |
| 16 | **Promotional Gloss** | *"Nestled in the heart of..."*, *"boasts world-class"* | Describe physical location and features objectively |
| 17 | **Borrowed Authority** | *"Experts agree that..."*, *"Industry studies indicate..."* | Cite the specific study/source or state claim simply |
| 18 | **Avoiding Simple Copulas** | *"serves as a primary component"*, *"functions to"* | Use direct verbs: *is*, *are*, *has*, *does* |

### D. Formulaic Formatting

| # | Pattern | Tell Example | Human Fix |
|---|---|---|---|
| 19 | **Gratuitous Boldface** | Bulleted lists where every item has a bold label and colon | Write cohesive narrative paragraphs |
| 20 | **Decorative Headers** | Title Case On Every Word, emojis (🚀, 💡), dividing lines | Use sentence case and clean markdown formatting |
| 21 | **Curly Quote Glitches** *(weak alone)* | Typographic curly quotes breaking shell commands | Preserve straight quotes in technical documentation |

### E. Leftovers from Chat and Draft

| # | Pattern | Tell Example | Human Fix |
|---|---|---|---|
| 22 | **Chatbot Residue** | *"Certainly! Here is a breakdown..."*, *"I hope this helps!"* | Strip conversation wrappers entirely |
| 23 | **Cutoff Disclaimers** | *"While records are limited, he likely grew up..."* | State known facts; omit speculative guesswork |
| 24 | **Immediate Header Echo** | Following a header with an opener repeating the header | Step directly into the substantive content |
| 25 | **Anachronistic Notes** | *"This function was rewritten to fix O(n^2) slowness"* | Document what the code does now, not past flaws |

---

## The 5-Step Editorial Methodology

Universal Humanizer incorporates the practical editing workflow developed by professional writing practitioners:

1. **Voice Sample Calibration:** Analyzes authentic text from the writer to mimic cadence, sentence length distributions, and idiosyncratic style. The user's sample takes precedence over general rules.
2. **Cadence & Burstiness Control:** Algorithms default to monotonous sentences of 14–19 words. The skill breaks this cadence by interlocking short sentences (under 8 words) with longer, clause-rich statements (over 25 words).
3. **Audience Anchoring:** Eliminates "average reader" vagueness by adjusting technical depth and tone for a specific reader.
4. **Empirical Grounding:** Preserves grounded, lived details (timestamps, mixed feelings, physical obstacles, specific tools) while strictly forbidding fabricated facts.
5. **Read-Aloud Breath Test:** Simulates vocal performance. If phrasing causes hesitation or breath exhaustion, it is rewritten.

---

## Full Transformation Examples

### English Example

**Before (AI-Generated Draft):**
> It's not just an infrastructure migration; it's a testament to our team's relentless commitment to innovation. Nestled within our core distributed architecture, the new message broker stands as a pivotal milestone, fostering robust scalability across disparate microservices. Experts agree that asynchronous queuing plays a key role in the modern cloud landscape. From request throttling to telemetry aggregation, every component works in perfect harmony, ensuring seamless operational excellence. The journey was not without its challenges, but the future looks incredibly bright. 🚀

**After (Universal Humanizer):**
> We migrated our primary message broker to Apache Kafka last month. The old RabbitMQ cluster was dropping consumer connections whenever throughput exceeded 12,000 events per second. The migration took three weekends of backfilling partition logs and required rewriting our retry handlers, but p99 event latency dropped from 85ms to 14ms across all production services.

---

### Russian Example (Русский язык)

**До (Типичный ИИ-текст):**
> В современном быстро меняющемся мире веб-разработки крайне важно отметить, что переписывание старого кода — это не просто рутинная задача, а глубокий процесс трансформации всей экосистемы проекта. Наша новая архитектура выступает в роли надежного фундамента, гармонично сочетая гибкость и безопасность. Эксперты сходятся во мнении, что чистый код открывает новые горизонты для масштабирования. Давайте погрузимся в детали и разберёмся, как это работает на практике. И это меняет всё. 💡

**После (Universal Humanizer):**
> В апреле мы переписали модуль авторизации. Старый монолитный контроллер накопил три тысячи строк спагетти-кода, в котором любая смена тарифа ломала сессии пользователей. Мы разделили логику на два отдельных сервиса и настроили валидацию токенов через Redis. Время ответа на логине упало со 180 до 35 миллисекунд.

---

## Credits

- Pattern taxonomy informed by Wikipedia's ["Signs of AI writing"](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) (maintained by WikiProject AI Cleanup, licensed under CC BY-SA).
- Inspired by peer work in agent-based prompt design, including [`blader/humanizer`](https://github.com/blader/humanizer).
- Editorial methodology informed by the practical writing framework at [Educraft.tech](https://educraft.tech/how-to-humanize-ai-generated-content-in-5-steps/).

---

## License

Universal Humanizer is open-source software licensed under the [MIT License](LICENSE).
Copyright (c) 2026 irrumi.