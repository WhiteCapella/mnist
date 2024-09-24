FROM python:3.11

WORKDIR /code

RUN apt update
RUN apt install -y cron
COPY ml-work-cronjob /etc/cron.d/ml-work-cronjob
RUN crontab /etc/cron.d/ml-work-cronjob

COPY src/mnist/main.py /code/
COPY run.sh /code/run.sh
COPY mnist240924.keras .
COPY src/mnist/worker.py .

RUN pip install --no-cache-dir --upgrade git+https://github.com/WhiteCapella/mnist@0.4.0/models

CMD ["sh", "run.sh"]
CMD ["python", "worker.py"]
