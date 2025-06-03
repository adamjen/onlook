# System Patterns *Optional*

This file documents recurring patterns and standards used in the project.
[2025-06-03 05:38:34 PM] - Project follows a modular architecture with separate components for client and server. Uses TypeScript for type safety and consistency.
It is optional, but recommended to be updated as the project evolves.
YYYY-MM-DD HH:MM:SS - Log of updates made.

*

## Coding Patterns

*   

## Architectural Patterns

*   

## Testing Patterns

*
[2025-06-03 18:47:23] - Pattern: Extensible LLM Provider Architecture
Description: New providers can be added by:
1. Creating provider function in providers.ts
2. Adding to LLMProvider enum
3. Implementing initModel switch case
4. Adding environment variables