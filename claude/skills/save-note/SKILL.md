---
name: save-note
description: 現在の検討内容・設計プランを Notion 設計ノートDBに保存
argument-hint: "[タイトル] [--project X] [--category Y] [--tags Z]"
allowed-tools: Read, Grep, Glob, mcp__claude_ai_Notion__notion-create-pages, mcp__claude_ai_Notion__notion-search, mcp__claude_ai_Notion__notion-fetch
---

# 設計ノート保存

会話中の検討内容・設計プラン・技術調査結果を Notion の「設計ノート」データベースに保存する。

## 設計ノートDB情報

- Data Source ID: `10b17547-b9f6-450b-b3fb-656acd9e0c66`
- DB URL: `https://www.notion.so/b7e5684a2d494ef5b708dc6ab4f6bdbe`

### スキーマ

| プロパティ | 型 | 値 |
|---|---|---|
| タイトル | TITLE | 必須 |
| プロジェクト | SELECT | claude-config / smartP / yukiyama / wb-next / その他 |
| カテゴリ | SELECT | 設計プラン / ADR / 技術調査 / バグ調査 / 検討メモ |
| ステータス | STATUS | 未着手 / 進行中 / 完了 |
| 日付 | DATE | ISO-8601 形式 |
| タグ | MULTI_SELECT | アーキテクチャ / パフォーマンス / セキュリティ / UI/UX / インフラ / DB |
| ID | UNIQUE_ID | 自動採番 (DN-X) |

---

## Phase 0: 引数の解析

`$ARGUMENTS` を以下のルールで解析する:

| 引数パターン | 動作 |
|---|---|
| `Notion MCP 認証設定 --project claude-config --category 技術調査` | タイトル・プロジェクト・カテゴリを指定 |
| `Notion MCP 認証設定` | タイトルのみ指定、他は会話内容から推定 |
| `--tags セキュリティ,インフラ` | タグを指定 |
| (空) | 会話内容からすべて自動推定 |

---

## Phase 1: コンテンツの収集

会話のコンテキストから以下を抽出する:

1. **タイトル**: 引数で指定されていればそれを使用。なければ検討テーマから生成
2. **本文**: 会話中の検討内容・結論・判断理由をまとめる
3. **メタデータ**: プロジェクト・カテゴリ・タグを会話の文脈から推定

### 本文の構成ガイドライン

```markdown
## 背景
{なぜこの検討が必要になったか}

## 検討内容
{調査・比較・議論した内容}

## 結論
{最終的な判断・選択}

## 理由
{なぜその結論に至ったか}
```

背景・検討内容・結論・理由の4セクション構成を基本とするが、内容に応じて柔軟に調整する。すべてのセクションが必要とは限らない。

---

## Phase 2: ページの作成

`mcp__claude_ai_Notion__notion-create-pages` を使って保存する。

### パラメータ構成

```json
{
  "parent": {
    "type": "data_source_id",
    "data_source_id": "10b17547-b9f6-450b-b3fb-656acd9e0c66"
  },
  "pages": [{
    "properties": {
      "タイトル": "{タイトル}",
      "プロジェクト": "{推定プロジェクト}",
      "カテゴリ": "{推定カテゴリ}",
      "ステータス": "完了",
      "date:日付:start": "{今日の日付 YYYY-MM-DD}",
      "date:日付:is_datetime": 0
    },
    "content": "{整形した本文}"
  }]
}
```

### タグの設定

タグは JSON 配列形式で指定する:
```json
"タグ": "[\"アーキテクチャ\", \"セキュリティ\"]"
```

---

## Phase 3: 完了報告

保存後、以下を表示する:

```
設計ノート DN-{ID} を保存しました。
URL: {page_url}
```

---

## 制約事項

- 会話のコンテキストが不十分な場合は、保存前にユーザーに確認する
- 機密情報（APIキー、パスワード等）はノートに含めない
- プロジェクト・カテゴリの値はスキーマ定義の選択肢のみ使用する
