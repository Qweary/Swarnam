#!/bin/bash
# verify-baselines.sh — Verify baseline snapshot completeness
# Run from the Swarnam repository root
# Usage: bash training/baselines/verify-baselines.sh

BASELINE_DIR="training/baselines"
PASS=0
FAIL=0

echo "=== Baseline Verification ==="

check_baseline() {
    local source="$1"
    local baseline="$2"
    if [ -f "$baseline" ]; then
        if [ -s "$baseline" ]; then
            echo "  [PASS] $baseline"
            ((PASS++))
        else
            echo "  [FAIL] $baseline exists but is empty"
            ((FAIL++))
        fi
    else
        echo "  [FAIL] $baseline missing (source: $source)"
        ((FAIL++))
    fi
}

echo "Competition agents:"
for agent in .claude/agents/*.md; do
    name=$(basename "$agent")
    case "$name" in
        pcap-analyst.md|training-evaluator.md|prompt-patcher.md) continue ;;
    esac
    check_baseline "$agent" "$BASELINE_DIR/agents/$name"
done

echo ""
echo "Competition commands:"
for cmd in .claude/commands/*.md; do
    name=$(basename "$cmd")
    case "$name" in
        analyze-pcap.md|training-run.md|debrief.md|apply-training.md|restore-competition.md) continue ;;
    esac
    check_baseline "$cmd" "$BASELINE_DIR/commands/$name"
done

echo ""
echo "Coordination templates:"
for coord in coordination/*.md; do
    name=$(basename "$coord")
    check_baseline "$coord" "$BASELINE_DIR/coordination/$name"
done

echo ""
echo "Root files:"
for root_file in CLAUDE.md COMPETITION-AUTHORIZATION.md; do
    target_name=$(echo "$root_file" | tr '/' '_')
    check_baseline "$root_file" "$BASELINE_DIR/root/$target_name"
done
check_baseline ".claude/settings.json" "$BASELINE_DIR/root/.claude_settings.json"

echo ""
echo "Manifest:"
[ -f "$BASELINE_DIR/MANIFEST.md" ] && { echo "  [PASS] MANIFEST.md exists"; ((PASS++)); } || { echo "  [FAIL] MANIFEST.md missing"; ((FAIL++)); }

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [ $FAIL -eq 0 ]; then
    echo "Baselines are complete. Training can begin."
else
    echo "WARNING: $FAIL baselines missing or empty. Re-run snapshot-baselines.sh."
fi
