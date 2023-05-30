FROM selenium/standalone-chrome
WORKDIR /src
ENV PYTHONPATH=/src
RUN sudo apt update && sudo apt upgrade -y
RUN sudo apt install python3-pip -y
COPY etl /src/etl
COPY main.py main.py
COPY requirements.txt requirements.txt
COPY config.yml config.yml
RUN pip3 install -r requirements.txt
EXPOSE 4444
CMD ["tail", "-f", "/dev/null"]