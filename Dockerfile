FROM ubuntu:18.04
#folder structure
#/SpacerBackend/
#├── chc-tools
#├── Dockerfile
#├── SpacerProseBackend
#├── pobvis
#│   └── app
#│       ├── exp_db
#│       ├── main.py
#│       ├── media
#│       ├── reinit_db.sh
#│       ├── settings.py
#│       ├── start_server.sh
#│       └── utils
#└── z3s
#install dotnet dep
RUN apt update && apt install -y wget
RUN wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O /opt/packages-microsoft-prod.deb && dpkg -i /opt/packages-microsoft-prod.deb
#install dotnet and other stuffs
RUN apt update && apt install -y vim python3-pip apt-transport-https dotnet-sdk-3.1

#dynamodb iam creds
ENV TABLE_NAME "spacer-visualization"
ENV ACCESS_KEY_ID AKIASOHWIFLXIIGPYLSH
ENV SECRET_ACCESS_KEY 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
ENV REGION_NAME "us-east-2"

COPY ./SpacerProseBackend /SpacerBackend/SpacerProseBackend
COPY ./z3 /SpacerBackend/z3s/NhamZ3
COPY ./pobvis /SpacerBackend/pobvis
COPY ./chc-tools /SpacerBackend/chc-tools

#build dotnet stuff
RUN cd /SpacerBackend/SpacerProseBackend/SpacerTransformationsAPI/SpacerTransformationsAPI && dotnet build

RUN pip3 install -r /SpacerBackend/chc-tools/requirements.txt
RUN pip3 install -r /SpacerBackend/pobvis/requirements.txt
ENV PYTHONPATH "${PYTHONPATH}:/SpacerBackend/chc-tools:/SpacerBackend/z3s/NhamZ3/build/python"
WORKDIR /SpacerBackend/pobvis/app/

