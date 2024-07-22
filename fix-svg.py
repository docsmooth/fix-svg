import os

debug = 1
file = input("Enter the file path: ")
outdir = "./resaved"

if not os.path.isfile(file):
    # we got a stream, do not handle!
    print("Cannot handle a stream!")
    exit(1)

if not os.path.isdir(outdir):
    print("No child directory to write into!")
    exit(1)

with open(file, "r") as fh, open(f"{outdir}/{os.path.basename(file)}", "w") as fo:
    classes = {}
    for line in fh:
        for class_match in re.findall(r"(cls-[0-9]+)\{([^\}]*)\}", line):
            class_name, class_styles = class_match
            classes[class_name] = re.sub(r":([^;]*);", r'="\1" ', class_styles)
            if class_name in line:
                line = re.sub(r'class="?{}?"?'.format(class_name), classes[class_name], line)
                if debug:
                    print(f"Replaced {class_name} with {classes[class_name]}")
        fo.write(line)

