# Parent image
FROM python:3

# Working director in container
WORKDIR /app

# Copy current directory into the container at /app
COPY . /app

# Install any needed dependencies specified in requirements.txt
RUN pip install -r requirements.txt

# Run your bot when the container launches
CMD ["python3", "main.py"]
