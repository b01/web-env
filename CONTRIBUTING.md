#How to Contribute

This repository contains a collection of shell command scripts that aid setting up a development environment on
Linux/Mac/Windows. Each script represents a command, so if you provide a Linux script, you must also provide the
equivalent for Mac & Window and viceversa.

Since there is no testing framework in this repo, each command added/modified must be tested on each system to ensure
they work.


## Documentation

Supporting documentation for each command and its functionality must also be provided and kept up-to-date with
modifications. Since there is no documentation framework, this must be done manually.

Each command **MUST** be added to the [Command Reference](./docs/command-reference.md) manual, please stick with and use the following format:
```$xslt
<command-name>: string representing the name of the script file without the extension.

<list>: A bulleted list of flags/arguments that can be be passed to the command at run-time, written as an <option>.

<option>: The flag string followed by a space, en-dash, then another space and then a summary. For example: v - turn on verbosity.

<description>: Is a string describing the benefits of running the command.

Format (please not that white-space is significant):
##<command-name>

    <description>

*<list>
```