# Vue デザイン機能 クイックチェックリスト

## 初回セットアップ（1回のみ）

- [ ] Claude Code を再起動して MCP サーバーを有効化
- [ ] `/mcp` で `playwright-mcp` が表示されることを確認
- [ ] Figma デスクトップで Dev Mode を有効化（`Shift + D`）
- [ ] Figma インスペクトパネル → 「Enable desktop MCP server」をオン

## プロジェクトごとのセットアップ

- [ ] プロジェクトディレクトリで `/figma:create-design-system-rules` を実行
- [ ] （オプション）Code Connect を使う場合:
  - [ ] `npm install -D @figma/code-connect`
  - [ ] `cp ~/.claude/templates/figma.config.json ./`
  - [ ] `figma.config.json` の `include` パスを調整

## 日常の使い方

### Figma から実装
```
figma:implement-design [Figma URL]
```

### 画像から実装
```
/vue-design-impl
→ 画像パスを指定またはペースト
```

### スクリーンショットから実装
```
/image-to-ui
→ スクリーンショットを指定またはペースト
```

## 困ったときは

| 問題 | 対処 |
|------|------|
| MCP が動かない | Claude Code を再起動 |
| スキルが認識されない | `~/.claude/skills/` 内のファイルを確認 |
| Figma 連携不可 | Figma Dev Mode + MCP server を有効化 |

## 詳細ドキュメント

```
~/.claude/docs/vue-design-setup-guide.md
```
