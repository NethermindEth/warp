import json
import sys

if __name__ == '__main__':
    with open(f"{sys.argv[1]}.json", 'r') as f:
        data = json.load(f)
    print(data['cairo_code'])