---
name: docker-dev
description: Docker開発環境のコンテナ操作・DB操作・コマンド実行を効率化
argument-hint: "<操作内容（例: 'DBのテーブル一覧', 'artisan migrate', 'SQLファイルを投入'）>"
allowed-tools: Read, Grep, Glob, Bash(docker:*), Bash(docker-compose:*), Bash(cat:*), Bash(ls:*), Bash(head:*), AskUserQuestion
---

# Docker 開発環境操作

Docker Compose で管理されている開発環境のコンテナ操作を効率化する。
コンテナ名・DB接続情報を自動検出し、繰り返しの手動入力を省略する。

## 動的コンテキスト

```
Docker状態: !`docker compose ps --format "table {{.Name}}\t{{.Service}}\t{{.Status}}" 2>/dev/null || docker-compose ps 2>/dev/null || echo "Docker Compose未検出"`
Composeファイル: !`cat docker-compose.yml 2>/dev/null | head -60 || echo "docker-compose.yml が見つかりません"`
```

---

## Step 1: 環境検出

上記の動的コンテキストから以下を把握する:
- 実行中のコンテナ一覧とサービス名
- DBコンテナの特定（mysql, postgres, mariadb 等のイメージ名で判別）
- アプリコンテナの特定（php, node, python 等）
- DB接続情報（docker-compose.yml の環境変数から取得）

コンテナが停止中の場合はユーザーに通知し、起動するか確認する。

---

## Step 2: 操作の実行

`$ARGUMENTS` に基づいて適切なコマンドを構成・実行する。

### DB操作の場合

```bash
# MySQL/MariaDB の場合
docker exec <DBコンテナ名> mysql -u <ユーザー> -p<パスワード> <DB名> -e "<クエリ>"

# PostgreSQL の場合
docker exec <DBコンテナ名> psql -U <ユーザー> -d <DB名> -c "<クエリ>"
```

### SQLファイル投入の場合

```bash
# ファイルの内容を事前に確認（先頭と末尾）
head -20 <SQLファイル>

# 投入前にユーザーに確認を取る
docker exec -i <DBコンテナ名> mysql -u <ユーザー> -p<パスワード> <DB名> < <SQLファイル>
```

### アプリコンテナでのコマンド実行

```bash
# Laravel artisan
docker compose exec <アプリサービス名> php artisan <コマンド>

# npm/yarn
docker compose exec <アプリサービス名> npm <コマンド>

# 汎用
docker compose exec <アプリサービス名> <コマンド>
```

---

## Step 3: 結果の確認

コマンド実行後、必要に応じて:
- DB操作: 影響を受けた行数や結果セットを確認
- マイグレーション: テーブル構造の変更を確認
- SQLファイル投入: 投入後のレコード数を確認

---

## 制約事項（厳守）

- **破壊的DB操作（DROP, TRUNCATE, DELETE without WHERE）は実行前に必ず確認を取る**
- **SQLファイル投入前はファイル内容の概要を提示し、対象DBを確認する**
- docker-compose.yml に記載されていないコンテナへの操作は行わない
- 本番環境のコンテナには操作しない（コンテナ名・イメージから判別）
- DB接続パスワード等の機密情報はログや出力に含めない（コマンド実行のみに使用）
