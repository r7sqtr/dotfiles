#!/bin/bash
# Claude Code 禁止コマンドチェッカー
# PreToolUse hook で Bash コマンドの実行前にチェック

# 標準入力から JSON を読み取る
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Bash ツール以外は許可
if [[ "$TOOL_NAME" != "Bash" ]]; then
    exit 0
fi

# コマンドが空の場合は許可
if [[ -z "$COMMAND" ]]; then
    exit 0
fi

# ===== 禁止コマンドパターン =====

BLOCKED_PATTERNS=(
    # 1. ファイルシステム破壊系
    'rm\s+(-[a-zA-Z]*r[a-zA-Z]*f[a-zA-Z]*|-[a-zA-Z]*f[a-zA-Z]*r[a-zA-Z]*)\s+/'
    'rm\s+(-[a-zA-Z]*r[a-zA-Z]*f[a-zA-Z]*|-[a-zA-Z]*f[a-zA-Z]*r[a-zA-Z]*)\s+~'
    'rm\s+(-[a-zA-Z]*r[a-zA-Z]*f[a-zA-Z]*|-[a-zA-Z]*f[a-zA-Z]*r[a-zA-Z]*)\s+\*'
    'rm\s+(-[a-zA-Z]*r[a-zA-Z]*f[a-zA-Z]*|-[a-zA-Z]*f[a-zA-Z]*r[a-zA-Z]*)\s+\.\.'
    'chmod\s+(-R\s+)?777'
    'chown\s+-R\s+[^[:space:]]+\s+/'
    'mkfs(\.[a-z0-9]+)?'
    'dd\s+.*if='

    # 2. Git 破壊系
    'git\s+push\s+--force'
    'git\s+push\s+-f(\s|$)'
    'git\s+push\s+[^[:space:]]+\s+\+'
    'git\s+reset\s+--hard'
    'git\s+clean\s+-f'
    'git\s+clean\s+-fd'
    'git\s+checkout\s+\.'
    'git\s+restore\s+\.'
    'git\s+branch\s+-D'
    'git\s+rebase\s+-i'
    'git\s+add\s+-i'

    # 3. システム操作系
    'sudo\s+'
    '\bsu\s+-'
    '\bshutdown\b'
    '\breboot\b'
    'systemctl\s+stop'
    'kill\s+-9'
    '\bkillall\b'

    # 4. 機密情報漏洩リスク
    # .env ファイル読み取り（各種コマンド）
    'cat\s+(.*\/)?\.env'
    '(head|tail|less|more|bat|nl)\s+(.*\/)?\.env'
    '(source|\.)\s+(.*\/)?\.env'
    '(base64|xxd|od|strings)\s+(.*\/)?\.env'
    '(sed|awk|perl|ruby|python[23]?)\s.*(.*\/)?\.env'
    '(cp|mv)\s+(.*\/)?\.env'
    '<\s*(.*\/)?\.env'
    'cat\s+.*credentials'
    'curl\s+.*-X\s*POST.*http'
    'wget\s+.*--post-data'
    '\bscp\s+'
    'rsync\s+.*@'
    '\bssh-keygen\b'
    'cat\s+~/.ssh/'
    'cat\s+.*\.ssh/'

    # 5. パッケージ管理（公開・グローバル）
    'npm\s+publish'
    'npm\s+unpublish'
    'npm\s+install\s+-g'
    'npm\s+i\s+-g'
    'yarn\s+global\s+add'
    'pnpm\s+add\s+-g'
    'composer\s+global\s+require'

    # 6. データベース操作（SQLクエリ）
    'DROP\s+DATABASE'
    'TRUNCATE\s+TABLE'
    'DELETE\s+FROM\s+[^[:space:]]+\s*;'
    'DELETE\s+FROM\s+[^[:space:]]+\s*$'

    # 7. ネットワーク・ポート操作
    '\biptables\b'
    '(netcat|nc)\s+-l'
    '\bnmap\b'
)

# パターンマッチング（禁止）
for pattern in "${BLOCKED_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qiE "$pattern"; then
        echo '{"error": "BLOCKED: このコマンドは禁止されています"}'
        exit 2
    fi
done

# ===== 警告コマンドパターン（確認を促す） =====
WARNING_PATTERNS=(
    # Laravel Artisan（データ破壊リスク）
    'php\s+artisan\s+migrate:fresh'
    'php\s+artisan\s+migrate:reset'
    'php\s+artisan\s+db:wipe'
    'php\s+artisan\s+migrate:rollback'

    # パッケージ管理
    'npm\s+run\s+build.*--production'
    'composer\s+update(\s|$)'

    # Docker/コンテナ操作
    'docker\s+system\s+prune'
    'docker\s+rm\s+-f'
    'docker\s+rmi\s+-f'
    'docker\s+volume\s+rm'
    'docker\s+container\s+prune'
    'docker\s+image\s+prune'
)

for pattern in "${WARNING_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qiE "$pattern"; then
        echo '{"error": "WARNING: このコマンドはデータ破壊の可能性があります。実行前に確認してください"}'
        exit 2
    fi
done

# 許可
exit 0
