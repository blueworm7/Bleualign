#/bin/sh
folder="/nlp2/nmt/corpus.crawl/bi/ko_zhcn/ted_2020_crawl"
tag="ted.kozhcn.20201230.selected.except_empty_fail"
org_ko=${folder}/${tag}.ko
org_zhcn=${folder}/${tag}.zhcn
src_ko=${folder}/${tag}.ko.src
src_zhcn=${folder}/${tag}.zhcn.src
tgt_ko=${folder}/${tag}.ko.trans
tgt_zhcn=${folder}/${tag}.zhcn.trans
paste_ko=${folder}/${tag}.ko.include.trans
paste_zhcn=${folder}/${tag}.zhcn.include.trans

ba_src=${paste_ko}.baform.src
ba_tgt=${paste_zhcn}.baform.src
ba_src_trans=${paste_ko}.baform.trans
ba_tgt_trans=${paste_zhcn}.baform.trans
ba_out_prefix=${folder}/${tag}.aligned

#cut -f3 ${org_ko} > ${src_ko}
#cut -f3 ${org_zhcn} > ${src_zhcn}
#cur_pwd=${PWD}
#cd /nlp/nmt/HNMT/translate/
#./translate.ko_zhcn.sh 0 ${src_ko} ${tgt_ko} 1> ${folder}/ted.ko_zhcn.trans.log 2>&1 &
#./translate.zhcn_ko.sh 1 ${src_zhcn} ${tgt_zhcn} 1> ${folder}/ted.zhcn_ko.trans.log 2>&1 
#wait
#sleep 5

export PATH=$PATH:/home/anaconda/bin
source activate /home/anaconda/envs/airlab_venv

paste ${org_ko} ${tgt_ko} > ${paste_ko}
paste ${org_zhcn} ${tgt_zhcn} > ${paste_zhcn}

#cd ${cur_pwd}
echo ${paste_ko}
python ../convert_bleualign.py -i ${paste_ko}
python ../convert_bleualign.py -i ${paste_zhcn}

python ../bleualign.py -s ${ba_src} -t ${ba_tgt} --srctotarget ${ba_src_trans} --targettosrc ${ba_tgt_trans} -o ${ba_out_prefix}  
python ../remove_duplicate.py --max-freq 2 -s ${ba_out_prefix}-s -t ${ba_out_prefix}-t --out-src ${ba_out_prefix}-s.no_dup --out-tgt ${ba_out_prefix}-t.no_dup
cp ${ba_out_prefix}-s.no_dup ${ba_out_prefix}.ko
cp ${ba_out_prefix}-t.no_dup ${ba_out_prefix}.zhcn
mv ${ba_out_prefix}.ko ${ba_out_prefix}.zhcn ${folder}/parsed/
