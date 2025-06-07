FROM python:3.10

# Avoid .pyc files and enable unbuffered output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

ENV PYTHONPATH=/app
# Set working directory inside container
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy entire backend source code
# COPY . .
COPY . /app


# Entry point (for backend service)
CMD ["gunicorn", "mini_netumo.wsgi:application", "--bind", "0.0.0.0:8000"]
