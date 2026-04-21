---
name: google-sheets
description: "Google Sheets の作成・編集を行うスキル。スプレッドシートの新規作成、データ書き込み、書式設定、数式挿入、共有設定に対応。ユーザーが「スプレッドシートを作って」「Google Sheetsに整理して」「シートに書き出して」と依頼した場合にトリガーする。"
argument-hint: "<作成内容の説明（例: '圏外対応の機能一覧をシートに整理', 'プロジェクト管理表を作成'）>"
allowed-tools: Bash, Read, Glob, Grep
---

# Google Sheets 操作スキル

gspread + Google Sheets API を使い、Google Sheets を直接作成・編集する。

対象: **$ARGUMENTS**

---

## 制約事項（厳守）

- **操作対象はサービスアカウントのマイドライブ内のみ**。他ユーザーのドライブや共有ドライブへのアクセス禁止
- **API レート制限**: 書き込みは60リクエスト/分。大量データは `batch_update` でまとめる
- **認証情報の出力禁止**: キーファイルの中身やトークンをコンソールに出力しない
- **既存シートの上書き**: 既存シートを編集する場合は、操作前にユーザーに確認を取る

---

## 認証

OAuth 2.0 認証を使用。ユーザーのマイドライブに直接アクセスする。

```python
import gspread
import os

gc = gspread.oauth(
    credentials_filename=os.environ["GOOGLE_OAUTH_CREDENTIALS_PATH"],
    authorized_user_filename=os.path.expanduser("~/.config/gcloud/google-sheets-token.json"),
)
```

---

## 基本操作リファレンス

### 新規作成

```python
sh = gc.create("スプレッドシート名")
# リンク共有を有効にする（閲覧者）
sh.share(None, perm_type="anyone", role="reader")
print(f"URL: {sh.url}")
```

### シート追加・選択

```python
ws = sh.sheet1
ws = sh.worksheet("シート名")
ws = sh.add_worksheet(title="新しいシート", rows=100, cols=20)
```

### データ書き込み

```python
# 単一セル
ws.update_acell("A1", "値")

# 範囲一括（推奨: API コール削減）
ws.update([
    ["ヘッダー1", "ヘッダー2", "ヘッダー3", "ヘッダー4"],
    ["データ1", "データ2", "データ3", "データ4"],
    ["データ5", "データ6", "データ7", "データ8"],
], "A1:D3")

# 行追加
ws.append_row(["値1", "値2", "値3"])
```

### 数式

```python
ws.update_acell("E2", "=SUM(A2:D2)")
```

### 読み取り

```python
all_data = ws.get_all_values()
cell_value = ws.acell("A1").value
row = ws.row_values(1)
col = ws.col_values(1)
```

---

## 書式設定リファレンス

gspread の `format()` メソッドまたは Google Sheets API の `batch_update` を使用する。

### ヘッダー行の書式

```python
ws.format("A1:Z1", {
    "backgroundColor": {"red": 0.2, "green": 0.4, "blue": 0.7},
    "textFormat": {"bold": True, "foregroundColor": {"red": 1, "green": 1, "blue": 1}, "fontSize": 11},
    "horizontalAlignment": "CENTER",
})
```

### 列幅の設定

```python
body = {
    "requests": [
        {
            "updateDimensionProperties": {
                "range": {
                    "sheetId": ws.id,
                    "dimension": "COLUMNS",
                    "startIndex": col_start,  # 0始まり
                    "endIndex": col_end,
                },
                "properties": {"pixelSize": width},
                "fields": "pixelSize",
            }
        }
    ]
}
sh.batch_update(body)
```

### 罫線

```python
body = {
    "requests": [
        {
            "updateBorders": {
                "range": {
                    "sheetId": ws.id,
                    "startRowIndex": 0,
                    "endRowIndex": row_count,
                    "startColumnIndex": 0,
                    "endColumnIndex": col_count,
                },
                "top": {"style": "SOLID", "width": 1},
                "bottom": {"style": "SOLID", "width": 1},
                "left": {"style": "SOLID", "width": 1},
                "right": {"style": "SOLID", "width": 1},
                "innerHorizontal": {"style": "SOLID", "width": 1},
                "innerVertical": {"style": "SOLID", "width": 1},
            }
        }
    ]
}
sh.batch_update(body)
```

### セル結合

```python
ws.merge_cells("A1:D1")
```

### 条件付き書式（背景色の交互設定）

```python
body = {
    "requests": [
        {
            "addConditionalFormatRule": {
                "rule": {
                    "ranges": [{"sheetId": ws.id, "startRowIndex": 1, "endRowIndex": row_count, "startColumnIndex": 0, "endColumnIndex": col_count}],
                    "booleanRule": {
                        "condition": {"type": "CUSTOM_FORMULA", "values": [{"userEnteredValue": "=MOD(ROW(),2)=0"}]},
                        "format": {"backgroundColor": {"red": 0.95, "green": 0.95, "blue": 0.95}},
                    },
                },
                "index": 0,
            }
        }
    ]
}
sh.batch_update(body)
```

### テキスト折り返し

```python
ws.format("A1:Z100", {"wrapStrategy": "WRAP"})
```

---

## デザインガイドライン

### カラーパレット（Professional Blue & Grey）

最大3〜5色に制限し統一感を保つ。色覚多様性に配慮し赤緑の組み合わせを避ける。

| 役割 | 名前 | HEX | RGB (0-1) | 用途 |
|------|------|-----|-----------|------|
| Primary | ハーメス | #20368F | (0.13, 0.21, 0.56) | セクションヘッダー |
| Accent | ミュートブルー | #829CD0 | (0.51, 0.61, 0.82) | テーブルヘッダー、サブヘッダー |
| Neutral Light | ペールシルバー | #EBEBEB | (0.92, 0.92, 0.92) | 代替行背景 |
| Neutral Dark | 濃グレー | #6D6D6D | (0.43, 0.43, 0.43) | 補足テキスト |
| Text | マインシャフト | #323232 | (0.20, 0.20, 0.20) | 本文テキスト |
| Background | オーセンティックホワイト | #F8F9FA | (0.97, 0.98, 0.98) | 全体背景 |
| Border | トラディショナルシルバー | #C2C3C5 | (0.76, 0.76, 0.77) | 罫線 |
| Positive | ジェイド | #00A568 | (0.0, 0.65, 0.41) | 対応済み・成功 |
| Warning | アンバー | #E8A735 | (0.91, 0.65, 0.21) | 注意・検討中 |
| Critical | コーラル | #D73027 | (0.84, 0.19, 0.15) | 重要・未対応 |

### 視覚的階層（4レベル）

| レベル | 用途 | フォント | 背景 | テキスト色 | 行高さ |
|--------|------|---------|------|-----------|--------|
| L1 | ドキュメントタイトル | 16pt Bold | Primary (#20368F) | 白 | 40px |
| L2 | セクションヘッダー | 13pt Bold | Accent (#829CD0) | 白 | 32px |
| L3 | テーブルヘッダー | 11pt Bold | Light (#EBEBEB) | Text (#323232) | 28px |
| L4 | データ行 | 10pt Regular | 白 / 交互 #F8F9FA | Text (#323232) | 24px |

### フォント

- ヘッダー系: Arial 11-16pt Bold
- 本文: Arial 10pt Regular
- 補注: Arial 9pt, 色 #6D6D6D
- フォントは最大2種類まで

### 方眼レイアウト

セルを方眼紙のように使い、セル結合で自由なレイアウトを作る。

- 全列を均一な小幅（30px）に設定する
- タイトル・ヘッダー・データ行はセル結合で必要な幅を確保する
- これにより列幅に縛られず、セクションごとに異なるレイアウトが可能になる
- 1シートの列数は 26列（A〜Z）を基本とする

### 罫線・ボーダーの使い方

- すべてのセルを囲まない。罫線は「控えめに、意図を持って」使う
- データテーブル: 薄いグレー (#C2C3C5) の水平線のみ。縦線は原則使わない
- セクション境界: テーブル上部に 1px の濃い線 (#6D6D6D) を引いて区切る
- 合計行・小計行: 上に水平線を引いて視覚的に分離する
- グリッドライン（シート全体の薄い線）は非表示にしない。方眼の視認性を保つ

### 余白・スペーシング

- セクション間は空白行（1〜2行）で区切る
- 関連するデータグループは近くに配置し、無関係なグループとは空白で分離する
- テキストは折り返し (WRAP) を設定する

### テーブルのルール

- ヘッダー行は固定（フリーズ）する
- データテーブルにはフィルターを有効にする
- データ行は交互背景色（白 / #F8F9FA）で視線誘導
- テキストは折り返し (WRAP) + 垂直中央揃え
- 数値は右揃え、テキスト・ラベルは左揃え、ヘッダーは中央揃え
- 日付は日付フォーマット、パーセントは小数第1位、通貨は適切な通貨フォーマットで表示する

### 提案資料としてのデザイン原則

- 技術用語やファイルパスは含めない。読者は非エンジニアの可能性がある
- セクションごとにタイトル行（L2レベル、セル結合 + 濃い背景 + 白テキスト）を設けて文書構造を明確にする
- 重要なポイントはセルの背景色やボールド体で強調する
- 各シートの冒頭に簡潔な説明行（L4レベル、イタリック、グレーテキスト）を設けてコンテキストを示す
- fill colors, borders, spacing, merged cells は「控えめに、意図を持って」使う。装飾過多にしない
- 元資料に表として列挙されている項目は省略・要約せず全て記載する。内容の削減は行わない

---

## ワークフロー

1. **要件確認**: ユーザーの指示から、シート構成・カラム・データを整理する
2. **Python スクリプト作成**: `$TMPDIR` に一時スクリプトを作成して実行する
3. **スプレッドシート作成**: gspread で新規作成し、データと書式を設定する
4. **共有設定**: リンク共有（閲覧者）を有効にする
5. **URL 出力**: 作成したスプレッドシートの URL をユーザーに提示する
6. **一時ファイル削除**: `$TMPDIR` のスクリプトを削除する

### 大量データの場合

- `ws.update()` で範囲一括書き込み（1セルずつ書かない）
- 書式設定は `batch_update` でまとめる
- 60リクエスト/分の制限に注意し、必要に応じて `time.sleep(1)` を挟む
