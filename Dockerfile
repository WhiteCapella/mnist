# 빌드 단계
FROM whitecapella/mnist:0.4.0 AS build

WORKDIR /code

RUN apt update && apt install -y cron
COPY ml-work-cronjob /etc/cron.d/ml-work-cronjob
RUN crontab /etc/cron.d/ml-work-cronjob

COPY src/mnist/main.py /code/
COPY run.sh /code/run.sh
COPY note/mnist240924.keras .
COPY src/mnist/worker.py /code/

RUN pip install --no-cache-dir --upgrade git+https://github.com/WhiteCapella/mnist@0.4/model

# 실행 단계
FROM python:3.11

WORKDIR /code

# 빌드 단계에서 필요한 파일만 복사
COPY --from=build /code/main.py /code/
COPY --from=build /code/run.sh /code/
COPY --from=build /code/mnist240924.keras /code/

CMD ["sh", "run.sh"]
CMD ["python", "worker.py"]
