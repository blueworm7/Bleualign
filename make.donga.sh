#/bin/sh
folder="/input/AIRLab/nmt/corpus.crawl/bi/enko/donga/raw"
tag="donga.crawled.20191031"
org_en=${folder}/${tag}.en
org_ko=${folder}/${tag}.ko
src_en=${folder}/${tag}.en.src
src_ko=${folder}/${tag}.ko.src
tgt_en=${folder}/${tag}.en.trans
tgt_ko=${folder}/${tag}.ko.trans
paste_en=${folder}/${tag}.en.include.trans
paste_ko=${folder}/${tag}.ko.include.trans

ba_src=${paste_en}.baform.src
ba_tgt=${paste_ko}.baform.src
ba_src_trans=${paste_en}.baform.trans
ba_tgt_trans=${paste_ko}.baform.trans
ba_out_prefix=${folder}/${tag}.aligned

#cut -f4 ${org_en} > ${src_en}
#cut -f4 ${org_ko} > ${src_ko}
#cur_pwd=${PWD}
#cd /input/AIRLab/nmt/HNMT/translate/
#./translate.enko.sh 2 ${src_en} ${tgt_en} 1> ${folder}/${tag}.enko.trans.log 2>&1 &
#./translate.koen.sh 3 ${src_ko} ${tgt_ko} 1> ${folder}/${tag}.koen.trans.log 2>&1 
#wait
#sleep 5

#paste ${org_en} ${tgt_en} > ${paste_en}
#paste ${org_ko} ${tgt_ko} > ${paste_ko}

#cd ${cur_pwd}
python ./convert_bleualign.py -i ${paste_en}
python ./convert_bleualign.py -i ${paste_ko}

python bleualign.py -s ${ba_src} -t ${ba_tgt} --srctotarget ${ba_src_trans} --targettosrc ${ba_tgt_trans} -o ${ba_out_prefix}  
#python remove_duplicate.py --max-freq 2 -s ${ba_out_prefix}-s -t ${ba_out_prefix}-t --out-src ${ba_out_prefix}-s.no_dup --out-tgt ${ba_out_prefix}-t.no_dup
#cp ${ba_out_prefix}-s.no_dup ${ba_out_prefix}.en
#cp ${ba_out_prefix}-t.no_dup ${ba_out_prefix}.ko
#mv ${ba_out_prefix}.en ${ba_out_prefix}.ko ${folder}/../parsed/
