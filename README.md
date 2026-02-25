# dotfiles

macOS向けの個人設定ファイル集。

## 構成

```
.config/
├── nvim/          # Neovim設定
├── wezterm/       # WezTerm設定
├── zsh/           # Zsh設定
└── claude/        # Claude Code設定
```

---

## Neovim

フルスタック開発向けのモダンなNeovim設定。lazy.nvimによるプラグイン管理、AI支援、豊富なLSPサポートを特徴とする。

### ディレクトリ構成

```
nvim/
├── init.lua                          # エントリーポイント
├── lua/
│   ├── config/
│   │   ├── lazy.lua                  # lazy.nvim設定
│   │   ├── options.lua               # エディタオプション
│   │   ├── keymaps.lua               # グローバルキーマップ
│   │   └── autocmds.lua              # 自動コマンド
│   └── plugins/
│       ├── ai/                       # AI支援プラグイン
│       ├── colorschemes/             # カラースキーム
│       ├── core/                     # コアUI・ナビゲーション
│       ├── lsp/                      # LSP・補完・フォーマット
│       └── utility/
│           ├── coding/               # コーディング補助
│           ├── git/                  # Git連携
│           ├── lang/                 # 言語・翻訳
│           └── ui/                   # UI拡張
└── plugin/
    └── namu_colorscheme_persist.lua  # カラースキーム永続化
```

### プラグイン一覧

#### AI支援

| プラグイン | 説明 | キーマップ |
|-----------|------|-----------|
| sidekick.nvim | CLI統合 | `<leader>aa` トグル, `<leader>ac` CLI, `<leader>af` ファイル送信 |
| codecompanion.nvim | マルチプロバイダーチャット | `<leader>cc` 開く, `<leader>ca` チャット |
| copilot.lua | GitHub Copilot | `<C-l>` 受け入れ, `<M-]>/<M-[>` 次/前 |

#### コアUI・ナビゲーション

| プラグイン | 説明 | キーマップ |
|-----------|------|-----------|
| snacks.nvim | 統合UIフレームワーク (ダッシュボード, エクスプローラー, Zen等) | `<leader>e` エクスプローラー, `<leader>zn` Zen |
| fzf-lua | ファジーファインダー | `<leader><space>` ファイル検索, `<leader>/` grep, `<leader>fo` 最近のファイル |
| which-key.nvim | キーマップヒント | `<leader>` 押下で表示 |
| bufferline.nvim | タブ形式バッファ表示 | `<Tab>`/`<S-Tab>` タブ移動 |
| noice.nvim | コマンドラインUI | - |
| toggleterm.nvim | 統合ターミナル | `<C-t>` 水平, `<C-f>` フロート |
| trouble.nvim | 診断・LSPリスト | `<leader>x*` 各種操作 |
| grug-far.nvim | 検索・置換 | - |
| incline.nvim | フローティングファイル名 | - |
| namu.nvim | シンボルブラウザ | `<leader>t` シンボル一覧 |

#### LSP・補完

| プラグイン | 説明 |
|-----------|------|
| nvim-lspconfig | LSP設定 |
| mason.nvim | LSP/フォーマッター/リンターのパッケージマネージャー |
| nvim-cmp | 補完エンジン |
| LuaSnip | スニペットエンジン |
| lspsaga.nvim | 高度なLSP UI (`K` でホバードキュメント) |
| lsp_lines.nvim | 仮想行による診断表示 |
| conform.nvim | コードフォーマッター (`<leader>cf`) |
| nvim-treesitter | シンタックスハイライト |

#### 対応LSPサーバー

| 言語 | サーバー |
|-----|---------|
| HTML | html |
| CSS | cssls |
| JavaScript/TypeScript | ts_ls |
| Vue.js | vue_ls |
| PHP | intelephense |
| Go | gopls |
| Lua | lua_ls |
| JSON | jsonls |
| YAML | yamlls |
| Bash | bashls |
| Docker | dockerls |

#### カラースキーム

14種類のカラースキームを搭載。spectra.nvim による `<leader>sp` でライブプレビュー付きピッカーを起動。選択したテーマは自動的に永続化される。

- catppuccin (macchiato), tokyonight, gruvbox, monokai
- ayu, kanagawa, nord, onedark, solarized-osaka
- night-owl, everforest, palenight, everblush, nordic

#### Git連携

| プラグイン | 説明 | キーマップ |
|-----------|------|-----------|
| gitsigns.nvim | サインカラムにGit表示 | - |
| git-blame.nvim | インラインblame | - |
| gitlinker.nvim | GitリンクをクリップボードへCopy | `<leader>gl` yank, `<leader>go` ブラウザで開く |
| diffview.nvim | 差分ビューア | `<leader>gd` Diffview, `<leader>gS` ファイル差分 |

#### ユーティリティ

| プラグイン | 説明 | キーマップ |
|-----------|------|-----------|
| Comment.nvim | コメントトグル | `gcc` 行, `gc` 選択範囲 |
| wyw.nvim | 技術ニュース (Zenn, Qiita等) | `:Wyw` |
| noxen.nvim | ノート管理 | `<leader>m*` |
| kulala.nvim | RESTクライアント | `<leader>r*` |
| pantran.nvim | 翻訳 | `<leader>w` |
| spectra.nvim | カラースキームピッカー | `<leader>sp` |
| transparent.nvim | 背景透過 | - |
| sunglasses.nvim | 非アクティブウィンドウをシェード | - |
| smear-cursor.nvim | カーソルアニメーション | - |
| render-markdown.nvim | Markdownプレビュー | - |

### 主要キーマップ

#### 基本操作

| キー | 動作 |
|-----|------|
| `te` | 新規タブ |
| `<Tab>` / `<S-Tab>` | タブ移動 |
| `<C-h/j/k/l>` | ウィンドウ間移動 |
| `<M-j>` / `<M-k>` | 行を上下に移動 |
| `jk` | インサートモード終了 |

#### Leader キーグループ

| プレフィックス | カテゴリ |
|---------------|---------|
| `<leader>a` | Sidekick (AI) |
| `<leader>c` | CodeCompanion |
| `<leader>e` | エクスプローラー |
| `<leader>f` | fzf-lua (ファイル操作) |
| `<leader>g` | Git |
| `<leader>l` | Lazy (プラグイン管理) |
| `<leader>m` | Noxen (ノート) |
| `<leader>r` | Kulala (REST) |
| `<leader>s` | Spectra (カラースキーム) |
| `<leader>t` | シンボル |
| `<leader>x` | Trouble (診断) |
| `<leader>z` | Zen モード |
| `<leader>w` | 翻訳 |

#### LSP操作

| キー | 動作 |
|-----|------|
| `gd` | 定義へジャンプ |
| `gr` | 参照一覧 |
| `K` | ホバードキュメント |
| `<leader>rn` | リネーム |
| `<leader>cf` | フォーマット |

### エディタ設定

- エンコーディング: UTF-8 (フォールバック: sjis, euc-jp)
- クリップボード: システム連携
- インデント: スペース2文字
- 行番号: 絶対番号
- スクロールオフ: 15行

---

## WezTerm

モダンなGPUアクセラレーション対応ターミナルエミュレータの設定。

### ディレクトリ構成

```
wezterm/
├── wezterm.lua              # メイン設定
└── config/
    ├── ui.lua               # UI・外観設定
    ├── fonts.lua            # フォント設定
    ├── keymap.lua           # キーバインド
    ├── colorscheme.lua      # カラースキームシステム
    ├── colorscheme_data.lua # 選択中のスキーム (自動生成)
    └── webview.lua          # WebView機能設定
```

### 主な特徴

#### UI設定
- ウィンドウサイズ: 170列 × 40行
- 背景透過度: 92% (macOSブラー効果付き)
- タブバー: 画面下部、単一タブ時は非表示
- リフレッシュレート: 144 FPS
- カーソル: アンダーライン (点滅なし)

#### フォント設定
- フォント: PlemolJP Console NF
- サイズ: 16.5pt
- 行の高さ: 1.2
- IME: 有効

#### インテリジェントタブバー
プロセスに応じたNerd Fontsアイコンを自動表示:
- Nvim, Vim, Node, Python, Git, Cargo, Docker, npm, zsh/bash/fish

### キーバインド

#### ペイン操作

| キー | 動作 |
|-----|------|
| `Cmd+D` | 垂直分割 |
| `Cmd+Shift+D` | 水平分割 |
| `Cmd+W` | ペインを閉じる |
| `Cmd+矢印キー` | ペイン間移動 |

#### カラースキーム

| キー | 動作 |
|-----|------|
| `Cmd+Shift+P` | カラースキームピッカー |

インタラクティブピッカーでファジー検索が可能。選択したスキームは自動的に永続化される。

#### WebView (オプション機能)

| キー | 動作 |
|-----|------|
| `Option+Shift+O` | URLをWebViewで開く (右分割) |
| `Option+Shift+U` | URLをWebViewで開く (下分割) |
| `Option+Shift+G` | Google |
| `Option+Shift+H` | GitHub |
| `Option+[` / `]` | 戻る / 進む |
| `Option+R` | リロード |
| `Option+W` | WebViewペインを閉じる |

---

## Zsh

用途ごとに分割したZsh設定。`.zshrc` はローダーとして機能し、`conf.d/` 内の各ファイルを順序通りに読み込む。

### ディレクトリ構成

```
zsh/
├── .zshenv              # ZDOTDIR の設定
├── .zprofile            # ログインシェル設定
├── .zshrc               # ローダー（conf.d/ を source）
└── conf.d/
    ├── env.zsh          # PATH、環境変数、履歴設定
    ├── secrets.zsh      # ~/.env.secrets の読み込み
    ├── completion.zsh   # fpath、compinit、補完スタイル
    ├── options.zsh      # setopt 設定
    ├── prompt.zsh       # Starship init（キャッシュ付き）
    ├── plugins.zsh      # プラグイン遅延読み込み、precmd フック
    ├── functions.zsh    # lsinfo(), wt(), docker_comp()
    └── aliases.zsh      # エイリアス定義
```

### 読み込み順序

`completion.zsh` は `env.zsh` の後（fpath 依存）、`aliases.zsh` は `functions.zsh` の後（`lsinfo` 参照）に読み込む必要がある。

### 主な機能

- **Starship**: キャッシュ付き init で起動高速化
- **プラグイン遅延読み込み**: zsh-autosuggestions / zsh-syntax-highlighting を precmd フックで初回表示時に読み込み
- **compinit キャッシュ**: glob qualifier で7日間隔の再生成
- **lsinfo()**: パーミッション・サイズ・日付付きのカスタム ls

---

## Claude Code

Claude Code（Anthropic CLI）のグローバル設定。`~/.config/claude` に配置し、`~/.claude` からシンボリックリンクで参照。

### ディレクトリ構成

```
claude/
├── CLAUDE.md                 # グローバルガイドライン
├── settings.json             # メイン設定（権限、Hook、プラグイン）
├── statusline-command.sh     # ステータスライン表示スクリプト
├── rules/                    # コーディングルール
├── agents/                   # エージェント定義
├── scripts/                  # Hook スクリプト
├── docs/                     # ドキュメント
└── skills/                   # カスタムスキル
```

### 新マシンでのセットアップ

```bash
# Claude Code をインストール前に実行
ln -s ~/.config/claude ~/.claude
```

---

## インストール

```bash
# リポジトリをクローン
git clone https://github.com/r7sqtr/dotfiles.git ~/.config

# Zsh の ZDOTDIR を設定（未設定の場合）
echo 'export ZDOTDIR="$HOME/.config/zsh"' >> ~/.zshenv

# Claude Code のシンボリックリンク
ln -s ~/.config/claude ~/.claude

# Neovimを起動してプラグインをインストール
nvim
```

### 依存関係

- Neovim >= 0.10
- WezTerm
- Zsh
- [Starship](https://starship.rs/) (プロンプト)
- Nerd Font (PlemolJP Console NF 推奨)
- ripgrep (検索用)
- fd (ファイル検索用)
- [Wezbrowzer](https://github.com/r7sqtr/wezbrowser) (オプション)

---
