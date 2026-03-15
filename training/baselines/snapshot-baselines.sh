#!/bin/bash
# snapshot-baselines.sh — Capture pre-training baselines for all competition files
# Run from the Swarnam repository root before any training modifications
# Usage: bash training/baselines/snapshot-baselines.sh

set -e

BASELINE_DIR="training/baselines"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

echo "=== Swarnam Baseline Snapshot ==="
echo "Timestamp: $TIMESTAMP"
echo ""

# Check we're in the right place
if [ ! -f "CLAUDE.md" ] || [ ! -d ".claude/agents" ]; then
    echo "ERROR: Run this script from the Swarnam repository root."
    echo "Expected to find CLAUDE.md and .claude/agents/ in the current directory."
    exit 1
fi

# Check if baselines already exist
if [ -d "$BASELINE_DIR/agents" ] || [ -d "$BASELINE_DIR/commands" ] || [ -d "$BASELINE_DIR/coordination" ]; then
    echo "WARNING: Baselines already exist in $BASELINE_DIR/"
    echo "Existing baselines will be archived to ${BASELINE_DIR}-archive-${TIMESTAMP}/"
    mv "$BASELINE_DIR" "${BASELINE_DIR}-archive-${TIMESTAMP}"
    mkdir -p "$BASELINE_DIR"
    # Preserve the README and scripts
    cp "${BASELINE_DIR}-archive-${TIMESTAMP}/README.md" "$BASELINE_DIR/" 2>/dev/null || true
    cp "${BASELINE_DIR}-archive-${TIMESTAMP}/snapshot-baselines.sh" "$BASELINE_DIR/" 2>/dev/null || true
    cp "${BASELINE_DIR}-archive-${TIMESTAMP}/verify-baselines.sh" "$BASELINE_DIR/" 2>/dev/null || true
    cp "${BASELINE_DIR}-archive-${TIMESTAMP}/diff-baselines.sh" "$BASELINE_DIR/" 2>/dev/null || true
fi

# Create baseline subdirectories
mkdir -p "$BASELINE_DIR/agents"
mkdir -p "$BASELINE_DIR/commands"
mkdir -p "$BASELINE_DIR/coordination"
mkdir -p "$BASELINE_DIR/root"

echo "Snapshotting competition agents..."
AGENT_COUNT=0
for agent in .claude/agents/*.md; do
    name=$(basename "$agent")
    # Skip training agents — only baseline competition agents
    case "$name" in
        pcap-analyst.md|training-evaluator.md|prompt-patcher.md)
            echo "  [SKIP] $name (training agent)"
            continue
            ;;
    esac
    cp "$agent" "$BASELINE_DIR/agents/$name"
    echo "  [OK] $name"
    ((AGENT_COUNT++))
done
echo "  Captured $AGENT_COUNT competition agent baselines."
echo ""

echo "Snapshotting competition commands..."
CMD_COUNT=0
for cmd in .claude/commands/*.md; do
    name=$(basename "$cmd")
    # Skip training commands — only baseline competition commands
    case "$name" in
        analyze-pcap.md|training-run.md|debrief.md|apply-training.md|restore-competition.md)
            echo "  [SKIP] $name (training command)"
            continue
            ;;
    esac
    cp "$cmd" "$BASELINE_DIR/commands/$name"
    echo "  [OK] $name"
    ((CMD_COUNT++))
done
echo "  Captured $CMD_COUNT competition command baselines."
echo ""

echo "Snapshotting coordination file templates..."
COORD_COUNT=0
for coord in coordination/*.md; do
    name=$(basename "$coord")
    cp "$coord" "$BASELINE_DIR/coordination/$name"
    echo "  [OK] $name"
    ((COORD_COUNT++))
done
echo "  Captured $COORD_COUNT coordination file baselines."
echo ""

echo "Snapshotting root configuration files..."
ROOT_COUNT=0
for root_file in CLAUDE.md COMPETITION-AUTHORIZATION.md .claude/settings.json; do
    if [ -f "$root_file" ]; then
        target_name=$(echo "$root_file" | tr '/' '_')
        cp "$root_file" "$BASELINE_DIR/root/$target_name"
        echo "  [OK] $root_file"
        ((ROOT_COUNT++))
    else
        echo "  [MISS] $root_file (not found)"
    fi
done
echo "  Captured $ROOT_COUNT root file baselines."
echo ""

# Write manifest
MANIFEST="$BASELINE_DIR/MANIFEST.md"
cat > "$MANIFEST" << EOF
# Baseline Manifest

Snapshot taken: $TIMESTAMP
Repository state at snapshot: $(git rev-parse --short HEAD 2>/dev/null || echo "not a git repo")

## Files Captured

Competition agents: $AGENT_COUNT
Competition commands: $CMD_COUNT
Coordination file templates: $COORD_COUNT
Root configuration files: $ROOT_COUNT
Total files: $((AGENT_COUNT + CMD_COUNT + COORD_COUNT + ROOT_COUNT))

## File Listing

### Agents
$(ls -1 "$BASELINE_DIR/agents/" 2>/dev/null | sed 's/^/- /')

### Commands
$(ls -1 "$BASELINE_DIR/commands/" 2>/dev/null | sed 's/^/- /')

### Coordination Templates
$(ls -1 "$BASELINE_DIR/coordination/" 2>/dev/null | sed 's/^/- /')

### Root Files
$(ls -1 "$BASELINE_DIR/root/" 2>/dev/null | sed 's/^/- /')

## Usage

The /restore-competition command diffs current competition files against these
baselines to show exactly what training changed. To manually diff a specific file:

\`\`\`bash
diff training/baselines/agents/initial-access.md .claude/agents/initial-access.md
\`\`\`
EOF

echo "Manifest written to $MANIFEST"
echo ""
echo "=== Baseline Snapshot Complete ==="
echo "Total files captured: $((AGENT_COUNT + CMD_COUNT + COORD_COUNT + ROOT_COUNT))"
echo "Baselines stored in: $BASELINE_DIR/"
echo ""
echo "You can now safely begin training runs. The /restore-competition command"
echo "will use these baselines to verify what training changed."
