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

RUN export CFLAGS=-I/usr/include/libffi/include
RUN pip install pyOpenSSL
# copy project

RUN mkdir -p /home/app

# create the app user
RUN addgroup -S app && adduser -S app -G app

# create the appropriate directories
ENV HOME=/home/app
ENV APP_HOME=/home/app/web
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY ./requirements.txt $APP_HOME/requirements.txt
RUN pip install -r requirements.txt
COPY . $APP_HOME


# chown all the files to the app user
RUN chown -R app:app $APP_HOME

# change to the app user
USER app

EXPOSE 8000
ENTRYPOINT ["/home/app/web/app/flaskDemoApp/docker-entrypoint.sh"]
