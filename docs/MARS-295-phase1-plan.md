# MARS-295 · Draft App Phase 1 Skeleton

## Problem
Draft App 需要一個 desktop-first PRD cockpit，能寫、能畫、能問 CoCo、能落 terminal。MARSN-Hub (Paperclip fork) 已 retire (MARS-294)。Terax AI 係最佳起點：Tauri 2 + React 19 + CodeMirror 6 + Vim + AI SDK v6 + xterm.js + MCP stdio 全部現成。

## Progress
- [x] Step 1: Fork + Repo Setup — done (Warp CoCo)
- [x] Step 2: Branding Swap — done (91 files, Warp CoCo)
- [x] Step 3: Design System Draft Tokens — done (Warp CoCo)
- [ ] Step 4: Cockpit Launcher
- [ ] Step 5: Write Tab — PRD Editor
- [ ] Step 6: Draw Tab — Excalidraw
- [ ] Step 7: Terminal Integration
- [ ] Step 8: Ask CoCo — Reuse AI Pipeline
- [ ] Step 9: Draft List (Sidebar)

## Key Architecture Decisions
- Fork entire Terax AI, NOT copy components — Terax IS the shell
- Keep ALL Terax modules (git-history, preview, markdown, terminal, AI chat)
- Only removed: Terax branding/onboarding
- Draw tab: use `@excalidraw/excalidraw`, NOT rough.js — `customData` for PRD linking
- CoCo chat: reuse Terax AiChat pipeline directly (fork, not copy)
- CoCo Rail = ambient AI panel (card format), NOT chatbox
- Terminal = core feature, `Cmd+\`` summon + Cockpit tile

## Step 4: Cockpit Launcher
新增 Cockpit 作為 app 嘅 landing view（對應 prototype `index.html`）：
- 2x2 tile grid: Write (⌘1) / Draw (⌘2) / Ask CoCo (⌘3) / Terminal (⌘4)
- 頂部 wordmark `DRAFT·COCKPIT`
- 底部 status bar (pulse dot + ready + machine name + time)
- Tile hover: translateY(-3px) + CoCo blue glow line
- CoCo tile 有獨立 blue tint
- 作為 workspace module 嘅新 route/view

## Step 5: Write Tab — PRD Editor
改造 Terax 嘅 editor module，加入 Draft-specific UI（對應 prototype `write.html`）：

**保留：**
- CodeMirror 6 editor core + Vim keymap
- File save/load logic
- Syntax highlighting

**新增 UI 層：**
- **Stage Pipeline** (頂部 breadcrumb): `Seed → Draft → Ready → Spawn → Shipped`，active/done/pending 三態
- **PRD Score Bar** (Stage bar 右側): track + fill + score number + tier badge (灰/橙/藍/綠) + Spawn button (Phase 1 disabled)
- **CoCo Rail** (右側 360px panel, `⌘\` toggle):
  - Header: CoCo avatar + `IN-CONTEXT` tag + HIDE button
  - JUDGMENT section: verdict badge (BLOCK/WARN/PASS) + reason + quote (Phase 1 = mock data)
  - RELATED MEMORY section: 3 memory cards with id + timestamp + text + memory:// link (Phase 1 = mock)
  - LAST COMMENT section: timestamp + comment text (Phase 1 = mock)
- **Quick Ask popup** (`⌘;`): 4 preset actions + free-form `coco>` input — 接 Terax 已有嘅 AI chat pipeline
- **Block editor** enhancements: gutter type labels, block-handle, selected/current states
- **Status bar**: vim mode + block position + nav hints

## Step 6: Draw Tab — Excalidraw
- `pnpm add @excalidraw/excalidraw`
- Light canvas background (`#fafaf8`) + dark toolbar
- Excalidraw element `customData` field 預留 `linked_prd_id` for Phase 2
- Canvas data persist to draft local storage
- Export PNG/SVG

## Step 7: Terminal Integration
- Terminal 預設隱藏
- `Cmd+\`` toggle terminal overlay (slide up from bottom)
- Cockpit ⌘4 tile 直接開 terminal tab
- 保留所有 Terax Terminal 功能（PTY, shell input, AI mode toggle）
- MCP stdio 直接跑 coco-memory

## Step 8: Ask CoCo — Reuse AI Pipeline
- `AiChat` + `AiComposerInput` → CoCo chatbox
- `Conversation` + `Message` + `MessageResponse` → streaming display
- 改 system prompt 為 CoCo persona
- Cockpit ⌘3 tile 開 CoCo chat view
- Write tab Quick Ask (`⌘;`) response 顯示喺 CoCo Rail

## Step 9: Draft List (Sidebar)
- Draft list 取代 file tree 作為 sidebar 主 view
- 每個 draft 顯示: title + stage badge + PRD score
- 新建 / 刪除 / 切換 draft
- Draft data 存 local SQLite via Tauri plugin-store

## Phase 1 唔做
- PRD Score 真實計算 (Phase 2)
- Spawn to Linear button 功能 (Phase 2)
- CoCo Rail 真實數據 (Phase 2)
- Draw ↔ PRD linking (Phase 2-3)
- Windows / Linux build
- Mobile

## Design System Tokens (已設定)
- Background: `#0d0d0d`
- Surface: `#1a1a1a` / `#161616`
- Border: `#2a2a2a`, strong `#3a3a3a`
- CoCo blue: `#4a9eff`
- Warning: `#ff6b35`
- Success: `#22c55e`
- Fonts: JetBrains Mono (code) + Inter (UI)
- Constraints: 無 gradient、無 >8px rounded、無 chat bubble

## Validation
- 打開 App：2 秒內進入 Cockpit
- Write tab 見到 PRD Stage，CoCo 喺右側
- `Cmd+\`` 喚起 Terminal
- 每個 tile/row 有 shortcut hint
- Vim keymap 預設 on
- `pnpm tauri dev` 成功 build + run
- `pnpm check-types` + `pnpm lint` 通過

## Reference
- Prototypes: `~/Documents/MarsVault-git/Projects/Draft-app/` (index.html, write.html, draw.html)
- UX Brief: `~/Documents/MarsVault-git/Projects/Draft-app/draft-concept.md`
- Phase 2 PRD: `~/Documents/MarsVault-git/Projects/Draft-app/DRAFT-APP-001-phase2-prd.md`
- Linear: https://linear.app/marsgroup/issue/MARS-295
