# redex-regex

A Racket-based implementation utilizing the Redex library to model and manipulate regular expressions. This project demonstrates the application of Redex for defining and testing the semantics of regular expressions.

## Features

- **Regular Expression Modeling**: Defines the syntax and semantics of regular expressions.
- **Reduction Semantics**: Implements reduction relations to model the evaluation of regular expressions.
- **Testing Framework**: Includes properties and tests to verify the correctness of the regular expression semantics.

## Files

- `main.rkt`: The entry point of the application, coordinating the execution of the regular expression semantics.
- `regex.rkt`: Defines the syntax and semantics of regular expressions.
- `compiler.rkt`: Contains the compilation logic for transforming regular expressions into executable forms.
- `processor.rkt`: Implements the evaluation of regular expressions.
- `input-gen.rkt`: Generates input data for testing the regular expression semantics.
- `properties.rkt`: Defines properties and tests for verifying the correctness of the regular expression semantics.
- `vm.rkt`: Contains the virtual machine logic for executing compiled regular expressions.

## Installation

To get started, clone this repository:

```bash
git clone https://github.com/daher13/redex-regex.git
```

## Usage
To run the project, execute the main.rkt file:

```bash
racket main.rkt
```
This will evaluate the regular expressions defined within the project and run the associated tests.

