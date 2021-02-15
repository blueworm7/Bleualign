#/bin/sh
folder="/nlp2/nmt/corpus.crawl/bi/ko_zhcn/d_news_crawl"
tag="donga.crawled.20210115"
org_ko=${folder}/${tag}.ko
org_zhcn=${folder}/${tag}.zhcn
src_ko=${folder}/${tag}.sentonly.ko
src_zhcn=${folder}/${tag}.sentonly.zhcn
tgt_ko=${folder}/${tag}.sentonly.ko.backtrans.zhcn
tgt_zhcn=${folder}/${tag}.sentonly.zhcn.backtrans.ko
paste_ko=${folder}/${tag}.ko.include.trans
paste_zhcn=${folder}/${tag}.zhcn.include.trans

ba_src=${paste_ko}.baform.src
ba_tgt=${paste_zhcn}.baform.src
ba_src_trans=${paste_ko}.baform.trans
ba_tgt_trans=${paste_zhcn}.baform.trans
ba_out_prefix=${folder}/${tag}.aligned

#cut -f3 ${org_ko} > ${src_ko}
#cut -f3 ${org_zhcn} > ${src_zhcn}
cur_pwd=${PWD}
#cd /nlp2/nmt/HNMT/translate/
#./translate.ko_zhcn.sh 2 ${src_ko} ${tgt_ko} 1> ${folder}/${tag}.ko_zhcn.trans.log 2>&1 &
#./translate.zhcn_ko.sh 3 ${src_zhcn} ${tgt_zhcn} 1> ${folder}/${tag}.zhcn_ko.trans.log 2>&1 
#wait
#sleep 5

paste ${org_ko} ${tgt_ko} > ${paste_ko}
paste ${org_zhcn} ${tgt_zhcn} > ${paste_zhcn}

#cd ${cur_pwd}
export PATH=$PATH:/home/anaconda/bin
source activate /home/anaconda/envs/airlab_venv
python ../convert_bleualign.py -i ${paste_ko}
echo "${paste_zhcn}"
python ../convert_bleualign.py -i ${paste_zhcn}

python ../bleualign.py -s ${ba_src} -t ${ba_tgt} --srctotarget ${ba_src_trans} --targettosrc ${ba_tgt_trans} -o ${ba_out_prefix}  
python ../remove_dummy_empty.py -s ${ba_out_prefix}-s -t ${ba_out_prefix}-t --out-src ${ba_out_prefix}-s.no_dummy --out-tgt ${ba_out_prefix}-t.no_dummy

cp ${ba_out_prefix}-s.no_dummy ${ba_out_prefix}.ko
cp ${ba_out_prefix}-t.no_dummy ${ba_out_prefix}.zhcn
mv ${ba_out_prefix}.ko ${ba_out_prefix}.zhcn ${folder}/parsed/
