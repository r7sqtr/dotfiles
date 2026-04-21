---
name: dep-audit
description: 依存関係のセキュリティ脆弱性・サプライチェーンリスク・設定漏洩を一括検出
argument-hint: "<対象ディレクトリ or 省略でカレントディレクトリ>"
allowed-tools: Bash, Grep, Read, Glob, Agent
---

# 依存関係セキュリティ監査

プロジェクトの依存関係とビルド設定を網羅的にスキャンし、セキュリティリスクをレポートする読み取り専用の分析 Skill。

## 動的コンテキスト

引数が指定された場合はそのディレクトリを対象とする。未指定の場合はカレントディレクトリを対象とする。

---

## 処理フロー

### Phase 1: プロジェクト検出

対象ディレクトリ内のパッケージマネージャとビルドツールを特定する:

- `package.json` / `package-lock.json` / `yarn.lock` / `pnpm-lock.yaml` → npm/yarn/pnpm
- `composer.json` / `composer.lock` → Composer (PHP)
- `Gemfile` / `Gemfile.lock` → Bundler (Ruby)
- `requirements.txt` / `Pipfile` / `pyproject.toml` → pip/pipenv/poetry (Python)
- `go.mod` → Go modules
- `Cargo.toml` → Cargo (Rust)

### Phase 2: 脆弱性スキャン

検出されたパッケージマネージャに応じて監査コマンドを実行:

| マネージャ | コマンド |
|-----------|---------|
| npm | `npm audit --json 2>/dev/null \| jq '.vulnerabilities \| length'` |
| yarn | `yarn audit --json 2>/dev/null` |
| composer | `composer audit 2>/dev/null` |
| pip | `pip audit 2>/dev/null` (インストール済みの場合) |

- 各脆弱性について: パッケージ名、影響バージョン、CVE ID、重大度を記録
- lock ファイルが存在しない場合は **Critical** として報告

### Phase 3: サプライチェーンリスク検出

1. **CDN `@latest` / バージョン未固定参照**
   - HTML/テンプレートファイル内の CDN URL を Grep で検索
   - バージョン指定なし（`@latest`、バージョンパス無し）を検出
   - SRI (Subresource Integrity) ハッシュの有無を確認
   - 検索パターン: `cdn\.`, `unpkg\.com`, `cdnjs\.`, `jsdelivr\.net`

2. **バージョン範囲の危険な指定**
   - `package.json` 等で `*`, `>=`, `>` の使用を検出
   - メジャーバージョン範囲指定 (`^` でメジャー0の場合の破壊的変更リスク)

3. **postinstall スクリプトの確認**
   - `package.json` の `scripts.postinstall`, `scripts.preinstall` を検出
   - 依存パッケージ内の install スクリプトの存在確認

### Phase 4: ビルド設定・公開設定の確認

1. **ソースマップ**
   - webpack/vite/nuxt 等のビルド設定を確認
   - 本番ビルドでソースマップが有効になっていないか検出
   - 検索: `devtool:`, `sourcemap:`, `productionSourceMap`, `sourceMap`

2. **デバッグモード**
   - 本番環境でデバッグモードが有効な設定を検出
   - `APP_DEBUG=true`, `DEBUG=`, `NODE_ENV=development` 等

3. **機密情報の露出**
   - `.env` ファイルが `.gitignore` に含まれているか確認
   - Git追跡されている `.env` ファイルを検出: `git ls-files | grep -i '\.env'`
   - ハードコードされた API キー / シークレットのパターン検索
   - 検索パターン: `API_KEY\s*=\s*['"][^'"]+`, `SECRET\s*=\s*['"]`, `password\s*=\s*['"]`
   - `.env.example` にシークレット値が残っていないか確認

4. **公開ディレクトリの確認**
   - `public/` や `static/` 配下に不要なファイル（`.env`, バックアップ, ログ等）がないか

### Phase 5: レポート生成

以下の形式で結果を提示する:

```markdown
## 依存関係セキュリティ監査レポート

### 対象: {対象ディレクトリ}
### 検出日: {日付}
### スキャン対象: {検出されたパッケージマネージャ一覧}

---

### 🔴 Critical

| # | カテゴリ | 対象 | リスク | 対応策 |
|---|---------|------|--------|--------|

### 🟡 Warning

| # | カテゴリ | 対象 | リスク | 対応策 |
|---|---------|------|--------|--------|

### 🔵 Info

| # | カテゴリ | 対象 | リスク | 対応策 |
|---|---------|------|--------|--------|

### 統計サマリー

| 項目 | 結果 |
|------|------|
| 脆弱性（Critical/High/Medium/Low） | x/x/x/x |
| CDN未固定参照 | x 件 |
| ソースマップ公開 | 有/無 |
| .env Git追跡 | 有/無 |
| lock ファイル | 有/無 |
```

---

## 制約事項

- **読み取り専用**: コードの変更、パッケージのインストール・更新は一切行わない
- **監査コマンドのみ**: `npm audit`, `composer audit` 等の読み取り専用コマンドのみ実行可
- **機密情報の非表示**: 検出した API キーやシークレットの値そのものは出力に含めない。存在箇所（ファイル名:行番号）のみ報告
- **誤検知の明示**: パターンマッチによる検出は誤検知の可能性があることを明記する
