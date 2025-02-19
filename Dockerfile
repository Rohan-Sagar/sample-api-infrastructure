# -slim = smaller image size, contains minimal packages
FROM python:3.11-slim
# creates /app directory inside container
WORKDIR /app
# copy requirements.txt from my local machine to current WORKDIR
COPY requirements.txt .
# install dependencies from requirements.txt, RUN executes command during image build
RUN pip install -r requirements.txt
# copy application code to curr WORKDIR
COPY main.py .
# expose the port the app runs on -- documentation purposes
EXPOSE 8000
# run application, CMD specifies what to run when container starts
CMD ["python", "main.py"]
