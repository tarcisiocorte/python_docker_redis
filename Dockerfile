# Use an official Python runtime as a parent image
FROM python:3.7.6-buster

ENV SERVICE_NAME=bootstrap-py \
    SERVICE_DESC='Boostrap project for Python based services' \
    SERVICE_TAGS='local,local-test,sens8,sensefinity-bootstrap-py,bootstrap-py' \
    SERVICE_CHECK_ENDPOINT='/' \
    SERVICE_CHECK_INTERVAL=10s \
    SERVICE_CHECK_TIMEOUT=2s \
    SERVICE_WEATHERAPI_CONFIG='[{"type":"owm","owm_list":[{"domain": "https://api.openweathermap.org", "path":"/data/2.5/weather", "args":"?units=metric&appid=244df0cbb2bcae2bca2fbe929ae3a613","key":"244df0cbb2bcae2bca2fbe929ae3a613"}]}]' \
    NODE_ENV=dev


# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD ./app /app

# Copy the requirements into the container at /etc
COPY ./requirements.txt /etc

RUN pip install --upgrade pip

# Install any needed packages specified in requirements.txt
RUN pip install -r /etc/requirements.txt

# Make port 5656 available to the world outside this container
EXPOSE 5656

# Define environment variable
ENV NAME World

RUN apt-get update \
  && apt-get install \
    bash wget curl \
    inotify-tools -y

RUN ["chmod", "+x", "/app/init.dev.sh"]

CMD ["python", "api.py"]
