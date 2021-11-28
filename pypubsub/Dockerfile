from ubuntu:18.04

RUN apt update && apt install -y python3 python3-pip

RUN python3 -m pip install pypubsub

WORKDIR demo

CMD ["python3", "simple.py"]
