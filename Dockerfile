FROM python:3.12-slim
RUN useradd --create-home appuser
WORKDIR /app
COPY app.py .
USER appuser
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')" || exit 1
EXPOSE 8080
CMD ["python", "app.py"]
