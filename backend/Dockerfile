FROM python:3.10

# Avoid .pyc files and enable unbuffered output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory in the container
WORKDIR /app

# Copy backend folder into /app
COPY backend/ .

# Copy the requirements.txt into the container
COPY requirements.txt .

# Install dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Install dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Start the Django app using Gunicorn
CMD ["gunicorn", "mini_netumo.wsgi:application", "--bind", "0.0.0.0:8000"]
