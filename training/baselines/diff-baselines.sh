#!/bin/bash
# diff-baselines.sh — Show what training changed relative to baselines
# Run from the Swarnam repository root
# Usage: bash training/baselines/diff-baselines.sh [--verbose]

BASELINE_DIR="training/baselines"
CHANGES=0
VERBOSE=0

[ "$1" = "--verbose" ] && VERBOSE=1

echo "=== Training Changes vs. Baselines ==="
echo ""

echo "--- Competition Agents ---"
for baseline in "$BASELINE_DIR"/agents/*.md; do
    [ -f "$baseline" ] || continue
    name=$(basename "$baseline")
    current=".claude/agents/$name"
    if [ -f "$current" ]; then
        DIFF=$(diff "$baseline" "$current" 2>/dev/null)
        if [ -n "$DIFF" ]; then
            ADDITIONS=$(echo "$DIFF" | grep -c "^>" || true)
            REMOVALS=$(echo "$DIFF" | grep -c "^<" || true)
            echo "  [CHANGED] $name (+$ADDITIONS/-$REMOVALS lines)"
            ((CHANGES++))
            if [ $VERBOSE -eq 1 ]; then
                echo "$DIFF" | head -40
                echo "  ..."
                echo ""
            fi
        else
            echo "  [UNCHANGED] $name"
        fi
    else
        echo "  [MISSING] $name — competition file deleted?"
    fi
done

echo ""
echo "--- Competition Commands ---"
for baseline in "$BASELINE_DIR"/commands/*.md; do
    [ -f "$baseline" ] || continue
    name=$(basename "$baseline")
    current=".claude/commands/$name"
    if [ -f "$current" ]; then
        DIFF=$(diff "$baseline" "$current" 2>/dev/null)
        if [ -n "$DIFF" ]; then
            ADDITIONS=$(echo "$DIFF" | grep -c "^>" || true)
            REMOVALS=$(echo "$DIFF" | grep -c "^<" || true)
            echo "  [CHANGED] $name (+$ADDITIONS/-$REMOVALS lines)"
            ((CHANGES++))
            if [ $VERBOSE -eq 1 ]; then
                echo "$DIFF" | head -40
                echo "  ..."
                echo ""
            fi
        else
            echo "  [UNCHANGED] $name"
        fi
    else
        echo "  [MISSING] $name — competition command deleted?"
    fi
done

echo ""
echo "--- Coordination Templates ---"
for baseline in "$BASELINE_DIR"/coordination/*.md; do
    [ -f "$baseline" ] || continue
    name=$(basename "$baseline")
    current="coordination/$name"
    if [ -f "$current" ]; then
        DIFF=$(diff "$baseline" "$current" 2>/dev/null)
        if [ -n "$DIFF" ]; then
            ADDITIONS=$(echo "$DIFF" | grep -c "^>" || true)
            REMOVALS=$(echo "$DIFF" | grep -c "^<" || true)
            echo "  [CHANGED] $name (+$ADDITIONS/-$REMOVALS lines)"
            ((CHANGES++))
            if [ $VERBOSE -eq 1 ]; then
                echo "$DIFF" | head -40
                echo "  ..."
                echo ""
            fi
        else
            echo "  [UNCHANGED] $name"
        fi
    else
        echo "  [MISSING] $name — coordination file deleted?"
    fi
done

echo ""
echo "--- Root Files ---"
for baseline in "$BASELINE_DIR"/root/*; do
    [ -f "$baseline" ] || continue
    name=$(basename "$baseline")
    current=$(echo "$name" | sed 's/_/\//g')
    if [ -f "$current" ]; then
        DIFF=$(diff "$baseline" "$current" 2>/dev/null)
        if [ -n "$DIFF" ]; then
            ADDITIONS=$(echo "$DIFF" | grep -c "^>" || true)
            REMOVALS=$(echo "$DIFF" | grep -c "^<" || true)
            echo "  [CHANGED] $current (+$ADDITIONS/-$REMOVALS lines)"
            ((CHANGES++))
            if [ $VERBOSE -eq 1 ]; then
                echo "$DIFF" | head -40
                echo "  ..."
                echo ""
            fi
        else
            echo "  [UNCHANGED] $current"
        fi
    else
        echo "  [MISSING] $current"
    fi
done

echo ""
echo "=== Summary: $CHANGES files changed by training ==="

if [ $CHANGES -eq 0 ]; then
    echo "No training modifications detected. Competition files match baselines exactly."
else
    echo ""
    echo "To see detailed diffs, re-run with --verbose flag:"
    echo "  bash training/baselines/diff-baselines.sh --verbose"
    echo ""
    echo "Or diff individual files:"
    echo "  diff training/baselines/agents/<file> .claude/agents/<file>"
fi
