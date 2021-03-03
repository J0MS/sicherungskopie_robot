FROM python:3.8

RUN apt-get update && \
    apt-get install -y software-properties-common \
    apt-utils\
    curl \
    build-essential && \
    apt-get clean



ENV PYTHONUNBUFFERED=1 \
    # prevents python creating .pyc files
    PYTHONDONTWRITEBYTECODE=1 \
    \
    # pip
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    \
    # poetry
    # https://python-poetry.org/docs/configuration/#using-environment-variables
    POETRY_VERSION=1.0.9 \
    # make poetry install to this location
    POETRY_HOME="/app/poetry" \
    # make poetry create the virtual environment in the project's root
    # it gets named `.venv`
    POETRY_VIRTUALENVS_IN_PROJECT=0 \
    POETRY_VIRTUALENVS_PATH="/app/venv" \
    # do not ask any interactive question
    POETRY_NO_INTERACTION=1 \
    \
    # paths
    # this is where our requirements + virtual environment will live
    PYSETUP_PATH="/app" \
    PROJECT_PATH="/app/project" \
    R_LIBS="/app/R/libs"

RUN mkdir -p "$R_LIBS" && mkdir -p "$PROJECT_PATH" && mkdir -p "$PYSETUP_PATH/bin"

# prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$PYSETUP_PATH/bin:$PATH"

# install poetry - respects $POETRY_VERSION & $POETRY_HOME
RUN curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python3

WORKDIR "$PROJECT_PATH"


COPY poetry.lock pyproject.toml ./

# install runtime deps - uses $POETRY_VIRTUALENVS_IN_PROJECT internally
RUN poetry install --no-dev --no-root

COPY ./src ./src

# Install Project
RUN poetry install --no-dev

ENTRYPOINT ["poetry", "run"]

RUN poetry show