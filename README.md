# llm-skills

端末共通で利用する、再利用可能な Codex skills のリポジトリです。プロジェクト固有の手順は各リポジトリの `.codex/skills/` または `AGENTS.md` に置き、このリポジトリには複数プロジェクトで通用するワークフローだけを収録します。

## Skills

- `diagnose-ci-failure`: CI失敗を調査し、根本原因と最小修正方針を報告する
- `review-code-change`: コード変更から具体的かつ実行可能な問題を探す
- `add-regression-test`: 不具合を再現し、再発を防ぐテストを追加する

## Install

全skillを `~/.codex/skills/` にシンボリックリンクします。

```sh
./install.sh install
```

個別に導入する場合:

```sh
./install.sh install diagnose-ci-failure review-code-change
```

既存のファイルや他のリンクは上書きしません。状態確認と解除も同じスクリプトで行えます。

```sh
./install.sh list
./install.sh doctor
./install.sh uninstall
```

標準以外の配置先は `--target DIR`、または `CODEX_SKILLS_DIR` で指定できます。

## Development

追加するskillは `skills/<skill-name>/SKILL.md` に作成し、`skills.txt` に登録します。名前は小文字・数字・ハイフンのみを使い、`description` には機能と発火条件を簡潔に記述してください。

```sh
./tests/validate_skills.sh
./tests/test_install.sh
```

詳細な手順や再利用可能な処理が本当に必要な場合だけ、skill内に `references/`、`scripts/`、`assets/` を追加します。
