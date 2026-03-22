# Training Baselines — Pre-Training Agent Snapshots

Purpose: this directory stores verbatim copies of all competition agent prompts, coordination file templates, and command definitions as they existed before any training modifications began. The /restore-competition command diffs current files against these baselines to show exactly what training changed, enabling the operator to verify that only intentional improvements were retained.

---

## When to Snapshot

Take a baseline snapshot once, before the first training run. Specifically, after the Swarnam swarm has been generated and validated (Test Suite Categories 1-3 pass), but before any /training-run or /analyze-pcap output has been incorporated into competition agent prompts. This captures the "virgin" state of the swarm.

If baselines already exist and you need to re-snapshot (e.g., after a major regeneration of the swarm), rename the existing baselines directory to baselines-YYYYMMDD-archive/ first, then take a fresh snapshot.

---

## Snapshot Script

Run this script from the Swarnam repository root to capture baselines:

```bash
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
    # Preserve the README and this script
    cp "${BASELINE_DIR}-archive-${TIMESTAMP}/README.md" "$BASELINE_DIR/" 2>/dev/null || true
    cp "${BASELINE_DIR}-archive-${TIMESTAMP}/snapshot-baselines.sh" "$BASELINE_DIR/" 2>/dev/null || true
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
        # Preserve directory structure for settings.json
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

To see all changes across all agents:

\`\`\`bash
for agent in training/baselines/agents/*.md; do
    name=\$(basename "\$agent")
    echo "=== \$name ==="
    diff "\$agent" ".claude/agents/\$name" || true
    echo ""
done
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
```

---

## Verification Script

After snapshotting, run this verification to confirm all expected files were captured:

```bash
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
        # Verify it's not empty
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
```

---

## Diff Script

Use this to see a summary of all training-induced changes across competition files:

```bash
#!/bin/bash
# diff-baselines.sh — Show what training changed relative to baselines
# Run from the Swarnam repository root
# Usage: bash training/baselines/diff-baselines.sh

BASELINE_DIR="training/baselines"
CHANGES=0

echo "=== Training Changes vs. Baselines ==="
echo ""

echo "--- Competition Agents ---"
for baseline in "$BASELINE_DIR"/agents/*.md; do
    name=$(basename "$baseline")
    current=".claude/agents/$name"
    if [ -f "$current" ]; then
        DIFF=$(diff "$baseline" "$current" 2>/dev/null)
        if [ -n "$DIFF" ]; then
            ADDITIONS=$(echo "$DIFF" | grep -c "^>" || true)
            REMOVALS=$(echo "$DIFF" | grep -c "^<" || true)
            echo "  [CHANGED] $name (+$ADDITIONS/-$REMOVALS lines)"
            ((CHANGES++))
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
    name=$(basename "$baseline")
    current=".claude/commands/$name"
    if [ -f "$current" ]; then
        DIFF=$(diff "$baseline" "$current" 2>/dev/null)
        if [ -n "$DIFF" ]; then
            ADDITIONS=$(echo "$DIFF" | grep -c "^>" || true)
            REMOVALS=$(echo "$DIFF" | grep -c "^<" || true)
            echo "  [CHANGED] $name (+$ADDITIONS/-$REMOVALS lines)"
            ((CHANGES++))
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
    name=$(basename "$baseline")
    current="coordination/$name"
    if [ -f "$current" ]; then
        DIFF=$(diff "$baseline" "$current" 2>/dev/null)
        if [ -n "$DIFF" ]; then
            ADDITIONS=$(echo "$DIFF" | grep -c "^>" || true)
            REMOVALS=$(echo "$DIFF" | grep -c "^<" || true)
            echo "  [CHANGED] $name (+$ADDITIONS/-$REMOVALS lines)"
            ((CHANGES++))
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
    name=$(basename "$baseline")
    # Reverse the filename transformation
    current=$(echo "$name" | sed 's/_/\//g')
    if [ -f "$current" ]; then
        DIFF=$(diff "$baseline" "$current" 2>/dev/null)
        if [ -n "$DIFF" ]; then
            ADDITIONS=$(echo "$DIFF" | grep -c "^>" || true)
            REMOVALS=$(echo "$DIFF" | grep -c "^<" || true)
            echo "  [CHANGED] $current (+$ADDITIONS/-$REMOVALS lines)"
            ((CHANGES++))
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
    echo "Run 'diff training/baselines/agents/<file> .claude/agents/<file>' for detailed diffs."
fi
```

---

## Directory Structure After Snapshot

After running the snapshot script, this directory should contain:

```
training/baselines/
├── README.md              ← this file
├── MANIFEST.md            ← auto-generated snapshot manifest
├── snapshot-baselines.sh  ← the snapshot script
├── verify-baselines.sh    ← the verification script
├── diff-baselines.sh      ← the diff summary script
├── agents/
│   ├── tactical-coordinator.md
│   ├── recon-specialist.md
│   ├── initial-access.md
│   ├── persistence-engineer.md
│   ├── evasion-specialist.md
│   ├── lateral-movement.md
│   ├── intel-reporting.md
│   └── payload-engineer.md
├── commands/
│   ├── start-ops.md
│   ├── scan-range.md
│   ├── attack-plan.md
│   ├── status.md
│   ├── rotate.md
│   └── end-ops.md
├── coordination/
│   ├── TARGET-STATUS.md
│   ├── RECON-FINDINGS.md
│   ├── PERSISTENCE-MANIFEST.md
│   ├── BURNED-TECHNIQUES.md
│   ├── OPERATION-LOG.md
│   ├── DECISION-LOG.md
│   ├── REFUSAL-LOG.md
│   └── CREDENTIALS.md
└── root/
    ├── CLAUDE.md
    ├── COMPETITION-AUTHORIZATION.md
    └── .claude_settings.json
```
