# LM Studio API Client Integration

## 1. Overview
Integration of LM Studio's API client into the existing AI provider infrastructure to enable local model hosting capabilities.

## 2. Architectural Decisions (ADR)
### Decision
Use LM Studio's REST API for local model inference instead of cloud-based providers when available.

### Rationale
- Lower latency for local development
- Reduced cloud costs
- Better privacy for sensitive data
- Compatible with existing provider interface

### Consequences
- Requires local LM Studio instance running
- Additional configuration needed
- Limited to models supported by LM Studio

## 3. Implementation Plan
### Current State Analysis
Current provider system in `packages/ai/src/chat/providers.ts` supports:
- OpenAI
- Anthropic
- Replicate
- Custom HTTP endpoints

### Proposed Changes
1. Add new `LMStudioProvider` class implementing `BaseProvider` interface
2. Extend provider registry to detect local LM Studio instances
3. Add configuration options for:
   - API base URL
   - Default model
   - Request timeouts

### Impact Analysis
| Component | Impact Level | Notes |
|-----------|--------------|-------|
| Provider System | High | New provider type |
| Configuration | Medium | New env vars |
| UI | Low | No changes needed |

## 4. Configuration Requirements
### Environment Variables
| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| LM_STUDIO_URL | string | No | http://localhost:1234 | Base API URL |
| LM_STUDIO_MODEL | string | No | local-model | Default model name |
| LM_STUDIO_TIMEOUT | number | No | 30000 | Request timeout in ms |

## 5. Version Compatibility
| Component | Current Version | Minimum Version | Notes |
|-----------|-----------------|-----------------|-------|
| LM Studio | 0.2.10 | 0.2.8 | API stability |
| Node.js | 18.0.0 | 16.0.0 | Fetch API required |
| TypeScript | 5.0.0 | 4.9.0 | Type definitions |

## 6. Approval Status
| Reviewer | Status | Date | Notes |
|----------|--------|------|-------|
|          |        |      |       |