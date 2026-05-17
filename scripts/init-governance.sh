#!/usr/bin/env bash
#
# AI Project Governance - 一键初始化脚本
#
# 用法（参数模式）:
#   bash init-governance.sh --project "My App" --branch dev --prod main --test "npm test" --pkg package.json /path/to/target
#
# 用法（交互模式）:
#   bash init-governance.sh /path/to/target
#
# 远程用法（直接执行）:
#   bash <(curl -sSL https://your-gh-user.github.io/repo/scripts/init-governance.sh) --project "My App" /path/to/target
#   或
#   curl -sSL https://your-gh-user.github.io/repo/scripts/init-governance.sh | bash -s /path/to/target
#
set -e

# ------------------------------------------------------------
# 默认值区（可在这里修改，也可在参数模式通过 --project 等覆盖）
# ------------------------------------------------------------
DEFAULT_PROJECT_NAME="我的项目"
DEFAULT_BRANCH="dev"
PROD_BRANCH="main"
TEST_COMMAND="npm test"
PACKAGE_FILE="package.json"
# ------------------------------------------------------------

# 帮助信息
print_usage() {
  cat <<'EOF'
用法:
  bash init-governance.sh /path/to/target               # 交互模式
  bash init-governance.sh --project "MyApp" /path/to/target  # 参数模式

参数:
  /path/to/target    目标项目目录（必需）
  --project NAME    项目名称
  --branch NAME     开发基线分支（默认 dev）
  --prod NAME       生产分支（默认 main）
  --test CMD        测试命令
  --pkg FILE        包管理文件
  -h, --help        显示本帮助

示例:
  bash init-governance.sh --project "MyApp" --branch dev --prod main --test "npm test" --pkg package.json ~/my-project
  curl -sSL https://example.com/scripts/init-governance.sh | bash -s /path/to/target --project "MyApp"
EOF
}

# 参数解析
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        print_usage; exit 0 ;;
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
        echo "❌ 未知参数: $1" >&2; print_usage >&2; exit 1 ;;
      *)
        TARGET_DIR="$1"; shift ;;
    esac
  done
}

apply_defaults() {
  PROJECT_NAME="${PROJECT_NAME:-$DEFAULT_PROJECT_NAME}"
  DEFAULT_BRANCH="${DEFAULT_BRANCH:-dev}"
  PROD_BRANCH_VAR="${PROD_BRANCH_VAR:-$PROD_BRANCH}"
  TEST_COMMAND_VAR="${TEST_COMMAND_VAR:-$TEST_COMMAND}"
  PACKAGE_FILE_VAR="${PACKAGE_FILE_VAR:-$PACKAGE_FILE}"
}

# 交互式收集参数
gather_params() {
  echo "请提供以下信息（直接回车使用默认值）："
  read_with_default "  项目名称"    "PROJECT_NAME"    "$DEFAULT_PROJECT_NAME"
  read_with_default "  开发基线分支" "DEFAULT_BRANCH"  "dev"
  read_with_default "  生产分支"     "PROD_BRANCH_VAR" "$PROD_BRANCH"
  read_with_default "  测试命令"     "TEST_COMMAND_VAR" "$TEST_COMMAND"
  read_with_default "  包管理文件"   "PACKAGE_FILE_VAR" "$PACKAGE_FILE"
}

read_with_default() {
  local prompt="$1" var_name="$2" default="$3"
  printf "%s [%s]: " "$prompt" "$default"
  local val; read val
  eval "$var_name=\${val:-\$default}"
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
    echo "如需重新初始化，请先删除："
    echo "  rm -rf $TARGET_DIR/{CLAUDE.md,AI开发与PR流程.md,项目开发规范.md,项目完整链路说明.md,项目文件结构说明.md,docs,governance,.cursor}"
    exit 0
  fi
}

# sed 替换占位符（macOS BSD sed / GNU Linux sed 兼容）
substitute() {
  local file="$1"
  # 先判断 sed 版本：BSD sed（macOS）传给 /dev/null 会报 "unknown option"
  if sed -i '' /dev/null 2>/dev/null; then
    # BSD sed（macOS）：-i 后面必须跟 ''
    sed -i '' \
      -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
      -e "s/{{DEFAULT_BRANCH}}/$DEFAULT_BRANCH/g" \
      -e "s/{{PROD_BRANCH}}/$PROD_BRANCH_VAR/g" \
      -e "s/{{TEST_COMMAND}}/$TEST_COMMAND_VAR/g" \
      -e "s/{{PACKAGE_FILE}}/$PACKAGE_FILE_VAR/g" \
      "$file"
  else
    # GNU sed（Linux）：-i 后面不能有空格
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

# 复制单个文件（支持相对路径自动拼 TARGET_DIR）
copy_one() {
  local src="$1" dst="$2"
  if [[ -f "$src" ]]; then
    # 相对路径基于 SOURCE_DIR，绝对路径直接用
    local abs_src="$src"
    local abs_dst="$dst"
    [[ "$dst" != /* ]] && abs_dst="$TARGET_DIR/$dst"
    mkdir -p "$(dirname "$abs_dst")"
    cp "$abs_src" "$abs_dst"
    substitute "$abs_dst"
    echo "  ✓ $(basename "$dst")"
  else
    echo "  ✗ 跳过（源不存在）: $src" >&2
  fi
}

main() {
  parse_args "$@"

  if [[ -z "$TARGET_DIR" ]]; then
    echo "❌ 错误：未指定目标目录。" >&2
    echo "用法：bash init-governance.sh /path/to/target" >&2
    exit 1
  fi

  # 非参数模式（无 --project 等）走交互流程
  if [[ -z "$PROJECT_NAME" && -z "$PROD_BRANCH_VAR" ]]; then
    echo ""
    echo "=== AI Project Governance 初始化 ==="
    echo "目标目录: $TARGET_DIR"
    gather_params
    print_summary
  else
    apply_defaults
  fi

  check_already_init

  echo "开始复制 governance 文档..."
  mkdir -p "$TARGET_DIR"

  # 根文档（直接复制到目标根目录）
  copy_one "$SOURCE_DIR/docs/CLAUDE.md"              "CLAUDE.md"
  copy_one "$SOURCE_DIR/docs/AI开发与PR流程.md"        "AI开发与PR流程.md"
  copy_one "$SOURCE_DIR/docs/项目开发规范.md"           "项目开发规范.md"
  copy_one "$SOURCE_DIR/docs/项目完整链路说明.md"       "项目完整链路说明.md"
  copy_one "$SOURCE_DIR/docs/项目文件结构说明.md"       "项目文件结构说明.md"

  # 需求分析（复制到目标 docs/ 目录）
  local req_src="$SOURCE_DIR/docs/项目需求分析.md"
  local req_dst="$TARGET_DIR/docs/项目需求分析.md"
  if [[ -f "$req_src" ]]; then
    mkdir -p "$TARGET_DIR/docs"
    cp "$req_src" "$req_dst"
    substitute "$req_dst"
    echo "  ✓ docs/项目需求分析.md"
  fi

  # governance 提案工作区骨架
  mkdir -p "$TARGET_DIR/governance/artifacts"
  echo "  ✓ governance/artifacts/"

  # Cursor Skill（复制到目标 .cursor/skills/）
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
  echo "  1. cd $TARGET_DIR && git init（如果不是 git 项目）"
  echo "  2. 重新打开 Cursor，AI 会自动读取 CLAUDE.md"
  echo "  3. 对 AI 说“初始化项目 governance”验证配置"
}

# ================================================================
# SOURCE_DIR 解析：从远程 curl|bash 管道执行时，
# $0 = "-bash", BASH_SOURCE[0] = "", $PWD 为任意目录。
# 策略：尝试 BASH_SOURCE[0] → 脚本本地存在判断 → 目录回溯搜索
# ================================================================
_resolve_source() {
  local try="${BASH_SOURCE[0]:-$0}"

  # 1. BASH_SOURCE[0] 指向真实文件（直接执行脚本时）
  if [[ -f "$try" && "$try" != "/dev/stdin" && "$try" != "/dev/fd/0" && "$try" != "-bash" ]]; then
    echo "$(cd "$(dirname "$try")/.." && pwd)"
    return
  fi

  # 2. 脚本本地存在判断：直接检查脚本文件是否在当前目录下（本地执行时）
  if [[ -f "${PWD}/scripts/init-governance.sh" ]]; then
    echo "$(cd "${PWD}" && pwd)"
    return
  fi

  # 3. 从 PWD 向上回溯搜索 governance 仓库特征文件
  local dir="$(pwd)"
  while [[ "$dir" != "/" && "$dir" != "$HOME" ]]; do
    if [[ -f "$dir/integrations/cursor/skills/ai-project-governance/SKILL.md" ]]; then
      echo "$dir"
      return
    fi
    dir="$(dirname "$dir")"
  done

  # 4. Linux：尝试 /proc/self/fd/255（bash 255 是 stdin）
  local real_path
  for fd in /proc/self/fd/255 /proc/self/fd/254; do
    if [[ -L "$fd" ]]; then
      real_path="$(readlink -f "$fd" 2>/dev/null)" || continue
      if [[ -f "$real_path" ]]; then
        echo "$(cd "$(dirname "$real_path")/.." && pwd)"
        return
      fi
    fi
  done

  echo ""  # 所有策略失败，返回空
}

SOURCE_DIR="$(_resolve_source)"
unset -f _resolve_source

# 如果 SOURCE_DIR 为空，说明所有路径解析策略都失效，主动报错并退出
if [[ -z "$SOURCE_DIR" ]]; then
  echo "❌ 错误：无法定位 governance 仓库路径。" >&2
  echo "请确保从本地脚本执行，或从包含 governance 仓库的目录运行。" >&2
  exit 1
fi

main "$@"