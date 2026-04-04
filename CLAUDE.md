# ReadingBuddy

AI-powered voice tutor for school students (Class 1–12). Single-file browser apps, no build tools.

## Files

| File | Purpose |
|---|---|
| `index.html` | Budget Mode — main app (Reading, Practice, Answers, Story tabs) |
| `index_live.html` | Live Mode — Gemini Multimodal Live API real-time voice tutor |
| `start.sh` | Serves on `http://localhost:8080` (mic permissions work on localhost) |

Run: `bash start.sh`

## Architecture

- Pure HTML + CSS + JS inline, no frameworks
- PDF.js from CDN for text extraction
- Web Speech API for STT (push-to-talk) and TTS
- All API keys stored in `localStorage`
- Both files share the same `localStorage` — chapter loaded in one is available in the other

## localStorage Keys

| Key | Value |
|---|---|
| `rb_class` | Selected class (1–12) |
| `rb_model` | Selected model ID |
| `rb_gemini-key` | Gemini API key |
| `rb_anthropic-key` | Anthropic API key |
| `rb_openai-key` | OpenAI API key |
| `rb_openrouter-key` | OpenRouter API key |
| `rb_chapter` | Last loaded chapter text |
| `rb_reply-lang` | Default reply language |

## API Routing (`index.html`)

- `gemini-*` → `generativelanguage.googleapis.com/v1beta/models/{model}:generateContent`
- `claude-*` → `api.anthropic.com/v1/messages` (requires `anthropic-dangerous-direct-browser-access: true`)
- `gpt-*` → `api.openai.com/v1/chat/completions`
- `or:*` → `openrouter.ai/api/v1/chat/completions` (strip `or:` prefix for model ID)

## Tabs (`index.html`)

- **Reading** — load chapter (PDF or photos), push-to-talk Q&A grounded to chapter
- **Practice** — AI-generated questions, voice answers, scored with hints
- **Answers** — generate model answers for exercises from chapter
- **Story** — sentence-by-sentence walkthrough with Hindi audio explanation; hover any word for Hindi meaning

## Scanned PDF Handling

PDF.js extracts text from digital PDFs. If extracted text < 20 words, assumes scanned/image PDF and triggers `ocrScannedPdf()`:
- Renders each page to canvas → base64 JPEG
- OCR via Gemini → fallback to OpenAI → fallback to Claude
- 2s delay between pages to avoid free-tier rate limits

## Live Mode (`index_live.html`)

- WebSocket: `wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1alpha.GenerativeService.BidiGenerateContent`
- Model: `models/gemini-3.1-flash-live-preview`
- Mic: 16kHz input (ScriptProcessor Float32→Int16→base64)
- Audio output: 24kHz PCM with `nextPlayTime` queuing
- `speech_config` must be inside `generation_config` (not a sibling)

## Class-Level Prompt Tuning

| Class | Instruction style |
|---|---|
| 1–2 | Extremely simple, 2–3 sentences, daily life examples |
| 3–5 | Simple vocabulary, relatable examples |
| 6–8 | Moderate vocab, explain difficult words |
| 9–10 | Standard vocab, thorough explanations |
| 11–12 | Advanced, technically accurate |
