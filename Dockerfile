FROM python:3.9

# Create a folder /app if it doesn't exist,
# the /app folder is the current working directory
WORKDIR /app

RUN apt-get update && apt-get install -y \
    libgomp1 \
 && rm -rf /var/lib/apt/lists/*
 
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy necessary files to our app
COPY main.py .

COPY models ./models
# Set MODEL_DIR env variable
ENV MODEL_PATH /app/models/model.pkl

# Port will be exposed, for documentation only
EXPOSE 30000

# Disable pip cache to shrink the image size a little bit,
# since it does not need to be re-installed

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "30000"]