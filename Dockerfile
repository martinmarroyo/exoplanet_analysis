FROM selenium/standalone-chrome
WORKDIR /src
ENV PYTHONPATH=/src
RUN sudo apt update
RUN sudo apt upgrade -y
RUN sudo apt install python pip -y
COPY etl /src/etl
COPY main.py main.py
COPY requirements.txt requirements.txt
COPY config.yml config.yml
RUN pip install -r requirements.txt
EXPOSE 4444
CMD ["tail", "-f", "/dev/null"]