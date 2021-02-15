# -*- coding: utf-8 -*-
#from __future__ import unicode_literals, print_function

import os
import sys
import argparse

END_OF_ARTICLE_TAG='.EOA'
DUMMY_ARTICLE_TAG='.DUMMY_ARTICLE'
MIN_SENT_LEN=5

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def normalize(sent):
    s = sent.strip()
    s = " ".join(s.split())
    return s

def remove_duplicate(src_input, tgt_input, out_src, out_tgt):
    dummy_cnt = 0
    with open(src_input, 'r') as is_f, open(tgt_input, 'r') as it_f, \
         open(out_src, 'w') as os_f, open(out_tgt, 'w') as ot_f:
        s_line = is_f.readline()
        t_line = it_f.readline()
        while( s_line and t_line ):
            s_line = s_line.strip()
            t_line = t_line.strip()

            if s_line == DUMMY_ARTICLE_TAG:
                dummy_cnt += 1
            elif len(s_line) < MIN_SENT_LEN:
                eprint("Too short sentence : {} : |{}|".format(len(s_line), MIN_SENT_LEN))
            elif len(t_line) < MIN_SENT_LEN:
                eprint("Too short sentence : {} : |{}|".format(len(t_line), MIN_SENT_LEN))
            else:
                os_f.write("{}\n".format(s_line))
                ot_f.write("{}\n".format(t_line))

            s_line = is_f.readline()
            t_line = it_f.readline()
    eprint("dummy article count : {}".format(dummy_cnt))


def main(argv):
    parser = argparse.ArgumentParser(description="file sampler")
    parser.add_argument("-s", "--src-input", required=True, help="Input File path of source language.")
    parser.add_argument("-t", "--tgt-input", required=True, help="Input File path of target language.")
    parser.add_argument("--out-src", required=True, help="Output File path of source language.")
    parser.add_argument("--out-tgt", required=True, help="Output File path of target language.")

    args = parser.parse_args()

    if not os.path.isfile(args.src_input):
        eprint("{} is not a file.".format(args.src_input))
        return
    if not os.path.isfile(args.tgt_input):
        eprint("{} is not a file.".format(args.tgt_input))
        return

    remove_duplicate(args.src_input, args.tgt_input, args.out_src, args.out_tgt)


if __name__ == '__main__':
    main(sys.argv)

# vim: set et ts=4 sw=4:
