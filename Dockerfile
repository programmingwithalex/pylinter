FROM python:3
RUN pip install --upgrade pip
RUN pip install flake8 mypy isort
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
