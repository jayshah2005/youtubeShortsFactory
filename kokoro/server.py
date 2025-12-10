# server.py
from fastapi import FastAPI, HTTPException
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
from kokoro import KPipeline
import soundfile as sf
import io
import os
from datetime import datetime

app = FastAPI()

# Initialize Kokoro pipeline with explicit repo_id
pipeline = KPipeline(lang_code='a', repo_id='hexgrad/Kokoro-82M')

# Directory to save generated audio
SAVE_DIR = "/Users/jay/Developer/youtubeShortsWorkflow/n8n_data/audio"
os.makedirs(SAVE_DIR, exist_ok=True)

class TTSRequest(BaseModel):
    text: str
    voice: str = "af_bella"
    speed: float = 1.0

@app.post("/tts")
def tts(req: TTSRequest):
    if not req.text:
        raise HTTPException(status_code=400, detail="Missing 'text'")
    
    # Generate audio
    generator = pipeline(req.text, voice=req.voice, speed=req.speed)
    gs, ps, audio = next(generator)  # first result

    # Safe filename with timestamp
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
    filename = os.path.join(SAVE_DIR, f"{req.voice}_{timestamp}.wav")
    
    # Save to WAV file
    sf.write(filename, audio, 24000, format='WAV')
    
    # Return audio as streaming response
    buf = io.BytesIO()
    sf.write(buf, audio, 24000, format='WAV')
    buf.seek(0)
    return StreamingResponse(buf, media_type="audio/wav")

# Run FastAPI via uvicorn in a way that keeps it alive
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "server:app",
        host="0.0.0.0",
        port=5151,
        reload=False,
        log_level="info"
    )
