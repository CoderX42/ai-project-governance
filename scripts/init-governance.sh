#!/usr/bin/env bash
#
# AI Project Governance - 一键初始化脚本
#
# 用法（交互模式）:
#   bash init-governance.sh
#
# 用法（参数模式）:
#   bash init-governance.sh --project "My App" --branch dev --prod main --test "npm test" --pkg package.json
#
# 用法（远程，发布后）:
#   bash <(curl -sSL https://raw.githubusercontent.com/YOUR_USER/ai-project-governance/main/scripts/init-governance.sh) --project "My App"
#
set -e

# ------------------------------------------------------------
# 默认值区
# ------------------------------------------------------------
DEFAULT_PROJECT_NAME="我的项目"
DEFAULT_BRANCH="dev"
PROD_BRANCH="main"
TEST_COMMAND="npm test"
PACKAGE_FILE="package.json"
# ------------------------------------------------------------

print_usage() {
  cat <<'EOF'
用法:
  bash init-governance.sh                      # 交互模式
  bash init-governance.sh --project "My App"   # 参数模式（任意顺序）
  bash init-governance.sh -h                    # 显示帮助

参数模式示例:
  --project "我的项目" --branch dev --prod main --test "npm test" --pkg package.json

EOF
}

# 解析命令行参数
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        print_usage
        exit 0
        ;;
      --project)
        PROJECT_NAME="$2"; shift 2 ;;
      --branch)
        DEFAULT_BRANCH="$2"; shift 2 ;;
      --prod)
        PROD_BRANCH_VAR="$2"; shift 2 ;;
      --test)
        TEST_COMMAND_VAR="$2"; shift 2 ;;
      --pkg)
        PACKAGE_FILE_VAR="$2"; shift 2 ;;
      -*)
        echo "❌ 未知参数: $1"; print_usage; exit 1 ;;
      *)
        TARGET_DIR="$1"; shift ;;
    esac
  done
}

# 默认值填充
apply_defaults() {
  PROJECT_NAME="${PROJECT_NAME:-$DEFAULT_PROJECT_NAME}"
  DEFAULT_BRANCH="${DEFAULT_BRANCH:-dev}"
  PROD_BRANCH_VAR="${PROD_BRANCH_VAR:-$PROD_BRANCH}"
  TEST_COMMAND_VAR="${TEST_COMMAND_VAR:-$TEST_COMMAND}"
  PACKAGE_FILE_VAR="${PACKAGE_FILE_VAR:-$PACKAGE_FILE}"
}

# 交互式收集参数（仅在非参数模式下调用）
gather_params() {
  echo "请提供以下信息（直接回车使用默认值）："
  echo ""

  read_with_default "  项目名称"    "PROJECT_NAME"    "$DEFAULT_PROJECT_NAME"
  read_with_default "  开发基线分支" "DEFAULT_BRANCH"  "dev"
  read_with_default "  生产分支"     "PROD_BRANCH_VAR" "$PROD_BRANCH"
  read_with_default "  测试命令"     "TEST_COMMAND_VAR" "$TEST_COMMAND"
  read_with_default "  包管理文件"   "PACKAGE_FILE_VAR" "$PACKAGE_FILE"
}

read_with_default() {
  local prompt="$1"
  local var_name="$2"
  local default="$3"
  printf "%s [%s]: " "$prompt" "$default"
  local val
  read val
  if [[ -z "$val" ]]; then
    eval "$var_name=\$default"
  else
    eval "$var_name=\$val"
  fi
}

print_summary() {
  echo ""
  echo "确认以下配置："
  echo "  项目名称      → $PROJECT_NAME"
  echo "  开发基线分支  → $DEFAULT_BRANCH"
  echo "  生产分支      → $PROD_BRANCH_VAR"
  echo "  测试命令      → $TEST_COMMAND_VAR"
  echo "  包管理文件    → $PACKAGE_FILE_VAR"
  echo ""
}

check_already_init() {
  if [[ -f "$TARGET_DIR/CLAUDE.md" ]]; then
    echo "⚠️  $TARGET_DIR 已存在 CLAUDE.md，跳过初始化"
    echo "如需重新初始化，请先删除现有的 governance 文档"
    exit 0
  fi
}

substitute() {
  local file="$1"
  if sed -i '' /dev/null 2>/dev/null; then
    # BSD sed (macOS): -i '' 语法
    sed -i '' \
      -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
      -e "s/{{DEFAULT_BRANCH}}/$DEFAULT_BRANCH/g" \
      -e "s/{{PROD_BRANCH}}/$PROD_BRANCH_VAR/g" \
      -e "s/{{TEST_COMMAND}}/$TEST_COMMAND_VAR/g" \
      -e "s/{{PACKAGE_FILE}}/$PACKAGE_FILE_VAR/g" \
      "$file"
  else
    # GNU sed (Linux): -i 没有空格
    sed -i.bak \
      -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
      -e "s/{{DEFAULT_BRANCH}}/$DEFAULT_BRANCH/g" \
      -e "s/{{PROD_BRANCH}}/$PROD_BRANCH_VAR/g" \
      -e "s/{{TEST_COMMAND}}/$TEST_COMMAND_VAR/g" \
      -e "s/{{PACKAGE_FILE}}/$PACKAGE_FILE_VAR/g" \
      "$file"
    rm -f "$file.bak"
  fi
}

copy_one() {
  local src="$1"
  local dst="$2"
  if [[ -f "$src" ]]; then
    local abs_dst="$dst"
    # 相对路径：以 TARGET_DIR 为基址；绝对路径直接用
    [[ "$dst" != /* ]] && abs_dst="$TARGET_DIR/$dst"
    mkdir -p "$(dirname "$abs_dst")"
    cp "$src" "$abs_dst"
    substitute "$abs_dst"
    echo "  ✓ $(basename "$dst")"
  fi
}

main() {
  parse_args "$@"

  # 目标目录：参数最后位置 或 当前目录
  TARGET_DIR="${TARGET_DIR:-$(pwd)}"

  # 非参数模式（没有传 --project 等）则交互询问
  if [[ -z "$PROJECT_NAME" && -z "$DEFAULT_BRANCH" && -z "$PROD_BRANCH_VAR" && -z "$TEST_COMMAND_VAR" && -z "$PACKAGE_FILE_VAR" ]]; then
    echo ""
    echo "=== AI Project Governance 初始化 ==="
    echo "目标目录: $TARGET_DIR"
    echo ""
    gather_params
    print_summary
  else
    apply_defaults
  fi

  check_already_init

  echo "开始复制 governance 文档..."
  mkdir -p "$TARGET_DIR"

  copy_one "$SOURCE_DIR/docs/CLAUDE.md"              "CLAUDE.md"
  copy_one "$SOURCE_DIR/docs/AI开发与PR流程.md"        "AI开发与PR流程.md"
  copy_one "$SOURCE_DIR/docs/项目开发规范.md"           "项目开发规范.md"
  copy_one "$SOURCE_DIR/docs/项目完整链路说明.md"       "项目完整链路说明.md"
  copy_one "$SOURCE_DIR/docs/项目文件结构说明.md"       "项目文件结构说明.md"

  # docs/项目需求分析.md 复制到目标 docs/ 下，需要避免同文件误报
  local req_src="$SOURCE_DIR/docs/项目需求分析.md"
  local req_dst="$TARGET_DIR/docs/项目需求分析.md"
  if [[ -f "$req_src" ]]; then
    mkdir -p "$TARGET_DIR/docs"
    cp "$req_src" "$req_dst"
    substitute "$req_dst"
    echo "  ✓ docs/项目需求分析.md"
  fi

  mkdir -p "$TARGET_DIR/governance/artifacts"
  echo "  ✓ governance/artifacts/"

  local skill_src="$SOURCE_DIR/integrations/cursor/skills/ai-project-governance"
  if [[ -d "$skill_src" ]]; then
    mkdir -p "$TARGET_DIR/.cursor/skills"
    cp -r "$skill_src" "$TARGET_DIR/.cursor/skills/ai-project-governance"
    echo "  ✓ .cursor/skills/ai-project-governance/"
  fi

  echo ""
  echo "✅ 初始化完成！"
  echo ""
  echo "下一步："
  echo "  1. 如果目标目录还不是 git 项目：cd $TARGET_DIR && git init"
  echo "  2. 重新打开 Cursor，AI 会自动读取 CLAUDE.md"
  echo "  3. 对 AI 说“初始化项目 governance”验证配置"
}

SOURCE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# ------------------------------------------------------------
# 从远程 curl | bash 执行时 $0 = bash/stdin，需要用 BASH_SOURCE[0] 找真实脚本位置
# ------------------------------------------------------------
_real_script="${BASH_SOURCE[0]:-$0}"
if [[ -f "$_real_script" && "$_real_script" != "/dev/stdin" && "$_real_script" != "/dev/fd/0" ]]; then
  SOURCE_DIR="$(cd "$(dirname "$_real_script")/.." && pwd)"
fi
unset _real_script
main "$@"