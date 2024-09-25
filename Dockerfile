FROM datamario24/py311tf:0.1.1

WORKDIR /code

RUN apt update
RUN apt install -y cron
COPY ml-work-cronjob /etc/cron.d/ml-work-cronjob
RUN crontab /etc/cron.d/ml-work-cronjob

COPY src/mnist/main.py /code/
COPY src/mnist/worker.py /code/
COPY run.sh /code/run.sh


RUN pip install --no-cache-dir --upgrade git+https://github.com/WhiteCapella/mnist.git@0.5/line

CMD ["sh", "run.sh"]
CMD ["python", "worker.py"]
