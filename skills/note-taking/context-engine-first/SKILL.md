---
name: context-engine-first
description: Use when a user wants answers grounded in a local context engine before external lookup. Never rely only on the LLM's training data; check the OIL/context engine first for grounded data, evaluate freshness and sufficiency, iterate retrieval before external lookup, and write durable learnings back.
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [context-engine, oil, obsidian, grounding, retrieval, user, context-engine]
    related_skills: [obsidian]
---

# Context Engine First

## Overview

This skill defines the user's default grounding protocol. The Obsidian/OIL context engine is the first point of search for any data used to ground a response to the user.

The goal is not to ban external information. The goal is to make the context engine the canonical working memory and decision surface:

1. Search OIL/context engine first.
2. Evaluate whether retrieved context is relevant, current, sufficient, and safe to use.
3. If information is missing or stale, do additional context-engine retrieval passes with refined queries.
4. Only look outward when the context engine cannot answer or is stale.
5. When external privileged source systems are refreshed, synthesize durable findings back into the context engine.

## When to Use

Use this skill when the user has a local context engine that should ground answers before external lookup.

Default assumption for context-engine-backed sessions: first check whether the context engine contains grounded data that should shape the response. Do not answer purely from the LLM's training data unless the request is so trivial and self-contained that no grounding would materially improve it.

Always use this skill whenever:

- Answering the user using any factual, personal, project, research, workflow, decision, meeting, task, or preference context.
- Working in the user's Obsidian/OIL personal intelligence layer.
- Deciding whether to use <workspace-provider>, <sync-provider>, web, local files, or other external tools for grounding.
- Updating the user's mental model, assistant instructions, projects, decisions, workflows, evidence logs, or source maps.
- A request might depend on prior context, current projects, personal facts, historical decisions, preferences, durable notes, or current external facts.

Very narrow exception: if the user explicitly asks for a transformation of content entirely contained in the current message, such as “make this sentence shorter,” and no outside context could materially help, a context-engine search may be skipped.

When uncertain, use it.

## Core Principle

> Context engine first. OIL as the primary interface. Never rely only on the LLM's training data when grounding could improve the answer. External sources only to fill missing or stale context. Durable learnings back to the context engine.

The context engine is not just a note archive. It is the source of truth for grounded assistance to the user.

## Tool Priority

### 1. OIL MCP first

OIL is the preferred interface for the context engine. OIL is a third-party MCP server; credit/upstream: https://github.com/JinLee794/Obsidian-Intelligence-Layer.

Use OIL for:

- vault search
- semantic search
- metadata reads
- section reads
- note creation
- atomic append/replace
- related-entity exploration

OIL use does **not** require the user's permission.

If OIL tools are unavailable in the current runtime, use filesystem Obsidian workflows as a fallback, following the `obsidian` skill:

- `search_files` for discovery
- `read_file` for notes
- `write_file` for new notes
- `patch` for targeted updates

### 2. Context engine before privileged sources

<workspace-provider> and <sync-provider> are privileged source systems. They are **not** normal grounding sources.

They exist to refresh or sync durable data into the context engine when internal context is missing, stale, or insufficient.

Do not casually ground an answer directly in <mail-provider>, <drive-provider>, Google Docs, Calendar, Sheets, local <sync-provider> files, or Microsoft APIs just because access exists.

Use them only when:

- the context engine is missing necessary information after repeated retrieval passes,
- the context engine appears stale,
- the user explicitly asks to refresh/sync from one of those systems,
- or a defined workflow says a sync is due.

Reasons:

- keep the system simple,
- avoid overusing <workspace/sync-provider> APIs,
- avoid accidental side effects,
- avoid unexpected complications like file writes, email sending, sharing, deletions, or API rate/permission issues.

### 3. External public sources

Use web/search/external sources when:

- the question is about current external reality,
- the context engine says its information is stale,
- the context engine lacks needed facts,
- or the answer requires source-backed current data.

After using external sources, update the context engine if the information is durable.

## Retrieval Loop

Follow this loop for grounded answers:

### Step 1 — Interpret the request

Identify what kind of context may be needed:

- person/preference context
- project context
- decision history
- tasks/open loops
- meeting notes
- research/source maps
- workflows/procedures
- agent instructions
- current-state facts
- external/current facts

### Step 2 — First OIL/context-engine pass

Search the context engine using the obvious terms from the request.

Typical targets:

- `People/the user/`
- `_system/Agent Instructions`
- `_system/Index`
- `Projects/`
- `Decisions/`
- `Tasks/`
- `Meetings/`
- `Research/`
- `Sources/`
- `Workflows/`
- `Agent Logs/`

### Step 3 — Evaluate context quality

For each retrieved item, evaluate:

| Dimension | Question |
|---|---|
| Relevance | Does this directly help answer the current request? |
| Freshness | Is it current enough for the request? |
| Specificity | Is it concrete enough, or too general? |
| Confidence | Is it source-backed, inferred, draft, or low-confidence? |
| Coverage | What is still missing? |
| Sensitivity | Should this be surfaced, summarized, or only used privately? |
| Actionability | Can this ground a response or next action? |

### Step 4 — Repeat retrieval before looking outward

If anything is missing, do not immediately use external tools.

Run additional context-engine passes with refined strategies:

- synonyms and alternate names
- related project names
- people or organization names
- linked notes and backlinks
- source maps
- decision records
- agent logs
- archived notes
- broader folder-level README/index pages
- date ranges or known event names

Repeat until one of these is true:

- the context engine is sufficient,
- the context engine clearly lacks the information,
- the context engine is stale and needs refresh,
- or the cost of more internal searching exceeds likely value.

### Step 5 — Decide whether external refresh is needed

Only after internal passes, decide whether to look outward.

Ask:

- Is the missing information likely in a privileged source system?
- Is this a one-time fact or durable context that should be synced back?
- Is this request urgent enough to justify external lookup now?
- Does the tool/action have side effects?
- Has the user explicitly asked for this source to be used?

### Step 6 — Use external tools carefully, if needed

For privileged sources:

- Prefer read-only retrieval.
- Avoid broad scans unless the workflow requires them.
- Never send, edit, delete, move, share, or modify without explicit confirmation.
- Treat <workspace-provider> and <sync-provider> as sync inputs, not primary grounding layers.

### Step 7 — Answer from synthesized context

Answer using the best available context.

If useful, state briefly:

- what the context engine contained,
- what was missing or stale,
- whether external refresh was used,
- and what confidence level applies.

Do not overburden simple answers with provenance, but be explicit for high-stakes, personal, or strategic topics.

### Step 8 — Write durable updates back

If the task generated durable context, update the context engine.

Examples:

| Durable finding | Write target |
|---|---|
| the user preference | `People/the user/the user - Communication Preferences.md` or memory if globally useful |
| Mental-model update | `People/the user/the user - Mental Model.md` and `the user - Evidence Log.md` |
| Project state | relevant `Projects/` note |
| Decision | `Decisions/` record |
| Recurring process | `Workflows/` note or Hermes skill |
| Source-backed research | `Research/` and `Sources/` notes |
| Agent behavior rule | `People/the user/the user - Assistant Instructions.md` or `_system/Agent Instructions.md` |

## Staleness Rules

Treat context as potentially stale when:

- `updated` is old relative to the question,
- `status` is `draft`, `needs-review`, `archived`, or `low-confidence`,
- the note is about time-sensitive facts,
- newer notes or user statements contradict it,
- the note itself says it requires refresh,
- it came from a one-time import or sample,
- external reality may have changed.

When stale:

1. Search for newer internal context first.
2. Check agent logs, project notes, decisions, and source maps.
3. If still stale, trigger or propose a sync/refresh from the appropriate source.
4. Update the stale note or add an addendum after refresh.

## Permission and Safety Rules

### OIL/context engine

- Read/search/write with OIL without asking.
- Creating new context-engine notes does not require permission.
- Additive synthesis does not require permission.
- Notes about the user are not protected by default.
- A note requires permission to change/delete only if it has YAML frontmatter:

```yaml
protected: true
```

### Privileged source systems

<workspace-provider> and <sync-provider> are privileged sync sources, not normal grounding sources.

Ask before:

- triggering broad syncs,
- reading a sensitive source class not already in the workflow,
- using a new connector,
- sending email,
- replying to email,
- creating/changing/deleting calendar events,
- sharing/moving/deleting Drive/<sync-provider> files,
- editing Docs/Sheets,
- making any external side effect.

### Public/external tools

Use public web/search tools when needed for current external facts. For sensitive or personal tasks, prefer summarizing external findings into the context engine rather than scattering raw data.

## Answer Provenance Patterns

For normal answers, be concise:

> I checked the context engine. The relevant current note says X, so I recommend Y.

For stale/missing context:

> The context engine has X, but it looks stale/missing Y. I searched the context engine again and did not find a newer note. The next step is to refresh from Z.

For external refresh:

> I used external source Z only after the context engine did not contain current enough data. I updated/will update the context engine with the durable result.

## Automated Evaluation Testing

For automated evaluation testing of this skill, see:

- Optional test suite: `Evaluations/Context Engine First/Context Engine First Evaluation Test Suite.md`
- Optional automation prompt: `Workflows/Context Engine First Skill Test Battery Prompt.md`
- Skill reference: `references/automated-evaluation.md`

This is an automated **evaluation** test, not an automated regression test. The run highlights skill/context-engine improvements; its artifacts and scores can later be compared across versions to identify regressions or progress.

If automated evaluation is configured, choose an explicit schedule and run once immediately after setup. Runs should create Markdown evaluation reports, versioned skill snapshots, and expected-evidence scorecards in the vault under `Evaluations/Context Engine First/` so retrieval quality can be compared over time.

### Automated evaluation run pattern

When running the evaluation battery from a cron/session prompt:

0. If the run is scheduled with restricted `enabled_toolsets`, include the MCP server alias `oil` as a toolset alongside any built-in toolsets (for example: `skills`, `file`, `terminal`, `oil`). MCP capabilities are registered as tools named `mcp_oil_*`, but the server itself is exposed for filtering as the `oil` toolset/alias. If `oil` is omitted from a restricted toolset list, OIL can be configured and healthy while still being absent from the runtime tool namespace. For the fuller diagnostic and UI-advertising pattern, see `references/mcp-tool-advertising.md`.
1. Confirm OIL availability with `mcp_oil_get_health`; use OIL primitives for retrieval/writes when available, and record whether OIL or filesystem fallback was used.
2. Read the automation prompt and canonical test suite from the vault before testing.
3. Define one `run_id` early and reuse it exactly for the report path, skill snapshot path, report frontmatter, and Run History row.
4. For each test, capture first-node search, second-node support, and third-node traversal using OIL search, metadata, section reads, and `get_related_entities`.
5. If `read_note_section` on a parent heading returns empty content, do not treat that as missing evidence immediately; inspect metadata headings and retrieve child sections or related entities.
6. Do not use privileged source systems or local <sync-provider> files during the battery; only state whether a narrow sync/refresh would be justified.
7. Create the versioned skill snapshot and evaluation report as Markdown artifacts, then update the test suite Run History with an mtime-safe append/replace.
8. Verify the created artifact metadata and Run History row before reporting back.

## Common Pitfalls

1. **Going straight to Google/<sync-provider> because access exists.** These are privileged sync sources, not default grounding layers.

2. **One-pass context search.** If the first search misses, try alternate queries and related notes before going outward.

3. **Treating stale context as truth.** Evaluate freshness and confidence before answering.

4. **Dumping raw external data into the vault.** Prefer concise synthesis, source links, and evidence logs.

5. **Over-provenancing simple answers.** Mention grounding when useful, but do not make every response bureaucratic.

6. **Freezing the user's mental model.** the user may prefer the model should grow and change through continuous evaluation.

7. **Using file tools as the first choice when OIL is available.** OIL is the primary interface; filesystem tools are fallback.

## Verification Checklist

Before finalizing a grounded answer for the user:

- [ ] Did I search the context engine/OIL first?
- [ ] Did I evaluate relevance, freshness, confidence, and gaps?
- [ ] If information was missing, did I do another context-engine pass before external lookup?
- [ ] Did I avoid using <workspace-provider>/<sync-provider> as primary grounding sources?
- [ ] If external data was needed, was it justified by missing/stale context?
- [ ] Did I avoid side effects without explicit confirmation?
- [ ] If the result is durable, did I update or propose updating the context engine?
- [ ] Did I keep provenance proportionate to the stakes of the answer?
