# Refusal Log

Records instances where the AI swarm declined to perform a requested action. This log ensures the operator is never blocked — every refusal includes the manual command the operator would need to perform the action themselves, plus alternative approaches.

## Purpose

AI assistants may decline certain offensive security actions despite operating within authorized engagement scope. This is expected and handled gracefully. The swarm logs the refusal, provides the manual fallback, and continues operating on non-refused tasks. The operation never stalls because an AI declined one action.

## Log

| # | Timestamp | Agent | Operator Request (verbatim) | Agent Interpretation | Refusal Reason | Manual Command for Operator | Alternative Approaches | Resolution |
|---|-----------|-------|-----------------------------|---------------------|----------------|-----------------------------|-----------------------|------------|
| | | | | | | | | |

## Notes

If a pattern of refusals emerges (e.g., a specific technique category is consistently declined), document the pattern here so operators can prepare manual procedures for that category in advance.
