import logging
import sys
from argparse import ArgumentParser, FileType
from .configs import read_config
from .utils import smart_close
from .main import run

parser = ArgumentParser(
    description="The universal judge for Dodona."
)
parser.add_argument('-p', '--testplan', type=FileType('r'),
                    help="Where to read the configs from", default="-")
parser.add_argument('-o', '--output', type=FileType('w'),
                    help="Where the judge output should be written to.",
                    default="-")
parser = parser.parse_args()

# Disable logging
# log = logging.getLogger()
# log.setLevel(logging.DEBUG)
# ch = logging.StreamHandler(stream=sys.stdout)
# formatter = logging.Formatter('%(name)s:%(levelname)s:%(message)s')
# ch.setFormatter(formatter)
# log.addHandler(ch)

configuration = read_config(parser.testplan)
with smart_close(parser.output) as out:
    run(configuration, out)
