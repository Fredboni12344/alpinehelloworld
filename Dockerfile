# Grab the latest alpine image
FROM alpine:latest

# Install python, pip, bash, and virtualenv
RUN apk add --no-cache --update python3 py3-pip bash

# Create a virtual environment
RUN python3 -m venv /venv

# Set the virtual environment to be used
ENV PATH="/venv/bin:$PATH"

# Copy the requirements file into the image
ADD ./webapp/requirements.txt /tmp/requirements.txt

# Install dependencies inside the virtual environment
RUN pip install --no-cache-dir -q -r /tmp/requirements.txt

# Add the web application code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Run as non-root user
RUN adduser -D myuser
USER myuser

# Run the app using Gunicorn (on Heroku, this will use the $PORT environment variable)
CMD gunicorn --bind 0.0.0.0:$PORT wsgi

