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
# 远程用法（推荐）:
#   curl -sSL https://raw.githubusercontent.com/YOUR_USER/ai-project-governance/BRANCH/scripts/init-governance.sh | bash -s /path/to/target
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
  bash init-governance.sh /path/to/target
  bash init-governance.sh --project "MyApp" /path/to/target
  curl -sSL URL | bash -s /path/to/target --project "MyApp"

参数:
  /path/to/target    目标项目目录（必需，最后位置）
  --project NAME     项目名称
  --branch NAME      开发基线分支（默认 dev）
  --prod NAME        生产分支（默认 main）
  --test CMD         测试命令
  --pkg FILE         包管理文件
EOF
}

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
        echo "❌ 未知参数: $1" >&2; exit 1 ;;
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
    echo "如需重新初始化，请先删除 governance 文档"
    exit 0
  fi
}

# sed 替换（macOS BSD sed / GNU Linux sed 兼容）
substitute() {
  local file="$1"
  if sed -i '' /dev/null 2>/dev/null; then
    sed -i '' \
      -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
      -e "s/{{DEFAULT_BRANCH}}/$DEFAULT_BRANCH/g" \
      -e "s/{{PROD_BRANCH}}/$PROD_BRANCH_VAR/g" \
      -e "s/{{TEST_COMMAND}}/$TEST_COMMAND_VAR/g" \
      -e "s/{{PACKAGE_FILE}}/$PACKAGE_FILE_VAR/g" \
      "$file"
  else
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

# 复制单个文件
copy_one() {
  local src="$1" dst="$2"
  if [[ -f "$src" ]]; then
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    substitute "$dst"
    echo "  ✓ $(basename "$dst")"
  fi
}

main() {
  parse_args "$@"

  if [[ -z "$TARGET_DIR" ]]; then
    echo "❌ 错误：未指定目标目录。用法：bash init-governance.sh /path/to/target" >&2
    exit 1
  fi

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

  # ------------------------------------------------------------
  # 核心：解析 SOURCE_DIR
  # 从 curl|bash 管道执行时 $0=-bash, PWD 为任意目录。
  # 策略：检查本地脚本是否存在 → PWD 回溯搜索 → /proc fd
  # ------------------------------------------------------------
  _resolve_source_dir() {
    local try="${BASH_SOURCE[0]:-$0}"
    # 1. BASH_SOURCE[0] 指向真实文件
    if [[ -f "$try" && "$try" != "/dev/stdin" && "$try" != "/dev/fd/0" && "$try" != "-bash" ]]; then
      echo "$(cd "$(dirname "$try")/.." && pwd)"; return
    fi
    # 2. 本地执行时 PWD 下脚本存在
    if [[ -f "${PWD}/scripts/init-governance.sh" ]]; then
      echo "$(cd "$PWD" && pwd)"; return
    fi
    # 3. 从 PWD 向上回溯（只搜到 $HOME 或 /）
    local dir="$(pwd)"
    while [[ "$dir" != "/" && "$dir" != "$HOME" ]]; do
      if [[ -f "$dir/integrations/cursor/skills/ai-project-governance/SKILL.md" ]]; then
        echo "$dir"; return
      fi
      dir="$(dirname "$dir")"
    done
    # 4. Linux /proc/self/fd/255
    for fd in /proc/self/fd/255 /proc/self/fd/254; do
      if [[ -L "$fd" ]]; then
        local rp="$(readlink -f "$fd" 2>/dev/null)" || continue
        if [[ -f "$rp" ]]; then
          echo "$(cd "$(dirname "$rp")/.." && pwd)"; return
        fi
      fi
    done
    echo ""
  }

  local src_dir
  src_dir="$(_resolve_source_dir)"
  unset -f _resolve_source_dir

  if [[ -z "$src_dir" ]]; then
    echo "❌ 错误：无法定位 governance 仓库路径。" >&2
    exit 1
  fi

  # 复制根文档
  copy_one "$src_dir/docs/CLAUDE.md"              "$TARGET_DIR/CLAUDE.md"
  copy_one "$src_dir/docs/AI开发与PR流程.md"        "$TARGET_DIR/AI开发与PR流程.md"
  copy_one "$src_dir/docs/项目开发规范.md"           "$TARGET_DIR/项目开发规范.md"
  copy_one "$src_dir/docs/项目完整链路说明.md"       "$TARGET_DIR/项目完整链路说明.md"
  copy_one "$src_dir/docs/项目文件结构说明.md"       "$TARGET_DIR/项目文件结构说明.md"

  # 需求分析
  if [[ -f "$src_dir/docs/项目需求分析.md" ]]; then
    mkdir -p "$TARGET_DIR/docs"
    cp "$src_dir/docs/项目需求分析.md" "$TARGET_DIR/docs/项目需求分析.md"
    substitute "$TARGET_DIR/docs/项目需求分析.md"
    echo "  ✓ docs/项目需求分析.md"
  fi

  # governance 工作区骨架
  mkdir -p "$TARGET_DIR/governance/artifacts"
  echo "  ✓ governance/artifacts/"

  # Cursor Skill
  if [[ -d "$src_dir/integrations/cursor/skills/ai-project-governance" ]]; then
    mkdir -p "$TARGET_DIR/.cursor/skills"
    cp -r "$src_dir/integrations/cursor/skills/ai-project-governance" \
          "$TARGET_DIR/.cursor/skills/ai-project-governance"
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

main "$@"