---
name: official-skills-catalog
description: Catalog of Hermes Agent's 103 official optional skills, installation status in this Termux profile, and workflow for installing needed official skills on demand.
---

# Hermes Official Optional Skills Catalog

Use this skill when the user asks about official Hermes skills, wants to install more skills, asks why a task lacks a skill, or when a task would benefit from an official optional skill that is not installed yet.

## Current profile context

- Active Hermes profile when this catalog was created: `default` on Android/Termux.
- Official optional skills are not active by default. Install with:

```sh
hermes skills install official/<category>/<skill> --yes
```

- Verify installed skills with:

```sh
hermes skills list
```

- Authoritative local catalog at creation time:

```text
the local Hermes checkout optional-skills catalog, when present
```

- If the online/installed Hermes docs differ from this skill, prefer the newer Hermes docs/catalog and patch this skill.

## On-demand installation policy

When a future task clearly needs an official optional skill that is not installed:

1. Check whether it is in the catalog below.
2. If it is official and directly useful for completing the user's current task, install it without asking:

```sh
hermes skills install official/<category>/<skill> --yes
```

3. Run `hermes skills list` to verify installation.
4. Patch this skill to change that skill's status to `INSTALLED` and add any install notes.
5. Load the newly installed skill with `skill_view` before continuing the task.

Ask first only if the skill has obvious external side effects, requires credentials/payment, installs heavy system packages, is security/pentest related, or the task does not clearly require it.

## Status legend

- `INSTALLED` = installed and enabled in the current `default` profile.
- `NOT INSTALLED` = official optional skill known in catalog but not installed.
- `DEFERRED` = intentionally not installed yet because it requires credentials, external services, heavy dependencies, or is not useful for current Android/SEO/GEO workflow.
- `ATTEMPTED / RATE-LIMITED` = install attempted but blocked by GitHub unauthenticated rate limit.
- `ATTEMPTED / BLOCKED` = install attempted but Hermes security/provenance guard blocked it.

## Practical installed package chosen for this user

Installed successfully on 2026-07-18:

- research/domain-intel — domain reconnaissance useful for SEO/GEO audits.
- research/duckduckgo-search — free web search.
- research/qmd — local knowledge-base search; installed despite scanner warnings because official/builtin source allowed it.
- research/scrapling — web scraping/crawling.
- research/searxng-search — meta-search via SearXNG.
- software-development/code-wiki — codebase documentation/wiki generation.
- software-development/rest-graphql-debug — API debugging; installed despite scanner warnings because official/builtin source allowed it.
- software-development/subagent-driven-development — structured subagent execution.

Additional official skills installed successfully after GitHub auth on 2026-07-18:

- devops/pinggy-tunnel — localhost tunnels over SSH; installed despite official/builtin dangerous scan verdict.
- devops/watchers — RSS/JSON/GitHub polling; installed despite official/builtin dangerous scan verdict.
- creative/concept-diagrams — SVG/HTML concept diagrams; installed despite official/builtin caution scan verdict.
- creative/creative-ideation — creative ideation methods.
- creative/meme-generation — meme image generation.
- communication/one-three-one-rule — structured decision-making framework.

Additional skills installed successfully after retry on 2026-07-18:

- productivity/here.now — installed successfully after retry; `hermes skills list` reports source `local`, trust `local`, enabled. Security scan resolved as official/builtin and allowed dangerous verdict.
- productivity/siyuan — installed successfully after retry; `hermes skills list` reports source `official`, trust `official`, enabled. Security scan resolved as official/builtin and allowed dangerous verdict.

## GitHub rate-limit fix for official skill installs

If `hermes skills install official/...` fails with GitHub unauthenticated API rate limits, fix the setup before retrying large skill installs:

```sh
pkg install -y gh
printf 'Y\n' | gh auth login --hostname github.com --git-protocol https --web --insecure-storage
# Open https://github.com/login/device and enter the printed one-time code.
gh auth status
```

Notes for Android/Termux:

- `gh` is available from the Termux repo as package `gh`.
- In non-interactive agent subprocesses, piping `Y\n` answers the “Authenticate Git with your GitHub credentials?” prompt and lets `gh` print the device-code URL/code.
- After browser approval, verify with `gh auth status`, then retry the official skill installs.
- Do not save the one-time code; it is transient.

## Recommended next additions for this user

The previously rate-limited practical additions were installed after GitHub auth. Consider later, only if needed:

- productivity/telephony — useful for SMS/calls but requires telephony provider setup.
- productivity/shopify — useful only for Shopify projects.
- productivity/here-now — installed after retry; use only when publishing/static cloud-file handoff is explicitly useful, and handle credentials carefully.
- productivity/siyuan — installed after retry; use only when a SiYuan instance/token is configured.
- devops/inference-sh-cli — useful for AI app workflows, but may need external CLI/service.
- mcp/fastmcp and mcp/mcporter — useful for building/using MCP servers.

## Full official optional skills catalog

### autonomous-ai-agents

- `official/autonomous-ai-agents/antigravity-cli` — `NOT INSTALLED` — Operate the Antigravity CLI.
- `official/autonomous-ai-agents/blackbox` — `NOT INSTALLED` — Delegate coding tasks to Blackbox AI CLI agent.
- `official/autonomous-ai-agents/grok` — `NOT INSTALLED` — Delegate coding to xAI Grok Build CLI.
- `official/autonomous-ai-agents/honcho` — `NOT INSTALLED` — Configure/use Honcho memory with Hermes.
- `official/autonomous-ai-agents/openhands` — `NOT INSTALLED` — Delegate coding to OpenHands CLI.

### blockchain

- `official/blockchain/evm` — `NOT INSTALLED` — Read-only EVM client.
- `official/blockchain/hyperliquid` — `NOT INSTALLED` — Hyperliquid market data/account history.
- `official/blockchain/solana` — `NOT INSTALLED` — Query Solana blockchain data.

### communication

- `official/communication/one-three-one-rule` — `INSTALLED` — Structured decision-making framework.

### creative

- `official/creative/baoyu-article-illustrator` — `NOT INSTALLED` — Article illustrations.
- `official/creative/baoyu-comic` — `NOT INSTALLED` — Knowledge comics.
- `official/creative/blender-mcp` — `NOT INSTALLED` — Drive Blender via MCP.
- `official/creative/concept-diagrams` — `INSTALLED` — Minimal SVG/HTML concept diagrams.
- `official/creative/creative-ideation` — `INSTALLED` — Generate ideas via named creative methods.
- `official/creative/hyperframes` — `NOT INSTALLED` — HTML-based video compositions.
- `official/creative/kanban-video-orchestrator` — `NOT INSTALLED` — Multi-agent video production pipeline.
- `official/creative/meme-generation` — `INSTALLED` — Generate real meme images.
- `official/creative/pixel-art` — `NOT INSTALLED` — Pixel art with era palettes.

### devops

- `official/devops/inference-sh-cli` — `NOT INSTALLED` — Run AI apps via inference.sh CLI.
- `official/devops/docker-management` — `DEFERRED` — Docker management; usually not practical on Android/Termux.
- `official/devops/hermes-s6-container-supervision` — `DEFERRED` — Hermes Docker/s6 supervision; not relevant unless working inside Docker image.
- `official/devops/pinggy-tunnel` — `INSTALLED` — Zero-install localhost tunnels over SSH.
- `official/devops/watchers` — `INSTALLED` — Poll RSS, JSON APIs, GitHub with watermark dedup.

### dogfood

- `official/dogfood/adversarial-ux-test` — `NOT INSTALLED` — Roleplay difficult user for UX testing.

### email

- `official/email/agentmail` — `DEFERRED` — Agent-owned email inbox; likely requires external service setup.

### finance

- `official/finance/3-statement-model` — `NOT INSTALLED` — Integrated financial statements in Excel.
- `official/finance/comps-analysis` — `NOT INSTALLED` — Comparable company analysis.
- `official/finance/dcf-model` — `NOT INSTALLED` — DCF valuation models.
- `official/finance/excel-author` — `NOT INSTALLED` — Auditable Excel workbooks.
- `official/finance/lbo-model` — `NOT INSTALLED` — Leveraged buyout models.
- `official/finance/merger-model` — `NOT INSTALLED` — Accretion/dilution merger models.
- `official/finance/pptx-author` — `NOT INSTALLED` — PowerPoint decks.
- `official/finance/stocks` — `NOT INSTALLED` — Stock quotes/history/search.

### gaming

- `official/gaming/minecraft-modpack-server` — `NOT INSTALLED` — Host modded Minecraft servers.
- `official/gaming/pokemon-player` — `NOT INSTALLED` — Play Pokemon via headless emulator.

### health

- `official/health/fitness-nutrition` — `NOT INSTALLED` — Gym/nutrition tracker.
- `official/health/neuroskill-bci` — `NOT INSTALLED` — NeuroSkill BCI integration.

### mcp

- `official/mcp/fastmcp` — `NOT INSTALLED` — Build/test/deploy MCP servers with FastMCP.
- `official/mcp/mcp-oauth-remote-gateway` — `NOT INSTALLED` — Manual OAuth for remote MCP servers.
- `official/mcp/mcporter` — `NOT INSTALLED` — MCP CLI operations.

### migration

- `official/migration/openclaw-migration` — `NOT INSTALLED` — Migrate OpenClaw customization to Hermes.

### mlops

- `official/mlops/huggingface-accelerate` — `NOT INSTALLED` — Distributed training API.
- `official/mlops/training/axolotl` — `NOT INSTALLED` — Axolotl fine-tuning.
- `official/mlops/chroma` — `NOT INSTALLED` — Embedding database.
- `official/mlops/clip` — `NOT INSTALLED` — CLIP image/language model.
- `official/mlops/research/dspy` — `NOT INSTALLED` — DSPy LM programs and RAG.
- `official/mlops/faiss` — `NOT INSTALLED` — Vector similarity search.
- `official/mlops/flash-attention` — `NOT INSTALLED` — Flash Attention optimization.
- `official/mlops/guidance` — `NOT INSTALLED` — Constrained LLM output.
- `official/mlops/huggingface-tokenizers` — `NOT INSTALLED` — Fast tokenizers.
- `official/mlops/instructor` — `NOT INSTALLED` — Structured extraction with Pydantic.
- `official/mlops/lambda-labs` — `NOT INSTALLED` — GPU cloud instances.
- `official/mlops/llava` — `NOT INSTALLED` — Vision-language assistant.
- `official/mlops/modal` — `NOT INSTALLED` — Serverless GPU platform.
- `official/mlops/nemo-curator` — `NOT INSTALLED` — GPU data curation.
- `official/mlops/obliteratus` — `NOT INSTALLED` — LLM refusal ablation.
- `official/mlops/inference/outlines` — `NOT INSTALLED` — Structured JSON/regex/Pydantic generation.
- `official/mlops/peft` — `NOT INSTALLED` — Parameter-efficient fine-tuning.
- `official/mlops/pinecone` — `NOT INSTALLED` — Managed vector database.
- `official/mlops/pytorch-fsdp` — `NOT INSTALLED` — PyTorch FSDP.
- `official/mlops/pytorch-lightning` — `NOT INSTALLED` — PyTorch Lightning.
- `official/mlops/qdrant` — `NOT INSTALLED` — Qdrant vector search.
- `official/mlops/saelens` — `NOT INSTALLED` — Sparse autoencoder training.
- `official/mlops/simpo` — `NOT INSTALLED` — Simple Preference Optimization.
- `official/mlops/slime` — `NOT INSTALLED` — RL post-training.
- `official/mlops/stable-diffusion` — `NOT INSTALLED` — Stable Diffusion image generation.
- `official/mlops/tensorrt-llm` — `NOT INSTALLED` — TensorRT-LLM inference.
- `official/mlops/torchtitan` — `NOT INSTALLED` — Distributed LLM pretraining.
- `official/mlops/training/trl-fine-tuning` — `NOT INSTALLED` — TRL fine-tuning/RLHF.
- `official/mlops/training/unsloth` — `NOT INSTALLED` — Unsloth LoRA/QLoRA.
- `official/mlops/whisper` — `NOT INSTALLED` — Speech recognition/transcription.

### payments

- `official/payments/mpp-agent` — `DEFERRED` — Machine Payments Protocol.
- `official/payments/stripe-link-cli` — `DEFERRED` — Stripe Link payments.
- `official/payments/stripe-projects` — `DEFERRED` — Stripe Projects services/creds.

### productivity

- `official/productivity/canvas` — `NOT INSTALLED` — Canvas LMS integration.
- `official/productivity/here-now` — `INSTALLED` — Static site/cloud file publishing; `hermes skills list` shows installed as `here.now` with local/local provenance after retry.
- `official/productivity/memento-flashcards` — `NOT INSTALLED` — Spaced-repetition flashcards.
- `official/productivity/shop` — `NOT INSTALLED` — Shop catalog/checkout/order tracking.
- `official/productivity/shopify` — `NOT INSTALLED` — Shopify APIs.
- `official/productivity/siyuan` — `INSTALLED` — SiYuan notes API; official/official provenance after retry.
- `official/productivity/telephony` — `DEFERRED` — Phone/SMS/calls; requires provider setup.

### research

- `official/research/bioinformatics` — `NOT INSTALLED` — Bioinformatics gateway.
- `official/research/darwinian-evolver` — `NOT INSTALLED` — Evolution loop for prompts/regex/SQL/code.
- `official/research/domain-intel` — `INSTALLED` — Passive domain reconnaissance.
- `official/research/drug-discovery` — `NOT INSTALLED` — Pharmaceutical research.
- `official/research/duckduckgo-search` — `INSTALLED` — Free DuckDuckGo web search.
- `official/research/gitnexus-explorer` — `NOT INSTALLED` — Codebase knowledge graph.
- `official/research/osint-investigation` — `NOT INSTALLED` — Public-records OSINT.
- `official/research/parallel-cli` — `NOT INSTALLED` — Parallel CLI research/extraction.
- `official/research/qmd` — `INSTALLED` — Local knowledge-base search.
- `official/research/scrapling` — `INSTALLED` — Web scraping/crawling.
- `official/research/searxng-search` — `INSTALLED` — Free meta-search via SearXNG.

### security

- `official/security/1password` — `DEFERRED` — 1Password CLI/secrets.
- `official/security/godmode` — `DEFERRED` — Jailbreak testing; install only if explicitly needed.
- `official/security/oss-forensics` — `NOT INSTALLED` — Supply-chain investigation.
- `official/security/sherlock` — `NOT INSTALLED` — Username search across social networks.
- `official/security/web-pentest` — `DEFERRED` — Authorized web app pentesting only with explicit scope.

### software-development

- `official/software-development/code-wiki` — `INSTALLED` — Codebase wiki/docs with Mermaid.
- `official/software-development/rest-graphql-debug` — `INSTALLED` — REST/GraphQL API debugging.
- `official/software-development/subagent-driven-development` — `INSTALLED` — Plan execution via subagents.

### web-development

- `official/web-development/page-agent` — `NOT INSTALLED` — Embed in-page GUI agent in web applications.

## Integration references

- `references/google-workspace-mcp-options.md` — guidance for connecting Gmail, Google Docs, Drive, Sheets, and similar services to Hermes, with n8n MCP as the preferred broad integration path and direct/custom alternatives.

## Google Workspace / MCP guidance

When the user asks about Gmail, Google Docs, Drive, Sheets, Calendar, or similar Google Workspace integrations:

1. Prefer n8n MCP for broad multi-service Google access.
2. Use direct Google MCP only after checking package provenance, OAuth scopes, token storage, and Termux compatibility.
3. Use custom Google API scripts plus a class-level skill for narrow repeatable project workflows.
4. Start with least-privilege scopes: Gmail read/search before send, Drive read-only or folder/file-scoped before full Drive, Docs/Sheets write only when needed.
5. Treat deletion, mass-mailing, payment, and broad write operations as explicit-confirmation actions.
6. If a workflow is successfully proven, create or patch a dedicated Google Workspace integration skill and link the session-specific details under `references/`.

## Maintenance instructions

After installing or uninstalling any official skill, patch this file immediately so status stays current. Also note blocked/rate-limited attempts so future sessions avoid repeating the same discovery work.
