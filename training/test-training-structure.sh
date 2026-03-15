#!/bin/bash
# test-training-structure.sh — Validate training infrastructure completeness
# Run from the Swarnam repository root after copying training files in
# Usage: bash training/test-training-structure.sh

PASS=0
FAIL=0

check() {
    if [ -f "$1" ]; then
        echo "  [PASS] $1"
        ((PASS++))
    else
        echo "  [FAIL] $1 missing"
        ((FAIL++))
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo "  [PASS] $1/"
        ((PASS++))
    else
        echo "  [FAIL] $1/ missing"
        ((FAIL++))
    fi
}

echo "=== Training Infrastructure Structure Validation ==="
echo ""

echo "--- Training Agents ---"
check ".claude/agents/pcap-analyst.md"
check ".claude/agents/training-evaluator.md"
check ".claude/agents/prompt-patcher.md"

echo ""
echo "--- Training Commands ---"
check ".claude/commands/analyze-pcap.md"
check ".claude/commands/training-run.md"
check ".claude/commands/debrief.md"
check ".claude/commands/apply-training.md"
check ".claude/commands/restore-competition.md"

echo ""
echo "--- Training Coordination Files ---"
check "training/PCAP-INTELLIGENCE.md"
check "training/TRAINING-METRICS.md"
check "training/DEBRIEF-QUEUE.md"
check "training/TRAINING-LOG.md"

echo ""
echo "--- Training Coordination Mirrors ---"
check "training/coordination/TARGET-STATUS.md"
check "training/coordination/RECON-FINDINGS.md"
check "training/coordination/PERSISTENCE-MANIFEST.md"
check "training/coordination/BURNED-TECHNIQUES.md"
check "training/coordination/OPERATION-LOG.md"
check "training/coordination/DECISION-LOG.md"
check "training/coordination/REFUSAL-LOG.md"
check "training/coordination/CREDENTIALS.md"

echo ""
echo "--- Training Directories ---"
check_dir "training/patches"
check_dir "training/baselines"
check_dir "training/analysis"

echo ""
echo "--- Baseline Scripts ---"
check "training/baselines/README.md"
check "training/baselines/snapshot-baselines.sh"
check "training/baselines/verify-baselines.sh"
check "training/baselines/diff-baselines.sh"

echo ""
echo "--- Training Agent Validity ---"
for agent in .claude/agents/pcap-analyst.md .claude/agents/training-evaluator.md .claude/agents/prompt-patcher.md; do
    if [ -f "$agent" ]; then
        name=$(basename "$agent")
        # Check YAML frontmatter
        head -1 "$agent" | grep -q "^---" && { echo "  [PASS] $name has frontmatter"; ((PASS++)); } || { echo "  [FAIL] $name missing frontmatter"; ((FAIL++)); }
        # Check name field
        grep -q "^name:" "$agent" && { echo "  [PASS] $name has name field"; ((PASS++)); } || { echo "  [FAIL] $name missing name field"; ((FAIL++)); }
        # Check model field
        grep -q "^model:" "$agent" && { echo "  [PASS] $name has model field"; ((PASS++)); } || { echo "  [FAIL] $name missing model field"; ((FAIL++)); }
        # Check authorization context
        grep -qi "authorization\|authorized\|WRCCDC\|sanctioned" "$agent" && { echo "  [PASS] $name has authorization context"; ((PASS++)); } || { echo "  [FAIL] $name missing authorization context"; ((FAIL++)); }
    fi
done

echo ""
echo "--- Training Command Validity ---"
for cmd in .claude/commands/analyze-pcap.md .claude/commands/training-run.md .claude/commands/debrief.md .claude/commands/apply-training.md .claude/commands/restore-competition.md; do
    if [ -f "$cmd" ]; then
        name=$(basename "$cmd")
        head -1 "$cmd" | grep -q "^---" && { echo "  [PASS] $name has frontmatter"; ((PASS++)); } || { echo "  [FAIL] $name missing frontmatter"; ((FAIL++)); }
        grep -q "^description:" "$cmd" && { echo "  [PASS] $name has description"; ((PASS++)); } || { echo "  [FAIL] $name missing description"; ((FAIL++)); }
        grep -qi "workflow\|step" "$cmd" && { echo "  [PASS] $name has workflow"; ((PASS++)); } || { echo "  [FAIL] $name missing workflow"; ((FAIL++)); }
    fi
done

echo ""
echo "--- Isolation Check ---"
# Verify no competition agent references training agents
CONTAMINATION=0
for agent in .claude/agents/tactical-coordinator.md .claude/agents/recon-specialist.md .claude/agents/initial-access.md .claude/agents/persistence-engineer.md .claude/agents/evasion-specialist.md .claude/agents/lateral-movement.md .claude/agents/intel-reporting.md .claude/agents/payload-engineer.md; do
    if [ -f "$agent" ]; then
        name=$(basename "$agent")
        if grep -qi "TRAIN-001\|TRAIN-002\|TRAIN-003\|pcap-analyst\|training-evaluator\|prompt-patcher" "$agent" 2>/dev/null; then
            echo "  [FAIL] $name references training agents (contamination)"
            ((FAIL++))
            ((CONTAMINATION++))
        fi
    fi
done
if [ $CONTAMINATION -eq 0 ]; then
    echo "  [PASS] No competition agents reference training agents"
    ((PASS++))
fi

# Verify no competition command references training commands
CONTAMINATION=0
for cmd in .claude/commands/start-ops.md .claude/commands/scan-range.md .claude/commands/attack-plan.md .claude/commands/status.md .claude/commands/rotate.md .claude/commands/end-ops.md; do
    if [ -f "$cmd" ]; then
        name=$(basename "$cmd")
        if grep -qi "training-run\|debrief\|apply-training\|analyze-pcap\|restore-competition" "$cmd" 2>/dev/null; then
            echo "  [FAIL] $name references training commands (contamination)"
            ((FAIL++))
            ((CONTAMINATION++))
        fi
    fi
done
if [ $CONTAMINATION -eq 0 ]; then
    echo "  [PASS] No competition commands reference training commands"
    ((PASS++))
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="

if [ $FAIL -eq 0 ]; then
    echo "Training infrastructure is complete and properly isolated."
else
    echo "WARNING: $FAIL checks failed. Review and fix before starting training."
fi
