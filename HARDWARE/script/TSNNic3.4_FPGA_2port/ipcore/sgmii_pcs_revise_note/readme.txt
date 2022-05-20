                                   sgmii_pcs_share修改说明
针对sgmii_pcs核的修改，是基于quartus软件在生成4端口IP核时，自身就存在问题，这里为配合用户方便使用，提供了以下一个修改方案仅供参考使用：
1.路径\...\sgmii_pcs_share\synth下的 sgmii_pcs_share.v文件替换与修改
按照参数配置生成好IP核文件后，打开\...\sgmii_pcs_share\synth路径：
1）直接用sgmii_substitute.v替换掉路径下的sgmii_pcs_share.v文件；
2）替换完成后将sgmii_substitute.v文件名改为“sgmii_pcs_share.v”；
3）打开修改名称后的文件“sgmii_pcs_share.v”，第10行对应修改为“module sgmii_pcs_share (”；
4）第124行修改为“sgmii_pcs_share_altera_eth_tse_191_3sjnh4y  eth_tse_0 (”

2.路径\...\sgmii_pcs_share\altera_eth_tse_191\synth下文件替换与修改
打开\...\sgmii_pcs_share\altera_eth_tse_191\synth路径：
1）用sgmii_eth_substitute.v文件替换掉路径下的sgmii_pcs_share_altera_eth_tse _191_3sjnh4y.v文件；
2）将替换的文件名称修改sgmii_pcs_share_altera_eth_tse_191_3sjnh4y.v，
3）打开名称修改后的sgmii_pcs_share_altera_eth_tse_191_3sjnh4y.v文本，将第10行修改为“module sgmii_pcs_share_altera_eth_tse_191_3sjnh4y (”；
4）确认文本第437行实例化指向路径\...\sgmii_pcs_share\altera_lvds_191\synth的sgmii_pcs_share_altera_lvds_191_ecdu3ty.v文件，如指向错误，请修改；
5）确认文本第449行实例化指向路径\...\sgmii_pcs_share\altera_lvds_191\synth的sgmii_pcs_share_altera_lvds_191_asrzfni.v文件，如指向错误，请修改；

修改完成后进行保存就完成了。
