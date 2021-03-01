import argconfig

parser = argconfig.ArgumentParser(description='argconfig example',config='./config.yaml')
parser.add_argument('-f','--foo', type=str, default='testing',
                    help='foo (default=testing, config=test)')
parser.add_argument('--bar',
                    help='bar (default=None, config = 2.0)')
args = parser.parse_args()

print('foo:',args.foo)
print('bar:',args.bar)
