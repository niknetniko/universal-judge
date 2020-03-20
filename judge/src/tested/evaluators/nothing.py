"""
RawEvaluator for channels without output.
"""

from tested.dodona import StatusMessage, Status
from . import EvaluationResult, try_outputs, exception, value
from ..testplan.channels import EmptyChannel, OutputChannel


def evaluate(_, channel: OutputChannel, actual: str) -> EvaluationResult:
    assert channel == EmptyChannel.NONE

    has_content = bool(actual)
    actual = try_outputs(actual, [exception.try_as_exception, value.try_as_value])

    if has_content:
        return EvaluationResult(
            result=StatusMessage(
                enum=Status.WRONG,
                human="Te veel uitvoer."
            ),
            readable_expected="",
            readable_actual=actual
        )
    else:
        return EvaluationResult(
            result=StatusMessage(enum=Status.CORRECT),
            readable_expected="",
            readable_actual=""
        )