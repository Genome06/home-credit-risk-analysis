# Use a lightweight and stable Python image
FROM python:3.10-slim

# Install system dependencies needed for LightGBM
RUN apt-get update && apt-get install -y \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /code

# Copy requirements & install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire contents of the project into the container
COPY . .

# Make sure the run.sh script can be executed
RUN chmod +x run.sh

# Hugging Face listens to port 7860 by default
ENV PORT=7860
EXPOSE 7860

# Use a non-root user for security (Hugging Face Standard)
RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

# Run the orchestrator script
CMD ["./run.sh"]