import sys
import png

width = 192
height = 64
table = [0x00, 0x08, 0x10, 0x18, 0x20, 0x29, 0x31, 0x39, 0x41, 0x4A, 0x52,
        0x5A, 0x62, 0x6A, 0x73, 0x7B, 0x83, 0x8B, 0x94, 0x9C, 0xA4, 0xAC,
        0xB4, 0xBD, 0xC5, 0xCD, 0xD5, 0xDE, 0xE6, 0xEE, 0xF6, 0xFF]

if (len(sys.argv) < 3):
    exit()

nameIn = sys.argv[1]
fileIn = open(nameIn, "rb")
fileIn.seek(160)
data = fileIn.read(width*height*2)
dataSrc = 0

pixels = []
for y in range(0, height, 4):
    row = [[],[],[],[]]
    for x in range(0, width, 4):
        for iy in range(0, 4):
            for ix in range(0, 4):
                src = dataSrc*2
                v = data[src]<<8 | data[src+1]
                row[iy].append(table[(v>>10) & 0x1f])
                row[iy].append(table[(v>> 5) & 0x1f])
                row[iy].append(table[(v>> 0) & 0x1f])
                dataSrc=dataSrc+1
    pixels.append(tuple(row[0]))
    pixels.append(tuple(row[1]))
    pixels.append(tuple(row[2]))
    pixels.append(tuple(row[3]))

nameOut = sys.argv[2]
fileOut = open(nameOut, "wb")
pngWriter = png.Writer(width, height, greyscale=False)
pngWriter.write(fileOut, pixels)
fileOut.close()
