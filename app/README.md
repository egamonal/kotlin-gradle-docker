# kotlin-gradle-docker
An example of dockerizing a hello world with Kotlin (1.3) and gradle (6.7)

Dockerizing a Kotlin app might be confusing if you come from another language. 
Gradle and Kotlin DSL versions have changed and answers in stackoverflow don't lead to fixing problems.

## Usage

    $ make build
    $ make run
    
That's all.
You'll get a hello world. 
The interesting part is the Dockerfile and the build gradle file.


### Goal
- Run the application and tests in Docker
- Remote debugging from IntelliJ in Docker

### Building Blocks
* 2-stage Docker: 
  - Gradle
  - Running environment

#### Gradle
Gradle is used as boilerplate generator. 
Install gradle in your system and run `gradle init` .
Choosing type `application` will create a hello world.
Normally [you'd add gradle binaries to git](https://stackoverflow.com/questions/20348451/why-should-the-gradle-wrapper-be-committed-to-vcs).
In this repo we don't need them, but they're included so that you can go step by step.

##### First attempt, without Docker
First make the process work, then dockerize it.
The goals are:

1. Build and run with gradle
2. Build with gradle, run with java later.

When running this from IntelliJ, the IDE has some defaults and conventions ([1], [2]) that will get the "hello world" printed on the terminal.
Try it from the terminal:

1. `$ ./gradlew build`.
2. `$ ./gradlew run`

You might get a hello world, but we need a **running Jar** 
We don't want just some files, or a zip. 
We need a running jar.
This is in `./app/build/libs/`.

The important parts here are: [defining a main class](https://discuss.gradle.org/t/kotlin-jvm-app-missing-main-manifest-attribute/31413) and [including everything](https://stackoverflow.com/a/56518749/1821749)..


The `application` plugin for gradle will generate the tar and zip files, but not the Jar.
This will lead to problems like a missing Manifest file, or missing a main class declaration.

The section added specifically for Jar files fixes it `tasks.withType<Jar> {...}`.

Once built, it can run with java:

    $ java -jar ./app/build/libs/app.jar

All done? now put it in a container: the first stage of the Dockerfile.

#### Running Environment
The second stage of the Dockerfile.
Add the JRE and copy the files. 
The entry point is running the jar file.

    $ docker build -t helloworld .
    $ docker run helloworld

And done.
The included Makefile is just an alias for not writing these commands.

[1]: https://kotlinlang.org/docs/reference/java-to-kotlin-interop.html?_ga=2.33060280.749662446.1605776235-1610367080.1604051640&_gac=1.18599883.1605776235.CjwKCAiAzNj9BRBDEiwAPsL0d0LfGGfPmTJFtMfYLpx8xL9kajKvHAVaBlw_n_dV93gNBgltVqfM3hoC3a8QAvD_BwE#package-level-functions
[2]: https://stackoverflow.com/a/46924193/1821749