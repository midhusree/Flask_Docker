# pull official base image
FROM python:3.8.0-alpine
# set work directory
WORKDIR /usr/src/app
# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev libffi-dev
# install dependencies
RUN pip install --upgrade pip
COPY ./requirements.txt /usr/src/app/requirements.txt
RUN export CFLAGS=-I/usr/include/libffi/include
RUN pip install pyOpenSSL
RUN pip install -r requirements.txt
# copy project
COPY . /usr/src/app/
EXPOSE 8000
RUN ls -la app/
ENTRYPOINT ["app/flaskDemoApp/docker-entrypoint.sh"]
