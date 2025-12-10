# Start from Alpine-based n8n
FROM n8nio/n8n:latest

USER root

# Install Python, pip, dev headers, and build tools
RUN apk add --no-cache \
        python3 \
        py3-pip \
        python3-dev \
        build-base \
        bash \
        curl \
        git \
        ffmpeg \
        libjpeg-turbo-dev \
        zlib-dev \
        libpng-dev \
        freetype-dev \
        lcms2-dev \
        tiff-dev \
        openjpeg-dev \
        libwebp-dev \
        portaudio-dev

# Upgrade pip and install Python packages
RUN python3 -m pip install --break-system-packages --upgrade pip setuptools wheel && \
    pip install --break-system-packages --no-cache-dir \
        moviepy==1.0.3 \
        Pillow==9.5.0 \
        ffmpeg-python

# Switch back to non-root user
USER node

