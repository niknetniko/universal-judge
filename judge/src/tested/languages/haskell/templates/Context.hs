{-# LANGUAGE NamedFieldPuns #-}
## Code to execute one context.
<%! from tested.languages.generator import _TestcaseArguments %>
<%! from tested.serialisation import Statement, Expression, Assignment %>
<%! from tested.utils import get_args %>
module ${context_name} where

##################################
## Setup                        ##
##################################

import System.IO (hPutStr, stderr, stdout, hFlush)
import System.Environment
import qualified Values
import Control.Monad.Trans.Class
import Control.Exception
import EvaluationUtils

## Import the language specific evaluators we will need.
% for name in evaluator_names:
    import qualified ${name}
% endfor

## Import the solution.
import qualified ${submission_name}


value_file = "${value_file}"
exception_file = "${exception_file}"

## Write the delimiter and flush to ensure the output is in the files.
writeDelimiter :: IO ()
writeDelimiter = do
    hPutStr stderr "--${secret_id}-- SEP"
    hPutStr stdout "--${secret_id}-- SEP"
    appendFile value_file "--${secret_id}-- SEP"
    appendFile exception_file "--${secret_id}-- SEP"
    hFlush stdout
    hFlush stderr


##################################
## Predefined functions         ##
##################################

## Send a value to TESTed
send :: Values.Typeable a => a -> IO ()
send = Values.sendValue value_file

## Send an exception to TESTed
sendException :: Exception e => Maybe e -> IO ()
sendException = Values.sendException exception_file

## Send the result of a language specific value evaluator to TESTed.
sendSpecificValue :: EvaluationResult -> IO ()
sendSpecificValue EvaluationResult {
    result, readableExpected, readableActual, messages
} = Values.sendEvaluated value_file result readableExpected readableActual messages

## Send the result of a language specific exception evaluator to TESTed.
sendSpecificException :: EvaluationResult -> IO ()
sendSpecificException EvaluationResult {
    result, readableExpected, readableActual, messages
} = Values.sendEvaluated exception_file result readableExpected readableActual messages


## Exception handler
handleException :: Exception e => (Maybe e -> IO()) -> Either e a -> IO ()
handleException f (Left e) = f (Just e)
handleException f (Right _) = f (Nothing)

##################################
## Main testcase evaluators     ##
##################################

eEvaluateMain value = <%include file="statement.mako" args="statement=context_testcase.exception_function"/>

##################################
## Other testcase evaluators    ##
##################################
% for testcase in testcases:
    % if testcase.value_function:
        vEvaluate${loop.index} value = <%include file="statement.mako" args="statement=testcase.value_function"/>
    % endif

    eEvaluate${loop.index} value = <%include file="statement.mako" args="statement=testcase.exception_function"/>
% endfor

## Main function of the context.
main = do
    ${before}

    % if context_testcase.exists:
        let mainArgs = [\
            % for argument in context_testcase.arguments:
                <%include file="value.mako" args="value=argument"/>\
            % endfor
        ]
        result <- try (withArgs mainArgs ${submission_name}.main) :: IO (Either SomeException ())
        handleException eEvaluateMain result
    % endif

    writeDelimiter

    % for testcase in testcases:
        ## In Haskell we do not actually have statements, so we need to keep them separate.
        ## Additionally, exceptions with "statements" are not supported at this time.
        % if isinstance(testcase.command, get_args(Assignment)):
            <%include file="statement.mako" args="statement=testcase.command,root=False" />
        % else:
            result${loop.index} <- catch
                (<%include file="statement.mako" args="statement=testcase.command,lifting=True" /> >>= \r -> vEvaluate${loop.index} r >> eEvaluate${loop.index} (Nothing :: Maybe SomeException))
                (\e -> eEvaluate${loop.index} (Just (e :: SomeException)))
        % endif

        writeDelimiter
    % endfor

    ${after}
