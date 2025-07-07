#!/bin/bash
set -e

# ✅ 스크립트가 위치한 디렉토리를 기준으로 루트 디렉토리 찾기
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
echo "$PROJECT_ROOT"
cd "$PROJECT_ROOT"

# 1. Git repository 확인
if [ ! -d ".git" ]; then
  echo "❌ 이 디렉토리는 Git 프로젝트가 아닙니다: $PROJECT_ROOT"
  exit 1
fi

# 2. submodule 초기화
if [ ! -d "./prompts/.git" ]; then
  echo "🌀 submodule 초기 등록 중..."
  git submodule add https://github.com/cashwalk-semin/ClaudePrompt.git prompts
fi

# 3. submodule 최신화
echo "🔄 submodule 최신화 중..."
git submodule update --init --recursive --remote

# 4. 프롬프트 경로 확인
PROMPT_PATH="./prompts/prompt-library/android/code-review.md"
if [ ! -f "$PROMPT_PATH" ]; then
  echo "❌ 프롬프트 파일이 없습니다: $PROMPT_PATH"
  exit 1
fi

# 5. 프롬프트 읽기
PROMPT=$(cat "$PROMPT_PATH")

# 6. Claude 실행
echo "🚀 Claude 실행 중..."
claude code --prompt "$PROMPT" "$@"
