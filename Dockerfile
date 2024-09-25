# 0.5.0 버전 기반 이미지 빌드 (새로운 버전으로 변경)
FROM whitecapella/mnist:0.5.0 AS build

WORKDIR /code

RUN apt update && apt install -y cron
COPY ml-work-cronjob /etc/cron.d/ml-work-cronjob
RUN crontab /etc/cron.d/ml-work-cronjob

COPY src/mnist/main.py /code/
COPY run.sh /code/run.sh
COPY note/mnist240924.keras .

# 0.5.0 버전에 맞는 의존성 설치 (필요한 경우 수정)
RUN pip install --upgrade git+https://github.com/WhiteCapella/mnist@0.5/model 

# 실행 단계
FROM python:3.11

WORKDIR /code

# 빌드 단계에서 필요한 파일만 복사
COPY --from=build /code/main.py /code/
COPY --from=build /code/run.sh /code/
COPY --from=build /code/mnist240924.keras /code/

# cron 서비스 시작 및 foreground 실행
CMD ["cron", "-f"]
