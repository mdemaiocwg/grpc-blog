# grpc-blog

## About:
This application was created in order to practice and demonstrate creating a true gRPC web-application. <br/>
It utilizes gRPC in both the frontend and backend thanks to the help of [grpc-web](https://github.com/grpc/grpc-web) and [Envoy proxy](https://www.envoyproxy.io/). <br/>
The code for the backend is written in [golang](https://golang.org/) and the frontend utilizes javascript([vue.js](https://vuejs.org/)). <br />
The inspiration and layout for this project came from [this](https://www.udemy.com/course/grpc-golang/) udemy course by [Stephane Maarek](https://www.udemy.com/user/stephane-maarek/)<br />
I essentially built upon what i learned in this course and utilizing other resources transformed the CLI portion of the project into a web application.

## Running the Application:
[Docker](https://www.docker.com/) is required in order to run this application.<br/>
To build the application run: `docker-compose build`<br/>
To run the application run: `docker-compose up` <br/>
To view the application in the web, visit [localhost](http://localhost:8081)
