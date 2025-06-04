import { createAnthropic } from '@ai-sdk/anthropic';
import { createOpenAI } from '@ai-sdk/openai';
import { CLAUDE_MODELS, LLMProvider } from '@onlook/models';
import { assertNever } from '@onlook/utility';
import { type LanguageModelV1 } from 'ai';

export async function initModel(
    provider: LLMProvider,
    model: CLAUDE_MODELS | string,
): Promise<LanguageModelV1> {
    switch (provider) {
        case LLMProvider.ANTHROPIC:
            return await getAnthropicProvider(model);
        case LLMProvider.LM_STUDIO:
            return await getLMStudioProvider(model);
        default:
            assertNever(provider);
    }
}

async function getAnthropicProvider(model: CLAUDE_MODELS | string): Promise<LanguageModelV1> {
    if (
        typeof model !== 'string' ||
        !Object.values(CLAUDE_MODELS).includes(model as CLAUDE_MODELS)
    ) {
        throw new Error(`Invalid Anthropic model: ${model}`);
    }
    const anthropic = createAnthropic();
    return anthropic(model, {
        cacheControl: true,
    });
}

async function getLMStudioProvider(model: string): Promise<LanguageModelV1> {
    const openai = createOpenAI({
        baseURL: process.env.LM_STUDIO_BASE_URL || 'http://localhost:1234/v1',
        apiKey: process.env.LM_STUDIO_API_KEY || 'none',
    });
    return openai(model);
}
