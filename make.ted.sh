#/bin/sh
folder="/input/AIRLab/nmt/corpus.crawl/bi/enko/ted/raw"
org_en=${folder}/ted.20190829.selected.except_empty.text.en
org_ko=${folder}/ted.20190829.selected.except_empty.text.ko
src_en=${folder}/ted.20190829.selected.except_empty.text.en.src
src_ko=${folder}/ted.20190829.selected.except_empty.text.ko.src
tgt_en=${folder}/ted.20190829.selected.except_empty.text.en.trans
tgt_ko=${folder}/ted.20190829.selected.except_empty.text.ko.trans
paste_en=${folder}/ted.20190829.selected.except_empty.text.en.include.trans
paste_ko=${folder}/ted.20190829.selected.except_empty.text.ko.include.trans
#cut -f3 ${org_en} > ${src_en}
#cut -f3 ${org_ko} > ${src_ko}
#cd /input/AIRLab/nmt/HNMT/translate/
#./translate.enko.sh 0 ${src_en} ${tgt_en} 1> ted.enko.trans.log 2>&1 &
#./translate.enko.sh 1 ${src_ko} ${tgt_ko} 1> ted.koen.trans.log 2>&1 

paste ${org_en} ${tgt_en} > ${paste_en}
paste ${org_ko} ${tgt_ko} > ${paste_ko}

python convert_bleualign.py -i ${paste_en}
python convert_bleualign.py -i ${paste_ko}

ba_src=
ba_tgt=
ba_src_trans=
ba_tgt_trans=
ba_out_path=

#python bleualign.py -s ${src} -t ${tgt} --srctotarget ${src_trans} --targettosrc ${tgt_trans} -o ${out_path}  
