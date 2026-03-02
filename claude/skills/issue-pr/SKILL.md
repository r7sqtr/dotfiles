---
name: issue-pr
description: GitHub Issueからブランチ作成、実装、PR作成までを自動化
argument-hint: "<issue番号 or URL>"
disable-model-invocation: true
allowed-tools: Read, Edit, Write, Grep, Glob, Task, Bash(gh:*), Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(git checkout:*), Bash(git switch:*), Bash(git add:*), Bash(git commit:*), Bash(git push:*), Bash(git stash:*), Bash(git show:*), Bash(git rev-parse:*), Bash(git remote:*), Bash(git fetch:*), Bash(npm:*), Bash(pnpm:*), Bash(yarn:*), Bash(composer:*), Bash(cargo:*), Bash(make:*), Bash(ls:*)
---

# GitHub Issue → PR 自動化

Issue **$ARGUMENTS** の内容に基づき、ブランチ作成から実装・PR作成までを一気通貫で実行する。

## 動的コンテキスト

```
リポジトリ: !`git remote get-url origin`
現在のブランチ: !`git branch --show-current`
デフォルトブランチ: !`gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'`
作業ツリー状態: !`git status --short`
最近のコミット: !`git log --oneline -5`
```

---

## Phase 0: 事前チェック

以下を順番に実行し、すべてパスしなければ中断する。

### 0-1. 引数の検証
- `$ARGUMENTS` が空なら「Issue番号またはURLを指定してください」と伝えて終了。
- URLの場合（`https://github.com/.../issues/123` 形式）は番号部分を抽出する。
- 抽出した番号を以降 `ISSUE_NUM` として扱う。

### 0-2. 作業ツリーの確認
- `git status --short` で未コミット変更を確認する。
- 変更がある場合、ユーザーに「未コミットの変更があります。stashしますか？中断しますか？」と確認する。
  - stashを選択 → `git stash push -m "issue-pr: stash before #ISSUE_NUM"`
  - 中断を選択 → 処理を終了する。

### 0-3. Issueの取得
- `gh issue view ISSUE_NUM --json number,title,body,state,labels,assignees` で取得する。
- Issueが存在しない場合 → エラーを報告して終了。
- state が `CLOSED` の場合 → 「このIssueはクローズ済みです。続行しますか？」と確認する。

### 0-4. 重複チェック
- `gh pr list --search "issue:ISSUE_NUM" --json number,title,headRefName,state` で既存PRを検索する。
- OPENなPRが存在する場合 → 既存PRのURLを報告し、「既にPRがあります。続行しますか？」と確認する。

---

## Phase 1: プランニング

### 1-1. Issue解析
Issue の title, body, labels から以下を判定する:
- **種別**: labels や title のキーワードから `feat` / `fix` / `docs` / `refactor` / `test` / `chore` を判定。不明なら `feat` をデフォルトとする。
- **要件**: body から具体的な要件・受け入れ条件を抽出する。
- **影響範囲**: 言及されたファイル、コンポーネント、モジュール名を特定する。

### 1-2. ブランチ名の決定
以下の命名規則でブランチ名を生成する:
```
{種別}/issue-{ISSUE_NUM}-{短い説明（kebab-case、英語、30文字以内）}
```
例: `feat/issue-42-add-user-profile`, `fix/issue-123-null-pointer-error`

### 1-3. コードベース調査
Task ツール（subagent_type=Explore）を使い、以下を調査する:
- Issue で言及されたファイル・コンポーネントの場所と内容
- 関連する既存パターン（類似機能の実装方法）
- 再利用可能なユーティリティやヘルパー
- テストの構成とパターン

### 1-4. 実装計画の策定
以下を含む計画を立てる:
- 変更対象ファイル一覧（新規/修正/削除）
- 各ファイルへの具体的な変更内容
- 実装アプローチ（使用するパターン、ライブラリ等）
- テスト方針（どのテストを追加・修正するか）
- 懸念事項・リスク（破壊的変更、パフォーマンス影響等）

---

## Phase 2: プランレビュー（承認ゲート）

**重要: ユーザーの明示的な承認なしに Phase 3 に進んではならない。**

以下を整理してユーザーに提示する:

```markdown
## 実装計画: Issue #ISSUE_NUM

### Issue要約
- タイトル: {title}
- 種別: {種別}
- 要件: {要件の箇条書き}

### ブランチ
`{ブランチ名}`

### 変更計画
| ファイル | 操作 | 変更内容 |
|---------|------|---------|
| path/to/file | 修正 | 説明 |

### アプローチ
{実装方針の説明}

### テスト方針
{追加・修正するテスト}

### 懸念事項
{リスクや注意点があれば}

---
この計画で実装を開始してよろしいですか？修正点があればお知らせください。
```

- ユーザーが承認 → Phase 3 に進む
- ユーザーがフィードバック → 計画を修正して再提示する
- ユーザーが中断 → 処理を終了する

---

## Phase 3: 実装

### 3-1. ブランチ作成
```
git fetch origin
git checkout -b {ブランチ名} origin/{デフォルトブランチ}
```

### 3-2. コード実装
- プロジェクトの既存パターン・コーディング規約に従って実装する。
- Phase 1 の計画に沿って、各ファイルを順番に変更する。
- 新規ファイルは必要最小限に留め、既存ファイルの編集を優先する。

### 3-3. 静的チェック
以下が利用可能であれば実行し、エラーを修正する:
- lint（eslint, phpstan, clippy 等）
- フォーマッター（prettier, php-cs-fixer, rustfmt 等）
- 型チェック（tsc, mypy 等）

実行コマンドはプロジェクトの `package.json`, `Makefile`, `composer.json`, `Cargo.toml` 等から判断する。

### 3-4. テスト
- 変更に対応するテストを追加または修正する。
- テストスイートを実行する。
- 失敗がある場合は原因を特定して修正する（最大3回リトライ）。
- 3回修正しても解決しない場合は、状況をユーザーに報告して判断を仰ぐ。

---

## Phase 4: コミット・PR作成

### 4-1. 変更の確認
- `git diff --stat` と `git diff` で変更内容を確認する。
- `.env`, `credentials`, API キー等の機密情報が含まれていないことを確認する。
- 意図しないファイルの変更がないことを確認する。

### 4-2. コミット
- 変更ファイルを個別に `git add` する（`git add .` や `git add -A` は使わない）。
- コンベンショナルコミット形式でコミットメッセージを英語で作成する。
- コミットメッセージには Issue 参照を含める。

```
git commit -m "$(cat <<'EOF'
{種別}: {変更の要約}

{詳細な説明（必要な場合）}

Refs #ISSUE_NUM

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

### 4-3. プッシュ
```
git push -u origin {ブランチ名}
```

### 4-4. PR作成
`gh pr create` で PR を作成する。本文は以下のテンプレートに従う:

```
gh pr create --title "{種別}: {簡潔なタイトル（70文字以内）}" --body "$(cat <<'EOF'
## Summary
- {変更点の箇条書き}

## Related Issue
Closes #ISSUE_NUM

## Changes
| ファイル | 変更内容 |
|---------|---------|
| path/to/file | 説明 |

## Test Plan
- [ ] {テスト項目}

---
🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

### 4-5. 完了報告
以下をユーザーに報告する:
- PR の URL
- 変更サマリー（ファイル数、追加行数、削除行数）
- 次のステップ（レビュー待ち、追加作業が必要な場合等）

---

## 制約事項（厳守）

- **破壊的Gitコマンド禁止**: `git reset --hard`, `git clean -f`, `git push --force`, `git checkout .`, `git restore .` は絶対に実行しない。
- **承認ゲート必須**: Phase 2 のユーザー承認をスキップしない。
- **機密情報の保護**: `.env`, 認証情報、APIキー等をコミットしない。
- **最小限の変更**: Issue の要件に直接関係しない変更は行わない。
- **既存パターンの尊重**: プロジェクトのコーディング規約・パターンに従う。
