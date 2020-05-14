import glob

files = glob.glob("./data/*")

#fname = "./annotations/subject_1_base.txt"

for f in files:
    fname = "./annotations/" + f.split('/')[-1][:-4] + ".txt"

    num_lines = 0
    with open(fname, 'r') as f:
        for line in f:
            num_lines += 1
    print("Number of lines:")
    print(num_lines)