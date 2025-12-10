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
youtubeShortsFactory/
├── ComfyUI/          # AI image/video generation service (port 8188)
├── kokoro/           # Text-to-speech service (port 5151)
├── n8n_data/         # n8n workflow data (includes pre-configured "Automatic YT Shorts" workflow)
├── logs/             # Service logs
├── docker-compose.yml # Docker Compose configuration for n8n
├── Dockerfile         # Dockerfile for n8n with Python dependencies
├── .env.example      # Environment variables template
└── start_all.sh      # Launches ComfyUI and Kokoro services (macOS)
```

## How to Use

### Prerequisites

- **For Docker setup**: Docker and Docker Compose
- **For local setup**: Python 3.9+, macOS (for the start script) or modify for your OS
- GPU recommended for ComfyUI (can run on CPU but slower)

## Quick Start with Docker (Recommended)

The easiest way to get started is using Docker, which includes the pre-configured n8n workflow.

### Docker Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd youtubeShortsFactory
   ```

2. **Create environment file** (optional)
   
   Create a `.env` file in the root directory if you want to customize n8n settings:
   ```bash
   # n8n Configuration (optional)
   N8N_HOST=localhost
   N8N_PROTOCOL=http
   WEBHOOK_URL=http://localhost:5678/
   ```
   
   **Note**: The `.env` file is optional. If you don't create it, n8n will use default settings.

3. **Build and start n8n container**
   ```bash
   docker-compose up -d --build
   ```

4. **Access n8n and create your account**
   - Open your browser to `http://localhost:5678`
   - On first access, you'll see a signup page - create your account with your email and password
   - After signing up, you'll be logged in automatically
   - The "Automatic YT Shorts" workflow is pre-loaded and ready to use!

5. **Start ComfyUI and Kokoro services** (required for the workflow to function)
   
   **Option A: Using the start script (macOS)**
   ```bash
   ./start_all.sh
   ```
   
   **Option B: Manual start**
   
   Start ComfyUI:
   ```bash
   cd ComfyUI
   python main.py --listen --port 8188
   ```
   
   Start Kokoro TTS (in a new terminal):
   ```bash
   cd kokoro
   python -m venv venv
   source venv/bin/activate
   pip install kokoro fastapi uvicorn soundfile
   python server.py
   ```

6. **Activate the workflow**
   - In n8n, open the "Automatic YT Shorts" workflow
   - Click the "Active" toggle to enable it
   - The workflow will automatically orchestrate ComfyUI and Kokoro to create YouTube Shorts

**Note**: The `n8n_data` directory contains the pre-configured workflow database. When you mount it to the Docker container, the workflow is automatically available.

**Useful Docker commands:**
- Stop n8n: `docker-compose down`
- View logs: `docker-compose logs -f`
- Restart n8n: `docker-compose restart`
- Rebuild after changes: `docker-compose up -d --build`

### Local Setup (Without Docker)

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd youtubeShortsFactory
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

4. **Set up n8n** (optional, if you want to use the workflow)
   - Install n8n: `npm install n8n -g`
   - Copy the `n8n_data` directory to your n8n data location
   - Start n8n: `n8n start`
   - Access at `http://localhost:5678`

### Running the Services

**If using Docker for n8n:**
1. Start n8n: `docker-compose up -d`
2. Start ComfyUI and Kokoro using one of the options below

**Option 1: Start ComfyUI and Kokoro at once (macOS)**
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

- **Pre-configured Workflow**: The `n8n_data/database.sqlite` file contains the "Automatic YT Shorts" workflow. When you mount this volume to the Docker container, the workflow is automatically available.
- **Outputs**: 
  - ComfyUI outputs are saved to `n8n_data/ComfyUI_Output/`
  - Kokoro audio files are saved to `n8n_data/audio/`
- **Logs**: Service logs are stored in the `logs/` directory
- **Configuration**: The `extra_model_paths.yaml` file configures ComfyUI model paths
- **Docker**: The Docker setup includes Python and video processing dependencies (ffmpeg, moviepy) needed for the workflow

## License

This project uses open-source components:
- ComfyUI: GPL-3.0 License
- Kokoro: Apache-2.0 License

