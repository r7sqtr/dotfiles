---
name: workflow-analyzer
description: セッションログからワークフローパターンを分析し、自動化Skillを生成
argument-hint: "[セッション数(デフォルト: 20)]"
allowed-tools: Read, Grep, Glob, Bash(~/.config/claude/skills/workflow-analyzer/scripts/*), Bash(jq:*), Bash(wc:*), Bash(find:*), Bash(ls:*), Bash(xargs:*), Write, Edit, AskUserQuestion
---

# ワークフロー分析 → Skill 自動生成

セッションログを分析し、繰り返しているワークフローパターンを検出して、自動化 Skill を生成する。

## 動的コンテキスト

```
セッションログディレクトリ: !`ls -d ~/.claude/projects/*/`
ログファイル数: !`find ~/.claude/projects/ -maxdepth 2 -name "*.jsonl" | wc -l`
既存 Skill 一覧: !`find ~/.config/claude/skills/ -name "SKILL.md" -exec dirname {} \; | xargs -I{} basename {}`
```

---

## Phase 1: データ抽出

ヘルパースクリプトを実行してセッションログからパターンを抽出する。

```bash
~/.config/claude/skills/workflow-analyzer/scripts/extract-patterns.sh $ARGUMENTS
```

`$ARGUMENTS` が空の場合はデフォルトの 20 セッションを分析する。

---

## Phase 2: パターン分析

抽出結果を以下の観点で分析する。

### 2-1. 繰り返しワークフローの特定

以下の基準で自動化候補を特定する:
- **ツールシーケンスの繰り返し**: 同じ順序のツール呼び出しが3回以上出現
- **共通の開始パターン**: セッション開始時に毎回行う操作
- **プロジェクト横断パターン**: 複数プロジェクトで共通して使うワークフロー

### 2-2. 自動化可能性の評価

各パターンについて:
- **自動化の効果**: 手動で何ステップ省略できるか
- **汎用性**: 特定プロジェクト固有 vs 汎用的
- **リスク**: 自動化による事故の可能性（破壊的操作の有無）

---

## Phase 3: Skill テンプレート生成

検出したパターンごとに SKILL.md のテンプレートを生成する。

### テンプレート構造

```markdown
---
name: {skill-name}
description: {1行の説明}
argument-hint: "{引数のヒント}"
allowed-tools: {必要なツール一覧}
---

# {Skill名}

{目的と概要}

## 処理フロー

{ステップバイステップの指示}

## 制約事項

{安全性に関する制約}
```

### 生成ルール

- Skill 名は既存 Skill と重複しないこと
- `allowed-tools` は必要最小限に絞る
- 破壊的操作（git push, ファイル削除等）は必ず確認ゲートを設ける
- 既存の Skill（review, issue-pr 等）と機能が重複しないこと

---

## Phase 4: ユーザーへの提示と承認

### 4-1. 分析サマリーの提示

以下を整理して提示する:

```markdown
## ワークフロー分析結果

### 検出パターン数: N 個

| # | パターン名 | 出現回数 | ツール数 | 自動化効果 |
|---|-----------|---------|---------|-----------|
| 1 | {名前}    | {回数}  | {数}    | {高/中/低} |

### 推奨 Skill 候補

{各パターンの詳細説明とSkill化の提案}
```

### 4-2. 承認フロー

ユーザーに以下を確認する:
1. どのパターンを Skill 化するか
2. Skill 名や動作の調整が必要か
3. ファイル作成の承認

**重要: ユーザーの承認なしにファイルを作成しない。**

---

## Phase 5: Skill ファイル作成

承認されたパターンについて:
1. `~/.config/claude/skills/{skill-name}/SKILL.md` を作成
2. 必要に応じてヘルパースクリプトも作成
3. 作成したファイルのパスを報告

---

## 制約事項（厳守）

- **読み取り専用フェーズ**: Phase 1〜4 ではファイルの作成・編集を行わない
- **承認ゲート必須**: Phase 4 のユーザー承認をスキップしない
- **既存ファイルの保護**: 既存の Skill ファイルを上書きしない（新規作成のみ）
- **機密情報の除外**: セッションログ内の機密情報（APIキー、パスワード等）を出力に含めない
