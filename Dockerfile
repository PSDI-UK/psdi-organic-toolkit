#
# Dockerfile for image containerising PSDI Organic Toolkit
#
#
# Building the image
# ------------------
#
# 1. Download the service repo containing the source code
#    from https://github.com/PSDI-UK/organic-toolkit-hub/tree/main
# 2. Copy this file into the main directory of the repo
# 3. From within the main directory of the repo, use docker to build the image
#    'organic-toolkit-hub' via the command
#    ``docker build -t organic-toolkit-hub .``
#
# To check that the image has been build run ``docker images``, which should
# list and image called 'organic-toolkit-hub'.
#
#
# Running the service
# -------------------
#
# The command ``docker run -p 8000:8000 organic-toolkit-hub`` will run the
# service on port 8000 of localhost, with logs output to stdout. To access the
# service visit http://localhost:8000 in your browser.
#

FROM python:3.14-slim-bookworm

RUN apt update
RUN apt-get -y install libxrender1 libxext6 git

# Install Python packages (including openbabel-wheel)
RUN pip install --upgrade pip

WORKDIR /app
COPY organic_toolkit_hub /app/organic_toolkit_hub
COPY CHANGELOG.md CONTRIBUTING.md LICENSE pyproject.toml README.md /app/

ENV SETUPTOOLS_SCM_PRETEND_VERSION="1.0.0"

RUN pip install .[deploy]

ENV PYTHONPATH="."
ENV SERVICE_MODE=true
ARG TAG
ENV TAG=$TAG
ARG TAG_SHA
ENV TAG_SHA=$TAG_SHA
ARG SHA
ENV SHA=$SHA

# The PRODUCTION_MODE env var hides features from the GUI that are only useful to developers, such as the SHA of the
# latest commit. This variable is injected into the container via the K8s deployment

# Set LOG_LEVEL to a desired level (e.g. "debug") to force all logging to be at that level. Leave blank for default
# behaviour (INFO+ to user log, ERROR+ to server log and stdout)

EXPOSE 8000

RUN mkdir -p /app/organic_toolkit_hub/static/uploads
RUN mkdir -p /app/organic_toolkit_hub/static/downloads

#set web server timout to more than application default (60)
ENV TIMEOUT=90

CMD ["sh", "-c", "gunicorn -b 0.0.0.0:8000 organic_toolkit_hub.app:app --timeout $TIMEOUT"]
