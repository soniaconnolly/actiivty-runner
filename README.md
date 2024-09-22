# Activity Runner
## Introduction
Activity Runner is a framework to test telemetry apps. It reads a JSON list of activities and executes them. A log in JSON format tracks the executed activities for comparison with telemetry app behaviors.

Supported activities:
- Start a process, given a path to an executable file and the desired (optional) command-line arguments
- Create a file of a specified type at a specified location 
- Modify a file
- Delete a file
- Establish a network connection and transmit data

## Setup
[Install Ruby](https://www.ruby-lang.org/en/documentation/installation/) if needed.

Ruby version: 3.3.5

Install gems:
```
bundle install
```

Docker build:
```
docker compose build
```

### JSON list of activities
Using the provided [activities.json](activities.json) as a template, create a list of activities. It is an array of JSON objects, each specifying an action, a path, and any additional arguments.

The valid actions are:
- `run_process`, properties: `action`, `path`, `args`
- `create_file`, properties: `action`, `path`, `type`
- `modify_file`, properties: `action`, `path`, `data`
- `delete_file`, properties: `action`, `path`
- `network_request`, properties: `action`, `path`, `protocol`, `data`

## Actions
### Run the test suite
```
bundle exec rspec
```

### Run the script
The provided [script](run_activities.rb) takes the activities file as an argument. The script logs to the default logfile, `activity_runner_log.json`. Note that log timestamps are in UTC.
```
./run_activities.rb <your activities.json file>
```

### Call ActivityRunner
Call `ActivityRunner` from `irb` or another Ruby program. Optionally specify an alternate logfile with the `logfile` named argument.
```
ActivityRunner.new(activity_file, logfile: './activity_runner_log.json')
```

### Run a bash shell under Linux in Docker
```
docker-compose run --rm --service-ports app
```

## Discussion
### Security
Running arbitrary processes, file operations, and network requests is a big security risk. For a production version, the user that runs the new processes should have carefully limited permissions. Possibly, file operations should be limited to an application subdirectory instead of being full paths.

Currently, no API keys are in use. If they are needed they should be added in a .env file and the dotenv gem can be added to the project. Also add `env_file: .env` to [docker-compose.yml](docker-compose.yml)

### Object Decomposition and Design Patterns
- `ActivityRunner` reads in a json file of activities, creates `Activity` objects, and runs them.
- `Activity` is the parent class for all types of activities. It can run a process because most activities use that capability. Inheritance and the Factory pattern are used to make this framework easily extensible.
  - `CreateFileActivity`, `ModifyFileActivity`, `DeleteFileActivity`, `NetworkFileActivity` are subclasses of `Activity`. They override the `command` method and possibly the `run` method.
  - `NullFileActivity` is used when the specified `action` property is invalid
- `ActivityFactory` creates the correct `Activity` subclass for the specified action. It is also possible to just put the desired class name in `action` and create the object directly, but that code would be less readable and maintainable. 

### Gems added
- [json_logger](https://github.com/tedconf/json_logger) logging in json format
- [sys-proctable](https://github.com/djberg96/sys-proctable) cross-platform information about running processes

