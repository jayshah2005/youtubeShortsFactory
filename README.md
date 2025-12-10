# YouTube Shorts Workflow Automation

An automated workflow system for creating YouTube Shorts content using AI-powered image/video generation and text-to-speech synthesis.

## Overview

This project automates the creation of YouTube Shorts by integrating multiple AI services:
- **ComfyUI**: Generates images and videos using Stable Diffusion models
- **Kokoro**: Converts text to high-quality speech using an 82M parameter TTS model
- **n8n**: Orchestrates the workflow automation between services

## Technologies Used

- **Python**: Core language for services
- **ComfyUI**: Visual AI engine for image/video generation (Stable Diffusion)
- **Kokoro**: Lightweight TTS model for text-to-speech conversion
- **n8n**: Workflow automation platform
- **FastAPI**: REST API for Kokoro TTS service
- **Bash**: Scripting for service orchestration

## Project Structure

```
youtubeShortsWorkflow/
├── ComfyUI/          # AI image/video generation service (port 8188)
├── kokoro/           # Text-to-speech service (port 5151)
├── n8n_data/         # Workflow data and outputs
├── logs/             # Service logs
└── start_all.sh      # Launches all services
```

## How to Use

### Prerequisites

- Python 3.9+ 
- macOS (for the start script) or modify for your OS
- GPU recommended for ComfyUI (can run on CPU but slower)

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd youtubeShortsWorkflow
   ```

2. **Set up ComfyUI**
   ```bash
   cd ComfyUI
   pip install -r requirements.txt
   # Add your Stable Diffusion models to models/checkpoints/
   ```

3. **Set up Kokoro**
   ```bash
   cd kokoro
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install kokoro fastapi uvicorn soundfile
   ```

4. **Configure n8n** (if using)
   - Set up n8n workflows to call ComfyUI API (port 8188) and Kokoro API (port 5151)
   - Configure workflow triggers and automation logic

### Running the Services

**Option 1: Start all services at once (macOS)**
```bash
./start_all.sh
```

**Option 2: Start services individually**

Start ComfyUI:
```bash
cd ComfyUI
python main.py --listen --port 8188
```

Start Kokoro TTS:
```bash
cd kokoro
source venv/bin/activate
python server.py
```

### Using the APIs

**Kokoro TTS API** (port 5151):
```bash
curl -X POST http://localhost:5151/tts \
  -H "Content-Type: application/json" \
  -d '{"text": "Hello, this is a test", "voice": "af_bella", "speed": 1.0}'
```

**ComfyUI API** (port 8188):
- Access the web interface at `http://localhost:8188`
- Use the API endpoints documented in ComfyUI for programmatic access

## What I Learned

- **API Integration**: Built REST APIs to connect multiple AI services together
- **Service Orchestration**: Learned to coordinate multiple services running simultaneously
- **AI Workflows**: Gained experience with Stable Diffusion for content generation and modern TTS models
- **Automation**: Explored workflow automation patterns using n8n for connecting services
- **System Design**: Designed a modular architecture where each service can run independently
- **DevOps**: Created startup scripts and logging infrastructure for managing multiple services

## Notes

- ComfyUI outputs are saved to `n8n_data/ComfyUI_Output/`
- Kokoro audio files are saved to `n8n_data/audio/`
- Service logs are stored in the `logs/` directory
- The `extra_model_paths.yaml` file configures ComfyUI model paths

## License

This project uses open-source components:
- ComfyUI: GPL-3.0 License
- Kokoro: Apache-2.0 License

