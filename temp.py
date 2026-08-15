import codecs
import sys

def convert(filename):
    try:
        with codecs.open(filename, 'r', 'utf-16') as f:
            content = f.read()
        with codecs.open(filename, 'w', 'utf-8') as f:
            f.write(content)
        print("Converted " + filename)
    except Exception as e:
        print("Error converting " + filename + ": " + str(e))

convert('d:\\vstechpos\\CafeSystem\\backend\\cafe_app\\lib\\feature\\HomeScreem.dart')
convert('d:\\vstechpos\\CafeSystem\\backend\\cafe_app\\lib\\feature\\MenuItem.dart')
