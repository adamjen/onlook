import OpenAI from 'openai';

(async () => {
  const openai = new OpenAI({
    baseURL: 'http://localhost:1234/v1',
    apiKey: 'none',
  });

  try {
    const chatCompletion = await openai.chat.completions.create({
      model: 'local-model',
      messages: [{ role: 'user', content: 'Hello, how are you?' }],
    });

    console.log('LM Studio response:');
    console.log(chatCompletion.choices[0].message.content);
  } catch (error) {
    console.error('Error connecting to LM Studio:');
    console.error(error);
  }
})();