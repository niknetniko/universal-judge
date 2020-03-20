## Code to execute_module one test context.
<%! from testplan import Assignment %>
import values
import sys

## Import the language specific evaluators we will need.
% for name in evaluator_names:
    import ${name}
% endfor


## Prepare some code for the evaluation.
value_file = open(r"${value_file}", "w")
exception_file = open(r"${exception_file}", "w")


def write_delimiter(delimiter):
    value_file.write(delimiter)
    exception_file.write(delimiter)


def send(value):
    values.send_value(value_file, value)


def send_exception(exception):
    values.send_exception(exception_file, exception)

def e_evaluate_main(value):
    <%include file="function.mako" args="function=main_testcase.exception_function"/>

% for additional in additional_testcases:
    % if additional.has_return:
        def v_evaluate_${loop.index}(value):
            <%include file="function.mako" args="function=additional.value_function"/>
    % endif

    def e_evaluate_${loop.index}(value):
        <%include file="function.mako" args="function=additional.exception_function"/>
% endfor


## Prepare arguments for context_testcase testcase if needed.
% if main_testcase.exists and main_testcase.arguments:
    sys.argv.extend([\
        % for argument in main_testcase.arguments:
            <%include file="literal.mako" args="value=argument"/>\
        % endfor
    ])
% endif

## Run the "before" code.
% if before:
    ${before}
% endif


## Import the code for the first time.
try:
    from ${submission_name} import *
except Exception as e:
    % if main_testcase.exists:
        e_evaluate_main(e)
    % else:
        raise e
    % endif


% if main_testcase.exists:
    sys.stderr.write("--${secret_id}-- SEP")
    sys.stdout.write("--${secret_id}-- SEP")
    write_delimiter("--${secret_id}-- SEP")
% endif

## Generate the actual tests based on the context.
% for additional in additional_testcases:
    try:
        % if isinstance(additional.statement, Assignment):
            <%include file="assignment.mako" args="assignment=additional.statement" />\
        % else:
            % if additional.has_return:
                v_evaluate_${loop.index}(\
            % endif
            <%include file="function.mako" args="function=additional.statement" />\
            % if additional.has_return:
                )\
            % endif
        % endif

    except Exception as e:
        e_evaluate_${loop.index}(e)

    sys.stderr.write("--${secret_id}-- SEP")
    sys.stdout.write("--${secret_id}-- SEP")
    write_delimiter("--${secret_id}-- SEP")

% endfor

% if after:
    ${after}
% endif

## Close output files.
value_file.close()
exception_file.close()