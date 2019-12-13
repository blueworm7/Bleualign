#/bin/sh
folder="/input/AIRLab/nmt/corpus.crawl/bi/enko/autopedia/raw"
tag="autopedia.bleualigned.20191213"

ba_src=${folder}/autopedia.explain.long.en
ba_tgt=${folder}/autopedia.explain.long.ko
ba_src_trans=${ba_src}.translated
ba_tgt_trans=${ba_tgt}.translated
ba_out_prefix=${folder}/${tag}.aligned

#python bleualign.py -s ${ba_src} -t ${ba_tgt} --srctotarget ${ba_src_trans} --targettosrc ${ba_tgt_trans} -o ${ba_out_prefix}  
python remove_dummy_empty.py -s ${ba_out_prefix}-s -t ${ba_out_prefix}-t --out-src ${ba_out_prefix}-s.no_dummy --out-tgt ${ba_out_prefix}-t.no_dummy --filter-korean "src"
cp ${ba_out_prefix}-s.no_dummy ${ba_out_prefix}.en
cp ${ba_out_prefix}-t.no_dummy ${ba_out_prefix}.ko
