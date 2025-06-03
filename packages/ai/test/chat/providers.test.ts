import { describe, expect, test, mock } from 'bun:test';
import { initModel } from '../../src/chat/providers';
import { LLMProvider } from '@onlook/models';

// Mock OpenAI client
mock.module('openai', () => ({
    OpenAI: class {
        chat = {
            completions: {
                create: () =>
                    Promise.resolve({
                        id: 'mock-completion',
                        choices: [{ message: { content: 'Hello world' } }],
                    }),
            },
        };
    },
}));

describe('LLM Providers', () => {
    test('Anthropic provider initializes', async () => {
        const model = await initModel(LLMProvider.ANTHROPIC, 'claude-3-5-haiku-20241022');
        expect(model).toBeDefined();
    });

    test('LM Studio provider initializes', async () => {
        const model = await initModel(LLMProvider.LM_STUDIO, 'qwen3-14b');
        expect(model).toBeDefined();
    });
});
