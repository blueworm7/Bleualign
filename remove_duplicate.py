# -*- coding: utf-8 -*-
#from __future__ import unicode_literals, print_function

import os
import sys
import argparse

END_OF_ARTICLE_TAG='.EOA'

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def normalize(sent):
    s = sent.strip()
    s = " ".join(s.split())
    return s

def remove_duplicate(src_input, tgt_input, out_src, out_tgt, max_freq):
    src_dic={}
    tgt_dic={}
    with open(src_input, 'r') as is_f, open(tgt_input, 'r') as it_f, \
         open(out_src, 'w') as os_f, open(out_tgt, 'w') as ot_f:
        s_line = is_f.readline()
        t_line = it_f.readline()
        while( s_line and t_line ):
            s_line = s_line.strip()
            t_line = t_line.strip()

            if s_line in src_dic:
                src_dic[s_line] += 1
            else:
                src_dic[s_line] = 1
            if t_line in tgt_dic:
                tgt_dic[t_line] += 1
            else:
                tgt_dic[t_line] = 1
            
            if src_dic[s_line] > max_freq or tgt_dic[t_line] > max_freq:
                #eprint("Exclude : [{}]\t[{}]".format(s_line, t_line))
                s_line = is_f.readline()
                t_line = it_f.readline()
                continue

            os_f.write("{}\n".format(s_line))
            ot_f.write("{}\n".format(t_line))
            s_line = is_f.readline()
            t_line = it_f.readline()


def main(argv):
    parser = argparse.ArgumentParser(description="file sampler")
    parser.add_argument("-s", "--src-input", required=True, help="Input File path of source language.")
    parser.add_argument("-t", "--tgt-input", required=True, help="Input File path of target language.")
    parser.add_argument("--out-src", required=True, help="Output File path of source language.")
    parser.add_argument("--out-tgt", required=True, help="Output File path of target language.")
    parser.add_argument("-m", "--max-freq", required=True, type=int, default=3, help="Max frequency threshold duplicate")

    args = parser.parse_args()

    if not os.path.isfile(args.src_input):
        eprint("{} is not a file.".format(args.src_input))
        return
    if not os.path.isfile(args.tgt_input):
        eprint("{} is not a file.".format(args.tgt_input))
        return

    remove_duplicate(args.src_input, args.tgt_input, args.out_src, args.out_tgt, args.max_freq)


if __name__ == '__main__':
    main(sys.argv)

# vim: set et ts=4 sw=4:
