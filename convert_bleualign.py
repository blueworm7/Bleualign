# -*- coding: utf-8 -*-
#from __future__ import unicode_literals, print_function

import os
import sys
import argparse

import secrets


END_OF_ARTICLE_TAG='.EOA'
DUMMY_ARTICLE_TAG='.DUMMY_ARTICLE'

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def normalize(sent):
    s = sent.strip()
    s = " ".join(s.split())
    return s

def convert_bleu_align_format(in_file):
    prev_doc_id = "0"
    line_num=0
    with open(in_file+'.baform.src', 'w') as s_f, open(in_file+'.baform.trans', 'w') as t_f:
        for line in open(in_file, 'r'):
            try:
                doc_id, line_id, src_sent, trans_sent = line.strip().split('\t')
            except:
                eprint("ERROR OCCURED! {}:|{}|".format(line_num, line))

            prev_doc_id = int(prev_doc_id)
            doc_id = int(doc_id)
            if prev_doc_id != doc_id:
                s_f.write("{}\n".format(END_OF_ARTICLE_TAG))
                t_f.write("{}\n".format(END_OF_ARTICLE_TAG))
                if prev_doc_id != doc_id -1:
                    for i in range(prev_doc_id, doc_id - 1):
                        s_f.write("{}\n{}\n".format(DUMMY_ARTICLE_TAG,END_OF_ARTICLE_TAG))
                        t_f.write("{}\n{}\n".format(DUMMY_ARTICLE_TAG,END_OF_ARTICLE_TAG))
            s_f.write("{}\n".format(normalize(src_sent)))
            t_f.write("{}\n".format(normalize(trans_sent)))
            prev_doc_id = doc_id
            line_num += 1



def main(argv):
    parser = argparse.ArgumentParser(description="file sampler")
    parser.add_argument("-i", "--input-path", required=True, help="Input File path for sampling.")

    args = parser.parse_args()

    if not os.path.isfile(args.input_path):
        eprint("{} is not a file.".format(args.input_path))
        return

    convert_bleu_align_format(args.input_path)


if __name__ == '__main__':
    main(sys.argv)

# vim: set et ts=4 sw=4:
