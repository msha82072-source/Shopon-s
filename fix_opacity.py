import os
import re

dir_path = r"d:\Development\projects\shopons\lib"

for root, dirs, files in os.walk(dir_path):
    for file in files:
        if file.endswith(".dart"):
            file_path = os.path.join(root, file)
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()

            new_content = re.sub(r'\.withOpacity\(\s*([^)]+)\s*\)', r'.withValues(alpha: \1)', content)

            if new_content != content:
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(new_content)
                print(f"Updated {file_path}")
