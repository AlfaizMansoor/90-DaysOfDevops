# This is test docker file for docker compose

FROM python:3.10-slim

WORKDIR /app

RUN pip install --no-cache-dir flask mysql-connector-python redis

COPY app.py /app/

EXPOSE 80

CMD ["python", "app.py"]
