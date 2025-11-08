# Use Python 3.11 slim image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY app.py .
COPY hashed_RB.pkl .
COPY Banner_RB.jpg .
COPY DS1_RB.jpg .
COPY Feild_Trial_RB.jpg .
COPY metrics_RB.jpg .
COPY metrics1_RB.jpg .

# Create streamlit config directory and configure
RUN mkdir -p /root/.streamlit && \
    echo "\
[server]\n\
headless = true\n\
port = 8080\n\
enableCORS = false\n\
enableXsrfProtection = false\n\
\n\
[browser]\n\
gatherUsageStats = false\n\
" > /root/.streamlit/config.toml

# Expose port 8080 (Cloud Run default)
EXPOSE 8080

# Run Streamlit
CMD ["streamlit", "run", "app.py", "--server.port=8080", "--server.address=0.0.0.0"]

