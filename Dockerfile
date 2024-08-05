# Use the official Python 3.8 slim image as the base image
FROM python:3.8-slim AS flask-build

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Build the Nginx container
FROM nginx:alpine

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the Flask application from the previous stage
COPY --from=flask-build /app /app

# Expose port 80
EXPOSE 80

# Set the working directory
WORKDIR /app

# Run the Flask app using gunicorn
RUN pip install gunicorn
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "inference:app"]
