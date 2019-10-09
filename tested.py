#
# Main file of the TESTed framework.
#
# For now, this only handles running the execution kernel.
#

from typing import NamedTuple


class Config(NamedTuple):
    resources: str
    source: str
    time_limit: str
    memory_limit: str
    natural_language: str
    programming_language: str
    workdir: str
    judge: str


def read_config() -> Config:
    """Read the configuration from stdout"""
    #test = sys.stdin.read()
    config_ = {
        "memory_limit": 536870912,
        "time_limit": 10000000,
        "programming_language": 'python',
        "natural_language": 'nl',
        "resources": './excercise',
        "source": './excercise/test.py',
        "judge": 'ignored',
        "workdir": 'ignored',
    }
    needed_config = {x: config_[x] for x in Config._fields}
    return Config(**needed_config)


if __name__ == '__main__':
    config = read_config()

    # For now, the action plan is as follows:
    # 1. Load the student user_code in the kernel
    # 2. Process the input line-by-line
    #    - Check the output for each element.
    # 3. Finish

    # Read user_code
    with open(config.source, 'r') as f:
        user_code = f.read()

    # Run it.
    from judge import KernelJudge
    from jupyter import JupyterContext

    tester = KernelJudge(config)
    tester.judge()
    tester._execute_test_plan()

    tester.test(user_code, JupyterContext(language=config.programming_language))
