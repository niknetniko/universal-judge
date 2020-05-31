"""
Generate the data for the appendix with the ECHO exercise.
"""
import json
import os
import re
import shutil
import subprocess
from pathlib import Path

import sys

prefix = Path("./src/sources/echo")
judge = Path("../judge/src")

prefix.mkdir(parents=True, exist_ok=True)
workdir = Path("./workdir")
shutil.rmtree(workdir, ignore_errors=True)
workdir.mkdir()

args = {
    "memory_limit":         536870912,
    "time_limit":           60,
    "programming_language": 'javascript',
    "natural_language":     'nl',
    "resources":            '../../exercise/echo/evaluation',
    "source":               '../../exercise/echo/solution/correct.js',
    "judge":                str(Path('..').resolve()),
    "workdir":              str(workdir.resolve()),
    "plan_name":            "two.tson",
    "options":              {
        "parallel": True,
        "linter": {
            "python": False
        }
    }
}

stdin = json.dumps(args)
r = subprocess.run(["python", "-m", "tested"], cwd=judge, input=stdin, text=True, capture_output=True)
sys.stderr.write(r.stderr)

# Copy the relevant files.
shutil.copy2(workdir / "common/context00.js", prefix)
shutil.copy2(workdir / "common/context01.js", prefix)
shutil.copy2("../exercise/echo/solution/correct.js", prefix)
shutil.rmtree(workdir, ignore_errors=True)


def clean(file):
    with open(file, 'r') as f:
        contents = f.read()
    contents = re.sub(r"(\s)+\n", os.linesep, contents)
    contents = re.sub(r"\[\s+]", "{}", contents)
    contents = contents.strip()
    with open(file, 'w') as f:
        f.write(contents)


clean(prefix / "context00.js")
clean(prefix / "context01.js")
