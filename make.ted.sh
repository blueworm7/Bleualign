#/bin/sh
folder="/input/AIRLab/nmt/corpus.crawl/bi/enko/ted/raw"
tag="ted.20190829.selected.except_empty_fail"
org_en=${folder}/${tag}.text.en
org_ko=${folder}/${tag}.text.ko
src_en=${folder}/${tag}.text.en.src
src_ko=${folder}/${tag}.text.ko.src
tgt_en=${folder}/${tag}.text.en.trans
tgt_ko=${folder}/${tag}.text.ko.trans
paste_en=${folder}/${tag}.text.en.include.trans
paste_ko=${folder}/${tag}.text.ko.include.trans

ba_src=${paste_en}.baform.src
ba_tgt=${paste_ko}.baform.src
ba_src_trans=${paste_en}.baform.trans
ba_tgt_trans=${paste_ko}.baform.trans
ba_out_prefix=${folder}/${tag}.aligned

cut -f3 ${org_en} > ${src_en}
cut -f3 ${org_ko} > ${src_ko}
cur_pwd=${PWD}
cd /input/AIRLab/nmt/HNMT/translate/
./translate.enko.sh 0 ${src_en} ${tgt_en} 1> ${folder}/ted.enko.trans.log 2>&1 &
./translate.koen.sh 1 ${src_ko} ${tgt_ko} 1> ${folder}/ted.koen.trans.log 2>&1 
wait
sleep 5

paste ${org_en} ${tgt_en} > ${paste_en}
paste ${org_ko} ${tgt_ko} > ${paste_ko}

cd ${cur_pwd}
python ./convert_bleualign.py -i ${paste_en}
python ./convert_bleualign.py -i ${paste_ko}

python bleualign.py -s ${ba_src} -t ${ba_tgt} --srctotarget ${ba_src_trans} --targettosrc ${ba_tgt_trans} -o ${ba_out_prefix}  
mv ${ba_out_prefix}-s ${ba_out_prefix}.en
mv ${ba_out_prefix}-t ${ba_out_prefix}.ko
