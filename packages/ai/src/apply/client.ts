interface LLMClient {
    chat: {
        completions: {
            create: (params: any) => Promise<any>;
        };
    };
}

const createPrompt = (originalCode: string, updateSnippet: string) => `<code>${originalCode}</code>
<update>${updateSnippet}</update>`;

export class FastApplyClient {
    protected client: LLMClient;

    constructor(apiKey: string, client?: LLMClient) {
        if (client) {
            this.client = client;
        } else {
            const openai = new (require('openai').OpenAI)({
                apiKey,
                baseURL: 'https://api.morphllm.com/v1',
            });
            this.client = openai;
        }
    }

    async applyCodeChange(originalCode: string, updateSnippet: string): Promise<string | null> {
        const response = await this.client.chat.completions.create({
            model: 'morph-v2',
            messages: [
                {
                    role: 'user',
                    content: createPrompt(originalCode, updateSnippet),
                },
            ],
        });
        return response.choices[0]?.message.content || null;
    }
}
