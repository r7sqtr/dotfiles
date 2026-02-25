# Claude Code デザイン機能強化ガイド（Vue.js向け）

## 概要

このガイドでは、Claude Code でデザインから Vue.js コンポーネントを効率的に生成するための設定と使い方を説明します。

---

## セットアップ状況

### ✅ 自動設定済み

| 項目 | 状態 | 備考 |
|------|------|------|
| Playwright MCP | ✅ | スクリーンショット・ブラウザ自動化 |
| vue-design-impl スキル | ✅ | Figma/画像 → Vue コンポーネント |
| image-to-ui スキル | ✅ | スクリーンショット解析特化 |
| Code Connect テンプレート | ✅ | `~/.claude/templates/figma.config.json` |

### ⚠️ 手動設定が必要

以下の項目は手動で設定する必要があります。

---

## 手動設定手順

### 1. Figma デスクトップ Dev Mode の有効化

ローカルの Figma デスクトップアプリと連携するための設定です。

**手順:**
1. Figma デスクトップアプリを開く
2. `Shift + D` キーで Dev Mode に切り替え
3. 右側のインスペクトパネルを開く
4. 「Enable desktop MCP server」をオンにする

**効果:**
- Figma で選択中のフレームを直接コード化可能
- ローカルサーバー（`127.0.0.1:3845`）経由で連携

---

### 2. プロジェクト固有のデザインシステムルール生成

各 Vue.js プロジェクトで、デザインシステムに沿ったルールを生成します。

**実行方法:**
```
/figma:create-design-system-rules
```

**設定すべき項目:**

| 設定項目 | 推奨値 |
|----------|--------|
| コンポーネント配置 | `src/components/` |
| SFC 構造順序 | `<script setup>` → `<template>` → `<style scoped>` |
| CSS 変数（色） | `var(--color-primary)` など |
| CSS 変数（スペース） | `var(--space-xs)` ～ `var(--space-xl)` |

**生成場所:**
- プロジェクトの `.claude/rules/` または `CLAUDE.md` に保存されます

---

### 3. Code Connect の設定（オプション）

Figma コンポーネントと Vue コンポーネントを紐付ける場合に設定します。

**手順:**

1. Code Connect CLI をインストール
   ```bash
   npm install -D @figma/code-connect
   ```

2. テンプレートをプロジェクトルートにコピー
   ```bash
   cp ~/.claude/templates/figma.config.json ./figma.config.json
   ```

3. `figma.config.json` を編集（`include` パスをプロジェクトに合わせる）
   ```json
   {
     "parser": "html",
     "include": ["src/components/**/*.vue"],
     "outDir": ".figma/code-connect"
   }
   ```

4. 初期ファイルを生成
   ```bash
   npx figma connect create
   ```

5. Figma に公開
   ```bash
   npx figma connect publish
   ```

---

## 使い方

### カスタムスキルの使用

#### `/vue-design-impl` - Figma/画像から Vue コンポーネント生成

```
/vue-design-impl
```

その後、以下のいずれかを指定:
- Figma ファイルの URL
- 画像ファイルのパス
- 画像を直接ペースト

**生成されるコードの特徴:**
- Vue 3 Composition API（`<script setup lang="ts">`）
- Tailwind CSS でスタイリング
- TypeScript で型安全
- アクセシビリティ対応

#### `/image-to-ui` - スクリーンショットから UI 実装

```
/image-to-ui
```

スクリーンショットや UI デザイン画像を解析し、Vue コンポーネントを生成します。

**最適な用途:**
- 既存 Web サイトの UI 再現
- モックアップ画像からの実装
- 競合サイトの UI 分析

---

### Figma MCP の使用

#### デザイン実装（`figma:implement-design`）

Figma の URL を指定して、デザインをコードに変換:

```
figma:implement-design [Figma URL]
```

#### Code Connect 設定（`figma:code-connect-components`）

既存の Vue コンポーネントを Figma に接続:

```
figma:code-connect-components
```

---

## 検証方法

### 1. MCP サーバーの接続確認

```
/mcp
```

以下が表示されることを確認:
- `figma` (Figma MCP)
- `playwright-mcp` (Screenshot MCP)

### 2. カスタムスキルの確認

```
/vue-design-impl
```

スキルが認識され、実行されることを確認。

### 3. テスト実装

簡単なテストとして、以下を試す:

1. シンプルな UI 画像を用意
2. `/image-to-ui` を実行
3. 画像を指定
4. 生成されたコードが Vue SFC 形式であることを確認

---

## トラブルシューティング

### MCP サーバーが表示されない

**原因:** Claude Code の再起動が必要

**対処:**
```bash
# Claude Code を終了して再起動
claude
```

### Figma 連携ができない

**原因:** Figma デスクトップの Dev Mode が無効

**対処:**
1. Figma デスクトップアプリで `Shift + D`
2. インスペクトパネル → 「Enable desktop MCP server」をオン

### カスタムスキルが認識されない

**原因:** スキルファイルの配置場所が間違っている

**確認:**
```bash
ls ~/.claude/skills/vue-design-impl/SKILL.md
ls ~/.claude/skills/image-to-ui/SKILL.md
```

両方のファイルが存在することを確認。

---

## ファイル構成

```
~/.claude/
├── skills/
│   ├── vue-design-impl/
│   │   ├── SKILL.md        # スキル定義
│   │   ├── examples.md     # Vue コンポーネント例
│   │   └── reference.md    # デザイントークン定義
│   └── image-to-ui/
│       ├── SKILL.md        # スキル定義
│       └── examples.md     # 解析パターン例
├── templates/
│   └── figma.config.json   # Code Connect テンプレート
└── docs/
    └── vue-design-setup-guide.md  # このファイル
```

---

## 参考リンク

- [Figma Code Connect](https://github.com/figma/code-connect)
- [Figma MCP Server](https://github.com/anthropics/mcp-servers)
- [Playwright MCP](https://github.com/anthropics/mcp-server-playwright)
- [Vue 3 Composition API](https://vuejs.org/guide/extras/composition-api-faq.html)
- [Tailwind CSS](https://tailwindcss.com/docs)

---

## 更新履歴

| 日付 | 内容 |
|------|------|
| 2026-01-23 | 初版作成 |
