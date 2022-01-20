/*
Navicat MySQL Data Transfer

Source Server         :
Source Server Version : 50722
Source Host           :
Source Database       : platform-mall-vendors

Target Server Type    : MYSQL
Target Server Version : 50733
File Encoding         : 65001

Date: 2021-08-26 12:36:32
*/

SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `MALL_GROUP_BUYING_RECORD`;
CREATE TABLE `MALL_GROUP_BUYING_RECORD` (
    `ID` varchar(32) NOT NULL COMMENT '主键',
    `GOODS_ID` varchar(32) NOT NULL COMMENT '商品id',
    `GOODS_DETAIL` varchar(255) NOT NULL COMMENT '商品规格',
    `USER_ID` varchar(32) NOT NULL COMMENT '团员id',
    `NICKNAME` varchar(64) DEFAULT '' COMMENT '团员昵称',
    `HEAD_IMG_URL` varchar(255) CHARACTER SET utf8 DEFAULT '' COMMENT '团员头像',
    `IS_LEADER` tinyint(1) NOT NULL COMMENT '是否团长(开团的人非团购的团长) 1=是 0=否',
    `LEADER_ID` varchar(32) NOT NULL DEFAULT '0' COMMENT 'pid 如果是团长 则=0',
    `ORDER_SN` varchar(32) NOT NULL DEFAULT '' COMMENT '订单编号',
    `EXPIRE_TIME` DATETIME NOT NULL COMMENT '到期时间(最迟成团时间，开团时间24小时内)',
    `JOIN_NUMBER` int(5) NOT NULL COMMENT '参加人数',
    `PRICE` decimal(10,2) NOT NULL COMMENT '拼团的价格',
    `STATUS` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态 1拼团中 2拼团成功 0拼团失败',
    `CREATE_TIME` DATETIME NOT NULL COMMENT '创建时间',
    `UPDATE_TIME` DATETIME DEFAULT NULL COMMENT '修改时间',
    `END_TIME` DATETIME DEFAULT NULL COMMENT '结束时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品-拼团记录表';

-- ----------------------------
-- Table structure for `MALL_ROOM`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_ROOM`;
CREATE TABLE `MALL_ROOM` (
    `ROOMID` int NOT NULL COMMENT '房间 id',
    `NAME` varchar(64) NOT NULL DEFAULT '' COMMENT '房间名',
    `COVER_IMG` varchar(128) DEFAULT NULL COMMENT '直播间背景图，图片规则：建议像素1080*1920，大小不超过2M',
    `SHARE_IMG` varchar(128) DEFAULT NULL COMMENT '直播间分享图，图片规则：建议像素800*640，大小不超过1M',
    `START_TIME` int(11) COMMENT '直播计划开始时间，列表按照 start_time 降序排列',
    `END_TIME` int(11) COMMENT '直播计划结束时间',
    `ANCHOR_NAME` varchar(255) DEFAULT NULL COMMENT '主播名',
    `LIVE_STATUS` varchar(255) DEFAULT NULL COMMENT '直播状态 101: 直播中, 102: 未开始, 103: 已结束, 104: 禁播, 105: 暂停中, 106: 异常, 107: 已过期',
    PRIMARY KEY (`ROOMID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='直播房间信息';

-- ----------------------------
-- Table structure for `MALL_ROOM_GOODS`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_ROOM_GOODS`;
CREATE TABLE `MALL_ROOM_GOODS` (
    `ID` varchar(32) NOT NULL COMMENT '主键',
    `ROOMID` int NOT NULL COMMENT '房间 id',
    `COVER_IMG` varchar(128) DEFAULT NULL COMMENT '直播间背景图，图片规则：建议像素1080*1920，大小不超过2M',
    `NAME` varchar(64) NOT NULL DEFAULT '' COMMENT '商品名',
    `URL` varchar(128) DEFAULT NULL COMMENT '商品图片url',
    `PRICE` int(11) DEFAULT '0' COMMENT '商品价格',
    `PRICE2` varchar(64) DEFAULT '0' COMMENT '商品价格2',
    PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='直播房间商品信息';

-- ----------------------------
-- Table structure for `MALL_ROOM_ALL_GOODS`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_ROOM_ALL_GOODS`;
CREATE TABLE `MALL_ROOM_ALL_GOODS` (
   `GOODS_ID` int(11) NOT NULL COMMENT '商品 id',
   `COVER_IMG_URL` varchar(128) DEFAULT NULL COMMENT '商品图片',
   `NAME` varchar(64) NOT NULL DEFAULT '' COMMENT '商品名',
   `PRICE_TYPE` tinyint(4) DEFAULT '1' COMMENT '1:一口价，此时读price字段; 2:价格区间，此时price字段为左边界，price2字段为右边界; 3:折扣价，此时price字段为原价，price2字段为现价；',
   `PRICE` varchar(64) DEFAULT '0' COMMENT '商品价格',
   `PRICE2` varchar(64) DEFAULT '0' COMMENT '商品价格',
   `URL` varchar(128) DEFAULT NULL COMMENT '商品url',
   `AUDIT_STATUS` tinyint(4) DEFAULT '1' COMMENT '0：未审核，1：审核中，2:审核通过，3审核失败',
   `THIRD_PARTY_TAG` tinyint(4) DEFAULT '1' COMMENT '1, 2：表示是为api添加商品，否则是在MP添加商品',
   `AUDIT_ID` int(11) DEFAULT NULL COMMENT '审核单ID',
   PRIMARY KEY (`GOODS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='直播接口所有商品信息';

-- ----------------------------
-- Table structure for `MALL_ROOM_MEDIA`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_ROOM_MEDIA`;
CREATE TABLE `MALL_ROOM_MEDIA` (
    `ROOMID` int NOT NULL COMMENT '房间 id',
    `MEDIA_URL` varchar(216) DEFAULT NULL COMMENT '回放视频 url',
    `EXPIRE_TIME` datetime DEFAULT NULL COMMENT '回放视频 url 过期时间',
    `CREATE_TIME` datetime DEFAULT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='直播房间回放视频';

-- ----------------------------
-- Table structure for `MALL_CATEGORY`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_CATEGORY`;
CREATE TABLE `MALL_CATEGORY` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `NAME` varchar(64) NOT NULL DEFAULT '' COMMENT '分类名称',
  `LEVEL` tinyint(4) DEFAULT '1' COMMENT '级别：1，2，3',
  `PARENT_ID` varchar(32) DEFAULT NULL COMMENT '父节点',
  `SORT` int(11) DEFAULT '0' COMMENT '排序',
  `IS_SHOW` tinyint(4) DEFAULT '1' COMMENT '是否显示 0:否 1:是',
  `IMG_URL` varchar(255) DEFAULT NULL COMMENT '分类页面顶部大图',
  `ICON_URL` varchar(255) DEFAULT NULL COMMENT 'ICON链接',
  `FRONT_NAME` varchar(255) DEFAULT NULL COMMENT '简介',
  PRIMARY KEY (`ID`),
  KEY `PARENT_ID` (`PARENT_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品分类';

-- ----------------------------
-- Records of MALL_CATEGORY
-- ----------------------------
INSERT INTO `MALL_CATEGORY` VALUES ('4b2c9c8c43ff237e52e1ff3ce1308bfa', '居家', 1, '0', 1, 1, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/92357337378cce650797444bc107b0f7.jpg', null, '回家，放松身心');
INSERT INTO `MALL_CATEGORY` VALUES ('98b8179c0784136cec52f69a7c1f92ea', '餐厨', 1, '0', 2, 1, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/w4e1etqqqtd.png', null, '爱，囿于厨房');
INSERT INTO `MALL_CATEGORY` VALUES ('6d56823ab7526e557ad84eab4559117c', '配件', 1, '0', 3, 1, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/cad5aba2bc52d3b8adfd0232c9814de2.png', null, '配角，亦是主角');
INSERT INTO `MALL_CATEGORY` VALUES ('2f2e8548fcd331b6d1442bfee095faf4', '服装', 1, '0', 4, 1, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/003e1d1289f4f290506ac2aedbd09d35.png', null, '贴身的，要亲肤');
INSERT INTO `MALL_CATEGORY` VALUES ('c0eec8a89586d168f68dfdc5669f5639', '洗护', 1, '0', 5, 1, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/ef8c49f8c92d1f86eb76dec0b5bc7cef.jpg', null, '亲肤之物，严选天然');
INSERT INTO `MALL_CATEGORY` VALUES ('88682eeafacd04e1d8dbdfdfd2cde5d7', '婴童', 1, '0', 6, 1, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/7dc78383e44df530f543659a977740de.jpg', null, '爱，从心开始');
INSERT INTO `MALL_CATEGORY` VALUES ('dde7b016cd46d35e33d8c4849c98377a', '杂货', 1, '0', 7, 1, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/d233a1a9060a22e8eb0e2b326252eece.jpg', null, '解忧，每个烦恼');
INSERT INTO `MALL_CATEGORY` VALUES ('de307082822389106675041aef6d8041', '志趣', 1, '0', 9, 1, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/99107fbd76eb66cd537213e478189ae1.png', null, '爱好，点缀生活');
INSERT INTO `MALL_CATEGORY` VALUES ('c9fc055f31c8404f82d8beac70df4f89', '内裤', 2, '2f2e8548fcd331b6d1442bfee095faf4', 1, 1, null, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/0a7fe0a08c195ca2cf55d12cd3c30f09.png', '透气洁净，环保染制');
INSERT INTO `MALL_CATEGORY` VALUES ('e8a24f377d0d4baf8bbd13f71272ab95', '内衣', 2, '2f2e8548fcd331b6d1442bfee095faf4', 2, 1, null, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/02fede55aba1bc6c9d7f7c01682f9e2d.png', '自然染料，亲肤舒适');
INSERT INTO `MALL_CATEGORY` VALUES ('aac3102ee84b43dd8f13e6ecaf7335a4', 'T恤', 2, '2f2e8548fcd331b6d1442bfee095faf4', 3, 1, null, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/505c9a5a794b79e85fef4654722b3447.png', '立体裁剪，专为国人打造');
INSERT INTO `MALL_CATEGORY` VALUES ('4c9b5c41805e4cc9bbeab6b8ff81c350', '袜子', 2, '2f2e8548fcd331b6d1442bfee095faf4', 4, 1, null, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/13f256bac02bb27d74e035ad25cbd375.png', '优选面料，精细做工，越是细节之物，越显品质之处');
INSERT INTO `MALL_CATEGORY` VALUES ('03a0ca10058d43799fb261290b37eb89', '丝袜', 2, '2f2e8548fcd331b6d1442bfee095faf4', 5, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/4f8f86dfd1d4b46a9cf783b4980db47f.png', '厚木制造商，专利冰丝');
INSERT INTO `MALL_CATEGORY` VALUES ('d672046e940646638d8a86048ea799fc', '家居服', 2, '2f2e8548fcd331b6d1442bfee095faf4', 6, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/5da102ea4c64081ce3a05a91c855fbc9.png', '居家休闲必备');
INSERT INTO `MALL_CATEGORY` VALUES ('3ca4b224c83c4e72bca69f56fb40728b', '衬衫', 2, '2f2e8548fcd331b6d1442bfee095faf4', 7, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/7927f8422c341f7353041a30d01045a2.png', '挺拔而不束缚');
INSERT INTO `MALL_CATEGORY` VALUES ('7bb4fb8e79c1444bad7e6f0dbea136c7', '毛衣', 2, '2f2e8548fcd331b6d1442bfee095faf4', 8, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/b610b058cfd73a9211dc890b7b0cbc66.png', '温暖柔软，品质之选');
INSERT INTO `MALL_CATEGORY` VALUES ('ebfac70d20544ff589a0fe33b07a6c83', '卫衣', 2, '2f2e8548fcd331b6d1442bfee095faf4', 9, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/0282a81bbcae6c39918808fe7c4e1b93.png', '舒适百搭，时尚选择');
INSERT INTO `MALL_CATEGORY` VALUES ('65913244e52a446aa49a2931d9281683', '外衣', 2, '2f2e8548fcd331b6d1442bfee095faf4', 10, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/647f7c39eb7c353958274a59fd821d03.png', '外衣，是你面对这个世界的铠甲');
INSERT INTO `MALL_CATEGORY` VALUES ('f6d5ab82ef134f78b242b3626bf20b52', '裤装', 2, '2f2e8548fcd331b6d1442bfee095faf4', 11, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/1728b4eeaa7a3928f5416884f0e75b1c.png', '高质感面料');
INSERT INTO `MALL_CATEGORY` VALUES ('e05fb1fd316c41405c52078a488d2fdf', '夏凉', 2, '4b2c9c8c43ff237e52e1ff3ce1308bfa', 1, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/bd17c985bacb9b9ab1ab6e9d66ee343c.png', '夏凉床品，舒适一夏');
INSERT INTO `MALL_CATEGORY` VALUES ('3015ea04795bb5a9dc25e1741cfce232', '被枕', 2, '4b2c9c8c43ff237e52e1ff3ce1308bfa', 2, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/b43ef7cececebe6292d2f7f590522e05.png', '选用优质材料，确保好芯');
INSERT INTO `MALL_CATEGORY` VALUES ('c21c8558d33b043c31951841ae4e0cc8', '床垫', 2, '4b2c9c8c43ff237e52e1ff3ce1308bfa', 3, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/d6e0e84961032fc70fd52a8d4d0fb514.png', '助你拥有舒眠好梦');
INSERT INTO `MALL_CATEGORY` VALUES ('605635ea67455835317908b2cfda8e30', '床品件套', 2, '4b2c9c8c43ff237e52e1ff3ce1308bfa', 4, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/81f671bd36bce05d5f57827e5c88dd1b.png', '严格用料，亲肤舒适');
INSERT INTO `MALL_CATEGORY` VALUES ('7b42c00db9606b8823ca9dad931d04ab', '地垫', 2, '4b2c9c8c43ff237e52e1ff3ce1308bfa', 5, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/1611ef6458e244d1909218becfe87c4d.png', '手工编织，时尚环保');
INSERT INTO `MALL_CATEGORY` VALUES ('799f6a95d1f5015be9c9d597eeed7574', '布艺软装', 2, '4b2c9c8c43ff237e52e1ff3ce1308bfa', 6, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/2e2fb4f2856a021bbcd1b4c8400f2b06.png', '换个软装，换个家');
INSERT INTO `MALL_CATEGORY` VALUES ('572802d7e14bd4c78c17ea393b29defd', '家具', 2, '4b2c9c8c43ff237e52e1ff3ce1308bfa', 7, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/d5d41841136182bf49c1f99f5c452dd6.png', '一级原木，严苛工艺');
INSERT INTO `MALL_CATEGORY` VALUES ('34761f9789ab1b23a441498357d156ff', '灯具', 2, '4b2c9c8c43ff237e52e1ff3ce1308bfa', 8, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/f702dc399d14d4e1509d5ed6e57acd19.png', '极简主义，贴近生活的设计');
INSERT INTO `MALL_CATEGORY` VALUES ('e278687d564fd77f340f9d6a889e19bb', '家饰', 2, '4b2c9c8c43ff237e52e1ff3ce1308bfa', 9, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/79275db76b5865e6167b0fbd141f2d7e.png', '点缀美好生活，品质在于细节');
INSERT INTO `MALL_CATEGORY` VALUES ('002676ac5545eaf095d93e7ca65158f1', '宠物', 2, '4b2c9c8c43ff237e52e1ff3ce1308bfa', 10, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/dae4d6e89ab8a0cd3e8da026e4660137.png', '出口品质，严选贴合萌宠生活习惯用品。');
INSERT INTO `MALL_CATEGORY` VALUES ('cc14aa8a1ec246b59097a11255e03cd9', '功能箱包', 2, '6d56823ab7526e557ad84eab4559117c', 1, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/0645dcda6172118f9295630c2a6f234f.png', '箱子里装着你的生活');
INSERT INTO `MALL_CATEGORY` VALUES ('874e84509995424bbd7c2398f61e1f83', '双肩包', 2, '6d56823ab7526e557ad84eab4559117c', 2, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/506d19510c967ba137283035a93738a1.png', '精巧设计，严选全程监制');
INSERT INTO `MALL_CATEGORY` VALUES ('72fa2c3cb96647b8b5eb30d25bad6afd', '单肩包', 2, '6d56823ab7526e557ad84eab4559117c', 3, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/55f34f23ed31f31e1313ff33602f90cc.png', '匠心制版，立体有型');
INSERT INTO `MALL_CATEGORY` VALUES ('fa8b3b96fbdd480c91f065b3df59de24', '鞋', 2, '6d56823ab7526e557ad84eab4559117c', 4, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/85566d138ea55e6aaeda2cda02df66f8.png', '百搭造型，舒适脚感，久穿不累');
INSERT INTO `MALL_CATEGORY` VALUES ('058889b5edb54dc2a92f18c972f1c2f3', '靴', 2, '6d56823ab7526e557ad84eab4559117c', 5, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/59485f1aa100e4210e16175f3412fa41.png', 'UGG制造商出品');
INSERT INTO `MALL_CATEGORY` VALUES ('d046b0b4fab14d579d82bf64c90be00e', '拖鞋', 2, '6d56823ab7526e557ad84eab4559117c', 6, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/984ddb9671aab41651784ba55b2cbdcf.png', '人体工学设计，放松双脚');
INSERT INTO `MALL_CATEGORY` VALUES ('fcef86684afa4709ac56d67daa5fee0a', '围巾件套', 2, '6d56823ab7526e557ad84eab4559117c', 7, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/6beb3fd67106e42dc0f026b173373d16.png', '严选好材料，亲肤柔软，防风抗寒，温暖不失风度');
INSERT INTO `MALL_CATEGORY` VALUES ('1715291a7d1b43d4b93749344d682b88', '配饰', 2, '6d56823ab7526e557ad84eab4559117c', 8, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/57ce29ca06f592d65aabfa5f0f87ad43.png', '优选设计，让细节显示好品味');
INSERT INTO `MALL_CATEGORY` VALUES ('b99de50322b246ab88f745cac6803dc5', '数码', 2, '6d56823ab7526e557ad84eab4559117c', 9, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/c33b13875a86da535c935e3d454a6fd2.png', '享受安全智能的科技生活');
INSERT INTO `MALL_CATEGORY` VALUES ('ace77856139d4539bae0c91b9b9d3d29', '服饰', 2, '88682eeafacd04e1d8dbdfdfd2cde5d7', 1, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/004f5f96df4aeb0645abbd70c0637239.png', '100%纯棉，无荧光剂，严格质检');
INSERT INTO `MALL_CATEGORY` VALUES ('3b795f13ee2f4958b5e43073f2c1635e', '妈咪', 2, '88682eeafacd04e1d8dbdfdfd2cde5d7', 2, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/844e2f4dce94f71283840c141d4ca71b.png', '孕育生命的你更值得被爱');
INSERT INTO `MALL_CATEGORY` VALUES ('9a8316ecb9624a1bad6c217f07c774be', '寝居', 2, '88682eeafacd04e1d8dbdfdfd2cde5d7', 3, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/476995896abea91d3f2e9ec20d56bd8d.png', '始于初心，为爱初色');
INSERT INTO `MALL_CATEGORY` VALUES ('ef57c17f0e90485ba9dd76aadf15c4c4', '玩具', 2, '88682eeafacd04e1d8dbdfdfd2cde5d7', 4, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/34b3267efcddad09cd652f181d87aab0.png', '严选材质，安全无害保证');
INSERT INTO `MALL_CATEGORY` VALUES ('592c6a64b9504f19ae1201f9dcc848d5', '婴童洗护', 2, '88682eeafacd04e1d8dbdfdfd2cde5d7', 5, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/f2e301b189befff1d99adf917ba8ce20.png', '给孩子更美好的童年体验');
INSERT INTO `MALL_CATEGORY` VALUES ('d845b4b15e97435fa65909dbcf827576', '喂养', 2, '88682eeafacd04e1d8dbdfdfd2cde5d7', 6, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/6b6f1672fe041594245fe56a5dd80871.png', '安全健康，我们执着于每个细节');
INSERT INTO `MALL_CATEGORY` VALUES ('bcc784afe782468a95291c3ae0ecb54a', '童车童椅', 2, '88682eeafacd04e1d8dbdfdfd2cde5d7', 7, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/4d16871eb80dac59d1796c7d806a5cea.png', '安全舒适，给宝宝一个快乐童年');
INSERT INTO `MALL_CATEGORY` VALUES ('18076cc291f249178d86e9a41777c48d', '锅具', 2, '98b8179c0784136cec52f69a7c1f92ea', 1, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/d2db0d1d0622c621a8aa5a7c06b0fc6d.png', '中华铸铁、精选不锈钢、进口珐琅');
INSERT INTO `MALL_CATEGORY` VALUES ('844b67acec3949ee9f5da5ed3894a385', '杯壶', 2, '98b8179c0784136cec52f69a7c1f92ea', 2, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/ec53828a3814171079178a59fb2593da.png', '10Q品质控制系统');
INSERT INTO `MALL_CATEGORY` VALUES ('278188bb1ca444eca9eef2f24fcb7b21', '功能厨具', 2, '98b8179c0784136cec52f69a7c1f92ea', 3, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/5b94463017437467a93ae4af17c2ba4f.png', '日日使用的物件，制作精良才能更耐用');
INSERT INTO `MALL_CATEGORY` VALUES ('198a7a3d04e843689b37f37143139da8', '餐具', 2, '98b8179c0784136cec52f69a7c1f92ea', 4, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/695ed861a63d8c0fc51a51f42a5a993b.png', '皇家道尔顿、日本KEYUCA制造商出品');
INSERT INTO `MALL_CATEGORY` VALUES ('3027bc39a6f94c8ab5e41685ead0a03f', '茶具咖啡具', 2, '98b8179c0784136cec52f69a7c1f92ea', 5, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/be3ba4056e274e311d1c23bd2931018d.png', '好茶配好器');
INSERT INTO `MALL_CATEGORY` VALUES ('f57f39f441564ba4a03f2e1a1fc3ce4c', '清洁保鲜', 2, '98b8179c0784136cec52f69a7c1f92ea', 6, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/04cd632e1589adcc4345e40e8ad75d2b.png', '让厨房整洁又新鲜，防尘防潮');
INSERT INTO `MALL_CATEGORY` VALUES ('3bb4c7b1396b4d7192729d2aa89bf542', '刀剪砧板', 2, '98b8179c0784136cec52f69a7c1f92ea', 7, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/555afbfe05dab48c1a3b90dcaf89b4f2.png', '厨房实用利器');
INSERT INTO `MALL_CATEGORY` VALUES ('78cd860ac1da45bbae9ad233649cc17d', '厨房小电', 2, '98b8179c0784136cec52f69a7c1f92ea', 8, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/c09d784ba592e4fadabbaef6b2e95a95.png', '省心省力，厨房高效能手');
INSERT INTO `MALL_CATEGORY` VALUES ('3ddfd2a84c3e4399a4dc5b576def4815', '清洁', 2, '98b8179c0784136cec52f69a7c1f92ea', 9, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/3a40faaef0a52627357d98ceed7a3c45.png', '特殊材质，做家务更简单');
INSERT INTO `MALL_CATEGORY` VALUES ('6f3aa6f4f9f24782bd77154534735c80', '毛巾', 2, 'c0eec8a89586d168f68dfdc5669f5639', 1, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/c53d2dd5ba6b1cfb55bd42ea0783f051.png', '精选长绒棉，出口日本品质标准');
INSERT INTO `MALL_CATEGORY` VALUES ('0721d89a73674233b5225eaf62ad277a', '香薰', 2, 'c0eec8a89586d168f68dfdc5669f5639', 2, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/fc7764ff8e12d18f6c5881a32318ed16.png', '提炼纯净，清雅不腻');
INSERT INTO `MALL_CATEGORY` VALUES ('0780c26be6c34586925ff2a93587bc58', '美妆', 2, 'c0eec8a89586d168f68dfdc5669f5639', 3, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/d6a7b9a2eb6af92d709429798a4ca3ea.png', '竹宝堂、资生堂等制造商出品');
INSERT INTO `MALL_CATEGORY` VALUES ('717e6d9cb37343a787fb1e2989de60bb', '面部护理', 2, 'c0eec8a89586d168f68dfdc5669f5639', 4, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/babf6573f8acd53f21205a7577ec03e1.png', '天然成分，无化学添加');
INSERT INTO `MALL_CATEGORY` VALUES ('2ebb35ae7615422abcfe156cbef8c0d0', '护发', 2, 'c0eec8a89586d168f68dfdc5669f5639', 5, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/398375d0e39574c6e87273d328316186.png', '护发超有效小秘诀');
INSERT INTO `MALL_CATEGORY` VALUES ('630f2623745f4eeab5a220ac30de93e0', '日用清洁', 2, 'c0eec8a89586d168f68dfdc5669f5639', 6, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/729638bb13997f9c4c435b41ce6ed910.png', '天然材料，温和去除污垢');
INSERT INTO `MALL_CATEGORY` VALUES ('e95b1db7d909430c8141dd2794aa26a5', '用具', 2, 'c0eec8a89586d168f68dfdc5669f5639', 7, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/4e3aebbd7ffef5bb250d19f13cb85620.png', '环保材料，耐用不发霉');
INSERT INTO `MALL_CATEGORY` VALUES ('806647d2cc75438fb7c2a38b6193034f', '文具', 2, 'dde7b016cd46d35e33d8c4849c98377a', 1, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/e074795f61a83292d0f20eb7d124e2ac.png', '极简设计，环保材质');
INSERT INTO `MALL_CATEGORY` VALUES ('45cb4437f64147119d6e3369fbaee511', '收纳', 2, 'dde7b016cd46d35e33d8c4849c98377a', 2, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/2a62f6c53f4ff089fa6a210c7a0c2e63.png', '智慧收纳，抗菌防霉，便利拆卸，小空间的大智慧');
INSERT INTO `MALL_CATEGORY` VALUES ('f7aca5e93e9845a381960f8217f4e982', '出行用品', 2, 'dde7b016cd46d35e33d8c4849c98377a', 3, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/81e18c6970a7809ee0d86f0545428aa4.png', '便携设计，轻便旅途');
INSERT INTO `MALL_CATEGORY` VALUES ('3d287b7035784eaca0d07b9717eac4ca', '雨具', 2, 'dde7b016cd46d35e33d8c4849c98377a', 4, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/589da0f02917b8393197a43175764381.png', '玻璃纤维伞骨，稳定抗风');
INSERT INTO `MALL_CATEGORY` VALUES ('a36484e2a35841e6a6ea92461d0e3344', '海外', 2, 'dde7b016cd46d35e33d8c4849c98377a', 5, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/fd1de05d274222f1e56d057d2f2c20c6.png', '海外供应商直供，零关税、零风险、即时达');
INSERT INTO `MALL_CATEGORY` VALUES ('45827d23097046a29715a9a2057786f1', '口罩', 2, 'dde7b016cd46d35e33d8c4849c98377a', 6, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/11d9700da759f2c962c2f6d9412ac2a1.png', '权威数据认证效果，防霾有底气');
INSERT INTO `MALL_CATEGORY` VALUES ('9bb32fe8ff2246c5ae193e8c51e6bd17', '户外', 2, 'dde7b016cd46d35e33d8c4849c98377a', 7, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/833476fc3ecc30a7446279b787328775.png', '踏青出游，便携不误好心情');
INSERT INTO `MALL_CATEGORY` VALUES ('5145ef7734cd43358d09e7de6eb28cfa', '节日礼盒', 2, 'dde7b016cd46d35e33d8c4849c98377a', 8, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/bbb6f0ab4f6321121250c12583b0ff9a.png', '遇见节日的美好');
INSERT INTO `MALL_CATEGORY` VALUES ('0a2cc158d74c4d48b45c71e1bbd78916', '眼镜', 2, 'dde7b016cd46d35e33d8c4849c98377a', 9, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/c25fb420ccb6f692a2d16f1740b60d21.png', '实用加时尚，造型百搭单品');
INSERT INTO `MALL_CATEGORY` VALUES ('52104ed48e0e4ff381a3794c9ee16c68', '汽车用品', 2, 'dde7b016cd46d35e33d8c4849c98377a', 10, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/552e943e585a999169fdbc57b59524d6.png', '给你的爱车添装备');
INSERT INTO `MALL_CATEGORY` VALUES ('12c4930d15244f02a68cc76fb0d4bde4', '魔兽世界', 2, 'de307082822389106675041aef6d8041', 1, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/becfba90e8a5c95d403b8a6b9bb77825.png', '魔兽世界周边');
INSERT INTO `MALL_CATEGORY` VALUES ('9661c51b53d9461da57c80b834b18590', '炉石传说', 2, 'de307082822389106675041aef6d8041', 2, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/b5af3f6bfcbeb459d6c448ba87f8cc35.png', '炉石传说周边');
INSERT INTO `MALL_CATEGORY` VALUES ('1414961719824b2abce2c95c4ef22dd7', '守望先锋', 2, 'de307082822389106675041aef6d8041', 3, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/a562f05bf38f5ee478fefb81856aad3d.png', '守望先锋周边');
INSERT INTO `MALL_CATEGORY` VALUES ('89d254fa9e36490a8a30b4ceb58bd34e', '暗黑破坏神III', 2, 'de307082822389106675041aef6d8041', 4, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/1e19e948de63a1d0895a8620250c441f.png', '暗黑破坏神III周边');
INSERT INTO `MALL_CATEGORY` VALUES ('a3d08e66dc594eb39836e9df58a9345c', '星际争霸II', 2, 'de307082822389106675041aef6d8041', 5, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/7394ce778791ae8242013d6c974f47e0.png', '星际争霸II周边');
INSERT INTO `MALL_CATEGORY` VALUES ('9fe03964f7054f439372e7dd9fd7c2c3', '风暴英雄', 2, 'de307082822389106675041aef6d8041', 6, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/ff1e28fb7151008f8dc46bbf8b357f63.png', '风暴英雄周边');
INSERT INTO `MALL_CATEGORY` VALUES ('c187baffeebe4b6fb858dc3b2b118f43', '梦幻西游', 2, 'de307082822389106675041aef6d8041', 7, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/36711325781ca50fdfe234489fca973e.png', '梦幻西游精品周边');
INSERT INTO `MALL_CATEGORY` VALUES ('1b1d0cb36cdb441ba66a11cad775a52c', '唱片', 2, 'de307082822389106675041aef6d8041', 8, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/3b69079ea27f90b4f539e8c3b76680f5.png', '瑞鸣音乐大师匠心打造');
INSERT INTO `MALL_CATEGORY` VALUES ('83c5a0e02fb2426b9cbf0c47d2e5fe46', '大话西游', 2, 'de307082822389106675041aef6d8041', 9, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/470a017f508e9a18f3068be7b315e14b.png', '大话西游正版周边');
INSERT INTO `MALL_CATEGORY` VALUES ('af925f8d4e1b4abdbdecf496f16b6a77', '夏日甜心', 2, 'de307082822389106675041aef6d8041', 10, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/2b8497fe583d3c9759128b2d76f89dfd.png', '湖南卫视《夏日甜心》授权，独家发售大猫熊同款周边');
INSERT INTO `MALL_CATEGORY` VALUES ('86c63a03284e4b7b9a3a31d755462de7', '礼品卡', 2, 'de307082822389106675041aef6d8041', 11, 1, null, 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/category/1266f0767a3f67298a40574df0d177fb.png', '传递高品质生活美学');

-- ----------------------------
-- Table structure for `MALL_ATTRIBUTE`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_ATTRIBUTE`;
CREATE TABLE `MALL_ATTRIBUTE` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `NAME` varchar(64) NOT NULL DEFAULT '' COMMENT '属性名称',
  `SORT` int(11) DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品详情参数类型';

-- ----------------------------
-- Records of MALL_ATTRIBUTE
-- ----------------------------
INSERT INTO `MALL_ATTRIBUTE` VALUES ('03377983671f40cc8057bea7c6354fe6', '安全类别', 26);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('07bc63c9e6b649a4ad867cd4ce8826e6', '执行标准', 5);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('10c1be2d59b24c60b059698ebc7c4b6c', '产地', 6);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('140e851fcd4c41e6939b4b6f64689512', '安全技术类别', 28);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('1fbf226bd06f49f186b12b85cd6fdc03', '件数', 3);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('26387512c0ea4704a32b5ce4b14d17d8', '含绒量', 14);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('2a682c43315e4d69b30e8c9863ab28ad', '适用人数', 25);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('336ea651d23246c5a2e11d2eca83da68', '外用面料', 33);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('44b06a6930f24668b3e1de2be81b1ead', '坐垫外层面料', 35);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('4e486d88931540b281251027d297c7fb', '外层面料', 30);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('597eaf7c616544a589120f2a7d2592a2', '内芯面料', 23);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('6084d547631d41fa8b9abc66c8633468', '尺寸', 9);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('6a8c2241dfbb4baa8412cf43f75a156e', '坐垫内芯材料', 36);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('6c193081b488403caabae1c1c71db2f7', '面料成份', 22);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('718a3c7c439e437ba8171dd3d2bab5ba', '里层面料', 31);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('7c4f1a4710a64218bba14742a9f2da07', '安全技术', 20);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('7c81261f46a54364a4410ac58c2af66e', '填充成分', 12);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('7ca6df34db804ac8ab49ac47eb4c66e1', '填充物重量', 8);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('8baa2c6da7964f598b225718791d534d', '面料', 10);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('8bc1312751574e9797b98df88a8058c9', '内芯', 32);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('906df288a4d940cf8b3887c568645c4a', '外套材质', 17);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('9740a0098f454d5fa03f0fd5931b57f8', '根数', 27);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('b46b64da6d0c487a952e058e3fd0050e', '产品等级', 21);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('b73b0a6b817046af809ecffc7a73e4e7', '*温馨提示', 19);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('bd7db332b3c646d8b629668089958259', '面料成分', 13);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('bfb8ec5b5aa542b18459487c0857fc58', '适用床尺寸', 2);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('c6d53073efff42c9a5bc55bd00b13a71', '内胆材质', 18);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('c8468c7a33604441a2badf674819c7f3', '工艺', 4);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('d22a28a3b20c422fbbade72ea5bc9dc1', '规格', 16);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('dfdc9920a94742b38ee4532a52db2602', '克重', 29);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('e4775e189a53448084d0c44cdf425ca9', '材质', 1);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('ed98f92bc30f4fb48cde2967da5f504f', '商品重量', 34);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('ee3e257a0cd7421596fad85786a6fae1', '温馨提示', 7);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('f56143bf64f241fd97d4593d44fe8943', '重量', 15);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('fd2bf099e8cf4e8e91373c0f5c914ad9', '填充物', 11);
INSERT INTO `MALL_ATTRIBUTE` VALUES ('fe7b1b2b20c747a5a4a0e8344aa0ea33', '颜色', 24);

-- ----------------------------
-- Table structure for `MALL_CHANNEL`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_CHANNEL`;
CREATE TABLE `MALL_CHANNEL` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `NAME` varchar(64) NOT NULL DEFAULT '' COMMENT '名称',
  `URL` varchar(255) NOT NULL DEFAULT '' COMMENT '跳转链接',
  `ICON_URL` varchar(255) NOT NULL DEFAULT '' COMMENT 'ICON链接',
  `SORT` int(11) DEFAULT '0' COMMENT '排序',
  `STATUS` tinyint(4) DEFAULT '0' COMMENT '状态 0:隐藏 1:显示',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='首页展示分类';

-- ----------------------------
-- Records of MALL_CHANNEL
-- ----------------------------
INSERT INTO `MALL_CHANNEL` VALUES ('9c7e9626bf8e446f8983ec2db1f703d3', '服装', '/pages/category/category?id=2f2e8548fcd331b6d1442bfee095faf4', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/upload/20180727/151537891573ed.png', 4, 1);
INSERT INTO `MALL_CHANNEL` VALUES ('a4e2103be9a14f06bf5428096769c254', '居家', '/pages/category/category?id=4b2c9c8c43ff237e52e1ff3ce1308bfa', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/upload/20180727/1509505811a78d.png', 1, 1);
INSERT INTO `MALL_CHANNEL` VALUES ('b23e48f5c3994b1590f70fdf863b3c72', '志趣', '/pages/category/category?id=de307082822389106675041aef6d8041', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/upload/20180727/151514826f7581.png', 5, 1);
INSERT INTO `MALL_CHANNEL` VALUES ('bb06f0a23486480983d04265e7cf353e', '配件', '/pages/category/category?id=6d56823ab7526e557ad84eab4559117c', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/upload/20180727/1508205806587c.png', 3, 1);
INSERT INTO `MALL_CHANNEL` VALUES ('eeeb43de72424fab91abc7704d8880d5', '餐厨', '/pages/category/category?id=98b8179c0784136cec52f69a7c1f92ea', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/upload/20180727/1512165188bbba.png', 2, 1);

-- ----------------------------
-- Table structure for `MALL_GOODS`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_GOODS`;
CREATE TABLE `MALL_GOODS` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `NAME` varchar(128) NOT NULL DEFAULT '' COMMENT '名称',
  `SHOPS_ID` varchar(32) NOT NULL DEFAULT '0' COMMENT '商家ID',
  `CATEGORY_ID` varchar(32) DEFAULT NULL COMMENT '商品类型ID',
  `SHOPS_CATEGORY_ID` varchar(32) DEFAULT NULL COMMENT '商家商品分类ID',
  `GOODS_SN` varchar(64) NOT NULL COMMENT '商品编码',
  `BRAND_ID` varchar(32) DEFAULT NULL COMMENT '品牌ID',
  `GOODS_NUMBER` int(11) DEFAULT '0' COMMENT '商品库存',
  `IS_HOT` tinyint(4) DEFAULT '0' COMMENT '是否热销 0:否 1:是',
  `IS_ON_SALE` tinyint(4) DEFAULT '1' COMMENT '是否上架 0:否 1:是',
  `IS_NEW` tinyint(4) DEFAULT '0' COMMENT '是否新商品 0:否 1:是',
  `IS_LIMITED` tinyint(4) DEFAULT '0' COMMENT '是否限购 0:否 1:是',
  `IS_GROUP` tinyint(4) DEFAULT '0' COMMENT '是否开启拼团 0:否 1:是',
  `GROUP_NUMBER` int(5) DEFAULT '2' COMMENT '拼团人数(阶梯团取最大阶梯人数)，最大99999',
  `GROUP_PRICE` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '拼团的最低价格',
  `IS_DELETE` tinyint(4) DEFAULT '1' COMMENT '删除状态 0：已删除 1：正常',
  `LIST_PIC_URL` varchar(256) DEFAULT NULL COMMENT '列表图',
  `KEYWORDS` varchar(255) DEFAULT NULL COMMENT '关键词',
  `GOODS_BRIEF` varchar(255) DEFAULT NULL COMMENT '简明介绍',
  `UNIT_PRICE` decimal(10,2) DEFAULT '0.00' COMMENT '进价',
  `MARKET_PRICE` decimal(10,2) DEFAULT '0.00' COMMENT '市场价',
  `RETAIL_PRICE` decimal(10,2) DEFAULT '0.00' COMMENT '零售价格',
  `COUNTER_PRICE` decimal(10,2) DEFAULT '0.00' COMMENT '专柜价格',
  `MIN_SELL` int(11) DEFAULT 1 COMMENT '起售数量',
  `IS_APP_EXCLUSIVE` tinyint(4) DEFAULT '0' COMMENT '是否是APP专属 0:否 1:是',
  `APP_EXCLUSIVE_PRICE` decimal(10,2) DEFAULT '0.00' COMMENT 'APP专享价',
  `GOODS_DESC` text COMMENT '商品描述',
  `SORT` int(11) DEFAULT '1' COMMENT '排序',
  `PROMOTION_TAG` varchar(64) DEFAULT NULL COMMENT '推广标签',
  `PROMOTION_DESC` varchar(256) DEFAULT NULL COMMENT '推广描述',
  `SALES` int(11) DEFAULT 0 COMMENT '销量',
  `CREATE_USER_ID` varchar(32) DEFAULT NULL COMMENT '创建人ID',
  `CREATE_TIME` datetime DEFAULT NULL COMMENT '添加时间',
  `CREATE_USER_ORG_NO` varchar(32) DEFAULT NULL COMMENT '创建人所属部门',
  `UPDATE_USER_ID` varchar(32) DEFAULT NULL COMMENT '修改人ID',
  `UPDATE_TIME` datetime DEFAULT NULL COMMENT '修改时间',
  `VIDEO_URL` varchar(256) DEFAULT NULL COMMENT '视频链接',
  PRIMARY KEY (`ID`),
  KEY `CATEGORY_ID` (`CATEGORY_ID`) USING BTREE,
  UNIQUE KEY `GOODS_SN` (`GOODS_SN`) USING BTREE,
  KEY `BRAND_ID` (`BRAND_ID`) USING BTREE,
  KEY `KEYWORDS` (`KEYWORDS`) USING BTREE,
  KEY `IS_ON_SALE` (`IS_ON_SALE`) USING BTREE,
  KEY `IS_DELETE` (`IS_DELETE`) USING BTREE,
  KEY `SORT` (`SORT`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品表';

-- ----------------------------
-- Records of MALL_GOODS
-- ----------------------------
INSERT INTO `MALL_GOODS` VALUES ('83dc4aa9cb99212840fae9e1b0c7b361', '竹语丝麻印花四件套', '3289962fb6cc4431972d2285ff19a500', '605635ea67455835317908b2cfda8e30', '1152161', '1bcbc9d7e2ee5c401b76e6ddd1b4aaa1', 'd67cb841efbd4464acfc0e9c25ed7ddd', 200, 1, 1, 1, 0, 0, 0, 0, 1, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/goodslist/977401e75113f7c8334c4fb5b4bf6215.png', null, '3重透气，清爽柔滑', 429.00, 504.90, 459.00, 459.00, 2, 0, 459.00, '<p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/cf116e8989e4b81e0d50c5f319bc106f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/93fbbfff577742915b3d0d7642656bf7.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c40d9809465f1c1941021f564052d60f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/933ae73c978ed874b2e5cd7ce909f962.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/cb256d888a121c2b71804c7da607b97b.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4be4e62c7b44f25c1a618447aa5dbacf.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/b6fa8de210f4f309a407e61915cf6a37.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/fe8b40624ae2c42c07a5ee9c2d75c8d1.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/46864e53b8d9fc4dee333e237d4a1574.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/22b672c95a602f962ac3bf80bfe78c15.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8dff21e77d809012d2542e144027dce1.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c52320c2b0c0a345eebce48a306feb77.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/3804f056b176a9d6155b59d031ca6132.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c25dc6d4a97dd48eb79099ccb1cc9e0e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ca65e2860c3cf07fa8eab69da1b52660.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/63bf368c5085f50fc615d9c4a59862ab.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4204c63b17ec1fac9bcb91e10ccd1ad0.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/7ab56f66b90797f611eda19493579770.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8af577bad4fc49a0c19746018daa3471.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/0ba321a17808e3bda5e80737d06d2ac0.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/40370cc37a778e51496be60aca486414.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/0dab164aa1ca90730899481e0c753195.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/329548b43585798b6f1bd9b7cd93a0c0.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/017f407ea546506b58221c477a2a8682.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/80ce79453e0eb915b3dfe9b7d638b410.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/d7cec1d667293cb179e67cd965d208df.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/cb29ca1498bd8ff9e36bcb99593f2485.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ca0d32927d292e14e2992c63627e1181.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/d56d749cbf18eb121f3a4040a3ef334f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/61f7e94e631a446f6a683d9256304fd6.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e1f0cae229da25b32a5ddf9a6472379c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/7a8c42109a307ee65b6de0f66d9e4e3f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/3427a0dbb683d88e86b4b1864c767b84.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4bd66cfacfda8467e491bcbb44e22906.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/979f9dcf65ce2b91f7b801f39db9b534.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8043490f0853723691db7ba64cff86c6.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/30ef0f46fcc6a175836332e76f758cc5.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ffd0c62f0c485cc78de05a6b22a7156e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/a422ce5a7a147175adbda6d2549cef6b.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/882556a9ac3b06b518b61c166a8d7f1e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/06aab3c72d4372656a9f1b2e513cb7fd.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/685e4a2fa3481ea948bef5681e52215a.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e3674d2936668967d8b1f97288e66de9.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/eb1f199f0270941fe64e82340042ead1.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/f82cde4430eb4d1bdfb07db04af0e734.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/f39325963c794851d1f12d6383ecdeab.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/7baee43f0c04e3429f9dc30699624c9a.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/2543913123e578347f09cd3f389c05f4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c1c4bccb5cd4ce28be27f3dcdf0055f2.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/757da5724cac81a0ec5cafe3271930fc.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/442b6ff5b416611ee61f989c4dc4d3a1.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/082e748775f644b758d3de6526e97844.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/56fb598a9440324c73745b08715cca3b.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/598fd4ff9a9c1915c9a0f1c3534316d4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/3d847d0a56e444b0e1cb36c26922b884.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/682c7151cad3e694497adfc12cb1e1da.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1ed414f70dcf49f91ceb1e2cbc2f5542.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/3609fa8d28d06e40d1886eb1ac0704cc.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/725aa2568d0f7143f2fbfa101e84447f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/5384db578319addff7edb303be9b1fed.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ca32f04d1d59020beff80d16ce372825.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/3e3782425ceddc455c2ffe74039f00d6.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ac06284b83b3b21a5dffe7614847c6cb.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/f5b98c459b62f8fbbf7be27bb9521d16.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1f5f77de250035f7975183dc67b8f09a.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/086452250325756475c68cb7e93c9d7b.jpg" class="fr-fin"/></p><p><br/></p>', 2, null, '3重透气，清爽柔滑', 12, null, null, null, null, null, null);
INSERT INTO `MALL_GOODS` VALUES ('c3def8ba9211a8d777ef4f7004e67a19', '母亲节礼物-舒适安睡组合', '3289962fb6cc4431972d2285ff19a500', '3015ea04795bb5a9dc25e1741cfce232', '1181000', '1bcbc9d7e2ee5c401b76e6ddd1b4aaa2', 'd67cb841efbd4464acfc0e9c25ed7ddd', 100, 1, 1, 1, 0, 0, 0, 0, 1, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/seckill/1f67b1970ee20fd572b7202da0ff705d.png', null, '安心舒适是最好的礼物', 2857.80, 2857.80, 2598.00, 2598.00, 2, 0, 0.00, '<p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/3ddfe10db43f7df33ba82ae7570ada80.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/7682b7930b4776ce032f509c24a74a1e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e0bb6a50e27681925c5bb26bceb67ef4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ba63b244c74ce06fda82bb6a29cc0f71.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/3c7808c3a4769bad5af4974782f08654.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/71798aaac23a91fdab4d77e1b980a4df.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c88cbb2dd2310b732571f49050fe4059.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/5dfdcd654e0f3076f7c05dd9c19c15ea.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/bd55d6ef7af69422d8d76af10ee70156.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/bae571b22954c521b35e446d652edc1d.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e709c4d9e46d602a4d2125e47110f6ae.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/83e41915035c418db177af8b1eca385c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/f42c561e6935fe3e0e0873653da78670.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8317726fbae80b98764dc4c6233a913e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ba904b7c948b8015db2171435325270f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4969c73d0d8f29bffb69529c96ca4889.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/d80b9b8c5c31031d1cd5357e48748632.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/3fe79bdae40662a7b1feed3179d3dd1f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/79eef059963b12479f65e782d1dca128.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e5a8f64f4297ccc01b41df98b0f252c8.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/a940b9e9525c4861407e4c3b07b02977.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/224b8b81cbe12e4ad060a50f1e26601a.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/85e151647452fad718effb7b1adc18e2.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/d47444ff3bb9dc0aa4ab1f9b84d83768.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/136262743f0c849cc0c55c8e7963dd7e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/331a97cbaff5b25a3b08ed7cdfe29df9.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/89b450aa0a8afe1db566dcad926f1fe8.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c1cf94f13b7280a97e751cebe573fa78.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1822c23def83b77e7607c24237eeec74.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/2af234312b3914d6d0bc316f92134614.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c4f8ab2b3813275d954a8bedcf902d26.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/42f18842ff0c92ed849c4401ae47bb61.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/a8ea64a35799e50ab31ecb65345fe8f4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/18759fa90cd153bdd744280807c3c155.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/431f00d068a8e747959deb3b7bdd495a.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/5bd3b44f1f4c627bfa39f7809e866ec6.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/7fc36778fe2f6129b9c26e8298c5be7e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c568432e3d5ab6786cd9dcae8008891b.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ec82ff5aecafa48807117da68cce2ce9.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/b8eccbed570da595e6f8a71ed4abc42c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/9cae1fed6ecefcd61435fe6e2c700fd6.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e306a418f82777399f5e88b93cca22db.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/a66d717084e23864ce079f936557709f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/6ae06c6505cdbf87a0210fe3b8727d5f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/58ac2086725b0ba2fe800195f274a0b4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/5e2e9d9eb099647fbe041ec6645ac034.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8154357c0fab82bd4e67cda9aaa128c0.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4325763b738ec3183ecf0d82b2b28e32.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/06d8ea9d10035a00f26c5c52cc601ca7.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/499f30b9e69b5dddf3db36f105756111.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ed7e1733d54e711a560edb3a76f1a60c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/b6474347eebdb917d2e827fd526dd01c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/b2c0691f9204c5ebc94b4ff678919ca7.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/b4811e702a6884a9251d7cc9e3b06b6f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/d518783c054695acf329e81d597fdec3.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/835ce09e785cca635c176008975053a1.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/769af780de81a302c0a3b03ed8e6c528.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/da34f99daf9141f0fe56a766461b8485.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/d7c9cd8722a2f9a78e158ce02ec5d4f2.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/09ea18953884b15227819e326103462b.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/5ef728213983842edf1aec27b2c1f5b6.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/95409f2a884dcfeaabfe5e61fcf9ec37.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/6807836dc2a940ba56ea10c7a63b14c9.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e1d976d06853e7a0e6c9cc4ab484ac8a.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/47f5673dec5005092f6d897d6335966c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1b0109abd0e6a0d13fa2423a96c1167e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/916111a8f94cc0bd39375b3dcac14e35.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c1360df3d6b703c5df9b2f47a2a3d12e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1d5a31eb93ef873a165993bd99f29df1.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/997a48948b89dd7261ed5a59ba884f45.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/eb96d9689735c9f4019ebf76da43b2b2.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/a92cf2172e6cafe080e4511205568d79.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c9e94570428f197292bb3f43609963f5.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/37145f06cce747311692ad7f276645db.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c9a698b71ed911364fc6f243006c241c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e89db969711efaa441c43d6b90498a0c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/3803bb1a18229562f18943512b1d3524.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/235cbb5be905ac2b87e7e8f7c8d90144.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/3e38435b3fdbae4ee80b83995592901e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8ceb7cd3231585da60a74dd2c1aa9015.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e151e225c2e30aab7ccf086094381577.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/363c19306953daf10968f4aa86617997.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4237a392cf2e69b110ad4ecf35e44059.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/da8ab35ada2dfe55006db01efa96e51a.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/aa1d4fd00b7879db3f1051dc6d16aa87.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/302a8f2d997ff22bedcd837672cdafc2.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/a39ff68c00522aef0472402958a334d2.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/86ccd0eb677c8b552398869d11a8917e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/a6d0ede352da947060d912d903646a5d.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e6a118bf95bdb61891409d25f193e9c4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c214066e9bf65d60bcebd691b5b1cbc1.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c301559ba3ee280bcbf2fc4269bfa9ca.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/573748f5c12ecb4515ba00a7b6e981dc.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/27bcc8bf512a7e6f994a9683b3deea82.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e22a4507fd1e4b5ef859035e857ae419.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/27b07b4ca709c33ad71b368f87781307.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ef31eb48bcb133728bffda7e1239b592.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/5f49aaaca59c0733ec92f100d01bc0af.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/818889261deb75044e1018ec53485d85.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/200369f023243e2faeb18a2a0a352ef1.jpg" class="fr-fin"/></p><p><br/></p>', 1, null, '安心舒适是最好的礼物', 12, null, null, null, null, null, null);
INSERT INTO `MALL_GOODS` VALUES ('c8135bfe31c1e39c1788b66683720ceb', '清新趣粉全棉四件套 条纹绿格', '3289962fb6cc4431972d2285ff19a500', '605635ea67455835317908b2cfda8e30', '1155000', '1bcbc9d7e2ee5c401b76e6ddd1b4aaa3', 'd67cb841efbd4464acfc0e9c25ed7ddd', 100, 1, 1, 1, 0, 0, 0, 0, 1, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/goodslist/d7d6ef1f1865991077384761b4521dce.png', null, '清新趣粉全棉四件套 青粉拼接', 300.00, 438.90, 399.00, 399.00, 2, 0, 399.00, '<p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/162f14bce2afba3a484ce8fb5da1e58b.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1f7942650759087591c5983b8833b0b0.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/7b2c61359c3323f426a0214d79f52e5d.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4ef5a035b31b1dea51c0f9ad89df9af3.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e78cd4ddd9bd39ab9a488fef9b5f7b3a.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/6cce2f34025ab487af8707ee4cf61373.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/248de06b79ddf1bc6e28a00ffbbb97d0.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c2306432efd11b36979518c91f3dac76.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/d62be6560ff53b1fd6b8f83664965758.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/879123cb7355ce5aa2df371bf8821754.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/24bd066e91fe31da4c21fb6f13d0b944.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/9da18ea054a561a17c36e41d693bfdae.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/71873676e788a2d2aa5184f46cc0f30e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/b3f9463598c55d2c55428b2eef8bf556.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/d1321c2db83e7485c67265427fa986bc.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4cc8bc6028a45eddab15e21ebc7caef7.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/27453a8037edc367424e6432a3e5a59c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/528ef8f963f9733d8cfd0f50556ae110.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/cb3c92fed21740cc6b5c5dc16fc60508.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/0dee0fd961eaffd7aa2bdaf62d2ab126.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/661e1cb14a801d03f28626196c00d14f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/2b6a2f6a7f3a45039b0b7c572c2eeed8.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e46db149caf4b825f4a90627e0db6a79.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/98673c4ff33fc8c55bf88945dbef364c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/9a2324cb4ff8f4332c51343efeaafe8e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/eb0d21207bf5b26592511ef80e48eb91.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/be386763462ada086662387e40431c85.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/71724c37bc98358af22d25a4edebe12d.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/3226eb33802d18a6baa093b1ccc3f412.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/32370f76a781924f6e0252abdea047f6.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/22c82828b81e11053849f3c9f826f453.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e8c42123ac126046542176d511a29139.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/d981ab4821ca98c89e71d2a2a9b23330.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/995a72c9c8bb895f5445a473daccc218.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/251151c89c54c9c272288ed461533a8c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/bba4921b09f7c9eb4bae76259d7d82e2.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/0fd159ef30bfd4cb6e4c37141ad96666.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4e31861a89e1e10be81f5290e31e6b85.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/3404e5c9b9e9e3855a52831a1d4acad7.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/5d15b51fc382847b8de4a4b6fad3646b.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/6fd940b500b07c5157a7db17d858c56f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4cf02bfda7429cb78da05f8b521e5195.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/74ed4ea956e43e6b1f37b1dd31c6feee.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/77d288d7c8e815e014f6ceac652adf83.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/18478afad61f4fad519a4fe598c38bb8.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/f527072aeaed7abb974551d7ad93faf4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/276d97cc862f718bfb7cd8a5970d2b9a.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1765a6390fd9116320230cea1b2e2570.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ee6eff91b9e9ee9c8a70cf9ad59cd274.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4db4a90e1e83e2e77b4b17deb6b618c4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/3e58b2129b6ca7f8f845d88ccb1ecda6.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/fe901e2f92e213b444f4950a6adb320f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/11c552fba5a1ba0bf6189da2d243db7d.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4c78602cdbba3992711257325de376ed.jpg" class="fr-fin"/></p><p><br/></p>', 4, null, '清新趣粉全棉四件套 青粉拼接', 12, null, null, null, null, null, null);
INSERT INTO `MALL_GOODS` VALUES ('b7c4fbf95493bd294054fe4296d0d9ad', '宫廷奢华真丝四件套', '3289962fb6cc4431972d2285ff19a500', '605635ea67455835317908b2cfda8e30', '1135002', '1bcbc9d7e2ee5c401b76e6ddd1b4aaa4', '69d62c7d52d247c58ae19f9174f30296', 111, 1, 1, 1, 0, 0, 0, 0, 1, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/goodslist/45548f26cfd0c7c41e0afc3709d48286.png', '宫廷', '100%桑蚕丝，丝滑润肤', 2299.00, 2858.90, 2599.00, 2599.00, 3, 0, 0.00, '<p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/0424fc28e47640c7c6ba75312c2ca5bf.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8fc6f2fd12ad2ab3e88967f065ff2bbd.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/22c6af025ed0d821fa457007299374b3.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4fd5bff6ec89da1b06fa816519d6e7b6.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/829b112ed840e85bc044f06c6ceab03c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8133e03d441d5cc5b76b24a08dc07d98.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8d63f4e1398c83c683d7338d4f8342b6.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/282121278c7b6955012291e22e593eb1.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/a20f4e08ee42189505c6280deebd099b.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4e684e5f1a11350dda1fed29bdd3e2b9.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/14b61c5ee99410c074e707a218eeda25.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/09017d6080bd06cc61fe041abc63e595.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/6ce679a19442519e3c294af05bfa489f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ba880116df8e433bec57a150434cf902.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/9db45016db258bee5056e3679d7133dd.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/6443ecab537c173230f5b9145e72c63c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e3a2430b1b44534b42fba1bc619fe99b.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/5f4ab8ef6f39d6ee1982a1b5235df01e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/deb0bd2f9c6305edda5a913254eb0226.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/5f605418c295aeafbea74c080b80e1a4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/09e488b6365dfe88c62c342bb6e2651d.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/01ae7e8310ba9d93ea0126f45827b1bf.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/b3bc7467085d7e29f6361d150faa3a12.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/a6d9a750dc037b2d4f12caae612aca01.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/71e32a86e630b8002c9107ca1f277706.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/325da9327a2285f12ef2d5bc8c4b0b59.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/3518bd7650cfe0a2a771b15b860056e1.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/cec68b3a090bbc20e92ab615f46b6cb0.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/650d14dad1f859e6e3e87fd6e915023d.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/9287025a3894cfcbb0a123943e1a7f40.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/f0b50198a0849ebcc8a019574efe51f8.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/058aa1880bb7f810fc1f8133278c59af.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4c175f566a2a819a53872239e201cda7.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ecaad579f54b460ddbaa3daee6cdced8.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c3d70c0519f20473d4b883c5d8bf8eb0.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/18ebbb3dff05fe4c62a098aafa907adb.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/a21ff1cef6c9b8faf725febef4978883.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/b77ebe85aae6430206f5effc343d061b.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1c3e6fe69de64048833a59c95151c28c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/5177ac6904222f532df28d15bc71491a.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/014fcb0caef743722da0bfbafcfdeb01.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1c24c42a4504dc22551fda973c441638.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/70872946f2b39cafe51e4e252f7ffcd7.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/65cda16ab3d35596eea8ab5f43443579.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/fd06e90ca149d8a147c3c42fff7373e4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/89c0e9b6f6a514cf0c288bc31f439d6d.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/0295b6e2d297ad00f9410342a43d4737.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/d583c4150b3003726097b9bf6b02b973.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/0ce855ae6a6b37e1927ca031cd4a681f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/21cfdd18eef2a56e136145b883fb5352.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e7bd322850ade4c17c09f5ea08e274ce.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/aad9f78488ab2a7f1e2b2b6327b14c15.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c350416e505b658f74177c5f794c2306.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e5b8ad7295c3426018f850c224fa6a13.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/78dee1c7c3d083b6e515a894db6b2c1a.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1561f13761b5678e629f0c6b830bddd4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/613c2a8fabcaffb1ad91f59b0651e0ad.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/57617866bd29417ea92e89c09a523b42.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/f476dbfc3a3a5190793d6cf48bed38ba.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8ed42bff4fddcac2c1c792b09577b2d4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1042a5564cf6cd8cde1244500b6dc59e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/62817f417e4f9dcc2ffbac799c65be85.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/73ebcb902436b1f1c2b4c65f4227b991.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e627e3b2666385e9c7687e29e2b9cae0.jpg" class="fr-fin"/></p><p><br/></p>', 4, null, '100%桑蚕丝，丝滑润肤', 23, null, null, null, null, null, null);
INSERT INTO `MALL_GOODS` VALUES ('8947fd4ea8e0a99de6c184214ed180d4', '简约知性记忆棉坐垫', '3289962fb6cc4431972d2285ff19a500', '799f6a95d1f5015be9c9d597eeed7574', '1134030', '1bcbc9d7e2ee5c401b76e6ddd1b4aaa5', 'f6fd2732e9d84da790920003f6f2803c', 230, 1, 1, 1, 0, 0, 0, 0, 1, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/goodslist/aa49dfe878becf768eddc4c1636643a6.png', '坐垫', '慢回弹海绵，时尚设计。', 40.00, 50.00, 46.00, 46.00, 6, 0, 46.00, '<p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/0424fc28e47640c7c6ba75312c2ca5bf.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8fc6f2fd12ad2ab3e88967f065ff2bbd.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/22c6af025ed0d821fa457007299374b3.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4fd5bff6ec89da1b06fa816519d6e7b6.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/829b112ed840e85bc044f06c6ceab03c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8133e03d441d5cc5b76b24a08dc07d98.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8d63f4e1398c83c683d7338d4f8342b6.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/282121278c7b6955012291e22e593eb1.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/a20f4e08ee42189505c6280deebd099b.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4e684e5f1a11350dda1fed29bdd3e2b9.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/14b61c5ee99410c074e707a218eeda25.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/09017d6080bd06cc61fe041abc63e595.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/6ce679a19442519e3c294af05bfa489f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ba880116df8e433bec57a150434cf902.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/9db45016db258bee5056e3679d7133dd.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/6443ecab537c173230f5b9145e72c63c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e3a2430b1b44534b42fba1bc619fe99b.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/5f4ab8ef6f39d6ee1982a1b5235df01e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/deb0bd2f9c6305edda5a913254eb0226.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/5f605418c295aeafbea74c080b80e1a4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/09e488b6365dfe88c62c342bb6e2651d.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/01ae7e8310ba9d93ea0126f45827b1bf.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/b3bc7467085d7e29f6361d150faa3a12.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/a6d9a750dc037b2d4f12caae612aca01.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/71e32a86e630b8002c9107ca1f277706.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/325da9327a2285f12ef2d5bc8c4b0b59.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/3518bd7650cfe0a2a771b15b860056e1.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/cec68b3a090bbc20e92ab615f46b6cb0.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/650d14dad1f859e6e3e87fd6e915023d.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/9287025a3894cfcbb0a123943e1a7f40.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/f0b50198a0849ebcc8a019574efe51f8.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/058aa1880bb7f810fc1f8133278c59af.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4c175f566a2a819a53872239e201cda7.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ecaad579f54b460ddbaa3daee6cdced8.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c3d70c0519f20473d4b883c5d8bf8eb0.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/18ebbb3dff05fe4c62a098aafa907adb.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/a21ff1cef6c9b8faf725febef4978883.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/b77ebe85aae6430206f5effc343d061b.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1c3e6fe69de64048833a59c95151c28c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/5177ac6904222f532df28d15bc71491a.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/014fcb0caef743722da0bfbafcfdeb01.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1c24c42a4504dc22551fda973c441638.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/70872946f2b39cafe51e4e252f7ffcd7.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/65cda16ab3d35596eea8ab5f43443579.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/fd06e90ca149d8a147c3c42fff7373e4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/89c0e9b6f6a514cf0c288bc31f439d6d.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/0295b6e2d297ad00f9410342a43d4737.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/d583c4150b3003726097b9bf6b02b973.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/0ce855ae6a6b37e1927ca031cd4a681f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/21cfdd18eef2a56e136145b883fb5352.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e7bd322850ade4c17c09f5ea08e274ce.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/aad9f78488ab2a7f1e2b2b6327b14c15.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c350416e505b658f74177c5f794c2306.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e5b8ad7295c3426018f850c224fa6a13.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/78dee1c7c3d083b6e515a894db6b2c1a.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1561f13761b5678e629f0c6b830bddd4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/613c2a8fabcaffb1ad91f59b0651e0ad.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/57617866bd29417ea92e89c09a523b42.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/f476dbfc3a3a5190793d6cf48bed38ba.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8ed42bff4fddcac2c1c792b09577b2d4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1042a5564cf6cd8cde1244500b6dc59e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/62817f417e4f9dcc2ffbac799c65be85.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/73ebcb902436b1f1c2b4c65f4227b991.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e627e3b2666385e9c7687e29e2b9cae0.jpg" class="fr-fin"/></p><p><br/></p>', 5, '坐垫', '慢回弹海绵，时尚设计。', 60, null, null, null, null, null, null);
INSERT INTO `MALL_GOODS` VALUES ('5505597d436be5a2b05479bd50705439', '意式毛线绣球四件套', '3289962fb6cc4431972d2285ff19a500', '605635ea67455835317908b2cfda8e30', '1022000', '1bcbc9d7e2ee5c401b76e6ddd1b4aaa6', '93046b54a1bb4c8ca23c32e925b694cd', 100, 1, 1, 1, 0, 0, 0, 0, 1, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/goodslist/5350e35e6f22165f38928f3c2c52ac57.png', '四件套', '浪漫毛线绣球，简约而不简单', 259.00, 328.90, 299.00, 299.00, 2, 0, 299.00, '<p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/0424fc28e47640c7c6ba75312c2ca5bf.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8fc6f2fd12ad2ab3e88967f065ff2bbd.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/22c6af025ed0d821fa457007299374b3.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4fd5bff6ec89da1b06fa816519d6e7b6.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/829b112ed840e85bc044f06c6ceab03c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8133e03d441d5cc5b76b24a08dc07d98.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8d63f4e1398c83c683d7338d4f8342b6.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/282121278c7b6955012291e22e593eb1.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/a20f4e08ee42189505c6280deebd099b.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4e684e5f1a11350dda1fed29bdd3e2b9.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/14b61c5ee99410c074e707a218eeda25.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/09017d6080bd06cc61fe041abc63e595.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/6ce679a19442519e3c294af05bfa489f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ba880116df8e433bec57a150434cf902.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/9db45016db258bee5056e3679d7133dd.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/6443ecab537c173230f5b9145e72c63c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e3a2430b1b44534b42fba1bc619fe99b.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/5f4ab8ef6f39d6ee1982a1b5235df01e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/deb0bd2f9c6305edda5a913254eb0226.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/5f605418c295aeafbea74c080b80e1a4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/09e488b6365dfe88c62c342bb6e2651d.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/01ae7e8310ba9d93ea0126f45827b1bf.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/b3bc7467085d7e29f6361d150faa3a12.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/a6d9a750dc037b2d4f12caae612aca01.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/71e32a86e630b8002c9107ca1f277706.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/325da9327a2285f12ef2d5bc8c4b0b59.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/3518bd7650cfe0a2a771b15b860056e1.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/cec68b3a090bbc20e92ab615f46b6cb0.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/650d14dad1f859e6e3e87fd6e915023d.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/9287025a3894cfcbb0a123943e1a7f40.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/f0b50198a0849ebcc8a019574efe51f8.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/058aa1880bb7f810fc1f8133278c59af.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/4c175f566a2a819a53872239e201cda7.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/ecaad579f54b460ddbaa3daee6cdced8.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c3d70c0519f20473d4b883c5d8bf8eb0.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/18ebbb3dff05fe4c62a098aafa907adb.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/a21ff1cef6c9b8faf725febef4978883.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/b77ebe85aae6430206f5effc343d061b.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1c3e6fe69de64048833a59c95151c28c.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/5177ac6904222f532df28d15bc71491a.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/014fcb0caef743722da0bfbafcfdeb01.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1c24c42a4504dc22551fda973c441638.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/70872946f2b39cafe51e4e252f7ffcd7.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/65cda16ab3d35596eea8ab5f43443579.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/fd06e90ca149d8a147c3c42fff7373e4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/89c0e9b6f6a514cf0c288bc31f439d6d.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/0295b6e2d297ad00f9410342a43d4737.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/d583c4150b3003726097b9bf6b02b973.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/0ce855ae6a6b37e1927ca031cd4a681f.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/21cfdd18eef2a56e136145b883fb5352.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e7bd322850ade4c17c09f5ea08e274ce.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/aad9f78488ab2a7f1e2b2b6327b14c15.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/c350416e505b658f74177c5f794c2306.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e5b8ad7295c3426018f850c224fa6a13.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/78dee1c7c3d083b6e515a894db6b2c1a.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1561f13761b5678e629f0c6b830bddd4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/613c2a8fabcaffb1ad91f59b0651e0ad.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/57617866bd29417ea92e89c09a523b42.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/f476dbfc3a3a5190793d6cf48bed38ba.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/8ed42bff4fddcac2c1c792b09577b2d4.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/1042a5564cf6cd8cde1244500b6dc59e.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/62817f417e4f9dcc2ffbac799c65be85.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/73ebcb902436b1f1c2b4c65f4227b991.jpg" class="fr-fin"/></p><p style="text-align: center;"><img src="http://yanxuan.nosdn.127.net/e627e3b2666385e9c7687e29e2b9cae0.jpg" class="fr-fin"/></p><p><br/></p>', 6, '四件套', '浪漫毛线绣球，简约而不简单', 12, null, null, null, null, null, null);
INSERT INTO `MALL_GOODS` VALUES ('6ee376d38feffca45e7b7c7cb95c0fbc', '微同商城商业版', '3289962fb6cc4431972d2285ff19a500', '12c4930d15244f02a68cc76fb0d4bde4', '1000000', '1bcbc9d7e2ee5c401b76e6ddd1b4aaa7', '135e44f24b6a47bb9c41cfa76a890059', 200, 1, 1, 1, 0, 0, 0, 0, 1, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/grocery/20181228/1114545734c867.jpg', '商业版', '小程序商城', 20000.00, 60000.00, 20000.00, 20000.00, 6, 0, 20000.00, '<p style="text-align: left;"><br/></p><h4 style="box-sizing: inherit; line-height: 1.4; margin-right: 0px; margin-bottom: 16px; margin-left: 0px; padding: 0px; font-size: 1.25em; position: relative; font-family: &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Helvetica Neue&quot;, &quot;Microsoft YaHei&quot;, Arial, Helvetica, sans-serif !important; margin-top: 0px !important;">项目说明<a class="anchor" href="http://fly2you.cn:3000/weitongkeji/platform-mall#%E9%A1%B9%E7%9B%AE%E8%AF%B4%E6%98%8E" style="box-sizing: inherit; background-color: transparent; color: rgb(65, 131, 196); text-decoration-line: none; position: absolute; top: 0px; left: 0px; display: block; padding-right: 6px; padding-left: 30px; margin-left: -30px; line-height: 1.2;"></a></h4><ul style="box-sizing: inherit; margin-bottom: 16px; padding-left: 2em; color: rgba(0, 0, 0, 0.87); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;Segoe UI&quot;, Arial, freesans, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);" class=" list-paddingleft-2"><li><p>服务器环境</p></li><ul style="list-style-type: square;" class=" list-paddingleft-2"><li><p>CentOS</p></li><li><p>Nginx</p></li><li><p>JDK1.8</p></li><li><p>MySQL5.7+</p></li><li><p>Redis</p></li></ul><li><p>开发工具</p></li><ul style="list-style-type: square;" class=" list-paddingleft-2"><li><p>IntelliJ IDEA、Eclipse</p></li><li><p>JetBrains WebStorm</p></li><li><p>微信web开发者工具</p></li><li><p>Navicat for MySQL</p></li><li><p>Xshell</p></li><li><p>Xftp</p></li><li><p>Postman&nbsp;</p></li></ul></ul><p style="text-align: left;"><strong><span style="color: rgb(51, 51, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255);"></span><span style="font-size: 16px; font-style: italic; font-weight: bold; color: rgb(51, 153, 204); line-height: 18px;"><span style="font-size: 16px; font-style: italic; font-weight: bold; line-height: 18px; color: rgb(51, 51, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255);">商业版后台使用SpringBoot开发，前端使用Vue+elementUI，实现前后端分离。</span><br/><span style="font-size: 16px; font-style: italic; font-weight: bold; line-height: 18px; color: rgb(51, 51, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255);">后台技术选型如下：</span></span><span style="color: rgb(51, 51, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255);"></span></strong></p><p style="text-align: left;"><span style="color: rgb(51, 51, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255);"><img src="https://platform-wxmall.oss-cn-beijing.aliyuncs.com//upload/20190718/10074973156a6.png" title="https://platform-wxmall.oss-cn-beijing.aliyuncs.com//upload/20190718/10074973156a6.png" alt="https://platform-wxmall.oss-cn-beijing.aliyuncs.com//upload/20190718/10074973156a6.png" _src="https://platform-wxmall.oss-cn-beijing.aliyuncs.com//upload/20190718/10074973156a6.png"/></span></p><p style="text-align: left;"><span style="font-size: 24px;"><strong><span style="color: rgb(51, 51, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255);">代码片段：</span></strong></span><br/><span style="color: rgb(51, 51, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255);"><span style="font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255); font-size: 16px; font-style: italic; font-weight: bold; color: rgb(51, 153, 204); line-height: 18px;">使用WxJava支付&nbsp;</span></span><a href="https://github.com/Wechat-Group/WxJava/wiki" target="_blank" style="text-decoration: underline; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255); font-size: 16px; font-style: italic; font-weight: bold; color: rgb(51, 153, 204); line-height: 18px;"><span style="font-size: 16px; font-style: italic; font-weight: bold; color: rgb(51, 153, 204); line-height: 18px;">https://github.com/Wechat-Group/WxJava/wiki</span></a><span style="font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255); font-size: 16px; font-style: italic; font-weight: bold; color: rgb(51, 153, 204); line-height: 18px;">&nbsp;</span><span style="color: rgb(51, 51, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255);"></span><br/><img src="https://platform-wxmall.oss-cn-beijing.aliyuncs.com//upload/20190718/1018198032e649.png" _src="https://platform-wxmall.oss-cn-beijing.aliyuncs.com//upload/20190718/1018198032e649.png"/><span style="color: rgb(51, 51, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255);"></span><br/><span style="color: rgb(51, 51, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255);"><span style="font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255); font-size: 16px; font-style: italic; font-weight: bold; color: rgb(51, 153, 204); line-height: 18px;">使用MyBatis-Plus查询&nbsp;</span></span><a href="https://mp.baomidou.com/guide/" target="_blank" style="text-decoration: underline; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255); font-size: 16px; font-style: italic; font-weight: bold; color: rgb(51, 153, 204); line-height: 18px;"><span style="font-size: 16px; font-style: italic; font-weight: bold; color: rgb(51, 153, 204); line-height: 18px;">https://mp.baomidou.com/guide/</span></a><span style="font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255); font-size: 16px; font-style: italic; font-weight: bold; color: rgb(51, 153, 204); line-height: 18px;">&nbsp;</span><span style="color: rgb(51, 51, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255);"></span><br/><img src="https://platform-wxmall.oss-cn-beijing.aliyuncs.com//upload/20190718/101842816bfd2b.png" _src="https://platform-wxmall.oss-cn-beijing.aliyuncs.com//upload/20190718/101842816bfd2b.png"/><span style="color: rgb(51, 51, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255);"></span><br/><span style="color: rgb(51, 51, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255);"><span style="color: rgb(51, 51, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255); font-size: 16px; font-style: italic; font-weight: bold; line-height: 18px;">代码整齐、简洁、高质量！</span></span></p><p style="text-align: left;"><span style="color: rgb(51, 51, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, 微软雅黑, Tahoma, Arial, sans-serif; background-color: rgb(255, 255, 255);"><br/></span></p><p style="text-align: left;"><span style="font-size: 24px;"><strong><span style="color:#333333;font-family:Helvetica Neue, Helvetica, PingFang SC, 微软雅黑, Tahoma, Arial, sans-serif"><span style="background-color: rgb(255, 255, 255);">开发文档目录</span></span></strong></span></p><p style="text-align: left;"><span style="color:#333333;font-family:Helvetica Neue, Helvetica, PingFang SC, 微软雅黑, Tahoma, Arial, sans-serif"><span style="background-color: rgb(255, 255, 255);"></span></span></p><p>1<span style="font-size: 14px; line-height: 107%; color: windowtext;">&nbsp;&nbsp;&nbsp;&nbsp; </span>项目简介<br/></p><p>2<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp; </span>安装教程<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">3</span></p><p>2.1<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>本地开发环境启动步骤<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">3</span></p><p>2.2<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>生产环境部署<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">4</span></p><p>2.2.1<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>后台部署<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">4</span></p><p>2.2.2<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>前端部署<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">4</span></p><p>3<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp; </span>小程序端扫码进入店铺<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">5</span></p><p>3.1<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>生成店铺小程序码<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">5</span></p><p>3.2<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>微信扫码进入店铺<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">7</span></p><p>4<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp; </span>上传图片<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">7</span></p><p>4.1<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>阿里云配置<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">7</span></p><p>4.2<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>腾讯云配置<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">8</span></p><p>4.3<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>七牛云配置<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">10</span></p><p>4.4<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>服务器配置<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">10</span></p><p>5<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp; </span>短信平台<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">11</span></p><p>5.1<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>登录腾讯云平台<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">11</span></p><p>5.2<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>创建短信签名<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">12</span></p><p>5.3<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>创建短信内容<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">12</span></p><p>6<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp; </span>小程序接口文档<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">12</span></p><p>6.1<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>请求路径<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">12</span></p><p>6.2<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>使用说明<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">12</span></p><p>7<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp; </span>后台源码分析<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">14</span></p><p>7.1<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>项目介绍<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">14</span></p><p>7.2<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>代码生成工具的使用<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">14</span></p><p>8<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp; </span>后端源码分析<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">15</span></p><p>8.1<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>platform-admin模块<span style="color: windowtext;display: none">... </span><span style="color: windowtext;display: none">15</span></p><p>8.1.1<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>操作日志（切面编程）<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">15</span></p><p>8.1.2<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>当前登录用户<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">16</span></p><p>8.1.3<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>数据权限实现（mybatis拦截器实现）<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">17</span></p><p>8.2<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>platform-api模块<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">19</span></p><p>8.2.1<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>当前登录会员<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">19</span></p><p>8.2.2<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>不需要token验证的接口<span style="color: windowtext;display: none">... </span><span style="color: windowtext;display: none">20</span></p><p>8.3<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>统一异常处理<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">21</span></p><p>8.3.1<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>后台异常处理<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">21</span></p><p>8.3.2<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>前端统一异常处理<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">23</span></p><p>8.4<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>限流<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">23</span></p><p>8.5<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>同步锁<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">24</span></p><p>8.6<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>定时任务<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">24</span></p><p>9<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp; </span>前端源码分析<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">25</span></p><p>9.1<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>技术栈<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">25</span></p><p>9.2<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>项目结构<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">26</span></p><p>9.3<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>主题定制<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">26</span></p><p>9.4<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>菜单图标<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">27</span></p><p>9.5<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>挂载全局的公共方法<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">27</span></p><p>9.6<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>按钮权限控制<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">27</span></p><p>9.7<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>页面组件<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">27</span></p><p>10<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>微信公众号配置<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">28</span></p><p>11<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>物流相关<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">29</span></p><p>12<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>项目所需材料<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">31</span></p><p>12.1<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>微信注册认证<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">31</span></p><p>12.2<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>微信支付所需材料<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">31</span></p><p>12.3<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>服务器<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">31</span></p><p>12.4<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>其他材料<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">32</span></p><p>13<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>系统所需配置参数<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">32</span></p><p>13.1<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp; </span>wx.appId、wx.secret <span style="color: windowtext;display: none">32</span></p><p>13.2<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp; </span>wx.pay.mchId、wx.pay.mchkey<span style="color: windowtext;display: none">. </span><span style="color: windowtext;display: none">32</span></p><p>13.3<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp; </span>wx.pay.basenotifyurl <span style="color: windowtext;display: none">32</span></p><p>13.4<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp; </span>wx.spbillcreateip<span style="color: windowtext;display: none">.. </span><span style="color: windowtext;display: none">32</span></p><p>13.5<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp; </span>kdn.businessId、kdn.appKey<span style="color: windowtext;display: none">. </span><span style="color: windowtext;display: none">33</span></p><p>13.6<span style="font-size: 14px;line-height: 107%;color: windowtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>业务域名<span style="color: windowtext;display: none">.... </span><span style="color: windowtext;display: none">33</span></p><p><strong>&nbsp;</strong></p><p style="text-align: left;"><span style="color:#333333;font-family:Helvetica Neue, Helvetica, PingFang SC, 微软雅黑, Tahoma, Arial, sans-serif"><span style="background-color: rgb(255, 255, 255);"><br/></span></span><br/></p>', 7, '小程序商城', '小程序商城', 36, null, null, null, null, null, null);

-- ----------------------------
-- Table structure for `MALL_GOODS_ATTRIBUTE`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_GOODS_ATTRIBUTE`;
CREATE TABLE `MALL_GOODS_ATTRIBUTE` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `goods_id` varchar(32) DEFAULT NULL COMMENT '商品Id',
  `attribute_id` varchar(32) DEFAULT NULL COMMENT '属性Id',
  `value` varchar(128) DEFAULT NULL COMMENT '属性值',
  `ORDER_SORT` int(4) DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`),
  KEY `goods_id` (`goods_id`) USING BTREE,
  KEY `attribute_id` (`attribute_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品参数列表';

-- ----------------------------
-- Records of MALL_GOODS_ATTRIBUTE
-- ----------------------------
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('310837365b7830fc701700af9176366a', 'c8135bfe31c1e39c1788b66683720ceb', 'e4775e189a53448084d0c44cdf425ca9', '100% 棉', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('4ce9e974d40b649bb64e472ae4fda38e', 'c3def8ba9211a8d777ef4f7004e67a19', 'd22a28a3b20c422fbbade72ea5bc9dc1', '组合一：AB面独立弹簧床垫 进口乳胶150*20', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('604837c6b8ef2ae7558786a366d71d30', '83dc4aa9cb99212840fae9e1b0c7b361', '6084d547631d41fa8b9abc66c8633468', '1.5米床品：被套200*230cm/枕套：48*74', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('6a92784cc58244a29251c7c499e19cd8', '83dc4aa9cb99212840fae9e1b0c7b361', '07bc63c9e6b649a4ad867cd4ce8826e6', 'GB/T 22844-2009', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('84c6d23e7d329b680a1fb5a9ed583d11', 'c8135bfe31c1e39c1788b66683720ceb', '10c1be2d59b24c60b059698ebc7c4b6c', '中国山东', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('a588f45b0076ad78bb2c0a6bbe4f9446', 'c8135bfe31c1e39c1788b66683720ceb', '07bc63c9e6b649a4ad867cd4ce8826e6', 'GB/t 22844-2009', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('b3f5e6b2c356f9a5d71c2ecf72b32002', '83dc4aa9cb99212840fae9e1b0c7b361', '10c1be2d59b24c60b059698ebc7c4b6c', '中国江苏', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('e0b9ef68ac96c8a6d23776dcabc7f879', 'c8135bfe31c1e39c1788b66683720ceb', '6084d547631d41fa8b9abc66c8633468', '1.5米床品：被套 200*230cm/枕套：48*74', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('f0057244475e4028bd09a92d5cd83448', 'c8135bfe31c1e39c1788b66683720ceb', 'fe7b1b2b20c747a5a4a0e8344aa0ea33', '素雅黑', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('fb7e92566a7bde89e131c98a63bd3c21', '83dc4aa9cb99212840fae9e1b0c7b361', 'e4775e189a53448084d0c44cdf425ca9', '12%长麻/12%竹浆纤维/76%莱赛尔', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('231cc53a4743a25207d00ef0c3ba95d0', 'b7c4fbf95493bd294054fe4296d0d9ad', '10c1be2d59b24c60b059698ebc7c4b6c', '中国四川', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('5edc94907c91eb58abdf429671d70fa4', 'b7c4fbf95493bd294054fe4296d0d9ad', '07bc63c9e6b649a4ad867cd4ce8826e6', 'GB/T22796-2009', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('60124890137e24df603804bdbe4ae163', 'b7c4fbf95493bd294054fe4296d0d9ad', '6084d547631d41fa8b9abc66c8633468', '1.5米床品：被套 200*230cm/枕套 48*74', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('edd186be58c239aae34941c5b6a6de0c', 'b7c4fbf95493bd294054fe4296d0d9ad', 'e4775e189a53448084d0c44cdf425ca9', '100%桑蚕丝', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('1aac5035a5ea070b3d2838a9607cb72e', '8947fd4ea8e0a99de6c184214ed180d4', '03377983671f40cc8057bea7c6354fe6', 'GB18401-2010 B类', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('f7360ecc22e813e9705e5d83226da2f6', '8947fd4ea8e0a99de6c184214ed180d4', '8baa2c6da7964f598b225718791d534d', '100%聚酯纤维', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('efcb16ca0ef6c4585af64278095bfc21', '8947fd4ea8e0a99de6c184214ed180d4', 'd22a28a3b20c422fbbade72ea5bc9dc1', '方形38*38*3cm', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('af62437814814fb69c168844e7ee20f8', '8947fd4ea8e0a99de6c184214ed180d4', 'b46b64da6d0c487a952e058e3fd0050e', '合格品', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('4f137b601fa9125d9403efcdb3fcff95', '8947fd4ea8e0a99de6c184214ed180d4', '7ca6df34db804ac8ab49ac47eb4c66e1', '方形：185g', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('18af605d4859c3a72ae7748aecef0b21', '8947fd4ea8e0a99de6c184214ed180d4', '07bc63c9e6b649a4ad867cd4ce8826e6', 'GB/t 22843-2009', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('1ee3fabbdf0ff1b079da298c71949005', '5505597d436be5a2b05479bd50705439', '9740a0098f454d5fa03f0fd5931b57f8', '200根', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('f9c6e5d4343db79639e21dd7d62883fa', '5505597d436be5a2b05479bd50705439', '6084d547631d41fa8b9abc66c8633468', '被套 200*230cm/床单 245*250/枕套 48*74', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('238cac6eabfa177fc4d7ac1cdb3f55aa', '5505597d436be5a2b05479bd50705439', '03377983671f40cc8057bea7c6354fe6', 'GB18401-2010 B类', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('dcaa15433606f69d08879271ca654439', '5505597d436be5a2b05479bd50705439', 'e4775e189a53448084d0c44cdf425ca9', '100%棉', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('c033343dd601a43d8108437ea7d125ca', '5505597d436be5a2b05479bd50705439', '10c1be2d59b24c60b059698ebc7c4b6c', '中国山东', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('f897fb8370bb55dc9535b3be4c1da1f5', '6ee376d38feffca45e7b7c7cb95c0fbc', '10c1be2d59b24c60b059698ebc7c4b6c', '安徽合肥', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('58293c137fdf5dcf3272991efa9c892d', '6ee376d38feffca45e7b7c7cb95c0fbc', '7c4f1a4710a64218bba14742a9f2da07', 'SpringBoot+Vue', 0);
INSERT INTO `MALL_GOODS_ATTRIBUTE` VALUES ('6b51a56c2e4e3c663b274440b156ec0a', '6ee376d38feffca45e7b7c7cb95c0fbc', 'b73b0a6b817046af809ecffc7a73e4e7', '请勿下单，购买请联系客服', 0);

-- ----------------------------
-- Table structure for `MALL_GOODS_SKU`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_GOODS_SKU`;
CREATE TABLE `MALL_GOODS_SKU` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `GOODS_ID` varchar(32) DEFAULT NULL COMMENT '商品ID',
  `GOODS_SN` varchar(64) NOT NULL COMMENT '商品编码',
  `GOODS_NUMBER` int(11) DEFAULT '0' COMMENT '商品库存',
  `RETAIL_PRICE` decimal(10,2) DEFAULT '0.00' COMMENT '零售价格',
  `MARKET_PRICE` decimal(10,2) DEFAULT '0.00' COMMENT '价格',
  `GROUP_PRICE` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '拼团价格',
  `LIST_PIC_URL` varchar(256) DEFAULT NULL COMMENT '图片',
  `MIN_SELL` int(11) DEFAULT 1 COMMENT '起售数量',
  PRIMARY KEY (`ID`),
  KEY `GOODS_ID` (`GOODS_ID`) USING BTREE,
  UNIQUE KEY `GOODS_SN` (`GOODS_SN`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品SKU';

-- ----------------------------
-- Records of MALL_GOODS_SKU
-- ----------------------------
INSERT INTO `MALL_GOODS_SKU` VALUES ('06480e95a99bfd5bf911684c62a2b0df', 'c3def8ba9211a8d777ef4f7004e67a19', '118100001', 30, 2480.00, 2598.00, 0, null, 1);
INSERT INTO `MALL_GOODS_SKU` VALUES ('2e9ed709b8419b6dc413df03aab253f1', 'c3def8ba9211a8d777ef4f7004e67a19', '118100005', 20, 2581.00, 2598.00, 0, null, 1);
INSERT INTO `MALL_GOODS_SKU` VALUES ('43fa812a2454efc45020ced98e1e388b', 'c3def8ba9211a8d777ef4f7004e67a19', '118100002', 20, 2481.00, 2598.00, 0, null, 1);
INSERT INTO `MALL_GOODS_SKU` VALUES ('4b2256b3632d6494105ce98fd2b25c0b', '83dc4aa9cb99212840fae9e1b0c7b361', '115216101', 100, 459.00, 460.00, 0, null, 1);
INSERT INTO `MALL_GOODS_SKU` VALUES ('610b2b5201b74d6e96fca9b6ae88ad13', 'c8135bfe31c1e39c1788b66683720ceb', '115500001', 100, 399.00, 438.90, 0, null, 1);
INSERT INTO `MALL_GOODS_SKU` VALUES ('ab5687a42d69442336c214f18c45dfc7', 'c3def8ba9211a8d777ef4f7004e67a19', '118100004', 30, 2580.00, 2598.00, 0, null, 1);
INSERT INTO `MALL_GOODS_SKU` VALUES ('ca4357bc5a793e0431e057af77d9139a', 'c3def8ba9211a8d777ef4f7004e67a19', '118100003', 50, 2482.00, 2598.00, 0, null, 1);
INSERT INTO `MALL_GOODS_SKU` VALUES ('ef1d5c55e52c15bc6b5ee03eaf482de0', 'c3def8ba9211a8d777ef4f7004e67a19', '118100006', 50, 2582.00, 2598.00, 0, null, 1);
INSERT INTO `MALL_GOODS_SKU` VALUES ('35833f2b1913bee9a53d983d2bb50b9b', 'b7c4fbf95493bd294054fe4296d0d9ad', '113500201', 22, 2599.00, 2858.90, 0, null, 1);
INSERT INTO `MALL_GOODS_SKU` VALUES ('b9f7e78df6307df23cd9dd6421db150e', 'b7c4fbf95493bd294054fe4296d0d9ad', '113500202', 33, 2598.00, 2858.90, 0, null, 1);
INSERT INTO `MALL_GOODS_SKU` VALUES ('d25deca6be2e2dd320472c0adbf1c076', 'b7c4fbf95493bd294054fe4296d0d9ad', '113500203', 45, 2597.00, 2858.90, 0, null, 1);
INSERT INTO `MALL_GOODS_SKU` VALUES ('f2754c82b27c9ec3b1be062c1e568567', '8947fd4ea8e0a99de6c184214ed180d4', '113403001', 120, 46.00, 50.00, 0, null, 1);
INSERT INTO `MALL_GOODS_SKU` VALUES ('b087b3fd72a188d4e81ad97561f4b92b', '5505597d436be5a2b05479bd50705439', '102200001', 100, 299.00, 328.90, 0, null, 1);
INSERT INTO `MALL_GOODS_SKU` VALUES ('93afd0fbc519171c33b15bc4adaabcf8', '6ee376d38feffca45e7b7c7cb95c0fbc', '100000001', 200, 20000.00, 60000.00, 0, null, 1);

-- ----------------------------
-- Table structure for `MALL_GOODS_SPECIFICATION`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_GOODS_SPECIFICATION`;
CREATE TABLE `MALL_GOODS_SPECIFICATION` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `GOODS_ID` varchar(32) DEFAULT '0' COMMENT '商品ID',
  `SKU_ID` varchar(32) DEFAULT '0' COMMENT 'SKU_ID',
  `NAME` varchar(255) DEFAULT NULL COMMENT 'SKU名称',
  `VALUE` varchar(64) DEFAULT NULL COMMENT 'SKU值',
  `PIC_URL` varchar(255) DEFAULT NULL COMMENT '图片',
  PRIMARY KEY (`ID`),
  KEY `GOODS_ID` (`GOODS_ID`) USING BTREE,
  KEY `SKU_ID` (`SKU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品SKU值表';

-- ----------------------------
-- Records of MALL_GOODS_SPECIFICATION
-- ----------------------------
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('0953ef540e44a0e57afebe688c350b70', 'c3def8ba9211a8d777ef4f7004e67a19', 'ef1d5c55e52c15bc6b5ee03eaf482de0', '颜色', '烟白灰', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('1c8ec91f22f5d6d5efed85b4af0efcf0', 'c3def8ba9211a8d777ef4f7004e67a19', 'ab5687a42d69442336c214f18c45dfc7', '规格', '1.8m床垫*1+枕头*2', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('2a06e340529f7b191f788e41922df4cc', 'c3def8ba9211a8d777ef4f7004e67a19', '2e9ed709b8419b6dc413df03aab253f1', '规格', '1.8m床垫*1+枕头*2', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('2b36a40fce0b0b13a8b1c139c65b3019', 'c3def8ba9211a8d777ef4f7004e67a19', 'ca4357bc5a793e0431e057af77d9139a', '颜色', '烟白灰', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('2caed3181ab358d26fc3ee1cb1f2161f', 'c3def8ba9211a8d777ef4f7004e67a19', '2e9ed709b8419b6dc413df03aab253f1', '颜色', '浅杏粉', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('34427ea111f6d6a8019c5619622f9475', 'c3def8ba9211a8d777ef4f7004e67a19', '06480e95a99bfd5bf911684c62a2b0df', '颜色', '玛瑙红', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('367b24fadad66e2be4650623400f3aa7', '83dc4aa9cb99212840fae9e1b0c7b361', '4b2256b3632d6494105ce98fd2b25c0b', '规格', '标准', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('47acd7941d9e9cbd27659dda44656259', 'c3def8ba9211a8d777ef4f7004e67a19', '43fa812a2454efc45020ced98e1e388b', '颜色', '浅杏粉', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('4d43028e912b0c1806349e6ad8871f68', 'c3def8ba9211a8d777ef4f7004e67a19', '06480e95a99bfd5bf911684c62a2b0df', '规格', '1.5m床垫*1+枕头*2', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('6f2e4e5508747b96df4d570533e58a9b', 'c3def8ba9211a8d777ef4f7004e67a19', 'ef1d5c55e52c15bc6b5ee03eaf482de0', '规格', '1.8m床垫*1+枕头*2', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('75ca941c214acb9f9c3b848f6d6aa1eb', 'c3def8ba9211a8d777ef4f7004e67a19', 'ab5687a42d69442336c214f18c45dfc7', '颜色', '玛瑙红', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('afa65e335a67b9a923b56fb97ac6d7f0', 'c8135bfe31c1e39c1788b66683720ceb', '610b2b5201b74d6e96fca9b6ae88ad13', '规格', '标准', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('d3cf7db6270a3adb151cc3f539b290bb', 'c3def8ba9211a8d777ef4f7004e67a19', '43fa812a2454efc45020ced98e1e388b', '规格', '1.5m床垫*1+枕头*2', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('f948f28717836fd1a045d8b01609d476', 'c3def8ba9211a8d777ef4f7004e67a19', 'ca4357bc5a793e0431e057af77d9139a', '规格', '1.5m床垫*1+枕头*2', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('24b21a67dfeaf1b0e9454fb426ca20f5', 'b7c4fbf95493bd294054fe4296d0d9ad', 'd25deca6be2e2dd320472c0adbf1c076', '规格', '标准', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('6b93daf44e8020360d82a2b643841941', 'b7c4fbf95493bd294054fe4296d0d9ad', '35833f2b1913bee9a53d983d2bb50b9b', '规格', '标准', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('6dde2d980182b7cfbc3f93e6925e0319', 'b7c4fbf95493bd294054fe4296d0d9ad', 'b9f7e78df6307df23cd9dd6421db150e', '颜色', '玛瑙红', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('b632341028741baa80300dcaf2b558bc', 'b7c4fbf95493bd294054fe4296d0d9ad', 'd25deca6be2e2dd320472c0adbf1c076', '颜色', '烟白灰', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('c6360dffed15a672cd0feff456821c62', 'b7c4fbf95493bd294054fe4296d0d9ad', '35833f2b1913bee9a53d983d2bb50b9b', '颜色', '浅杏粉', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('d36f7cbbf7081771759697d255440a9e', 'b7c4fbf95493bd294054fe4296d0d9ad', 'b9f7e78df6307df23cd9dd6421db150e', '规格', '标准', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('b4e360b28b31b83dc654b5e41a28aba1', '8947fd4ea8e0a99de6c184214ed180d4', 'f2754c82b27c9ec3b1be062c1e568567', '规格', '标准', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('4075625b0022ad7018f3f1df954c9319', '5505597d436be5a2b05479bd50705439', 'b087b3fd72a188d4e81ad97561f4b92b', '规格', '标准', null);
INSERT INTO `MALL_GOODS_SPECIFICATION` VALUES ('b81d760ad7c2413c47e8eff61d5fbe2f', '6ee376d38feffca45e7b7c7cb95c0fbc', '93afd0fbc519171c33b15bc4adaabcf8', '规格', '标准', null);

-- ----------------------------
-- Table structure for `MALL_SPECIFICATION`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_SPECIFICATION`;
CREATE TABLE `MALL_SPECIFICATION` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `GOODS_ID` varchar(32) DEFAULT NULL COMMENT '商品ID',
  `NAME` varchar(64) DEFAULT NULL COMMENT 'SKU键名称',
  `SORT` tinyint(4) DEFAULT '1' COMMENT '排序',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品SKU键表';

-- ----------------------------
-- Records of MALL_SPECIFICATION
-- ----------------------------
INSERT INTO `MALL_SPECIFICATION` VALUES ('3aaa548cda7d646299ebf571091844f6', 'c3def8ba9211a8d777ef4f7004e67a19', '规格', 1);
INSERT INTO `MALL_SPECIFICATION` VALUES ('86f96a2ac3f8a61e0a7ee58daa6751e6', 'c3def8ba9211a8d777ef4f7004e67a19', '颜色', 2);
INSERT INTO `MALL_SPECIFICATION` VALUES ('caa57560e6240140cbec3ff350e8f879', 'c8135bfe31c1e39c1788b66683720ceb', '规格', 1);
INSERT INTO `MALL_SPECIFICATION` VALUES ('f49ae794c9056e7bc2ae6d6dd4977d64', '83dc4aa9cb99212840fae9e1b0c7b361', '规格', 1);
INSERT INTO `MALL_SPECIFICATION` VALUES ('b061210c09b4319e504985b56e1af520', 'b7c4fbf95493bd294054fe4296d0d9ad', '颜色', 2);
INSERT INTO `MALL_SPECIFICATION` VALUES ('c5fdcf78e2eaea9255b7201343fcef49', 'b7c4fbf95493bd294054fe4296d0d9ad', '规格', 1);
INSERT INTO `MALL_SPECIFICATION` VALUES ('7cd71f8c8cd9aee0eb7d4972e2a933e2', '8947fd4ea8e0a99de6c184214ed180d4', '规格', 1);
INSERT INTO `MALL_SPECIFICATION` VALUES ('e7d67e20cdf9e5ac039420254e7de9a5', '5505597d436be5a2b05479bd50705439', '规格', 1);
INSERT INTO `MALL_SPECIFICATION` VALUES ('616f83efeb7b23e6efc811693768d76d', '6ee376d38feffca45e7b7c7cb95c0fbc', '规格', 1);

-- ----------------------------
-- Table structure for `MALL_ATTACHMENT`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_ATTACHMENT`;
CREATE TABLE `MALL_ATTACHMENT` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `BUSSINESS_ID` varchar(32) DEFAULT NULL COMMENT '业务表ID',
  `NAME` varchar(512) DEFAULT NULL COMMENT '名称',
  `URL` varchar(512) DEFAULT NULL COMMENT 'URL',
  `ORDER_SORT` int(4) DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`ID`),
  KEY `BUSSINESS_ID` (`BUSSINESS_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='附件表';

-- ----------------------------
-- Records of MALL_ATTACHMENT
-- ----------------------------
INSERT INTO `MALL_ATTACHMENT` VALUES ('0ae89faae2254bd8b49c061f5d0c5535', '8947fd4ea8e0a99de6c184214ed180d4', '35538160e3b41ae559031fa8c82fcebb', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/35538160e3b41ae559031fa8c82fcebb.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('2458095895684b8bb7ceceab53c92921', '8947fd4ea8e0a99de6c184214ed180d4', 'f2107c529bcc5c51bc3ce2b5cc9948db', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/f2107c529bcc5c51bc3ce2b5cc9948db.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('2754fc14c248448a9f9092b873bc3c37', 'b7c4fbf95493bd294054fe4296d0d9ad', '47c131a02d5d5b97ddcd19c16b391bbb', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/47c131a02d5d5b97ddcd19c16b391bbb.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('27f0edae006440a5bc4971d6cf55dfd1', '83dc4aa9cb99212840fae9e1b0c7b361', '810555afa6919c766a33422edefb1bc8', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/810555afa6919c766a33422edefb1bc8.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('2f074cbec8004f44a4b08e34210a9115', 'c8135bfe31c1e39c1788b66683720ceb', '6bdf224d6c0276a2737d6af775b6ed8a', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/6bdf224d6c0276a2737d6af775b6ed8a.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('32b8a2f41c5e45b2b5ae2e30d1e0d0d7', '83dc4aa9cb99212840fae9e1b0c7b361', '79200063ab5893cf3fdd16f428e4d505', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/79200063ab5893cf3fdd16f428e4d505.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('37b8b6d997e9478996abafcdd8852396', '8947fd4ea8e0a99de6c184214ed180d4', '9b4ee214032f7707c15943a1f1dfc881', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/9b4ee214032f7707c15943a1f1dfc881.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('420066313c2a4135b435dd6d662d6b4c', 'c8135bfe31c1e39c1788b66683720ceb', '517914d4f7d872b17a55e9c3864df717', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/517914d4f7d872b17a55e9c3864df717.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('45f14e46153940f6946537dfb559d671', 'c8135bfe31c1e39c1788b66683720ceb', '2eca5d0f8a1ce61baf32311264cebdd1', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/2eca5d0f8a1ce61baf32311264cebdd1.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('4d420a8accfa6fda17e9c7b647c73379', 'c3def8ba9211a8d777ef4f7004e67a19', 'e3f5272b1e404aa99bfa1a8aacd05d21', 'https://platform-wxmall-1251990035.cos.ap-shanghai.myqcloud.com/upload/20191107/e3f5272b1e404aa99bfa1a8aacd05d21.png', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('641418f93ded4b98873f6da2829f043a', 'b7c4fbf95493bd294054fe4296d0d9ad', '586f42c66523559838fbb97b7315bab6', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/586f42c66523559838fbb97b7315bab6.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('84dfec5315024ecebc778be80cbeb9f7', '83dc4aa9cb99212840fae9e1b0c7b361', '38a0b23950b79611fb565bae14351a11', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/38a0b23950b79611fb565bae14351a11.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('ae471e0aa8f84e3d99eb042181fbb1ab', 'b7c4fbf95493bd294054fe4296d0d9ad', 'cb78d268c517c15381aeb5b5905101fe', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/cb78d268c517c15381aeb5b5905101fe.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('b1415bef306e449380d1af52ae658227', 'c8135bfe31c1e39c1788b66683720ceb', '6fa8774f6da6cc473ba3714aec95f6b6', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/6fa8774f6da6cc473ba3714aec95f6b6.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('b48975cac59d4eb0bbfdee8da2bfa690', 'b7c4fbf95493bd294054fe4296d0d9ad', '5300c083dcc0c6a856364d883f3284e8', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/5300c083dcc0c6a856364d883f3284e8.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('cd7313c3c40a4c3ea52f8033042ea9be', '83dc4aa9cb99212840fae9e1b0c7b361', '79200063ab5893cf3fdd16f428e4d505', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/79200063ab5893cf3fdd16f428e4d505.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('dedac9ce7cf440cf9f43ea6897301a85', '8947fd4ea8e0a99de6c184214ed180d4', '97c6d4c7e80855966f0d38392b42a570', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/97c6d4c7e80855966f0d38392b42a570.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('e13f2a58a97e64bee5c2652ce6a525e7', 'c3def8ba9211a8d777ef4f7004e67a19', 'c8c09be5576b4e73a4f981009491cd00', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/c8c09be5576b4e73a4f981009491cd00.png', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('bf0d62f734d845b882259c995e7d3708', '5505597d436be5a2b05479bd50705439', '989d0d84d55e4a77a1c6dafa0a3bc207', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/989d0d84d55e4a77a1c6dafa0a3bc207.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('18056ce28f3548e18bca742cb7004125', '5505597d436be5a2b05479bd50705439', '3664e1b166b8dd54d05edd631e6966f9', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/3664e1b166b8dd54d05edd631e6966f9.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('afae25ba38144f49aac29f78bd56ee20', '5505597d436be5a2b05479bd50705439', 'ac649a9fc8332aae1c60e8a10fb5a775', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/ac649a9fc8332aae1c60e8a10fb5a775.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('a61a275a6055491aa224c26fc5a5dd01', '5505597d436be5a2b05479bd50705439', '61a44e7426fbc32db87afd48d85f2e99', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/attachment/61a44e7426fbc32db87afd48d85f2e99.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('95a3df29557e45e9f944400d57c94f19', '6ee376d38feffca45e7b7c7cb95c0fbc', '1114545734c867.jpg', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/image/20191122/5bd274a77b2a48a68fab2828dc16a32d.jpg', 0);
INSERT INTO `MALL_ATTACHMENT` VALUES ('f1ac521ea310562ef5fc12827aade854', '6ee376d38feffca45e7b7c7cb95c0fbc', '软著.png', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/image/20191122/24725dc0a9824444b6aada5f9cdce939.png', 0);

-- ----------------------------
-- Table structure for `MALL_SECKILL`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_SECKILL`;
CREATE TABLE `MALL_SECKILL` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `SHOPS_ID` varchar(32) NOT NULL DEFAULT '0' COMMENT '店铺ID',
  `GOODS_ID` varchar(32) DEFAULT NULL COMMENT '商品ID',
  `NAME` varchar(128) NOT NULL COMMENT '秒杀名称',
  `LIST_PIC_URL` varchar(255) DEFAULT NULL COMMENT '图片链接',
  `PRICE` decimal(10,2) DEFAULT '0.00' COMMENT '秒杀金额',
  `STOCK` int(11) NOT NULL DEFAULT '0' COMMENT '秒杀库存',
  `START_TIME` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '秒杀开启时间',
  `END_TIME` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '秒杀结束时间',
  `CREATE_TIME` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `VERSION` int(11) COMMENT '版本号',
  PRIMARY KEY (`ID`),
  KEY `START_TIME` (`START_TIME`),
  KEY `END_TIME` (`END_TIME`),
  KEY `CREATE_TIME` (`CREATE_TIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='秒杀库存表';

-- ----------------------------
-- Records of MALL_SECKILL
-- ----------------------------
INSERT INTO `MALL_SECKILL` VALUES ('038e4f78de5fa8f25ac03d0e5c4fd3f7', '3289962fb6cc4431972d2285ff19a500', 'c3def8ba9211a8d777ef4f7004e67a19', '300秒杀母亲节礼物-舒适安睡组合', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/seckill/1f67b1970ee20fd572b7202da0ff705d.png', 300.00, 10, '2019-11-07 18:50:19', '2021-11-07 18:50:30', '2019-11-07 19:02:43', 1);

-- ----------------------------
-- Table structure for `MALL_SHOPS`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_SHOPS`;
CREATE TABLE `MALL_SHOPS` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `QR_CODE` varchar(256) DEFAULT null COMMENT '店铺小程序码',
  `NAME` varchar(128) NOT NULL DEFAULT '' COMMENT '店铺名字',
  `SHOPS_SN` varchar(128) NOT NULL DEFAULT '' COMMENT '店铺编号',
  `IMG_URL` varchar(128) NOT NULL DEFAULT '' COMMENT '店铺图片',
  `USER_ID` varchar(32) DEFAULT NULL COMMENT '店铺管理员',
  `WORK_TIME` varchar(128) DEFAULT NULL COMMENT '营业时间',
  `LONGITUDE` varchar(128) DEFAULT NULL COMMENT '经度',
  `LATITUDE` varchar(128) DEFAULT NULL COMMENT '纬度',
  `DETAILS` varchar(512) DEFAULT NULL COMMENT '详细位置',
  `TELEPHONE` varchar(64) DEFAULT NULL COMMENT '联系电话',
  `DELETE_STATUS` tinyint(4) DEFAULT 1 COMMENT '状态 0：已删除 1：正常',
  `SHOP_DESC` text COMMENT '描述',
  `SORT` tinyint(4) DEFAULT '1' COMMENT '排序',
  `CREATE_USER_ID` varchar(32) DEFAULT '' COMMENT '创建人',
  `CREATE_USER_ORG_NO` varchar(32) DEFAULT NULL COMMENT '创建人所属机构',
  `CREATE_TIME` datetime DEFAULT NULL COMMENT '创建时间',
  `ID_CARD` varchar(20) DEFAULT NULL COMMENT '身份证',
  `APPLYER` varchar(50) DEFAULT NULL COMMENT '申请人',
  `ID_CARD_VALID` varchar(100) DEFAULT NULL COMMENT '身份有效期',
  `APPLY_STATUS` tinyint(2) DEFAULT '0' COMMENT '申请状态 1通过 0不通过',
  `ID_CARD_FRONT` varchar(255) DEFAULT NULL COMMENT '身份证正面',
  `ID_CARD_REVERSE` varchar(255) DEFAULT NULL COMMENT '身份证反面',
  `APPLY_RESULT_DESC` varchar(255) DEFAULT NULL COMMENT '审核结果描述',
  `COMPANY_NAME` varchar(128) DEFAULT NULL COMMENT '公司名称',
  `COMPANY_LICENSE` varchar(255) DEFAULT NULL COMMENT '营业执照',
  `WITHDRAW_USER_ID` varchar(64) DEFAULT NULL COMMENT '提现会员Id',
  `QR_CODE_BIND` varchar(256) DEFAULT NULL COMMENT '绑定二维码',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商家';

-- ----------------------------
-- Records of MALL_SHOPS
-- ----------------------------
INSERT INTO `MALL_SHOPS` VALUES ('3289962fb6cc4431972d2285ff19a500', 'https://platform-wxmall-1251990035.cos.ap-shanghai.myqcloud.com/upload/20210713/638f75b512c14c07a71474758366eb24.png', '合肥一店', '80001', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/banner/79b2dbf762217e6e532f335bda4c85b3.jpg', '1', '8:30-17:30', '117.172108', '31.859577', '安徽省合肥市蜀山区井岗镇稻香路88号', '15209831990', '1', '<p>描述</p>', '1', '1', null, null, null, null, null, '1', null, null, null, null, null, null, 'http://harmon.oss-cn-beijing.aliyuncs.com/image/20210524/82c8d4f8f91c4104882ddaa00d000319.png');

-- ----------------------------
-- Table structure for `MALL_SHOPS_CATEGORY`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_SHOPS_CATEGORY`;
CREATE TABLE `MALL_SHOPS_CATEGORY` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `NAME` varchar(32) NOT NULL DEFAULT '' COMMENT '分类名称',
  `SHOPS_ID` varchar(32) NOT NULL DEFAULT '0' COMMENT '店铺ID',
  `STATUS` tinyint(4) DEFAULT '1' COMMENT '状态 0:隐藏 1:显示',
  `SORT` tinyint(4) DEFAULT '1' COMMENT '排序',
  `ICON` varchar(256) DEFAULT NULL COMMENT '图标',
  `CREATE_USER_ID` varchar(32) DEFAULT NULL COMMENT '创建者ID',
  `CREATE_USER_ORG_NO` varchar(32) DEFAULT NULL COMMENT '创建人所属机构',
  `CREATE_TIME` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`ID`),
  KEY `SHOPS_ID` (`SHOPS_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='店铺商品分类';

-- ----------------------------
-- Records of MALL_SHOPS_CATEGORY
-- ----------------------------
INSERT INTO `MALL_SHOPS_CATEGORY` VALUES ('1bcbc9d7e2ee5c401b76e6ddd1b4aaa3', '服装', '3289962fb6cc4431972d2285ff19a500', 1, 1, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/image/20191207/de524f4eacd8485ab7f4744c819becce.jpg', null, null, null);
INSERT INTO `MALL_SHOPS_CATEGORY` VALUES ('69ff31284bfeeca217bfda0822b80d2d', '床垫', '3289962fb6cc4431972d2285ff19a500', 1, 2, 'https://img-shop.qmimg.cn/s23107/2019/04/30/458c5a14fb2f190f96.png?imageView2/0/w/200/h/200', null, null, null);
INSERT INTO `MALL_SHOPS_CATEGORY` VALUES ('942fcc6943965ff8c0d1493199ace9e4', '居家', '3289962fb6cc4431972d2285ff19a500', 1, 4, 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/image/20191205/f24fe6102ace4611851211a51a9cebb6.png', null, null, null);
INSERT INTO `MALL_SHOPS_CATEGORY` VALUES ('ab5028d7f376abd839c021867fc7420d', '棉麻', '3289962fb6cc4431972d2285ff19a500', 1, 5, 'https://fly2you.cn/upload/20201113/5b37e0b98b584d469bb76593810e355b.jpg', null, null, null);
INSERT INTO `MALL_SHOPS_CATEGORY` VALUES ('e7af7c33a658bd743b825bd2ca5c21da', '被枕', '3289962fb6cc4431972d2285ff19a500', 1, 3, 'https://fly2you.cn/upload/20201217/605241b99c084133b9b31b8703648fb5.jpg', null, null, null);

-- ----------------------------
-- Table structure for `MALL_ACCOUNT_LOG`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_ACCOUNT_LOG`;
CREATE TABLE `MALL_ACCOUNT_LOG` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `USER_ID` varchar(32) NOT NULL,
  `TYPE` tinyint(4) NOT NULL COMMENT '类型：1=收入，2=支出',
  `PRICE` decimal(10,2) NOT NULL COMMENT '变动金额',
  `LOG_DESC` text NOT NULL COMMENT '变动说明',
  `ADD_TIME` datetime NOT NULL,
  `ORDER_TYPE` tinyint(4) NOT NULL DEFAULT '0' COMMENT '订单类型 0--充值 1--商城订单 2--秒杀订单 3--拼团订单 4--商城订单退款 5--秒杀订单退款 6--拼团订单退款',
  `ORDER_SN` varchar(32) DEFAULT '0' COMMENT '订单编号',
  `FROM_TYPE` tinyint(4) DEFAULT NULL COMMENT '用户下单来源类型 1:微信小程序 2:微信公众号 3:app 4:H5 5:支付宝小程序',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户账户余额变动记录';

-- ----------------------------
-- Records of MALL_ACCOUNT_LOG
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_INTEGRAL_LOG`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_INTEGRAL_LOG`;
CREATE TABLE `MALL_INTEGRAL_LOG` (
    `ID` varchar(32) NOT NULL COMMENT '主键',
    `USER_ID` varchar(32) DEFAULT NULL COMMENT '会员ID',
    `TYPE` tinyint(4) NOT NULL COMMENT '类型：1=收入，2=支出',
    `TYPE_DETAIL` tinyint(4) DEFAULT NULL COMMENT '类型 1：签到奖励 2：购物奖励 3：抽奖奖励 4：系统发放 5：兑换支出 6：退款',
    `NUMBER` int(11) NOT NULL COMMENT '变动积分数量',
    `ADD_TIME` datetime DEFAULT NULL COMMENT '添加时间',
    PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='积分变动记录';

-- ----------------------------
-- Table structure for `MALL_INTEGRAL_GOODS`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_INTEGRAL_GOODS`;
CREATE TABLE `MALL_INTEGRAL_GOODS` (
    `ID` varchar(32) NOT NULL COMMENT '主键',
    `NAME` varchar(128) NOT NULL DEFAULT '' COMMENT '名称',
    `GOODS_SN` varchar(64) NOT NULL COMMENT '商品编码',
    `GOODS_NUMBER` int(11) DEFAULT 0 COMMENT '商品库存',
    `IS_ON_SALE` tinyint(4) DEFAULT 1 COMMENT '是否上架 0:否 1:是',
    `IS_DELETE` tinyint(4) DEFAULT 1 COMMENT '删除状态 0：已删除 1：正常',
    `LIST_PIC_URL` varchar(256) DEFAULT NULL COMMENT '列表图',
    `KEYWORDS` varchar(255) DEFAULT NULL COMMENT '关键词',
    `GOODS_BRIEF` varchar(255) DEFAULT NULL COMMENT '简明介绍',
    `RETAIL_PRICE` int(11) DEFAULT 0 COMMENT '积分价格',
    `GOODS_DESC` text COMMENT '商品描述',
    `SORT` int(11) DEFAULT '1' COMMENT '排序',
    `SALES` int(11) DEFAULT 0 COMMENT '销量',
    `CREATE_USER_ID` varchar(32) DEFAULT NULL COMMENT '创建人ID',
    `CREATE_TIME` datetime DEFAULT NULL COMMENT '添加时间',
    `CREATE_USER_ORG_NO` varchar(32) DEFAULT NULL COMMENT '创建人所属部门',
    `VIDEO_URL` varchar(256) DEFAULT NULL COMMENT '视频链接',
    PRIMARY KEY (`ID`),
    UNIQUE KEY `GOODS_SN` (`GOODS_SN`) USING BTREE,
    KEY `KEYWORDS` (`KEYWORDS`) USING BTREE,
    KEY `IS_ON_SALE` (`IS_ON_SALE`) USING BTREE,
    KEY `IS_DELETE` (`IS_DELETE`) USING BTREE,
    KEY `SORT` (`SORT`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='积分商品表';

-- ----------------------------
-- Table structure for `MALL_ADDRESS`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_ADDRESS`;
CREATE TABLE `MALL_ADDRESS` (
  `ID` varchar(32) NOT NULL,
  `USER_ID` varchar(32) NOT NULL COMMENT '会员ID',
  `USER_NAME` varchar(64) DEFAULT NULL COMMENT '收货人姓名',
  `MOBILE` varchar(32) DEFAULT NULL COMMENT '手机',
  `POSTAL_CODE` varchar(64) DEFAULT NULL COMMENT '邮编',
  `NATIONAL_CODE` varchar(64) DEFAULT NULL COMMENT '收货地址国家码',
  `PROVINCE_NAME` varchar(64) DEFAULT NULL COMMENT '省',
  `CITY_NAME` varchar(64) DEFAULT NULL COMMENT '市',
  `COUNTY_NAME` varchar(64) DEFAULT NULL COMMENT '区',
  `DETAIL_INFO` varchar(512) DEFAULT NULL COMMENT '详细收货地址信息',
  `IS_DEFAULT` tinyint(4) NOT NULL DEFAULT '0' COMMENT '默认地址 0:否 1:是',
  `LONGITUDE` varchar(128) DEFAULT NULL COMMENT '经度',
  `LATITUDE` varchar(128) DEFAULT NULL COMMENT '纬度',
  PRIMARY KEY (`ID`),
  KEY `USER_ID` (`USER_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员地址';

-- ----------------------------
-- Records of MALL_ADDRESS
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_BANNER`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_BANNER`;
CREATE TABLE `MALL_BANNER` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `MEDIA_TYPE` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型 0:图片 1:链接 2:文本',
  `TITLE` varchar(128) DEFAULT '' COMMENT '标题',
  `IMAGE_URL` text COMMENT '图片',
  `LINK` varchar(256) DEFAULT '' COMMENT '链接',
  `CONTENT` text COMMENT '文本',
  `END_TIME` datetime DEFAULT NULL COMMENT '结束时间',
  `ENABLED` tinyint(4) DEFAULT '1' COMMENT '状态 0:禁用 1:启用',
  `VIDEO_URL` varchar(256) DEFAULT '' COMMENT '视频链接',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='首页轮播配置';

-- ----------------------------
-- Records of MALL_BANNER
-- ----------------------------
INSERT INTO `MALL_BANNER` VALUES ('1', 1, '商业版', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/banner/38a0b23950b79611fb565bae14351a11.jpg', '/pages/goods/goods?id=83dc4aa9cb99212840fae9e1b0c7b361', '商业版', '2020-11-05 08:37:20', 1, null);
INSERT INTO `MALL_BANNER` VALUES ('2', 0, '双十一', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/banner/aa860e44fbd468a7804c1a84796c4827.jpg', null, null, '2020-11-05 08:37:29', 1, null);
INSERT INTO `MALL_BANNER` VALUES ('3', 0, '纷格新品', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/banner/f02a4f8d5bbaf7f32e131c1f08ff21ae.jpg', null, null, '2020-11-05 08:37:31', 1, null);
INSERT INTO `MALL_BANNER` VALUES ('4', 0, '居家生活', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/banner/79b2dbf762217e6e532f335bda4c85b3.jpg', null, null, '2020-10-05 08:37:37', 1, null);
INSERT INTO `MALL_BANNER` VALUES ('471d15d1d9f5e929b4f1a870829ca431', 0, '111', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/image/20200301/bed930af04ae43acb0b5d8b6062c8f81.png', '', null, '2020-08-29 00:00:00', 1, null);

-- ----------------------------
-- Table structure for `MALL_BRAND`
-- ----------------------------index.wxml
DROP TABLE IF EXISTS `MALL_BRAND`;
CREATE TABLE `MALL_BRAND` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `NAME` varchar(255) NOT NULL COMMENT '品牌名称',
  `LIST_PIC_URL` varchar(255) DEFAULT '' COMMENT '品牌大图',
  `APP_LIST_PIC_URL` varchar(255) DEFAULT '' COMMENT '品牌小图',
  `SIMPLE_DESC` varchar(255) DEFAULT '' COMMENT '品牌描述',
  `SORT` int(11) DEFAULT '0' COMMENT '排序',
  `IS_SHOW` tinyint(4) DEFAULT '1' COMMENT '显示 0:否 1:是',
  `FLOOR_PRICE` decimal(10,2) DEFAULT '0.00' COMMENT '底价',
  PRIMARY KEY (`ID`),
  KEY `IS_SHOW` (`IS_SHOW`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='品牌制造商';

-- ----------------------------
-- Records of MALL_BRAND
-- ----------------------------
INSERT INTO `MALL_BRAND` VALUES ('135e44f24b6a47bb9c41cfa76a890059', '星巴克制造商', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/5668bc50f2f2e551891044525710dc84.png', 'https://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/5668bc50f2f2e551891044525710dc84.png', '严选寻访全国保温杯制造企业，最终找到高端咖啡品牌星巴克的制造商，专注保温杯生产20年，品质与颜值兼备。', 34, 1, 39.00);
INSERT INTO `MALL_BRAND` VALUES ('1ebfa920d8fe479492dac5dbdd88dccb', 'Coach制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/1b1cc16135fd8467d40983f75f644127.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/1b1cc16135fd8467d40983f75f644127.png', '严选为制作高品质高颜值皮具配件，由Coach、MK等品牌制造商生产，由严选360度全程监制，给你带来优质皮具。', 3, 1, 49.00);
INSERT INTO `MALL_BRAND` VALUES ('20bbc20f6b9a43d58ce72f7bbe433940', 'PetitBateau小帆船制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/1a11438598f1bb52b1741e123b523cb5.jpg', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/1a11438598f1bb52b1741e123b523cb5.jpg', '为打造适合宝宝的婴童服装，严选团队寻找PetitBateau小帆船的品牌制造商，无荧光剂，国家A类标准，让宝宝穿的放心。', 25, 1, 36.00);
INSERT INTO `MALL_BRAND` VALUES ('2206a7888a3147f190e85d107488b5c2', 'Gucci制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/278869cad9bf5411ffc18982686b88fb.jpg', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/278869cad9bf5411ffc18982686b88fb.jpg', '严选为设计一款优雅时尚的品质礼帽，找寻拥有10来年经验的大型毛毡帽厂商合作，坚持打造好设计、好工艺、好材质的潮流礼帽。', 23, 1, 59.00);
INSERT INTO `MALL_BRAND` VALUES ('22e7d3fae8b64bb98e265d6d0a23540e', 'Adidas制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/335334d0deaff6dc3376334822ab3a2f.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/335334d0deaff6dc3376334822ab3a2f.png', '严选找到为Adidas等品牌制造商，选取优质原材料，与厂方一起设计，为你提供好的理想的运动装备。', 30, 1, 49.00);
INSERT INTO `MALL_BRAND` VALUES ('2db5ff5f54ef43d58e72f26f6f920322', 'NITORI制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/6f3d310601b18610553c675e0e14d107.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/6f3d310601b18610553c675e0e14d107.png', '宠物是人类最温情的陪伴，严选找寻日本最大家居品牌NITORI制造商，每一个脚印，都是为了更好地关怀你的TA', 43, 1, 69.00);
INSERT INTO `MALL_BRAND` VALUES ('33609faebf144b399cb0c202d30079fc', '资生堂制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/5449236b80d1e678dedee2f626cd67c4.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/5449236b80d1e678dedee2f626cd67c4.png', '发现美，成为美，是女性一生的追求。严选找寻资生堂代工厂，打造天然美妆产品，致力于带来更多美的体验和享受。', 19, 1, 29.00);
INSERT INTO `MALL_BRAND` VALUES ('3527d8ff88cb4910b9ec8c5bdfbc74a1', 'Timberland制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/6dcadb0791b33aa9fd00380b44fa6645.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/6dcadb0791b33aa9fd00380b44fa6645.png', '为制作优质时尚的工装鞋靴，严选团队深入探访国内外制靴大厂，选择Timberland制造商，工厂拥有15年制鞋历史，专业品质有保证。', 37, 1, 359.00);
INSERT INTO `MALL_BRAND` VALUES ('36ac2bb1d5f84014ba605f5b51baa922', 'Goody制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/7c918f37de108f3687d69b39daab34eb.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/7c918f37de108f3687d69b39daab34eb.png', '严选深入美国百年发饰品牌Goody制造商，确保每把梳子做工精湛，养护头皮。戴安娜王妃的最爱，你也能拥有。', 48, 1, 39.00);
INSERT INTO `MALL_BRAND` VALUES ('39fd15c5bff14e0e809ac5b6c29ca5dd', '爱马仕集团制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/d98470dd728fb5a91f7aceade07572b5.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/d98470dd728fb5a91f7aceade07572b5.png', '严选采用欧洲一线品牌爱马仕的御用香料供应商，经过反复配比改良、试香调香、选品定样，为你带来独特馥郁的散香体验。', 33, 1, 19.00);
INSERT INTO `MALL_BRAND` VALUES ('3a1d66ab41024a4ba27d7e6a1f3627e6', 'OBH制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/bf3499ac17a11ffb9bb7caa47ebef2dd.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/bf3499ac17a11ffb9bb7caa47ebef2dd.png', '严选寻找OBH品牌的制造商，打造精致厨具，韩国独资工厂制造，严格质检，品质雕琢力求为消费者带来全新的烹饪体验。', 42, 1, 39.00);
INSERT INTO `MALL_BRAND` VALUES ('3f09b49a184d470da87a7bf16bec9f8e', '竹宝堂制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/61b0b7ae4f0163422009defbceaa41ad.jpg', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/61b0b7ae4f0163422009defbceaa41ad.jpg', '严选走访河北、安徽等制刷基地，选定竹宝堂、丝芙兰等品牌的制造商，严格把关生产与质检，与您一同追求美的生活。', 39, 1, 29.00);
INSERT INTO `MALL_BRAND` VALUES ('4273af1e49a64b198e5412dbb727bc53', '新秀丽制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/80dce660938931956ee9a3a2b111bd37.jpg', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/80dce660938931956ee9a3a2b111bd37.jpg', '严选为制作品质与颜值兼具的箱包，选定新秀丽、CK、Ricardo等品牌合作的制造商，拥有国内先进流水线20余条，实力保障品质。', 5, 1, 59.00);
INSERT INTO `MALL_BRAND` VALUES ('5375ba721fec4d4e8eb6dcc2e4236f20', 'Royal Doulton制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/0de643a02043fd9680b11e21c452adaa.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/0de643a02043fd9680b11e21c452adaa.png', '严选深入英国最大骨瓷品牌Royal Doulton制造商，顶级英国瓷器的代名词，广受世界皇室喜爱。每件瓷器，都有自己的故事。', 47, 1, 24.90);
INSERT INTO `MALL_BRAND` VALUES ('61fd1060e9364c77994308caa7303e84', '罗莱制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/14122a41a4985d23e1a172302ee818e9.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/14122a41a4985d23e1a172302ee818e9.png', '严选团队为打造吸湿透气柔软的蚕丝被，从蚕茧原材到温感性能，多次甄选测试选择罗莱制造商工厂，手工处理，优质舒适。', 45, 1, 699.00);
INSERT INTO `MALL_BRAND` VALUES ('62f2bf8c95a94b12a7ceb064cf3c603d', 'MUJI制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/1541445967645114dd75f6b0edc4762d.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/1541445967645114dd75f6b0edc4762d.png', '严选精选了MUJI制造商和生产原料，用几乎零利润的价格，剔除品牌溢价，让用户享受原品牌的品质生活。', 2, 1, 12.90);
INSERT INTO `MALL_BRAND` VALUES ('69d62c7d52d247c58ae19f9174f30296', 'Police制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/66e2cb956a9dd1efc7732bea278e901e.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/66e2cb956a9dd1efc7732bea278e901e.png', '严选团队选定Police品牌制造商合作，有11年眼镜生产资质，兼顾品质与品味，为你带来专业时尚的墨镜。', 6, 1, 109.00);
INSERT INTO `MALL_BRAND` VALUES ('6cfb443ee50b4af8bb008d3185d8498b', 'Sperry制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/2eb12d84037346441088267432da31c4.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/2eb12d84037346441088267432da31c4.png', '严选团队对比多家硫化鞋制造商产品质量，走访多个制鞋工厂，最终选定Sperry品牌制造商，为你提供一双舒适有型的高品质帆布鞋。', 32, 1, 199.00);
INSERT INTO `MALL_BRAND` VALUES ('729a4ccbb7f2407dafa62cf3dbaaa010', '爱慕制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/5104f84110eac111968c63c18ebd62c0.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/5104f84110eac111968c63c18ebd62c0.png', '150家样品比对筛选，20家工厂深入走访，严选最终选定高端内衣爱慕制造商，20年品质保证，为你打造天然舒适的衣物。', 9, 1, 35.00);
INSERT INTO `MALL_BRAND` VALUES ('78d15b4649fe47e2a0a2cb591239e323', 'Palladium制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/3480f2a4026c60eb4921f0aa3facbde8.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/3480f2a4026c60eb4921f0aa3facbde8.png', '严选探访多个制鞋大厂，选定Palladium制造商，对比工艺选材，找到传承多年的制鞋配方，只为制作一款高品质休闲鞋。', 31, 1, 249.00);
INSERT INTO `MALL_BRAND` VALUES ('7b5f62315d1748aeb9179a964ffe0f33', 'TEFAL制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/2b7a07e25a3f3be886a7fb90ba975bb7.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/2b7a07e25a3f3be886a7fb90ba975bb7.png', '严选对标国际品质，致力于高品质生活好物，执着寻求优质厨房电器供应商，携手WMF、Tefal制造商，打造高品质厨具。', 44, 1, 259.00);
INSERT INTO `MALL_BRAND` VALUES ('7d3573b433064cc78569a291913950b3', 'Carters制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/efe9131599ced0297213e6ec67eb2174.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/efe9131599ced0297213e6ec67eb2174.png', '来自Carters大牌代工厂生产，严选纯天然材料，无荧光不添加，ITS安心标志权威检测，安全护航。', 41, 1, 19.90);
INSERT INTO `MALL_BRAND` VALUES ('7ffe4b24d91c482a9a70816eeebb7d6b', '优衣库制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/0d72832e37e7e3ea391b519abbbc95a3.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/0d72832e37e7e3ea391b519abbbc95a3.png', '严选找到日本知名服装UNIQLO的制造商，选取优质长绒棉和精梳工艺，与厂方一起设计，为你提供理想的棉袜。', 12, 1, 29.00);
INSERT INTO `MALL_BRAND` VALUES ('824f5d5f443c4720b7c5da9d653dc4b7', '京瓷制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/3dda530605e3ab1c82d5ed30f2489473.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/3dda530605e3ab1c82d5ed30f2489473.png', '严选想为你的厨房生活，带来新鲜感和活力，深入全国各地，选择日本京瓷等品牌代工厂，打造钻石系列厨具，颜值与品质兼具。', 38, 1, 89.00);
INSERT INTO `MALL_BRAND` VALUES ('8bd7a622858849489ac8888989313d92', 'Burberry制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/07af01e281c7e0b912d162d611e22c32.jpg', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/07af01e281c7e0b912d162d611e22c32.jpg', '为打造时尚舒适的童装系列，严选选择Burberry制造商，优化版型配色英伦风情融入经典格纹，百搭优雅气质款。', 4, 1, 99.00);
INSERT INTO `MALL_BRAND` VALUES ('8c767e5497f445ef98ab702d3032bf13', 'WMF制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/2018e9ac91ec37d9aaf437a1fd5d7070.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/2018e9ac91ec37d9aaf437a1fd5d7070.png', '严选找寻德国百年高端厨具WMF的制造商，选择拥有14年经验的不锈钢生产工厂，为你甄选事半功倍的优质厨具。', 8, 1, 9.90);
INSERT INTO `MALL_BRAND` VALUES ('93046b54a1bb4c8ca23c32e925b694cd', 'Ralph Lauren制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/9df78eb751eae2546bd3ee7e61c9b854.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/9df78eb751eae2546bd3ee7e61c9b854.png', '我们与Ralph Lauren Home的制造商成功接洽，掌握先进的生产设备，传承品牌工艺和工序。追求生活品质的你，值得拥有。', 20, 1, 29.00);
INSERT INTO `MALL_BRAND` VALUES ('9dcda5b29439479e90bb326b8010e115', 'UGG制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/4d2a3dea7e0172ae48e8161f04cfa045.jpg', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/4d2a3dea7e0172ae48e8161f04cfa045.jpg', '为寻找优质的皮毛一体雪地靴，严选走访多家雪地靴制造商，对比工艺，甄选UGG认可的代工厂，只为足下的优雅舒适。', 29, 1, 59.00);
INSERT INTO `MALL_BRAND` VALUES ('a520e6882c5646a897af9ea1fc45418c', 'Alexander McQueen制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/db7ee9667d84cbce573688297586699c.jpg', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/db7ee9667d84cbce573688297586699c.jpg', '为制造精致实用的高品质包包，严选团队选择Alexander McQueen制造商，严格筛选，带来轻奢优雅体验。', 16, 1, 69.00);
INSERT INTO `MALL_BRAND` VALUES ('adbcbeb451144d839bd0886f91768212', 'KitchenAid制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/e11385bf29d1b3949435b80fcd000948.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/e11385bf29d1b3949435b80fcd000948.png', '严选寻访KitchenAid品牌的制造商，采用德国LFGB认证食品级专用不锈钢，欧式简约设计，可靠安心，尽享下厨乐趣。', 46, 1, 98.00);
INSERT INTO `MALL_BRAND` VALUES ('b40b8106c89f4f648d4ef64420be7ffa', '范思哲制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/c80ae035387495a61a4515906205efff.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/c80ae035387495a61a4515906205efff.png', '严选找寻意大利奢侈品牌范思哲Versace的制造商，致力于为用户带来精致、优雅、时尚的皮包，传承独特美感，体验品质生活。', 18, 1, 99.00);
INSERT INTO `MALL_BRAND` VALUES ('becd1ef666b34dc98f37915b5760c00d', 'BCBG制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/b9072023afd3621714fd5c49f140fca8.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/b9072023afd3621714fd5c49f140fca8.png', '严选从产品源头开始，每道工序质量把关，选择美国知名品牌BCBG的制造商合作，严谨匠心，致力于优质柔滑的睡衣穿搭产品。', 36, 1, 99.00);
INSERT INTO `MALL_BRAND` VALUES ('c090b87f7b1f4b5b98a02dd2b8d09d9d', '内野制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/8ca3ce091504f8aa1fba3fdbb7a6e351.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/8ca3ce091504f8aa1fba3fdbb7a6e351.png', '严选从世界各地挑选毛巾，最终选择了为日本内野代工的工厂，追求毛巾的柔软度与功能性。品质比肩商场几百元的毛巾。', 10, 1, 29.00);
INSERT INTO `MALL_BRAND` VALUES ('c2764aaa30b24d87b503bd5776eecd7a', 'Stoneline制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/3a44ae7db86f3f9b6e542720c54cc349.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/3a44ae7db86f3f9b6e542720c54cc349.png', '严选找寻德国经典品牌Stoneline的制造商，追踪工艺，考量细节，亲自试用，为你甄选出最合心意的锅具和陶瓷刀，下厨如神。', 28, 1, 9.90);
INSERT INTO `MALL_BRAND` VALUES ('c9e3cb26e91e4d3eadd962a92f680b50', 'Kenneth Cole制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/236322546c6860e1662ab147d6b0ba2f.jpg', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/236322546c6860e1662ab147d6b0ba2f.jpg', '为出品优质格调的商务鞋靴，严选团队选择Kenneth Cole品牌合作的制造商，一切努力，只为打造高品质鞋靴。', 7, 1, 349.00);
INSERT INTO `MALL_BRAND` VALUES ('ce33b21b541c4c3cb2f6a9f73aaae2ce', 'Birkenstock集团制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/05a2ecffb60b77e4c165bd8492e5c22a.jpg', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/05a2ecffb60b77e4c165bd8492e5c22a.jpg', '为打造一双舒适的软木拖鞋，严选团队寻找BIRKENSTOCK集团旗下产品制造商，360度全程监制，舒适随脚，百搭文艺。', 14, 1, 59.90);
INSERT INTO `MALL_BRAND` VALUES ('d3f9302e1cfe4eb1a7dd1fcec52e1f68', 'Nine West制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/ad4df7848ce450f00483c2d5e9f2bfa7.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/ad4df7848ce450f00483c2d5e9f2bfa7.png', '为打造一双优雅舒适的高跟鞋，严选选择美国Nine West玖熙品牌的制造商，让美丽绽放在足尖。', 13, 1, 219.00);
INSERT INTO `MALL_BRAND` VALUES ('d471d3c5329f44838965c21339d9f75a', '膳魔师制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/5fd51e29b9459dae7df8040c8219f241.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/5fd51e29b9459dae7df8040c8219f241.png', '严选深入保温行业内部，找到德国膳魔师制造商的代工厂。同样的品质，却有更优的价格。', 40, 1, 45.00);
INSERT INTO `MALL_BRAND` VALUES ('d5af6fc5939f49d1844da740640fa1ad', 'Tescom制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/c17cd65971189fdc28f5bd6b78f657a7.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/c17cd65971189fdc28f5bd6b78f657a7.png', '严选为打造时尚健康的个护电器，选择Tescom品牌制造商，全球最大个护电器工厂之一，拥有20年经验，出口180多个国家，品质有保障。', 15, 1, 59.00);
INSERT INTO `MALL_BRAND` VALUES ('d67cb841efbd4464acfc0e9c25ed7ddd', '厚木ATSUGI制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/7df55c408dbac6085ed6c30836c828ac.jpg', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/7df55c408dbac6085ed6c30836c828ac.jpg', '严选考究袜子品质，层层把关原料生产，携手12年行业生产资质的厚木品牌制造商，带来轻盈优雅，舒适显瘦的袜子系列。', 27, 1, 29.00);
INSERT INTO `MALL_BRAND` VALUES ('d70075835cbd4ea1af6c4c02f598ef42', 'Wedgwood制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/68940e8e23f96dbeb3548d943d83d5e4.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/68940e8e23f96dbeb3548d943d83d5e4.png', '严选寻访英国皇室御用陶瓷Wedgwood制造商，制模到成品，历经25道工序、7次检验、3次烧制，你看不见的地方，我们也在坚持。', 21, 1, 39.00);
INSERT INTO `MALL_BRAND` VALUES ('e8105caf28c34b459b617b206c354999', 'Armani制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/981e06f0f46f5f1f041d7de3dd3202e6.jpg', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/981e06f0f46f5f1f041d7de3dd3202e6.jpg', '严选团队携手国际标准化专业生产厂家，厂家长期为Armani、Alexander wang等知名品牌代工，专业进口设备，精密质量把控，精于品质居家体验。', 26, 1, 199.00);
INSERT INTO `MALL_BRAND` VALUES ('ed7eb9d5f19e401dba85ab9a8e9c85e0', 'MK制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/fc9cd1309374f7707855de80522fb310.jpg', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/fc9cd1309374f7707855de80522fb310.jpg', '严选为制造高品质的皮具，选择Michael Kors品牌合作的制造工厂，18年专业皮具生产经验，手工至美，品质保证。', 17, 1, 79.00);
INSERT INTO `MALL_BRAND` VALUES ('f53a899fcbda49a98de4675b006509e1', 'Under Armour制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/4e93ea29b1d06fabfd24ba68a9b20a34.jpg', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/4e93ea29b1d06fabfd24ba68a9b20a34.jpg', '严选为甄选优质好袜，走访东北、新疆等产袜基地，最终选定Under Armour品牌的合作制造商，从原料、工艺、品质多维度筛选监制，保证好品质。', 35, 1, 39.00);
INSERT INTO `MALL_BRAND` VALUES ('f5c6c39b216f41358266b514bf813769', 'HUGO BOSS制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/70ada9877b2efa82227437af3231fe50.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/70ada9877b2efa82227437af3231fe50.png', '严选深入德国知名奢侈品HUGO BOSS的制造商，开发睡衣、睡袍、休闲裤等轻奢品质家居服，希望你在家的每一天都优雅精致。', 11, 1, 45.00);
INSERT INTO `MALL_BRAND` VALUES ('f5e9102656404a6c9de15b384c5c4edf', 'WPC制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/c4e97cc87186ce17f9316f3ba39e220c.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/c4e97cc87186ce17f9316f3ba39e220c.png', '严选寻找日本雨伞品牌W.P.C制造商，采用严谨工艺以及环保材料，沉淀15年行业经验，打造精致雨具。', 22, 1, 59.00);
INSERT INTO `MALL_BRAND` VALUES ('f6fd2732e9d84da790920003f6f2803c', 'CK制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/658f09b7ec522d31742b47b914d64338.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/658f09b7ec522d31742b47b914d64338.png', '严选寻访Calvin Klein品牌的制造商，深入世界领带第一生产地，设计与品质并重，致力于给消费者带来优质典雅的服饰用品。', 1, 1, 39.00);
INSERT INTO `MALL_BRAND` VALUES ('f96e84eb93ca451ea841c6adb2caae8b', '日本KEYUCA制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/9b85b45f23da558be101dbcc273b1d6d.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/9b85b45f23da558be101dbcc273b1d6d.png', 'KEYUCA是日本餐具及料理用具品牌，遵循极简原木风，高端餐具体验。严选的餐具正是来自这一品牌制造商。', 49, 1, 14.90);
INSERT INTO `MALL_BRAND` VALUES ('ff020827ced4484699ce40cf382ab073', 'Marc Jacobs制造商', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/c8dac4eb1a458d778420ba520edab3d0.png', 'http://platform-wxmall.oss-cn-beijing.aliyuncs.com/platform-plus-mall/brand/c8dac4eb1a458d778420ba520edab3d0.png', '严选寻访独立设计品牌Marc Jacobs的制造商，严格选材，细究纺织与生产的细节，多次打磨，初心不忘，为你带来优雅高档的服饰配件。', 24, 1, 69.00);

-- ----------------------------
-- Table structure for `MALL_BULLETIN`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_BULLETIN`;
CREATE TABLE `MALL_BULLETIN` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `TITLE` varchar(128) DEFAULT '' COMMENT '标题',
  `CONTENT` text COMMENT '文本',
  `ADD_TIME` datetime DEFAULT NULL COMMENT '添加时间',
  `ENABLED` tinyint(4) DEFAULT '1' COMMENT '状态 0:禁用 1:启用',
  `SORT` int(11) DEFAULT '1' COMMENT '排序',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商城公告';

-- ----------------------------
-- Records of MALL_BULLETIN
-- ----------------------------
INSERT INTO `MALL_BULLETIN` VALUES ('1', '微同商城旗舰版，销售价格两万元，提供所有源码以及文档！联系手机：15209831990、微信同号', '<p>微同商城<span style=\"text-decoration: underline;\">商业版</span>，销售价格两万元，提供所有源码以及文档！联系手机：15209831990、微信同号</p>', '2019-07-17 04:03:29', '1', '1');

-- ----------------------------
-- Table structure for `MALL_CART`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_CART`;
CREATE TABLE `MALL_CART` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `USER_ID` varchar(32) DEFAULT NULL COMMENT '会员ID',
  `GOODS_ID` varchar(32) DEFAULT NULL COMMENT '商品ID',
  `GOODS_SN` varchar(64) DEFAULT NULL COMMENT '商品编码',
  `GOODS_NAME` varchar(128) DEFAULT NULL COMMENT '商品名称',
  `SKU_ID` varchar(32) DEFAULT NULL COMMENT 'SKU_ID',
  `MARKET_PRICE` decimal(10,2) DEFAULT '0.00' COMMENT '市场价',
  `RETAIL_PRICE` decimal(10,2) DEFAULT '0.00' COMMENT '零售价格',
  `NUMBER` int(11) DEFAULT '0' COMMENT '数量',
  `GOODS_SPECIFITION_NAME_VALUE` text COMMENT '规格属性组成的字符串，用来显示用',
  `CHECKED` tinyint(4) DEFAULT '1',
  `LIST_PIC_URL` varchar(256) DEFAULT NULL COMMENT '商品图片',
  `SHOPS_ID` varchar(32) DEFAULT NULL COMMENT '店铺ID',
  `CREATE_TIME` datetime DEFAULT NULL COMMENT '添加时间',
  PRIMARY KEY (`ID`),
  KEY `GOODS_ID` (`GOODS_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='购物车';

-- ----------------------------
-- Records of MALL_CART
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_COLLECT`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_COLLECT`;
CREATE TABLE `MALL_COLLECT` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `USER_ID` varchar(32) NOT NULL DEFAULT '' COMMENT '用户ID',
  `GOODS_ID` varchar(32) DEFAULT NULL COMMENT '商品ID',
  `ADD_TIME` datetime DEFAULT NULL COMMENT '添加时间',
  PRIMARY KEY (`ID`),
  KEY `USER_ID` (`USER_ID`) USING BTREE,
  KEY `GOODS_ID` (`GOODS_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员收藏';

-- ----------------------------
-- Records of MALL_COLLECT
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_COMMENT`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_COMMENT`;
CREATE TABLE `MALL_COMMENT` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `USER_ID` varchar(32) DEFAULT '0' COMMENT '会员ID',
  `ORDER_ID` varchar(32) DEFAULT NULL COMMENT '订单ID',
  `GOODS_ID` varchar(32) DEFAULT NULL COMMENT '商品ID',
  `GOODS_SPECIFITION_NAME_VALUE` varchar(32) DEFAULT NULL COMMENT '规格属性组成的字符串，用来显示用',
  `CONTENT` text COMMENT '评价内容，储存为BASE64编码',
  `TYPE` tinyint(4) NOT NULL DEFAULT '0' COMMENT '类型 0:评论的是商品,1:评论的是文章',
  `ADD_TIME` datetime DEFAULT NULL COMMENT '记录时间',
  `STATUS` tinyint(4) DEFAULT '0' COMMENT '状态 是否被管理员批准显示 0:待审核 1:审核通过',
  `EVAL_LEVEL` tinyint(4) DEFAULT '5' COMMENT '评价级别 1-5级 默认 5',
  `DELIVERY_LEVEL` tinyint(4) DEFAULT '0' COMMENT '配送质量',
  `GOODS_LEVEL` tinyint(4) DEFAULT '0' COMMENT '商品服务评价',
  PRIMARY KEY (`ID`),
  KEY `USER_ID` (`USER_ID`) USING BTREE,
  KEY `GOODS_ID` (`GOODS_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员评价';

-- ----------------------------
-- Records of MALL_COMMENT
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_COMMENT_PICTURE`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_COMMENT_PICTURE`;
CREATE TABLE `MALL_COMMENT_PICTURE` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `COMMENT_ID` varchar(32) NOT NULL DEFAULT '0' COMMENT '评价ID',
  `PIC_URL` varchar(255) NOT NULL DEFAULT '' COMMENT '评价图片',
  `SORT` int(11) DEFAULT '1' COMMENT '排序',
  PRIMARY KEY (`ID`),
  KEY `COMMENT_ID` (`COMMENT_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员评价图片';

-- ----------------------------
-- Records of MALL_COMMENT_PICTURE
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_COUPON`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_COUPON`;
CREATE TABLE `MALL_COUPON` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `TITLE` varchar(128) DEFAULT '' COMMENT '优惠券标题',
  `COUPON_SN` varchar(128) DEFAULT '' COMMENT '优惠券编号',
  `COUPON_TYPE` tinyint(4) DEFAULT '0' COMMENT '优惠券类型：1:代金券 2:折扣',
  `MIN_PRICE` decimal(10,2) DEFAULT '0.00' COMMENT '最低消费金额',
  `SUB_PRICE` decimal(10,2) DEFAULT '0.00' COMMENT '优惠金额',
  `DISCOUNT` decimal(3,1) DEFAULT '10.0' COMMENT '折扣率',
  `BEGIN_TIME` datetime DEFAULT NULL COMMENT '有效期开始时间',
  `END_TIME` datetime DEFAULT NULL COMMENT '有效期结束时间',
  `BEGIN_GET_TIME` datetime DEFAULT NULL COMMENT '开始领取时间',
  `END_GET_TIME` datetime DEFAULT NULL COMMENT '结束领取时间',
  `TOTAL_COUNT` int(11) DEFAULT '0' COMMENT '优惠券数量',
  `SEND_COUNT` int(11) DEFAULT '0' COMMENT '已发放数量',
  `LIMIT_TYPE` tinyint(4) DEFAULT '0' COMMENT '指定使用类型 0：全场通用券 1：指定商品 2：指定品牌',
  `LIMIT_USER` int(11) DEFAULT '0' COMMENT '每人限领数量',
  `STATUS` tinyint(4) DEFAULT '1' COMMENT '状态 1:可领用 2：过期 3：禁用',
  `SORT` int(11) DEFAULT '1' COMMENT '排序',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='优惠券列表';

-- ----------------------------
-- Records of MALL_COUPON
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_USER_COUPON`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_USER_COUPON`;
CREATE TABLE `MALL_USER_COUPON` (
    `ID` varchar(32) NOT NULL COMMENT '主键',
    `USER_ID` varchar(32) DEFAULT NULL COMMENT '会员ID',
    `COUPON_ID` varchar(32) DEFAULT NULL COMMENT '优惠券ID',
    `ADD_TIME` datetime DEFAULT NULL COMMENT '领用时间',
    `TYPE` tinyint(4) DEFAULT '1' COMMENT '领取类型 0:平台发放 1:自动发放 2:领券中心领取',
    `STATUS` tinyint(4) DEFAULT '0' COMMENT '状态 0:未使用 1:已使用 2：过期',
    `USED_TIME` datetime DEFAULT NULL COMMENT '使用时间',
    `ORDER_ID` varchar(32) DEFAULT NULL COMMENT '使用的订单ID',
    PRIMARY KEY (`ID`),
    KEY `USER_ID` (`USER_ID`) USING BTREE,
    KEY `COUPON_ID` (`COUPON_ID`) USING BTREE,
    KEY `STATUS` (`STATUS`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员优惠券';

-- ----------------------------
-- Records of MALL_USER_COUPON
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_COUPON_GOODS`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_COUPON_GOODS`;
CREATE TABLE `MALL_COUPON_GOODS` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `COUPON_ID` varchar(32) DEFAULT NULL COMMENT '优惠券ID',
  `GOODS_ID` varchar(32) DEFAULT NULL COMMENT '商品ID',
  PRIMARY KEY (`ID`),
  KEY `COUPON_ID` (`COUPON_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='优惠券关联商品';

-- ----------------------------
-- Records of MALL_COUPON_GOODS
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_COUPON_BRAND`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_COUPON_BRAND`;
CREATE TABLE `MALL_COUPON_BRAND` (
    `ID` varchar(32) NOT NULL COMMENT '主键',
    `COUPON_ID` varchar(32) DEFAULT NULL COMMENT '优惠券ID',
    `BRAND_ID` varchar(32) DEFAULT NULL COMMENT '品牌ID',
    PRIMARY KEY (`ID`),
    KEY `COUPON_ID` (`COUPON_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='优惠券关联品牌';

-- ----------------------------
-- Records of MALL_COUPON_BRAND
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_FEEDBACK`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_FEEDBACK`;
CREATE TABLE `MALL_FEEDBACK` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `USER_ID` varchar(32) DEFAULT NULL COMMENT '会员ID',
  `MOBILE` varchar(32) DEFAULT NULL COMMENT '手机',
  `FEED_TYPE` tinyint(4) DEFAULT '1' COMMENT '反馈类型 1:商品相关, 2:物流状况, 3:客户服务,4:优惠活动, 5:功能异常, 6:产品建议, 7:其他',
  `CONTENT` text COMMENT '详细内容',
  `STATUS` tinyint(4) DEFAULT '0' COMMENT '状态 0:未读 1:已读',
  `ADD_TIME` datetime DEFAULT NULL COMMENT '反馈时间',
  PRIMARY KEY (`ID`),
  KEY `USER_ID` (`USER_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员反馈';

-- ----------------------------
-- Records of MALL_FEEDBACK
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_FOOTPRINT`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_FOOTPRINT`;
CREATE TABLE `MALL_FOOTPRINT` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `USER_ID` varchar(32) DEFAULT NULL COMMENT '会员ID',
  `GOODS_ID` varchar(32) DEFAULT NULL COMMENT '商品ID',
  `ADD_TIME` datetime DEFAULT NULL COMMENT '记录时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员足迹';

-- ----------------------------
-- Records of MALL_FOOTPRINT
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_ISSUE`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_ISSUE`;
CREATE TABLE `MALL_ISSUE` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `QUESTION` text COMMENT '问题',
  `ANSWER` text COMMENT '回答',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品问答';

-- ----------------------------
-- Records of MALL_ISSUE
-- ----------------------------
INSERT INTO `MALL_ISSUE` VALUES ('1', '购买运费如何收取？', '单笔订单金额（不含运费）满88元免邮费；不满88元，每单收取10元运费。(港澳台地区需满199元免邮费）。');
INSERT INTO `MALL_ISSUE` VALUES ('2', '使用什么快递发货？', '默认使用顺丰快递发货（个别商品使用其他快递），配送范围覆盖全国大部分地区（港澳台地区将使用UPS）。');
INSERT INTO `MALL_ISSUE` VALUES ('3', '如何申请退货？', '自收到商品之日起7日内，顾客可申请无忧退货，退款将原路返还，不同的银行处理时间不同。');
INSERT INTO `MALL_ISSUE` VALUES ('4', '如何开具发票？', '如需开具普通发票，请在下单时联系客服。');

-- ----------------------------
-- Table structure for `MALL_KEYWORDS`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_KEYWORDS`;
CREATE TABLE `MALL_KEYWORDS` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `KEYWORD` varchar(128) NOT NULL DEFAULT '' COMMENT '关键词',
  `TYPE` tinyint(4) DEFAULT '0' COMMENT '场景 0:小程序 1:公众号 2:APP 3:PC',
  `IS_HOT` tinyint(4) DEFAULT '0' COMMENT '热搜 0:否 1:是',
  `IS_DEFAULT` tinyint(4) DEFAULT '0' COMMENT '默认 0:否 1:是',
  `IS_SHOW` tinyint(4) DEFAULT '1' COMMENT '显示 0:否 1:是',
  `SCHEME_URL` varchar(255) DEFAULT NULL COMMENT '跳转链接',
  `SORT` int(11) DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`ID`),
  KEY `KEYWORD` (`KEYWORD`) USING BTREE,
  KEY `IS_SHOW` (`IS_SHOW`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='搜索关键词';

-- ----------------------------
-- Records of MALL_KEYWORDS
-- ----------------------------
INSERT INTO `MALL_KEYWORDS` VALUES ('0adbee8b4e4ebbdce28e011dda110bf2', '四件套', '0', '0', '0', '0', '', '0');
INSERT INTO `MALL_KEYWORDS` VALUES ('d958c3743e1deb12bc8f83e48ee68c81', '竹语丝麻印花四件套', '0', '0', '0', '0', '/pages/goods/goods?id=83dc4aa9cb99212840fae9e1b0c7b361', '0');

-- ----------------------------
-- Table structure for `MALL_ORDER`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_ORDER`;
CREATE TABLE `MALL_ORDER` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `FROM_TYPE` tinyint(4) DEFAULT '1',
  `ORDER_TYPE` tinyint(4) DEFAULT '1' COMMENT '订单类型 1：普通订单 2：店铺订单 3:秒杀订单 4：积分订单',
  `ORDER_SN` varchar(32) DEFAULT NULL COMMENT '订单编号',
  `USER_ID` varchar(32) DEFAULT NULL COMMENT '会员ID',
  `ORDER_STATUS` smallint(6) DEFAULT '0' COMMENT '订单状态 0:订单创建成功等待付款 100:订单超时已过期 101:订单已取消 102:订单已删除 201:订单已付款,等待发货 300:订单已发货 301:用户确认收货 400:申请退款 401:没有发货，退款　402:已收货，退款退货',
  `SHIPPING_STATUS` tinyint(4) DEFAULT '1' COMMENT '发货状态 商品配送情况;1:未发货 2:已发货 3:已收货 4:退货',
  `PAY_STATUS` tinyint(4) DEFAULT '1' COMMENT '付款状态 1:未付款 2:付款中 3:已付款 4:退款',
  `PAY_TYPE` tinyint(4) DEFAULT NULL COMMENT '支付方式 1：微信支付  2：余额支付  3：支付宝支付',
  `CONSIGNEE` varchar(128) DEFAULT NULL COMMENT '收货人',
  `COUNTRY` varchar(64) DEFAULT NULL COMMENT '国家',
  `PROVINCE` varchar(64) DEFAULT NULL COMMENT '省',
  `CITY` varchar(64) DEFAULT NULL COMMENT '市',
  `DISTRICT` varchar(64) DEFAULT NULL COMMENT '地区',
  `ADDRESS` varchar(255) DEFAULT NULL COMMENT '详细地址',
  `POSTAL_CODE` varchar(64) DEFAULT NULL COMMENT '邮编',
  `MOBILE` varchar(32) DEFAULT NULL COMMENT '手机号',
  `POSTSCRIPT` varchar(512) DEFAULT NULL COMMENT '留言',
  `SHIPPING_ID` varchar(32) DEFAULT NULL COMMENT '快递公司ID',
  `SHIPPING_NAME` varchar(64) DEFAULT NULL COMMENT '快递公司名称',
  `SHIPPING_CODE` varchar(64) DEFAULT NULL COMMENT '快递公司CODE',
  `SHIPPING_NO` varchar(64) DEFAULT NULL COMMENT '快递单号',
  `SHIPPING_FEE` decimal(10,2) DEFAULT '0.00' COMMENT '快递费用',
  `PREPAY_ID` varchar(64) DEFAULT NULL COMMENT '支付PREPAY_ID',
  `ACTUAL_PRICE` decimal(10,2) DEFAULT '0.00' COMMENT '实际支付的金额',
  `INTEGRAL_MONEY` decimal(10,2) DEFAULT '0.00' COMMENT '积分抵扣金额',
  `ORDER_PRICE` decimal(10,2) DEFAULT '0.00' COMMENT '订单总价',
  `ADD_TIME` datetime DEFAULT NULL COMMENT '下单时间',
  `CONFIRM_TIME` datetime DEFAULT NULL COMMENT '确认时间',
  `PAY_TIME` datetime DEFAULT NULL COMMENT '付款时间',
  `COUPON_ID` varchar(32) DEFAULT NULL COMMENT '使用的优惠券ID',
  `COUPON_PRICE` decimal(10,2) DEFAULT NULL COMMENT '优惠价格',
  `PARENT_ID` varchar(32) DEFAULT NULL COMMENT '父级订单ID',
  `SHOPS_ID` varchar(32) DEFAULT NULL COMMENT '店铺ID',
  `GOODS_ID` varchar(32) DEFAULT NULL COMMENT '秒杀商品',
  `GROUP_ID` varchar(32) DEFAULT NULL COMMENT '团ID',
  `EXPIRE_TIME` datetime DEFAULT NULL COMMENT '订单过期时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ORDER_SN` (`ORDER_SN`) USING BTREE,
  KEY `USER_ID` (`USER_ID`) USING BTREE,
  KEY `ORDER_STATUS` (`ORDER_STATUS`) USING BTREE,
  KEY `SHIPPING_STATUS` (`SHIPPING_STATUS`) USING BTREE,
  KEY `PAY_STATUS` (`PAY_STATUS`) USING BTREE,
  KEY `CONSIGNEE` (`CONSIGNEE`) USING BTREE,
  KEY `PREPAY_ID` (`PREPAY_ID`) USING BTREE,
  KEY `PARENT_ID` (`PARENT_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单表';

-- ----------------------------
-- Records of MALL_ORDER
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_ORDER_GOODS`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_ORDER_GOODS`;
CREATE TABLE `MALL_ORDER_GOODS` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `ORDER_ID` varchar(32) NOT NULL DEFAULT '0' COMMENT '订单ID',
  `GOODS_ID` varchar(32) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `GOODS_NAME` varchar(128) NOT NULL DEFAULT '' COMMENT '商品名称',
  `GOODS_SN` varchar(64) NOT NULL DEFAULT '' COMMENT '商品编码',
  `SKU_ID` varchar(32) DEFAULT NULL COMMENT 'SKU_ID',
  `NUMBER` int(11) DEFAULT '0' COMMENT '商品数量',
  `MARKET_PRICE` decimal(10,2) DEFAULT '0.00' COMMENT '市场价',
  `RETAIL_PRICE` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '零售价格',
  `GOODS_SPECIFITION_NAME_VALUE` text COMMENT '商品规格详情',
  `LIST_PIC_URL` varchar(255) DEFAULT NULL COMMENT '图片链接',
  PRIMARY KEY (`ID`),
  KEY `ORDER_ID` (`ORDER_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单详情';

-- ----------------------------
-- Records of MALL_ORDER_GOODS
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_SEARCH_HISTORY`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_SEARCH_HISTORY`;
CREATE TABLE `MALL_SEARCH_HISTORY` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `USER_ID` varchar(32) DEFAULT NULL COMMENT '会员ID',
  `KEYWORD` varchar(32) DEFAULT NULL COMMENT '关键词',
  `SEARCH_FROM` tinyint(4) DEFAULT '0' COMMENT '搜索来源 0:小程序 1:公众号 2:APP 3:PC',
  `ADD_TIME` datetime DEFAULT NULL COMMENT '搜索时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='搜索历史';

-- ----------------------------
-- Records of MALL_SEARCH_HISTORY
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_SHIPPING`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_SHIPPING`;
CREATE TABLE `MALL_SHIPPING` (
 `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `CODE` varchar(64) DEFAULT NULL COMMENT '快递公司编码',
  `NAME` varchar(128) DEFAULT NULL COMMENT '快递公司名称',
  `STATUS` tinyint(4) DEFAULT '1' COMMENT '状态 0：禁用 1：正常',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=637 DEFAULT CHARSET=utf8 COMMENT='快递公司配置';

-- ----------------------------
-- Records of MALL_SHIPPING
-- ----------------------------
INSERT INTO `MALL_SHIPPING` VALUES (1, 'SF', '顺丰速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (2, 'HTKY', '百世快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (3, 'ZTO', '中通快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (4, 'STO', '申通快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (5, 'YTO', '圆通速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (6, 'YD', '韵达速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (7, 'YZPY', '邮政快递包裹', 1);
INSERT INTO `MALL_SHIPPING` VALUES (8, 'EMS', 'EMS', 1);
INSERT INTO `MALL_SHIPPING` VALUES (9, 'HHTT', '天天快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (10, 'JD', '京东快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (11, 'UC', '优速快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (12, 'DBL', '德邦快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (13, 'ZJS', '宅急送', 1);
INSERT INTO `MALL_SHIPPING` VALUES (14, 'AJ', '安捷快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (15, 'ALKJWL', '阿里跨境电商物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (16, 'AX', '安迅物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (17, 'AYUS', '安邮美国', 1);
INSERT INTO `MALL_SHIPPING` VALUES (18, 'AMAZON', '亚马逊物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (19, 'AOMENYZ', '澳门邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (20, 'ANE', '安能物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (21, 'ADD', '澳多多', 1);
INSERT INTO `MALL_SHIPPING` VALUES (22, 'AYCA', '澳邮专线', 1);
INSERT INTO `MALL_SHIPPING` VALUES (23, 'AXD', '安鲜达', 1);
INSERT INTO `MALL_SHIPPING` VALUES (24, 'ANEKY', '安能快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (25, 'ABGJ', '澳邦国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (26, 'ANNTO', '安得物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (27, 'AUODEXPRESS', '澳德物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (28, 'A4PX', '转运四方', 1);
INSERT INTO `MALL_SHIPPING` VALUES (29, 'BDT', '八达通  ', 1);
INSERT INTO `MALL_SHIPPING` VALUES (30, 'BETWL', '百腾物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (31, 'BJXKY', '北极星快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (32, 'BNTWL', '奔腾物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (33, 'BFDF', '百福东方', 1);
INSERT INTO `MALL_SHIPPING` VALUES (34, 'BHGJ', '贝海国际 ', 1);
INSERT INTO `MALL_SHIPPING` VALUES (35, 'BFAY', '八方安运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (36, 'BTWL', '百世快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (37, 'BBFZY', '帮帮发转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (38, 'BCTWL', '百城通物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (39, 'CFWL', '春风物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (40, 'CHTWL', '诚通物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (41, 'CXHY', '传喜物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (42, 'CITY100', '城市100', 1);
INSERT INTO `MALL_SHIPPING` VALUES (43, 'CJKD', '城际快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (44, 'CNPEX', 'CNPEX中邮快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (45, 'COE', 'COE东方快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (46, 'CSCY', '长沙创一', 1);
INSERT INTO `MALL_SHIPPING` VALUES (47, 'CDSTKY', '成都善途速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (48, 'CTG', '联合运通', 1);
INSERT INTO `MALL_SHIPPING` VALUES (49, 'CRAZY', '疯狂快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (50, 'CBO', 'CBO钏博物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (51, 'CNEX', '佳吉快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (52, 'CND', '承诺达', 1);
INSERT INTO `MALL_SHIPPING` VALUES (53, 'CSTD', '畅顺通达', 1);
INSERT INTO `MALL_SHIPPING` VALUES (54, 'DSWL', 'D速物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (55, 'DLG ', '到了港', 1);
INSERT INTO `MALL_SHIPPING` VALUES (56, 'DTWL', '大田物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (57, 'DNWL', '东骏快捷物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (58, 'DEKUN', '德坤', 1);
INSERT INTO `MALL_SHIPPING` VALUES (59, 'DBL', '德邦快运/德邦物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (60, 'DML', '大马鹿', 1);
INSERT INTO `MALL_SHIPPING` VALUES (61, 'DNWL', '丹鸟物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (62, 'EST365', '东方汇', 1);
INSERT INTO `MALL_SHIPPING` VALUES (63, 'ETK', 'E特快', 1);
INSERT INTO `MALL_SHIPPING` VALUES (64, 'EMS2', 'EMS国内', 1);
INSERT INTO `MALL_SHIPPING` VALUES (65, 'EWE', 'EWE', 1);
INSERT INTO `MALL_SHIPPING` VALUES (66, 'ETONG', 'E通速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (67, 'ESDEX', '卓志速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (68, 'FKD', '飞康达', 1);
INSERT INTO `MALL_SHIPPING` VALUES (69, 'FTD', '富腾达  ', 1);
INSERT INTO `MALL_SHIPPING` VALUES (70, 'FYKD', '凡宇货的', 1);
INSERT INTO `MALL_SHIPPING` VALUES (71, 'FASTGO', '速派快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (72, 'FBKD', '飞豹快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (73, 'FBOX', '丰巢', 1);
INSERT INTO `MALL_SHIPPING` VALUES (74, 'FWX', '丰网速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (75, 'FHKD', '飞狐快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (76, 'FRGYL', '复融供应链', 1);
INSERT INTO `MALL_SHIPPING` VALUES (77, 'FYPS', '飞远配送', 1);
INSERT INTO `MALL_SHIPPING` VALUES (78, 'FYSD', '凡宇速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (79, 'FT', '丰通快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (80, 'GD', '冠达   ', 1);
INSERT INTO `MALL_SHIPPING` VALUES (81, 'GDEMS', '广东邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (82, 'GSD', '共速达', 1);
INSERT INTO `MALL_SHIPPING` VALUES (83, 'GTONG', '广通       ', 1);
INSERT INTO `MALL_SHIPPING` VALUES (84, 'GDKD', '冠达快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (85, 'GHX', '挂号信', 1);
INSERT INTO `MALL_SHIPPING` VALUES (86, 'GTKD', '广通速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (87, 'GTKY', '高铁快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (88, 'GAI', '迦递快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (89, 'GKSD', '港快速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (90, 'GTSD', '高铁速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (91, 'HGLL', '黑狗冷链', 1);
INSERT INTO `MALL_SHIPPING` VALUES (92, 'HLWL', '恒路物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (93, 'HOAU', '天地华宇', 1);
INSERT INTO `MALL_SHIPPING` VALUES (94, 'HOTSCM', '鸿桥供应链', 1);
INSERT INTO `MALL_SHIPPING` VALUES (95, 'HPTEX', '海派通物流公司', 1);
INSERT INTO `MALL_SHIPPING` VALUES (96, 'hq568', '华强物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (97, 'HQSY', '环球速运  ', 1);
INSERT INTO `MALL_SHIPPING` VALUES (98, 'HXLWL', '华夏龙物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (99, 'HBJH', '河北建华', 1);
INSERT INTO `MALL_SHIPPING` VALUES (100, 'HF', '汇丰物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (101, 'HHKD', '华航快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (102, 'HHWL', '华翰物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (103, 'DNWL', '黄马甲快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (104, 'HMSD', '海盟速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (105, 'HQKY', '华企快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (106, 'HSWL', '昊盛物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (107, 'HTWL', '鸿泰物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (108, 'HXWL', '豪翔物流 ', 1);
INSERT INTO `MALL_SHIPPING` VALUES (109, 'HFHW', '合肥汇文', 1);
INSERT INTO `MALL_SHIPPING` VALUES (110, 'HLONGWL', '辉隆物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (111, 'HQKD', '华企快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (112, 'HRWL', '韩润物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (113, 'HTKD', '青岛恒通快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (114, 'HYH', '货运皇物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (115, 'HLYSD', '好来运快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (116, 'HJWL', '皇家物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (117, 'HISENSE', '海信物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (118, 'HSSY', '汇森速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (119, 'HTB56', '徽托邦物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (120, 'JAD', '捷安达  ', 1);
INSERT INTO `MALL_SHIPPING` VALUES (121, 'JGSD', '京广速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (122, 'JIUYE', '九曳供应链', 1);
INSERT INTO `MALL_SHIPPING` VALUES (123, 'JXD', '急先达', 1);
INSERT INTO `MALL_SHIPPING` VALUES (124, 'JYKD', '晋越快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (125, 'JCEX', '佳成国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (126, 'JTKD', '捷特快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (127, 'JYSY', '精英速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (128, 'JYM', '加运美', 1);
INSERT INTO `MALL_SHIPPING` VALUES (129, 'JGWL', '景光物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (130, 'JYWL', '佳怡物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (131, 'JD', '京东快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (132, 'JDWL', '金大物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (133, 'JTSD', '极兔速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (134, 'KYSY', '跨越速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (135, 'KFW', '快服务', 1);
INSERT INTO `MALL_SHIPPING` VALUES (136, 'KSDWL', '快速递物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (137, 'KLWL', '康力物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (138, 'KTKD', '快淘快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (139, 'KYDSD', '快优达速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (140, 'KYWL', '跨越物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (141, 'KBSY', '快8速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (142, 'LB', '龙邦快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (143, 'LHKD', '蓝弧快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (144, 'LJD', '乐捷递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (145, 'LJS', '立即送', 1);
INSERT INTO `MALL_SHIPPING` VALUES (146, 'LHT', '联昊通速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (147, 'MB', '民邦快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (148, 'MHKD', '民航快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (149, 'MK', '美快    ', 1);
INSERT INTO `MALL_SHIPPING` VALUES (150, 'MDM', '门对门快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (151, 'MD', '迈达', 1);
INSERT INTO `MALL_SHIPPING` VALUES (152, 'MSKD', '闽盛快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (153, 'MRDY', '迈隆递运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (154, 'MLWL', '明亮物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (155, 'NFCM', '南方传媒物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (156, 'NJSBWL', '南京晟邦物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (157, 'NEDA', '能达速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (158, 'PADTF', '平安达腾飞快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (159, 'PANEX', '泛捷快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (160, 'PJ', '品骏快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (161, 'PXWL', '陪行物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (162, 'PCA', 'PCA Express', 1);
INSERT INTO `MALL_SHIPPING` VALUES (163, 'QCKD', '全晨快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (164, 'QRT', '全日通快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (165, 'QUICK', '快客快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (166, 'QXT', '全信通', 1);
INSERT INTO `MALL_SHIPPING` VALUES (167, 'QYZY', '七曜中邮', 1);
INSERT INTO `MALL_SHIPPING` VALUES (168, 'RFD', '如风达', 1);
INSERT INTO `MALL_SHIPPING` VALUES (169, 'RQ', '荣庆物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (170, 'RRS', '日日顺物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (171, 'RLWL', '日昱物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (172, 'RFEX', '瑞丰速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (173, 'SAD', '赛澳递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (174, 'SNWL', '苏宁物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (175, 'SAWL', '圣安物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (176, 'DNWL', '晟邦物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (177, 'SDWL', '上大物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (178, 'SFWL', '盛丰物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (179, 'ST', '速通物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (180, 'STWL', '速腾快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (181, 'SUBIDA', '速必达物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (182, 'SDEZ', '速递e站', 1);
INSERT INTO `MALL_SHIPPING` VALUES (183, 'SCZPDS', '速呈宅配', 1);
INSERT INTO `MALL_SHIPPING` VALUES (184, 'SURE', '速尔快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (185, 'SDHH', '山东海红', 1);
INSERT INTO `MALL_SHIPPING` VALUES (186, 'SFGJ', '顺丰国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (187, 'SHWL', '盛辉物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (188, 'SJWL', '穗佳物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (189, 'STSD', '三态速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (190, 'SXHMJ', '山西红马甲', 1);
INSERT INTO `MALL_SHIPPING` VALUES (191, 'SYKD', '世运快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (192, 'SS', '闪送', 1);
INSERT INTO `MALL_SHIPPING` VALUES (193, 'STKD', '盛通快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (194, 'SJ', '郑州速捷', 1);
INSERT INTO `MALL_SHIPPING` VALUES (195, 'SX', '顺心捷达', 1);
INSERT INTO `MALL_SHIPPING` VALUES (196, 'SQWL', '商桥物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (197, 'SYJWDX', '佳旺达物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (198, 'SENDCN', '速递中国', 1);
INSERT INTO `MALL_SHIPPING` VALUES (199, 'TAIWANYZ', '台湾邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (200, 'TSSTO', '唐山申通', 1);
INSERT INTO `MALL_SHIPPING` VALUES (201, 'TJS', '特急送', 1);
INSERT INTO `MALL_SHIPPING` VALUES (202, 'TYWL', '通用物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (203, 'TDHY', '华宇物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (204, 'THTX', '通和天下', 1);
INSERT INTO `MALL_SHIPPING` VALUES (205, 'TLWL', '腾林物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (206, 'TJDGJWL', '泰捷达物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (207, 'UAPEX', '全一快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (208, 'UBI', 'UBI', 1);
INSERT INTO `MALL_SHIPPING` VALUES (209, 'UEQ', 'UEQ Express', 1);
INSERT INTO `MALL_SHIPPING` VALUES (210, 'USEX', '美国快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (211, 'WJK', '万家康  ', 1);
INSERT INTO `MALL_SHIPPING` VALUES (212, 'WJWL', '万家物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (213, 'WHTZX', '武汉同舟行', 1);
INSERT INTO `MALL_SHIPPING` VALUES (214, 'WPE', '维普恩', 1);
INSERT INTO `MALL_SHIPPING` VALUES (215, 'WM', '中粮我买网', 1);
INSERT INTO `MALL_SHIPPING` VALUES (216, 'DNWL', '万象物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (217, 'WTP', '微特派', 1);
INSERT INTO `MALL_SHIPPING` VALUES (218, 'WTWL', '温通物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (219, 'WJEXPRESS', '文捷航空速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (220, 'XCWL', '迅驰物流  ', 1);
INSERT INTO `MALL_SHIPPING` VALUES (221, 'XFEX', '信丰物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (222, 'XYT', '希优特', 1);
INSERT INTO `MALL_SHIPPING` VALUES (223, 'XBWL', '新邦物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (224, 'XLYT', '祥龙运通', 1);
INSERT INTO `MALL_SHIPPING` VALUES (225, 'XJ', '新杰物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (226, 'XIAOBI', '晓毕物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (227, 'XDEXPRESS', '迅达速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (228, 'YAD', '源安达快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (229, 'YCWL', '远成物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (230, 'YCSY', '远成快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (231, 'YDH', '义达国际物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (232, 'YDT', '易达通  ', 1);
INSERT INTO `MALL_SHIPPING` VALUES (233, 'YFHEX', '原飞航物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (234, 'YFSD', '亚风快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (235, 'YTKD', '运通快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (236, 'YXKD', '亿翔快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (237, 'YUNDX', '运东西网', 1);
INSERT INTO `MALL_SHIPPING` VALUES (238, 'YMDD', '壹米滴答', 1);
INSERT INTO `MALL_SHIPPING` VALUES (239, 'YZBK', '邮政国内标快', 1);
INSERT INTO `MALL_SHIPPING` VALUES (240, 'YZTSY', '一站通速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (241, 'YFSUYUN', '驭丰速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (242, 'YSDF', '余氏东风', 1);
INSERT INTO `MALL_SHIPPING` VALUES (243, 'YF', '耀飞快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (244, 'YDKY', '韵达快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (245, 'YL', '云路', 1);
INSERT INTO `MALL_SHIPPING` VALUES (246, 'YBJ', '邮必佳', 1);
INSERT INTO `MALL_SHIPPING` VALUES (247, 'YFEX', '越丰物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (248, 'YJSD', '银捷速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (249, 'YLJY', '优联吉运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (250, 'YLSY', '亿领速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (251, 'YMWL', '英脉物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (252, 'YSH', '亿顺航', 1);
INSERT INTO `MALL_SHIPPING` VALUES (253, 'YSKY', '音素快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (254, 'YTD', '易通达', 1);
INSERT INTO `MALL_SHIPPING` VALUES (255, 'YTFH', '一统飞鸿', 1);
INSERT INTO `MALL_SHIPPING` VALUES (256, 'YTOGJ', '圆通国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (257, 'YXWL', '宇鑫物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (258, 'YZGN', '包裹/平邮/挂号信', 1);
INSERT INTO `MALL_SHIPPING` VALUES (259, 'YZT', '一智通', 1);
INSERT INTO `MALL_SHIPPING` VALUES (260, 'YBWL', '优拜物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (261, 'YLFWL', '一路发物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (262, 'YJWL', '云聚物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (263, 'ZENY', '增益快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (264, 'ZTKY', '中铁快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (265, 'ZTWY', '中天万运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (266, 'ZWYSD', '中外运速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (267, 'ZY_AZY', '澳转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (268, 'ZY_BDA', '八达网', 1);
INSERT INTO `MALL_SHIPPING` VALUES (269, 'ZY_BYECO', '贝易购', 1);
INSERT INTO `MALL_SHIPPING` VALUES (270, 'ZY_CTM', '赤兔马转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (271, 'ZY_CUL', 'CUL中美速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (272, 'ZY_ETD', 'ETD', 1);
INSERT INTO `MALL_SHIPPING` VALUES (273, 'ZY_FCKD', '风驰快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (274, 'ZY_FLSD', '风雷速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (275, 'ZY_HCYD', '皓晨优递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (276, 'ZY_HDB', '海带宝', 1);
INSERT INTO `MALL_SHIPPING` VALUES (277, 'ZY_HFMZ', '汇丰美中速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (278, 'ZY_HJSD', '豪杰速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (279, 'ZY_HMKD', '华美快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (280, 'ZY_HTAO', '360hitao转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (281, 'ZY_HTCUN', '海淘村', 1);
INSERT INTO `MALL_SHIPPING` VALUES (282, 'ZY_HTKE', '365海淘客', 1);
INSERT INTO `MALL_SHIPPING` VALUES (283, 'ZY_HTONG', '华通快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (284, 'ZY_HXKD', '海星桥快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (285, 'ZY_HXSY', '华兴速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (286, 'ZY_IHERB', 'LogisticsY', 1);
INSERT INTO `MALL_SHIPPING` VALUES (287, 'ZY_LPZ', '领跑者快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (288, 'ZY_LZWL', '量子物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (289, 'ZY_MBZY', '明邦转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (290, 'ZY_MJ', '美嘉快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (291, 'ZY_MZ', '168 美中快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (292, 'ZY_OEJ', '欧e捷', 1);
INSERT INTO `MALL_SHIPPING` VALUES (293, 'ZY_OZF', '欧洲疯', 1);
INSERT INTO `MALL_SHIPPING` VALUES (294, 'ZY_OZGO', '欧洲GO', 1);
INSERT INTO `MALL_SHIPPING` VALUES (295, 'ZY_QMT', '全美通', 1);
INSERT INTO `MALL_SHIPPING` VALUES (296, 'ZY_SCS', 'SCS国际物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (297, 'ZY_SOHO', 'SOHO苏豪国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (298, 'ZY_SONIC', 'Sonic-Ex速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (299, 'ZY_TCM', '通诚美中快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (300, 'ZY_TPAK', 'TrakPak', 1);
INSERT INTO `MALL_SHIPPING` VALUES (301, 'ZY_TTHT', '天天海淘', 1);
INSERT INTO `MALL_SHIPPING` VALUES (302, 'ZY_TZKD', '天泽快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (303, 'ZY_XDKD', '迅达快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (304, 'ZY_XDSY', '信达速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (305, 'ZY_XGX', '新干线快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (306, 'ZY_XJ', '信捷转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (307, 'ZY_YGKD', '优购快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (308, 'ZY_YJSD', '友家速递(UCS)', 1);
INSERT INTO `MALL_SHIPPING` VALUES (309, 'ZY_YPW', '云畔网', 1);
INSERT INTO `MALL_SHIPPING` VALUES (310, 'ZY_YSW', '易送网', 1);
INSERT INTO `MALL_SHIPPING` VALUES (311, 'ZYQS', '中运全速', 1);
INSERT INTO `MALL_SHIPPING` VALUES (312, 'ZYWL', '中邮物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (313, 'ZHQKD', '汇强快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (314, 'ZTE', '众通快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (315, 'ZTOKY', '中通快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (316, 'ZYKD', '中邮快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (317, 'DNWL', '芝麻开门', 1);
INSERT INTO `MALL_SHIPPING` VALUES (318, 'ZHWL', '中骅物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (319, 'ZTWL', '中铁物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (320, 'ZHN', '智汇鸟', 1);
INSERT INTO `MALL_SHIPPING` VALUES (321, 'ZYE', '众邮快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (322, 'ZHONGHUAN', '中环快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (323, 'AAE', 'AAE全球专递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (324, 'ACS', 'ACS雅仕快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (325, 'ADP', 'ADP Express Tracking', 1);
INSERT INTO `MALL_SHIPPING` VALUES (326, 'ANGUILAYOU', '安圭拉邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (327, 'APAC', 'APAC', 1);
INSERT INTO `MALL_SHIPPING` VALUES (328, 'ARAMEX', 'Aramex', 1);
INSERT INTO `MALL_SHIPPING` VALUES (329, 'AT', '奥地利邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (330, 'AOL', 'AOL（澳通）', 1);
INSERT INTO `MALL_SHIPPING` VALUES (331, 'AUSTRALIA', 'Australia Post Tracking', 1);
INSERT INTO `MALL_SHIPPING` VALUES (332, 'AUEX', '澳邮国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (333, 'BEL', '比利时邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (334, 'BHT', 'BHT快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (335, 'BILUYOUZHE', '秘鲁邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (336, 'BR', '巴西邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (337, 'BALUNZHI', '巴伦支快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (338, 'BETWL_Crack', 'BETWL_Crack', 1);
INSERT INTO `MALL_SHIPPING` VALUES (339, 'BEUROPE', '败欧洲', 1);
INSERT INTO `MALL_SHIPPING` VALUES (340, 'BCWELT', 'BCWELT   ', 1);
INSERT INTO `MALL_SHIPPING` VALUES (341, 'BN', '笨鸟国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (342, 'BKWL', '宝凯物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (343, 'BLZ', '巴伦支', 1);
INSERT INTO `MALL_SHIPPING` VALUES (344, 'BNTWL_Crack', 'BNTWL_Crack', 1);
INSERT INTO `MALL_SHIPPING` VALUES (345, 'BQXHM', '北青小红帽', 1);
INSERT INTO `MALL_SHIPPING` VALUES (346, 'BUDANYOUZH', '不丹邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (347, 'BSWL', '邦送物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (348, 'BLYZ', '波兰邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (349, 'CCES', 'CCES快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (350, 'CKY', '出口易', 1);
INSERT INTO `MALL_SHIPPING` VALUES (351, 'CNXLM', '新配盟', 1);
INSERT INTO `MALL_SHIPPING` VALUES (352, 'CDEK', 'CDEK', 1);
INSERT INTO `MALL_SHIPPING` VALUES (353, 'CA', '加拿大邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (354, 'CG', '程光物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (355, 'DBYWL', '递必易国际物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (356, 'DDWL', '大道物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (357, 'DGYKD', '德国云快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (358, 'DLGJ', '到乐国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (359, 'DHL', 'DHL', 1);
INSERT INTO `MALL_SHIPPING` VALUES (360, 'DHL_DE', 'DHL德国', 1);
INSERT INTO `MALL_SHIPPING` VALUES (361, 'DHL_EN', 'DHL(英文版)', 1);
INSERT INTO `MALL_SHIPPING` VALUES (362, 'DHL_GLB', 'DHL全球', 1);
INSERT INTO `MALL_SHIPPING` VALUES (363, 'DHLGM', 'DHL Global Mail', 1);
INSERT INTO `MALL_SHIPPING` VALUES (364, 'DK', '丹麦邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (365, 'DCWL', '德创物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (366, 'DHL_C', 'DHL(中国件)', 1);
INSERT INTO `MALL_SHIPPING` VALUES (367, 'DHL_USA', 'DHL(美国)', 1);
INSERT INTO `MALL_SHIPPING` VALUES (368, 'DHWL', '东红物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (369, 'DTKD', '店通快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (370, 'DYWL', '大洋物流快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (371, 'DPD', 'DPD', 1);
INSERT INTO `MALL_SHIPPING` VALUES (372, 'D4PX', '递四方速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (373, 'DPEX', 'DPEX', 1);
INSERT INTO `MALL_SHIPPING` VALUES (374, 'DRL', '鼎润物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (375, 'EMSGJ', 'EMS国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (376, 'EKM', '易客满', 1);
INSERT INTO `MALL_SHIPPING` VALUES (377, 'ESHIPPER', 'EShipper', 1);
INSERT INTO `MALL_SHIPPING` VALUES (378, 'EPS', 'EPS (联众国际快运)', 1);
INSERT INTO `MALL_SHIPPING` VALUES (379, 'EASYEX', 'EASY-EXPRESS', 1);
INSERT INTO `MALL_SHIPPING` VALUES (380, 'EASYEX', 'EFS POST', 1);
INSERT INTO `MALL_SHIPPING` VALUES (381, 'FCWL', '丰程物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (382, 'FX', '法翔速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (383, 'FQ', 'FQ', 1);
INSERT INTO `MALL_SHIPPING` VALUES (384, 'FLYZ', '芬兰邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (385, 'FZGJ', '方舟国际速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (386, 'FEDEX_GJ', 'FEDEX联邦(国际件）', 1);
INSERT INTO `MALL_SHIPPING` VALUES (387, 'FEDEX', 'FEDEX联邦(国内件）', 1);
INSERT INTO `MALL_SHIPPING` VALUES (388, 'GJEYB', '国际e邮宝', 1);
INSERT INTO `MALL_SHIPPING` VALUES (389, 'GJYZ', '国际邮政包裹', 1);
INSERT INTO `MALL_SHIPPING` VALUES (390, 'GE2D', 'GE2D', 1);
INSERT INTO `MALL_SHIPPING` VALUES (391, 'GLS', 'GLS', 1);
INSERT INTO `MALL_SHIPPING` VALUES (392, 'GT', '冠泰', 1);
INSERT INTO `MALL_SHIPPING` VALUES (393, 'IOZYZ', '欧洲专线(邮政)', 1);
INSERT INTO `MALL_SHIPPING` VALUES (394, 'IADLYYZ', '澳大利亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (395, 'IAEBNYYZ', '阿尔巴尼亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (396, 'IAEJLYYZ', '阿尔及利亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (397, 'IAFHYZ', '阿富汗邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (398, 'IAGLYZ', '安哥拉邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (399, 'IAJYZ', '埃及邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (400, 'IALBYZ', '阿鲁巴邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (401, 'IALYYZ', '阿联酋邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (402, 'IASBJYZ', '阿塞拜疆邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (403, 'IBCWNYZ', '博茨瓦纳邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (404, 'IBDLGYZ', '波多黎各邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (405, 'IBDYZ', '冰岛邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (406, 'IBELSYZ', '白俄罗斯邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (407, 'IBHYZ', '波黑邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (408, 'IBJLYYZ', '保加利亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (409, 'IBJSTYZ', '巴基斯坦邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (410, 'IBLNYZ', '黎巴嫩邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (411, 'IBOLYZ', '波兰邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (412, 'IBTD', '宝通达', 1);
INSERT INTO `MALL_SHIPPING` VALUES (413, 'IBYB', '贝邮宝', 1);
INSERT INTO `MALL_SHIPPING` VALUES (414, 'IDGYZ', '德国邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (415, 'IWDMLYZ', '危地马拉邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (416, 'IWGDYZ', '乌干达邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (417, 'IWKLEMS', '乌克兰EMS', 1);
INSERT INTO `MALL_SHIPPING` VALUES (418, 'IWKLYZ', '乌克兰邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (419, 'IWLGYZ', '乌拉圭邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (420, 'ILKKD', '林克快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (421, 'IWLYZ', '文莱邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (422, 'IXGLDNYYZ', '新喀里多尼亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (423, 'IE', '爱尔兰邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (424, 'IXPWL', '夏浦物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (425, 'IYDYZ', '印度邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (426, 'IXPSJ', '夏浦世纪', 1);
INSERT INTO `MALL_SHIPPING` VALUES (427, 'IEGDEYZ', '厄瓜多尔邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (428, 'IELSYZ', '俄罗斯邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (429, 'IFTWL', '飞特物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (430, 'IGDLPDYZ', '瓜德罗普岛邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (431, 'IGSDLJYZ', '哥斯达黎加邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (432, 'IHGYZ', '韩国邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (433, 'IHLY', '互联易', 1);
INSERT INTO `MALL_SHIPPING` VALUES (434, 'IHSKSTYZ', '哈萨克斯坦邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (435, 'IHSYZ', '黑山邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (436, 'IJBBWYZ', '津巴布韦邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (437, 'IJEJSSTYZ', '吉尔吉斯斯坦邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (438, 'IJKYZ', '捷克邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (439, 'IJNYZ', '加纳邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (440, 'IJPZYZ', '柬埔寨邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (441, 'IADLSQDYZ', '安的列斯群岛邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (442, 'IAGTYZ', '阿根廷邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (443, 'IALQDYZ', '奥兰群岛邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (444, 'IAMYZ', '阿曼邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (445, 'IASEBYYZ', '埃塞俄比亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (446, 'IASNYYZ', '爱沙尼亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (447, 'IASSDYZ', '阿森松岛邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (448, 'IBLSD', '便利速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (449, 'IBLYZ', '巴林邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (450, 'IBMDYZ', '百慕达邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (451, 'IDFWL', '达方物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (452, 'IELTLYYZ', '厄立特里亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (453, 'IGDLPDEMS', '瓜德罗普岛EMS', 1);
INSERT INTO `MALL_SHIPPING` VALUES (454, 'IGJESD', '俄速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (455, 'IGLBYYZ', '哥伦比亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (456, 'IGLLYZ', '格陵兰邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (457, 'IKTDWYZ', '科特迪瓦邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (458, 'IKTEYZ', '卡塔尔邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (459, 'ILBYYZ', '利比亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (460, 'ILSBYZ', '卢森堡邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (461, 'ILTWYYZ', '拉脱维亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (462, 'ILTWYZ', '立陶宛邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (463, 'ILZDSDYZ', '列支敦士登邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (464, 'IMEDFYZ', '马尔代夫邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (465, 'IMJLGEMS', '孟加拉国EMS', 1);
INSERT INTO `MALL_SHIPPING` VALUES (466, 'IMLGYZ', '摩洛哥邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (467, 'IMLQSYZ', '毛里求斯邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (468, 'IMLXYEMS', '马来西亚EMS', 1);
INSERT INTO `MALL_SHIPPING` VALUES (469, 'IMLXYYZ', '马来西亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (470, 'IMQDYZ', '马其顿邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (471, 'IMTNKEMS', '马提尼克EMS', 1);
INSERT INTO `MALL_SHIPPING` VALUES (472, 'IMTNKYZ', '马提尼克邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (473, 'IMXGYZ', '墨西哥邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (474, 'INFYZ', '南非邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (475, 'INWYZ', '挪威邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (476, 'IPTYYZ', '葡萄牙邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (477, 'IQQKD', '全球快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (478, 'IQTWL', '全通物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (479, 'ISDYZ', '苏丹邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (480, 'ISEWDYZ', '萨尔瓦多邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (481, 'ISLFKYZ', '斯洛伐克邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (482, 'ISLWNYYZ', '斯洛文尼亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (483, 'ISTALBYZ', '沙特阿拉伯邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (484, 'ITEQYZ', '土耳其邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (485, 'ITGYZ', '泰国邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (486, 'ITLNDHDBGE', '特立尼达和多巴哥EMS', 1);
INSERT INTO `MALL_SHIPPING` VALUES (487, 'ITNSYZ', '突尼斯邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (488, 'ITSNYYZ', '坦桑尼亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (489, 'IWZBKSTEMS', '乌兹别克斯坦EMS', 1);
INSERT INTO `MALL_SHIPPING` VALUES (490, 'IXFLWL', '小飞龙物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (491, 'IXJPYZ', '新加坡邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (492, 'IXLYYZ', '叙利亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (493, 'IXYLYZ', '匈牙利邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (494, 'IYDNXYYZ', '印度尼西亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (495, 'IYLYZ', '伊朗邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (496, 'IYNYZ', '越南邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (497, 'IYSLYZ', '以色列邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (498, 'IYTG', '易通关', 1);
INSERT INTO `MALL_SHIPPING` VALUES (499, 'IYWWL', '燕文物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (500, 'IZBLTYZ', '直布罗陀邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (501, 'IKNDYYZ', '克罗地亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (502, 'IKNYYZ', '肯尼亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (503, 'IKTDWEMS', '科特迪瓦EMS', 1);
INSERT INTO `MALL_SHIPPING` VALUES (504, 'ILMNYYZ', '罗马尼亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (505, 'IMEDWYZ', '摩尔多瓦邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (506, 'IMETYZ', '马耳他邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (507, 'INRLYYZ', '尼日利亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (508, 'ISEWYYZ', '塞尔维亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (509, 'ISPLSYZ', '塞浦路斯邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (510, 'IWZBKSTYZ', '乌兹别克斯坦邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (511, 'IXBYYZ', '西班牙邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (512, 'IXJPEMS', '新加坡EMS', 1);
INSERT INTO `MALL_SHIPPING` VALUES (513, 'IXLYZ', '希腊邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (514, 'IXXLYZ', '新西兰邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (515, 'IYDLYZ', '意大利邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (516, 'IYGYZ', '英国邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (517, 'IYMNYYZ', '亚美尼亚邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (518, 'IZLYZ', '智利邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (519, 'IYMYZ', '也门邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (520, 'JP', '日本邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (521, 'JFGJ', '今枫国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (522, 'JGZY', '极光转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (523, 'JXYKD', '吉祥邮转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (524, 'JLDT', '嘉里国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (525, 'JYSD', '上海久易国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (526, 'JPKD', '绝配国际速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (527, 'LYT', '联运通', 1);
INSERT INTO `MALL_SHIPPING` VALUES (528, 'LHKDS', '联合快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (529, 'NSF', '新顺丰', 1);
INSERT INTO `MALL_SHIPPING` VALUES (530, 'NL', '荷兰邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (531, 'ONTRAC', 'ONTRAC', 1);
INSERT INTO `MALL_SHIPPING` VALUES (532, 'OCS', 'OCS', 1);
INSERT INTO `MALL_SHIPPING` VALUES (533, 'PAPA', '啪啪供应链', 1);
INSERT INTO `MALL_SHIPPING` VALUES (534, 'POSTEIBE', 'POSTEIBE', 1);
INSERT INTO `MALL_SHIPPING` VALUES (535, 'QQYZ', '全球邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (536, 'QYHY', '秦远海运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (537, 'RDSE', '瑞典邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (538, 'RLG', '澳洲飞跃', 1);
INSERT INTO `MALL_SHIPPING` VALUES (539, 'SKYPOST', 'SKYPOST', 1);
INSERT INTO `MALL_SHIPPING` VALUES (540, 'SHLDHY', '林道国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (541, 'SYJHE', '佳惠尔', 1);
INSERT INTO `MALL_SHIPPING` VALUES (542, 'SWCH', '瑞士邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (543, 'SDSY', '首达速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (544, 'SK', '穗空物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (545, 'STONG', '首通快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (546, 'STO_INTL', '申通快递国际单', 1);
INSERT INTO `MALL_SHIPPING` VALUES (547, 'SUNSHINE', '光线速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (548, 'TNT', 'TNT快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (549, 'TAILAND138', '泰国138', 1);
INSERT INTO `MALL_SHIPPING` VALUES (550, 'UBONEX', '优邦国际速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (551, 'UEX', 'UEX   ', 1);
INSERT INTO `MALL_SHIPPING` VALUES (552, 'USPS', 'USPS美国邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (553, 'UPU', '万国邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (554, 'UPS', 'UPS', 1);
INSERT INTO `MALL_SHIPPING` VALUES (555, 'VENUCIA', '启辰国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (556, 'VCTRANS', '中越国际物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (557, 'XKGJ', '星空国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (558, 'XD', '迅达国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (559, 'XGYZ', '香港邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (560, 'XLKD', '喜来快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (561, 'XSRD', '鑫世锐达', 1);
INSERT INTO `MALL_SHIPPING` VALUES (562, 'XYGJ', '新元国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (563, 'XYJ', '西邮寄', 1);
INSERT INTO `MALL_SHIPPING` VALUES (564, 'XYGJSD', 'ADLER雄鹰国际速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (565, 'YAMA', '日本大和运输(Yamato)', 1);
INSERT INTO `MALL_SHIPPING` VALUES (566, 'YODEL', 'YODEL', 1);
INSERT INTO `MALL_SHIPPING` VALUES (567, 'YHXGJSD', '一号线', 1);
INSERT INTO `MALL_SHIPPING` VALUES (568, 'YUEDANYOUZ', '约旦邮政', 1);
INSERT INTO `MALL_SHIPPING` VALUES (569, 'YMSY', '玥玛速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (570, 'YYSD', '鹰运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (571, 'YJD', '易境达', 1);
INSERT INTO `MALL_SHIPPING` VALUES (572, 'YBG', '洋包裹', 1);
INSERT INTO `MALL_SHIPPING` VALUES (573, 'YJ', '友家速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (574, 'ZY_AG', '爱购转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (575, 'ZY_AOZ', '爱欧洲', 1);
INSERT INTO `MALL_SHIPPING` VALUES (576, 'ZY_AUSE', '澳世速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (577, 'ZY_AXO', 'AXO', 1);
INSERT INTO `MALL_SHIPPING` VALUES (578, 'ZY_BH', '贝海速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (579, 'ZY_BEE', '蜜蜂速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (580, 'ZY_BL', '百利快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (581, 'ZY_BM', '斑马物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (582, 'ZY_BT', '百通物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (583, 'ZY_CM', '策马转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (584, 'ZY_ESONG', '宜送转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (585, 'ZY_FD', '飞碟快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (586, 'ZY_FG', '飞鸽快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (587, 'ZY_FX', '风行快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (588, 'ZY_FXSD', '风行速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (589, 'ZY_FY', '飞洋快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (590, 'ZY_HC', '皓晨快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (591, 'ZY_HYSD', '海悦速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (592, 'ZY_JA', '君安快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (593, 'ZY_JD', '时代转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (594, 'ZY_JDKD', '骏达快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (595, 'ZY_JDZY', '骏达转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (596, 'ZY_JH', '久禾快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (597, 'ZY_JHT', '金海淘', 1);
INSERT INTO `MALL_SHIPPING` VALUES (598, 'ZY_LBZY', '联邦转运FedRoad', 1);
INSERT INTO `MALL_SHIPPING` VALUES (599, 'ZY_LX', '龙象快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (600, 'ZY_MGZY', '美国转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (601, 'ZY_MST', '美速通', 1);
INSERT INTO `MALL_SHIPPING` VALUES (602, 'ZY_MXZY', '美西转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (603, 'ZY_QQEX', 'QQ-EX', 1);
INSERT INTO `MALL_SHIPPING` VALUES (604, 'ZY_RT', '瑞天快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (605, 'ZY_RTSD', '瑞天速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (606, 'ZY_SDKD', '速达快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (607, 'ZY_SFZY', '四方转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (608, 'ZY_ST', '上腾快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (609, 'ZY_TJ', '天际快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (610, 'ZY_TM', '天马转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (611, 'ZY_TN', '滕牛快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (612, 'ZY_TPY', '太平洋快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (613, 'ZY_TSZ', '唐三藏转运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (614, 'ZY_TWC', 'TWC转运世界', 1);
INSERT INTO `MALL_SHIPPING` VALUES (615, 'ZY_RDGJ', '润东国际快线', 1);
INSERT INTO `MALL_SHIPPING` VALUES (616, 'ZY_TX', '同心快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (617, 'ZY_TY', '天翼快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (618, 'ZY_DGHT', '德国海淘之家', 1);
INSERT INTO `MALL_SHIPPING` VALUES (619, 'ZY_DYW', '德运网', 1);
INSERT INTO `MALL_SHIPPING` VALUES (620, 'ZY_WDCS', '文达国际DCS', 1);
INSERT INTO `MALL_SHIPPING` VALUES (621, 'ZY_TZH', '同舟快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (622, 'ZY_UCS', 'UCS合众快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (623, 'ZY_XC', '星辰快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (624, 'ZY_XF', '先锋快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (625, 'ZY_YQ', '云骑快递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (626, 'ZY_YSSD', '优晟速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (627, 'ZY_YTUSA', '运淘美国', 1);
INSERT INTO `MALL_SHIPPING` VALUES (628, 'ZY_ZCSD', '至诚速递', 1);
INSERT INTO `MALL_SHIPPING` VALUES (629, 'ZYZOOM', '增速海淘', 1);
INSERT INTO `MALL_SHIPPING` VALUES (630, 'ZH', '中驰物流', 1);
INSERT INTO `MALL_SHIPPING` VALUES (631, 'ZO', '中欧快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (632, 'ZSKY', '准实快运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (633, 'ZWSY', '中外速运', 1);
INSERT INTO `MALL_SHIPPING` VALUES (634, 'ZZJH', '郑州建华', 1);
INSERT INTO `MALL_SHIPPING` VALUES (635, 'ZTOGLOBAL', '中通国际', 1);
INSERT INTO `MALL_SHIPPING` VALUES (636, 'ZYSFGJ', '转运四方国际快递', 1);

-- ----------------------------
-- Table structure for `MALL_TEMPLATE_CONF`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_TEMPLATE_CONF`;
CREATE TABLE `MALL_TEMPLATE_CONF` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `TEMPLATE_TYPE` tinyint(4) DEFAULT '1' COMMENT '模板类型 0:新订单提醒	 1:下单成功通知 2:订单评价提醒 3:退款 4:秒杀成功通知 5:订单配送通知',
  `TEMPLATE_ID` varchar(64) DEFAULT '' COMMENT '推送模板ID',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='微信订阅消息';

-- ----------------------------
-- Records of MALL_TEMPLATE_CONF
-- ----------------------------
INSERT INTO `MALL_TEMPLATE_CONF` VALUES ('0', 0, 'DTuRopf48UD5T4cxl-xfhEaDgCn3MQGC2Zgrw41MwFU');
INSERT INTO `MALL_TEMPLATE_CONF` VALUES ('1', 1, 'zHUyp74CW9WOjYmEWn_sdjJ650tlnO3t7VhDWLBOIkU');
INSERT INTO `MALL_TEMPLATE_CONF` VALUES ('2', 2, 'FWkWilLIrl2_uXiuGFFIuYswjT9PGyeXmusTI_11Yhg');
INSERT INTO `MALL_TEMPLATE_CONF` VALUES ('3', 3, 'Gzprigz9UMS-hwzuvaeAE0ULTCCuEYvGsK29E1ZoQvI');
INSERT INTO `MALL_TEMPLATE_CONF` VALUES ('4', 4, '2AnnInQ46mZG4cwu-sC3KjgBOX2gDMFHI3PfAxNsZ88');
INSERT INTO `MALL_TEMPLATE_CONF` VALUES ('5', 5, 'Kvl-JSiIFmfTrlymfFgGibn9HcJ76OFP61OvxIlIuoY');

-- ----------------------------
-- Table structure for `MALL_USER`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_USER`;
CREATE TABLE `MALL_USER` (
  `ID` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '用户ID',
  `USER_NAME` varchar(128) NOT NULL DEFAULT '' COMMENT '用户名',
  `PASSWORD` varchar(128) CHARACTER SET utf8 DEFAULT '' COMMENT '密码',
  `GENDER` tinyint(4) DEFAULT NULL COMMENT '用户的性别（1是男性，2是女性，0是未知）',
  `BIRTHDAY` datetime DEFAULT NULL COMMENT '生日',
  `REGISTER_TIME` datetime DEFAULT NULL COMMENT '注册时间',
  `LAST_LOGIN_TIME` datetime DEFAULT NULL COMMENT '最后登录时间',
  `LAST_LOGIN_IP` varchar(32) CHARACTER SET utf8 DEFAULT '' COMMENT '最后登录IP',
  `USER_LEVEL_ID` varchar(32) CHARACTER SET utf8 DEFAULT NULL COMMENT '会员等级ID',
  `NICKNAME` varchar(64) DEFAULT '' COMMENT '微信昵称',
  `MOBILE` varchar(256) CHARACTER SET utf8 DEFAULT '' COMMENT '手机号',
  `REGISTER_IP` varchar(64) CHARACTER SET utf8 DEFAULT '' COMMENT '注册ip',
  `HEAD_IMG_URL` varchar(255) CHARACTER SET utf8 DEFAULT '' COMMENT '用户头像',
  `ALI_USER_ID` varchar(64) CHARACTER SET utf8 DEFAULT NULL COMMENT '支付宝用户标识',
  `OPEN_ID` varchar(64) CHARACTER SET utf8 DEFAULT '' COMMENT '小程序用户的标识',
  `MP_OPEN_ID` varchar(64) CHARACTER SET utf8 DEFAULT NULL COMMENT '公众号用户的标识',
  `QQ_OPEN_ID` varchar(64) DEFAULT NULL COMMENT 'QQ用户标识',
  `UNION_ID` varchar(128) CHARACTER SET utf8 DEFAULT NULL COMMENT '用户唯一标识',
  `SUBSCRIBE` tinyint(4) DEFAULT '0' COMMENT '公众号关注状态（1是关注，0是未关注），未关注时获取不到其余信息',
  `SUBSCRIBE_TIME` varchar(32) CHARACTER SET utf8 DEFAULT NULL COMMENT '用户关注公众号时间，为时间戳。如果用户曾多次关注，则取最后关注时间',
  `INTEGRAL` int(11) DEFAULT NULL COMMENT '积分',
  `BALANCE` decimal(10,2) DEFAULT '0.00' COMMENT '余额',
  PRIMARY KEY (`ID`),
  KEY `OPEN_ID` (`OPEN_ID`) USING BTREE,
  KEY `NICKNAME` (`NICKNAME`) USING BTREE,
  KEY `MOBILE` (`MOBILE`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员';

-- ----------------------------
-- Records of MALL_USER
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_USER_LEVEL`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_USER_LEVEL`;
CREATE TABLE `MALL_USER_LEVEL` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `NAME` varchar(64) NOT NULL DEFAULT '' COMMENT '等级名称',
  `MONEY` decimal(10,2) DEFAULT NULL COMMENT '会员完成订单金额满足则升级',
  `DISCOUNT` decimal(10,2) DEFAULT NULL COMMENT '折扣',
  `IMAGE_URL` varchar(128) DEFAULT NULL COMMENT '会员等级图片',
  `DESCRIPTION` varchar(255) NOT NULL DEFAULT '' COMMENT '描述',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员等级管理';

-- ----------------------------
-- Records of MALL_USER_LEVEL
-- ----------------------------
INSERT INTO `MALL_USER_LEVEL` VALUES ('1', 'VIP1', '0.00', '1.00', null, '0');
INSERT INTO `MALL_USER_LEVEL` VALUES ('2', 'VIP2', '500.00', '0.95', null, '500');
INSERT INTO `MALL_USER_LEVEL` VALUES ('3', 'VIP3', '2000.00', '0.90', null, '2000');
INSERT INTO `MALL_USER_LEVEL` VALUES ('4', 'VIP4', '5000.00', '0.85', null, '5000');
INSERT INTO `MALL_USER_LEVEL` VALUES ('5', 'VIP5', '20000.00', '0.80', null, '20000');

-- ----------------------------
-- Table structure for `MALL_USER_SIGN_RECORD`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_USER_SIGN_RECORD`;
CREATE TABLE `MALL_USER_SIGN_RECORD` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `USER_ID` varchar(32) DEFAULT NULL COMMENT '会员ID',
  `SIGN_TIME` datetime DEFAULT NULL COMMENT '签到时间',
  `SIGN_INTEGRAL` int(11) DEFAULT NULL COMMENT '本次签到获得积分',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户签到记录';

-- ----------------------------
-- Records of MALL_USER_SIGN_RECORD
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_TOPIC`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_TOPIC`;
CREATE TABLE `MALL_TOPIC` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `title` varchar(255) NOT NULL DEFAULT '''''' COMMENT '活动主题',
  `content` text COMMENT '活动内容',
  `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '化名',
  `item_pic_url` varchar(255) NOT NULL DEFAULT '' COMMENT '活动条例图片',
  `subtitle` varchar(255) NOT NULL DEFAULT '''' COMMENT '子标题',
  `topic_category_id` varchar(32) NOT NULL DEFAULT '0' COMMENT '活动类别',
  `price_info` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '活动价格',
  `read_count` varchar(255) NOT NULL DEFAULT '0',
  `scene_pic_url` varchar(255) NOT NULL DEFAULT '' COMMENT '场景图片链接',
  `topic_template_id` varchar(32) NOT NULL DEFAULT '0' COMMENT '活动模板Id',
  `topic_tag_id` varchar(32) NOT NULL DEFAULT '0' COMMENT '活动标签Id',
  KEY `topic_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of MALL_TOPIC
-- ----------------------------
INSERT INTO `MALL_TOPIC` VALUES ('1', '关爱他成长的每一个足迹', '<p><img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\" class=\"fr-fin\"><img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\" class=\"fr-fin\"><img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\" class=\"fr-fin\"><img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\" class=\"fr-fin\"><img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\" class=\"fr-fin\"><img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\" class=\"fr-fin\"><img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\" class=\"fr-fin\"></p>', 'https://yanxuan.nosdn.127.net/14943186689221563.png', 'https://yanxuan.nosdn.127.net/14943267735961674.jpg', '专业运动品牌同厂，毛毛虫鞋买二送一', '2', '0.00', '6.4k', 'https://yanxuan.nosdn.127.net/14943267735961674.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('2', '一次解决5个节日送礼难题', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14942967243991290.png', 'https://yanxuan.nosdn.127.net/14942996754171334.jpg', '这些就是他们想要的礼物清单', '0', '59.90', '7.8k', 'https://yanxuan.nosdn.127.net/14942996754171334.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('3', '秒杀化学洗涤剂的纯天然皂', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14939843011001088.png', 'https://yanxuan.nosdn.127.net/14939843143621089.jpg', '前段时间有朋友跟我抱怨，和婆婆住到一起才发现生活理念有太多不和。别的不提，光是洗...', '1', '0.00', '15.3k', 'https://yanxuan.nosdn.127.net/14939843143621089.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('4', '买过的人都说它是差旅神器', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14938873720850678.png', 'https://yanxuan.nosdn.127.net/14938873919030679.jpg', '许多人经历过旅途中内裤洗晾不便的烦恼，尤其与旅伴同居一室时，晾在卫生间里的内裤更...', '1', '0.00', '28.7k', 'https://yanxuan.nosdn.127.net/14938873919030679.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('5', '他们在严选遇见的新生活', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14937987677390284.png', 'https://yanxuan.nosdn.127.net/14938092956370380.jpg', '多款商品直减中，最高直减400元', '0', '35.80', '36.6k', 'https://yanxuan.nosdn.127.net/14938092956370380.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('6', '这只锅，可以从祖母用到孙辈', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14937214529340142.png', 'https://yanxuan.nosdn.127.net/14937214454750141.jpg', '买100年传世珐琅锅送迷你马卡龙色小锅', '4', '149.00', '108.1k', 'https://yanxuan.nosdn.127.net/14937214454750141.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('7', '舒适新主张', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14933596154560938.png', 'https://yanxuan.nosdn.127.net/14939496197300723.jpg', '如何挑选适合自己的好物？', '0', '29.00', '67.8k', 'https://yanxuan.nosdn.127.net/14939496197300723.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('8', '专业运动袜也可以高性价比', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14932840884890614.png', 'https://yanxuan.nosdn.127.net/14932840600970609.jpg', '越来越多运动人士意识到，运动鞋要购置好的，鞋里的运动袜也不可忽视。专业运动袜帮助...', '1', '0.00', '11.9k', 'https://yanxuan.nosdn.127.net/14932840600970609.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('9', '严选新式样板间', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14931133750100134.png', 'https://yanxuan.nosdn.127.net/14931970965550315.jpg', '一种软装一个家', '3', '29.90', '55.6k', 'https://yanxuan.nosdn.127.net/14931970965550315.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('10', '无“油”无虑的甜蜜酥脆', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14931121505610125.png', 'https://yanxuan.nosdn.127.net/14931121822100127.jpg', '大家都知道，饮食组是严选体重最重的一组，基本上每个新人都能在一个月之内迅速长胖。...', '1', '0.00', '15.6k', 'https://yanxuan.nosdn.127.net/14931121822100127.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('11', '条纹新风尚', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14926859949660827.png', 'https://yanxuan.nosdn.127.net/14926859849200826.jpg', '经典百搭，时尚线条', '3', '29.00', '76.5k', 'https://yanxuan.nosdn.127.net/14926859849200826.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('12', '成就一室笋香', '<p><img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\" class=\"fr-fin\" alt=\"title\" title=\"title\"><img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\" class=\"fr-fin\"><img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\" class=\"fr-fin\"><img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\" class=\"fr-fin\"><img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\" class=\"fr-fin\"><img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\" class=\"fr-fin\"><img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\" class=\"fr-fin\"></p>', 'https://yanxuan.nosdn.127.net/14927695155801070.png', 'https://yanxuan.nosdn.127.net/14927695046601069.jpg', '三石哥办公室常备小食推荐', '2', '12.00', '40.9k', 'https://yanxuan.nosdn.127.net/14927695046601069.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('13', '孩子成长中少不了的一双鞋', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14927748094971079.png', 'https://yanxuan.nosdn.127.net/14927748974441080.jpg', '说起毛毛虫鞋，好处实在太多了，作为一个2岁孩子的宝妈选品员，按捺不住想告诉大家，...', '1', '0.00', '42.5k', 'https://yanxuan.nosdn.127.net/14927748974441080.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('14', '治愈生活的满怀柔软', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14926748590030593.png', 'https://yanxuan.nosdn.127.net/14926737925770587.jpg', '太鼓抱枕的上架历程，是从失踪开始的。由于表面的绒感，最初它被安排在秋冬季上架。某...', '1', '0.00', '19.6k', 'https://yanxuan.nosdn.127.net/14926737925770587.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('15', '没有软木拖，怎么过夏天', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14925821004620235.png', 'https://yanxuan.nosdn.127.net/14925822213780237.jpg', '刚入四月，杭州的气温就已升高至30度。店庆时买了软木拖的用户，陆续发回评价说，很...', '1', '0.00', '46.4k', 'https://yanxuan.nosdn.127.net/14925822213780237.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('16', '料理也要精细简单', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14925201467400187.png', 'https://yanxuan.nosdn.127.net/14925200530030186.jpg', '享受天然的味道，日子每天都好新鲜', '2', '69.00', '125.6k', 'https://yanxuan.nosdn.127.net/14925200530030186.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('17', '选式新懒人', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14924199159971698.png', 'https://yanxuan.nosdn.127.net/14924199099661697.jpg', '懒出格调，懒出好生活。', '3', '15.00', '57.7k', 'https://yanxuan.nosdn.127.net/14924199099661697.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('18', '米饭好吃的秘诀：会呼吸的锅', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14920712417610604.png', 'https://yanxuan.nosdn.127.net/14920623353130483.jpg', '今年1月份，我们联系到了日本伊贺地区的长谷园，那里有着180年伊贺烧历史的窑厂。...', '1', '0.00', '33.3k', 'https://yanxuan.nosdn.127.net/14920623353130483.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('19', '一条丝巾就能提升时髦度', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14919005600900208.png', 'https://yanxuan.nosdn.127.net/14919007135160213.jpg', '不知道大家对去年G20时，严选与国礼制造商一起推出的《凤凰于飞》等几款丝巾是否还...', '1', '0.00', '35.0k', 'https://yanxuan.nosdn.127.net/14919007135160213.jpg', '0', '0');
INSERT INTO `MALL_TOPIC` VALUES ('20', '设计师们推荐的应季好物', '<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">', 'https://yanxuan.nosdn.127.net/14920662001560500.png', 'https://yanxuan.nosdn.127.net/14918201901050274.jpg', '原创设计春款系列上新', '0', '29.90', '77.7k', 'https://yanxuan.nosdn.127.net/14918201901050274.jpg', '0', '0');

-- ----------------------------
-- Table structure for `MALL_TOPIC_CATEGORY`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_TOPIC_CATEGORY`;
CREATE TABLE `MALL_TOPIC_CATEGORY` (
    `id` varchar(32) NOT NULL COMMENT '主键',
    `title` varchar(255) NOT NULL DEFAULT '' COMMENT '活动类别主题',
    `pic_url` varchar(255) NOT NULL DEFAULT '' COMMENT '活动类别图片链接',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of MALL_TOPIC_CATEGORY
-- ----------------------------
INSERT INTO `MALL_TOPIC_CATEGORY` VALUES ('1', '严选幕后', 'https://yanxuan.nosdn.127.net/dc1b671ad54e16339f1b26cfeec6a1ea.jpg');
INSERT INTO `MALL_TOPIC_CATEGORY` VALUES ('2', '丁磊私物推荐', 'https://yanxuan.nosdn.127.net/1de4da49367dd7c01af1f7a2b23b0237.jpg');
INSERT INTO `MALL_TOPIC_CATEGORY` VALUES ('3', '特色系列', 'https://yanxuan.nosdn.127.net/14939888170021096.png');
INSERT INTO `MALL_TOPIC_CATEGORY` VALUES ('4', '明星商品', 'https://yanxuan.nosdn.127.net/14939888168151095.png');
INSERT INTO `MALL_TOPIC_CATEGORY` VALUES ('5', '严选推荐', 'http://mp123.oss-cn-shenzhen.aliyuncs.com//upload/20170820/1553241265c59c.jpg');

DROP TABLE IF EXISTS `MALL_PAY_FACE_TO_FACE`;
CREATE TABLE `MALL_PAY_FACE_TO_FACE` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `USER_ID` varchar(32) DEFAULT NULL COMMENT '会员ID',
  `FROM_TYPE` tinyint(4) DEFAULT NULL COMMENT '用户下单来源类型 1:微信小程序 2:微信公众号 3:app 4:H5 5:支付宝小程序 6:QQ小程序',
  `ORDER_SN` varchar(32) DEFAULT NULL COMMENT '订单编号',
  `PAY_STATUS` tinyint(4) DEFAULT '1' COMMENT '付款状态 1:未付款 2:付款中 3:已付款',
  `ACTUAL_PRICE` decimal(10,2) DEFAULT '0.00' COMMENT '实际支付的金额',
  `ADD_TIME` datetime DEFAULT NULL COMMENT '下单时间',
  `PAY_TIME` datetime DEFAULT NULL COMMENT '付款时间',
  `SHOPS_ID` varchar(32) DEFAULT NULL COMMENT '店铺ID',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ORDER_SN` (`ORDER_SN`) USING BTREE,
  KEY `USER_ID` (`USER_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='当面付记录';

-- ----------------------------
-- Table structure for `QRTZ_BLOB_TRIGGERS`
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_BLOB_TRIGGERS`;
CREATE TABLE `QRTZ_BLOB_TRIGGERS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `BLOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `SCHED_NAME` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `QRTZ_BLOB_TRIGGERS_IBFK_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of QRTZ_BLOB_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for `QRTZ_CALENDARS`
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CALENDARS`;
CREATE TABLE `QRTZ_CALENDARS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `CALENDAR_NAME` varchar(200) NOT NULL,
  `CALENDAR` blob NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`CALENDAR_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of QRTZ_CALENDARS
-- ----------------------------

-- ----------------------------
-- Table structure for `QRTZ_CRON_TRIGGERS`
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CRON_TRIGGERS`;
CREATE TABLE `QRTZ_CRON_TRIGGERS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `CRON_EXPRESSION` varchar(120) NOT NULL,
  `TIME_ZONE_ID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `QRTZ_CRON_TRIGGERS_IBFK_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of QRTZ_CRON_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for `QRTZ_FIRED_TRIGGERS`
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_FIRED_TRIGGERS`;
CREATE TABLE `QRTZ_FIRED_TRIGGERS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `ENTRY_ID` varchar(95) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `FIRED_TIME` bigint(13) NOT NULL,
  `SCHED_TIME` bigint(13) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  `STATE` varchar(16) NOT NULL,
  `JOB_NAME` varchar(200) DEFAULT NULL,
  `JOB_GROUP` varchar(200) DEFAULT NULL,
  `IS_NONCONCURRENT` varchar(1) DEFAULT NULL,
  `REQUESTS_RECOVERY` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`ENTRY_ID`),
  KEY `IDX_QRTZ_FT_TRIG_INST_NAME` (`SCHED_NAME`,`INSTANCE_NAME`),
  KEY `IDX_QRTZ_FT_INST_JOB_REQ_RCVRY` (`SCHED_NAME`,`INSTANCE_NAME`,`REQUESTS_RECOVERY`),
  KEY `IDX_QRTZ_FT_J_G` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_FT_JG` (`SCHED_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_FT_T_G` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_FT_TG` (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of QRTZ_FIRED_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for `QRTZ_JOB_DETAILS`
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_JOB_DETAILS`;
CREATE TABLE `QRTZ_JOB_DETAILS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) NOT NULL,
  `IS_DURABLE` varchar(1) NOT NULL,
  `IS_NONCONCURRENT` varchar(1) NOT NULL,
  `IS_UPDATE_DATA` varchar(1) NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) NOT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_J_REQ_RECOVERY` (`SCHED_NAME`,`REQUESTS_RECOVERY`),
  KEY `IDX_QRTZ_J_GRP` (`SCHED_NAME`,`JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of QRTZ_JOB_DETAILS
-- ----------------------------

-- ----------------------------
-- Table structure for `QRTZ_LOCKS`
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_LOCKS`;
CREATE TABLE `QRTZ_LOCKS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `LOCK_NAME` varchar(40) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`LOCK_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of QRTZ_LOCKS
-- ----------------------------

-- ----------------------------
-- Table structure for `QRTZ_PAUSED_TRIGGER_GRPS`
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_PAUSED_TRIGGER_GRPS`;
CREATE TABLE `QRTZ_PAUSED_TRIGGER_GRPS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of QRTZ_PAUSED_TRIGGER_GRPS
-- ----------------------------

-- ----------------------------
-- Table structure for `QRTZ_SCHEDULER_STATE`
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SCHEDULER_STATE`;
CREATE TABLE `QRTZ_SCHEDULER_STATE` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `LAST_CHECKIN_TIME` bigint(13) NOT NULL,
  `CHECKIN_INTERVAL` bigint(13) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`INSTANCE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of QRTZ_SCHEDULER_STATE
-- ----------------------------

-- ----------------------------
-- Table structure for `QRTZ_SIMPLE_TRIGGERS`
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPLE_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPLE_TRIGGERS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `REPEAT_COUNT` bigint(7) NOT NULL,
  `REPEAT_INTERVAL` bigint(12) NOT NULL,
  `TIMES_TRIGGERED` bigint(10) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `QRTZ_SIMPLE_TRIGGERS_IBFK_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of QRTZ_SIMPLE_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for `QRTZ_SIMPROP_TRIGGERS`
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPROP_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPROP_TRIGGERS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `STR_PROP_1` varchar(512) DEFAULT NULL,
  `STR_PROP_2` varchar(512) DEFAULT NULL,
  `STR_PROP_3` varchar(512) DEFAULT NULL,
  `INT_PROP_1` int(11) DEFAULT NULL,
  `INT_PROP_2` int(11) DEFAULT NULL,
  `LONG_PROP_1` bigint(20) DEFAULT NULL,
  `LONG_PROP_2` bigint(20) DEFAULT NULL,
  `DEC_PROP_1` decimal(13,4) DEFAULT NULL,
  `DEC_PROP_2` decimal(13,4) DEFAULT NULL,
  `BOOL_PROP_1` varchar(1) DEFAULT NULL,
  `BOOL_PROP_2` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `QRTZ_SIMPROP_TRIGGERS_IBFK_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of QRTZ_SIMPROP_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for `QRTZ_TRIGGERS`
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_TRIGGERS`;
CREATE TABLE `QRTZ_TRIGGERS` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PREV_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PRIORITY` int(11) DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) NOT NULL,
  `TRIGGER_TYPE` varchar(8) NOT NULL,
  `START_TIME` bigint(13) NOT NULL,
  `END_TIME` bigint(13) DEFAULT NULL,
  `CALENDAR_NAME` varchar(200) DEFAULT NULL,
  `MISFIRE_INSTR` smallint(2) DEFAULT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_T_J` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_T_JG` (`SCHED_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_T_C` (`SCHED_NAME`,`CALENDAR_NAME`),
  KEY `IDX_QRTZ_T_G` (`SCHED_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_T_STATE` (`SCHED_NAME`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_N_STATE` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_N_G_STATE` (`SCHED_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_NEXT_FIRE_TIME` (`SCHED_NAME`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_ST` (`SCHED_NAME`,`TRIGGER_STATE`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_MISFIRE` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_ST_MISFIRE` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_NFT_ST_MISFIRE_GRP` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  CONSTRAINT `QRTZ_TRIGGERS_IBFK_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `QRTZ_JOB_DETAILS` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of QRTZ_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for `SCHEDULE_JOB`
-- ----------------------------
DROP TABLE IF EXISTS `SCHEDULE_JOB`;
CREATE TABLE `SCHEDULE_JOB` (
  `JOB_ID` varchar(32) NOT NULL COMMENT '任务id',
  `BEAN_NAME` varchar(200) DEFAULT NULL COMMENT 'spring bean名称',
  `METHOD_NAME` varchar(100) DEFAULT NULL COMMENT '方法名',
  `PARAMS` varchar(2000) DEFAULT NULL COMMENT '参数',
  `CRON_EXPRESSION` varchar(100) DEFAULT NULL COMMENT 'cron表达式',
  `STATUS` tinyint(4) DEFAULT NULL COMMENT '任务状态  0：正常  1：暂停',
  `REMARK` varchar(255) DEFAULT NULL COMMENT '备注',
  `CREATE_TIME` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`JOB_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='定时任务';

-- ----------------------------
-- Records of SCHEDULE_JOB
-- ----------------------------
INSERT INTO `SCHEDULE_JOB` VALUES ('7a737ccd0cf55d1447a73ad8d4417c83', 'orderTask', 'expireOrder', null, '0 0/1 * * * ?', 0, '过期自动取消订单', '2019-07-19 16:54:54');
INSERT INTO `SCHEDULE_JOB` VALUES ('1bbb4265010759616070eb7366d9da63', 'liveTask', 'getLiveList', '{start:0,limit:100}', '0 0 0 * * ?', 0, '同步直播房间列表', '2020-03-30 21:19:28');
INSERT INTO `SCHEDULE_JOB` VALUES ('db303cd143302df15ab7cb2ee4b2dfa4', 'liveTask', 'getapproved', '{start:0,limit:100}', '0 0 0 * * ?', 0, '同步直播商品信息', '2020-07-06 19:45:49');
INSERT INTO `SCHEDULE_JOB` VALUES ('7c6128ea1124c0cf0e643fb2a53abaa5', 'couponTask', 'expireCoupon', '', '0 0 0 * * ?', 0, '优惠券过期', '2020-04-20 17:56:36');
INSERT INTO `SCHEDULE_JOB` VALUES ('a28b9be050a7c7c8be3ae4ba9bf6a289', 'commissionTask', 'amountArrive', '', '0 0 6 * * ?', 0, '佣金定时到账', '2020-06-08 16:15:37');
INSERT INTO `SCHEDULE_JOB` VALUES ('9952dac7bcfe90f058b06d940a48da55', 'orderTask', 'expireGroup', '', '0 0/1 * * * ?', 0, '过期未完成拼团订单任务', '2021-11-16 16:11:24');

-- ----------------------------
-- Table structure for `SCHEDULE_JOB_LOG`
-- ----------------------------
DROP TABLE IF EXISTS `SCHEDULE_JOB_LOG`;
CREATE TABLE `SCHEDULE_JOB_LOG` (
  `LOG_ID` varchar(32) NOT NULL COMMENT '任务日志id',
  `JOB_ID` varchar(32) NOT NULL COMMENT '任务id',
  `BEAN_NAME` varchar(200) DEFAULT NULL COMMENT 'spring bean名称',
  `METHOD_NAME` varchar(100) DEFAULT NULL COMMENT '方法名',
  `PARAMS` varchar(2000) DEFAULT NULL COMMENT '参数',
  `STATUS` tinyint(4) NOT NULL COMMENT '任务状态    0：成功    1：失败',
  `ERROR` varchar(2000) DEFAULT NULL COMMENT '失败信息',
  `TIMES` int(11) NOT NULL COMMENT '耗时(单位：毫秒)',
  `CREATE_TIME` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`LOG_ID`),
  KEY `JOB_ID` (`JOB_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='定时任务日志';

-- ----------------------------
-- Records of SCHEDULE_JOB_LOG
-- ----------------------------

-- ----------------------------
-- Table structure for `SYS_CAPTCHA`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_CAPTCHA`;
CREATE TABLE `SYS_CAPTCHA` (
  `UUID` char(36) NOT NULL COMMENT 'uuid',
  `CODE` varchar(6) NOT NULL COMMENT '验证码',
  `EXPIRE_TIME` datetime DEFAULT NULL COMMENT '过期时间',
  PRIMARY KEY (`UUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统验证码';

-- ----------------------------
-- Records of SYS_CAPTCHA
-- ----------------------------

-- ----------------------------
-- Table structure for `SYS_CONFIG`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_CONFIG`;
CREATE TABLE `SYS_CONFIG` (
  `ID` varchar(32) NOT NULL,
  `PARAM_KEY` varchar(50) DEFAULT NULL COMMENT 'key',
  `PARAM_VALUE` text COMMENT 'value',
  `STATUS` tinyint(4) DEFAULT '1' COMMENT '状态   0：隐藏   1：显示',
  `REMARK` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `PARAM_KEY` (`PARAM_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统配置信息表';

-- ----------------------------
-- Records of SYS_CONFIG
-- ----------------------------
INSERT INTO `SYS_CONFIG` VALUES ('1', 'CLOUD_STORAGE_CONFIG_KEY', '{\"type\":2,\"qiniuDomain\":\"\",\"qiniuPrefix\":\"\",\"qiniuAccessKey\":\"\",\"qiniuSecretKey\":\"\",\"qiniuBucketName\":\"\",\"aliyunDomain\":\"https://platform-wxmall.oss-cn-beijing.aliyuncs.com\",\"aliyunPrefix\":\"image\",\"aliyunEndPoint\":\"oss-cn-beijing.aliyuncs.com\",\"aliyunAccessKeyId\":\"\",\"aliyunAccessKeySecret\":\"\",\"aliyunBucketName\":\"platform-wxmall\",\"qcloudDomain\":\"\",\"qcloudPrefix\":\"\",\"qcloudSecretId\":\"\",\"qcloudSecretKey\":\"\",\"qcloudBucketName\":\"\",\"diskPath\":\"/usr/local/nginx/html/upload\",\"proxyServer\":\"http://132.232.89.47/upload\"}', '0', '云存储配置信息');
INSERT INTO `SYS_CONFIG` VALUES ('2', 'SMS_CONFIG_KEY', '{\"domain\":\"http://web.cr6868.com/asmx/smsservice.aspx?\",\"name\":\"lipengjun\",\"pwd\":\"\",\"sign\":\"【微同科技】\",\"type\":1}', '0', '短信配置');
INSERT INTO `SYS_CONFIG` VALUES ('3', 'ORDER_EXPIRE', '30', 1, '下单支付过期时间，单位分钟');
INSERT INTO `SYS_CONFIG` VALUES ('4', 'SHIPPING_FEE', '12', 1, '运费');
INSERT INTO `SYS_CONFIG` VALUES ('5', 'SHIPPING_FEE_FREE', '80', 1, '免运费门槛');
INSERT INTO `SYS_CONFIG` VALUES ('6', 'RECHARGE_STATUS', '2', 1, '是否开启余额支付，1：开启 2：禁用');
INSERT INTO `SYS_CONFIG` VALUES ('7', 'DISTRIBUTION_AUDIT', '1', 1, '是否开启分销商申请审核，1：开启 2：禁用');
INSERT INTO `SYS_CONFIG` VALUES ('8', 'WITHDRAW_AUDIT', '1', 1, '是否开启提现审核，1：开启 2：禁用');
INSERT INTO `SYS_CONFIG` VALUES ('9', 'COMMISSION_TYPE_DIST_1', '0', 1, '一级分销提成比例');
INSERT INTO `SYS_CONFIG` VALUES ('10', 'COMMISSION_TYPE_DIST_2', '0', 1, '二级分销提成比例');
INSERT INTO `SYS_CONFIG` VALUES ('11', 'COMMISSION_TYPE_PROMO_1', '0', 1, '一级推广提成比例');
INSERT INTO `SYS_CONFIG` VALUES ('12', 'COMMISSION_TYPE_PROMO_2', '0', 1, '二级推广提成比例');
INSERT INTO `SYS_CONFIG` VALUES ('13', 'WITHDRAW_SINGLE_LOWEST', '1', 1, '单次最低提现额度');
INSERT INTO `SYS_CONFIG` VALUES ('14', 'WITHDRAW_SINGLE_HIGHEST', '5000', 1, '单次最高提现额度');
INSERT INTO `SYS_CONFIG` VALUES ('15', 'WITHDRAW_DAY_HIGHEST', '5000', 1, '当日最高提现额度');
INSERT INTO `SYS_CONFIG` VALUES ('16', 'ALLOW_REFUND_TIME', '7', 1, '收货后可申请退款时间');
INSERT INTO `SYS_CONFIG` VALUES ('17', 'USER_TREATY', '7', 0, '用户协议');
INSERT INTO `SYS_CONFIG` VALUES ('18', 'PRIVACY_TREATY', '7', 0, '隐私协议');
INSERT INTO `SYS_CONFIG` VALUES ('19', 'DISTRIBUTION_STATUS', '2', 1, '是否开启分销功能1：开启，2：关闭');

-- ----------------------------
-- Table structure for `SYS_DICT`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_DICT`;
CREATE TABLE `SYS_DICT` (
  `ID` varchar(32) NOT NULL,
  `GROUP_ID` varchar(32) DEFAULT NULL COMMENT '所属分组ID',
  `NAME` varchar(100) DEFAULT NULL COMMENT '字典名称',
  `VALUE` varchar(64) DEFAULT NULL COMMENT '字典值',
  `SORT` int(11) DEFAULT NULL COMMENT '排序号',
  `STATUS` int(11) DEFAULT NULL COMMENT '状态码',
  `REMARK` text COMMENT '备注',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据字典';

-- ----------------------------
-- Records of SYS_DICT
-- ----------------------------
INSERT INTO `SYS_DICT` VALUES ('37f73ea6b07c40ab8baec7f58b10e69e', '0b5e3fc9c30a4839a881bef0f85fc8af', '男', '1', '1', '1', null);
INSERT INTO `SYS_DICT` VALUES ('3b3cd7a1d75611afa42478cf0db98a9f', '756acef68d0acb5b9d90676689720b94', '商品相关', '1', '1', '1', null);
INSERT INTO `SYS_DICT` VALUES ('7936bc509417490ba0df9d938ccd1ce4', '2bbfcb36f9414b71a5d65f497be93496', '是', '1', '1', '1', null);
INSERT INTO `SYS_DICT` VALUES ('7fd70974ea18040f767e7a68130cd85d', '756acef68d0acb5b9d90676689720b94', '客户服务', '3', '3', '1', null);
INSERT INTO `SYS_DICT` VALUES ('957f3e162dc65c88233988b4533b54cb', '756acef68d0acb5b9d90676689720b94', '其他', '7', '7', '1', null);
INSERT INTO `SYS_DICT` VALUES ('979439be76954bc1852fdf2aeccf3cbc', '0b5e3fc9c30a4839a881bef0f85fc8af', '未知', '0', '3', '1', null);
INSERT INTO `SYS_DICT` VALUES ('a93382cde1b3e89ac9727b5d38ed2e9f', '756acef68d0acb5b9d90676689720b94', '产品建议', '6', '6', '1', null);
INSERT INTO `SYS_DICT` VALUES ('cbab5cc984cee053a56182915da1d32d', '756acef68d0acb5b9d90676689720b94', '功能异常', '5', '5', '1', null);
INSERT INTO `SYS_DICT` VALUES ('cd58ce94393df39d22958631c7c3c4ad', '756acef68d0acb5b9d90676689720b94', '优惠活动', '4', '4', '1', null);
INSERT INTO `SYS_DICT` VALUES ('d931f0a83fad5780f20ea6760b5ee222', '756acef68d0acb5b9d90676689720b94', '物流状况', '2', '2', '1', null);
INSERT INTO `SYS_DICT` VALUES ('f6cf775c5cea4c7b8858eb2ce0501177', '2bbfcb36f9414b71a5d65f497be93496', '否', '0', '2', '1', null);
INSERT INTO `SYS_DICT` VALUES ('fc982423addd41e3852c70f8396a0c6c', '0b5e3fc9c30a4839a881bef0f85fc8af', '女', '2', '2', '1', null);
INSERT INTO `SYS_DICT` VALUES ('e40b241a1da81bda7de470d068f8685e', 'afb2ccbe3ae990f313486c9d12b462a6', '工作室', '3', '3', '1', null);
INSERT INTO `SYS_DICT` VALUES ('9e06fd930521025e9ff9246f81912f11', 'afb2ccbe3ae990f313486c9d12b462a6', '有限公司', '2', '2', '1', null);
INSERT INTO `SYS_DICT` VALUES ('45d94555898773e9bccfd53920351789', 'afb2ccbe3ae990f313486c9d12b462a6', '个体户', '1', '1', '1', null);
INSERT INTO `SYS_DICT` VALUES ('1b059fa36e0a1bca7a50df5a3cd32f8c', 'afb2ccbe3ae990f313486c9d12b462a6', '其他', '4', '4', '1', null);

-- ----------------------------
-- Table structure for `SYS_DICT_GROUP`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_DICT_GROUP`;
CREATE TABLE `SYS_DICT_GROUP` (
  `ID` varchar(32) NOT NULL,
  `CODE` varchar(64) NOT NULL COMMENT '分组编码',
  `NAME` varchar(100) DEFAULT NULL COMMENT '分组名称',
  `CREATE_TIME` datetime DEFAULT NULL COMMENT '创建时间',
  `REMARK` text COMMENT '备注',
  PRIMARY KEY (`ID`,`CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据字典分组';

-- ----------------------------
-- Records of SYS_DICT_GROUP
-- ----------------------------
INSERT INTO `SYS_DICT_GROUP` VALUES ('0b5e3fc9c30a4839a881bef0f85fc8af', 'SEX', '性别', null, '性别，1：男 2：女 0：未知');
INSERT INTO `SYS_DICT_GROUP` VALUES ('2bbfcb36f9414b71a5d65f497be93496', 'IS_NOT', '是否', null, '1：是 0：否');
INSERT INTO `SYS_DICT_GROUP` VALUES ('756acef68d0acb5b9d90676689720b94', 'FEED_TYPE', '反馈类型', '2019-07-02 21:49:52', '1:商品相关, 2:物流状况, 3:客户服务,4:优惠活动, 5:功能异常, 6:产品建议, 7:其他');
INSERT INTO `SYS_DICT_GROUP` VALUES ('afb2ccbe3ae990f313486c9d12b462a6', 'COMPANY_TYPE', '公司类型', '2019-12-17 22:35:30', '公司类型 1个体户 2有限公司/ 3工作室 4其他');

-- ----------------------------
-- Table structure for `SYS_LOG`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_LOG`;
CREATE TABLE `SYS_LOG` (
  `ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(50) DEFAULT NULL COMMENT '用户名',
  `OPERATION` varchar(50) DEFAULT NULL COMMENT '用户操作',
  `METHOD` varchar(200) DEFAULT NULL COMMENT '请求方法',
  `PARAMS` varchar(5000) DEFAULT NULL COMMENT '请求参数',
  `TIME` bigint(20) NOT NULL COMMENT '执行时长(毫秒)',
  `IP` varchar(64) DEFAULT NULL COMMENT 'IP地址',
  `CREATE_TIME` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统日志';

-- ----------------------------
-- Records of SYS_LOG
-- ----------------------------

-- ----------------------------
-- Table structure for `SYS_MAIL_LOG`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_MAIL_LOG`;
CREATE TABLE `SYS_MAIL_LOG` (
  `ID` varchar(32) NOT NULL,
  `SENDER` varchar(100) NOT NULL COMMENT '发送人',
  `RECEIVER` varchar(4000) NOT NULL COMMENT '接收人',
  `SUBJECT` varchar(500) NOT NULL COMMENT '邮件主题',
  `CONTENT` varchar(4000) DEFAULT NULL COMMENT '发送内容',
  `SEND_DATE` datetime DEFAULT NULL COMMENT '发送时间',
  `TYPE` tinyint(4) DEFAULT NULL COMMENT '0：系统发送邮件 1：用户发送邮件',
  `SEND_RESULT` tinyint(4) DEFAULT NULL COMMENT '发送结果 0:发送成功 1:发送失败',
  `CREATE_USER_ID` varchar(32) DEFAULT NULL COMMENT '创建者ID',
  `CREATE_USER_ORG_NO` varchar(32) DEFAULT NULL COMMENT '创建人所属机构',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='邮件发送日志';

-- ----------------------------
-- Records of SYS_MAIL_LOG
-- ----------------------------

-- ----------------------------
-- Table structure for `SYS_MENU`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_MENU`;
CREATE TABLE `SYS_MENU` (
  `MENU_ID` varchar(8) NOT NULL,
  `PARENT_ID` varchar(8) DEFAULT NULL COMMENT '父菜单ID，一级菜单为0',
  `NAME` varchar(50) DEFAULT NULL COMMENT '菜单名称',
  `URL` varchar(200) DEFAULT NULL COMMENT '菜单URL',
  `PERMS` varchar(500) DEFAULT NULL COMMENT '授权(多个用逗号分隔，如：user:list,user:create)',
  `TYPE` tinyint(4) DEFAULT NULL COMMENT '类型   0：目录   1：菜单   2：按钮',
  `ICON` varchar(50) DEFAULT NULL COMMENT '菜单图标',
  `ORDER_NUM` int(11) DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`MENU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='菜单管理';

-- ----------------------------
-- Records of SYS_MENU
-- ----------------------------
INSERT INTO `SYS_MENU` VALUES ('10', '0', '系统设置', null, null, 0, 'system', 0);
INSERT INTO `SYS_MENU` VALUES ('1001', '10', '菜单管理', 'sys/menu', 'sys:menu:list,sys:menu:info', 1, 'menu', 1);
INSERT INTO `SYS_MENU` VALUES ('100101', '1001', '新增', null, 'sys:menu:save,sys:menu:select', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('100102', '1001', '修改', null, 'sys:menu:update,sys:menu:select', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('100103', '1001', '删除', null, 'sys:menu:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1002', '10', '组织机构', 'sys/org', 'sys:org:list,sys:org:info', 1, 'org', 2);
INSERT INTO `SYS_MENU` VALUES ('100201', '1002', '新增', null, 'sys:org:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('100202', '1002', '修改', null, 'sys:org:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('100203', '1002', '删除', null, 'sys:org:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1003', '10', '系统参数', 'sys/config', 'sys:config:list,sys:config:info', 1, 'xitongpeizhi', 3);
INSERT INTO `SYS_MENU` VALUES ('100301', '1003', '新增', null, 'sys:config:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('100302', '1003', '修改', null, 'sys:config:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('100303', '1003', '删除', null, 'sys:config:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1004', '10', '字典管理', 'sys/dictgroup', 'sys:dictgroup:list,sys:dictgroup:info,sys:dict:list,sys:dict:info', 1, 'dict', 4);
INSERT INTO `SYS_MENU` VALUES ('100401', '1004', '数据字典新增', null, 'sys:dict:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('100402', '1004', '数据字典修改', null, 'sys:dict:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('100403', '1004', '数据字典删除', null, 'sys:dict:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('100404', '1004', '数据字典分组新增', null, 'sys:dictgroup:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('100405', '1004', '数据字典分组修改', null, 'sys:dictgroup:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('100406', '1004', '数据字典分组删除', null, 'sys:dictgroup:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1005', '10', '图片管理', 'oss/oss', 'sys:oss:list', 1, 'oss', 5);
INSERT INTO `SYS_MENU` VALUES ('100501', '1005', '云存储配置', null, 'sys:oss:config', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('100502', '1005', '删除', null, 'sys:oss:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1006', '10', '系统日志', 'sys/log', 'sys:log:list', 1, 'log', 6);
INSERT INTO `SYS_MENU` VALUES ('1007', '10', '邮件系统', 'sys/maillog', 'sys:maillog:list,sys:maillog:info', 1, 'email', 7);
INSERT INTO `SYS_MENU` VALUES ('100701', '1007', '删除', null, 'sys:maillog:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('100702', '1007', '邮箱配置', null, 'sys:maillog:config', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('11', '0', '权限管理', null, null, 0, 'auth', 1);
INSERT INTO `SYS_MENU` VALUES ('1101', '11', '管理员列表', 'sys/user', 'sys:user:list,sys:user:info', 1, 'admin', 1);
INSERT INTO `SYS_MENU` VALUES ('110101', '1101', '重置密码', null, 'sys:user:resetPw', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('110102', '1101', '新增', null, 'sys:user:save,sys:role:select', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('110103', '1101', '修改', null, 'sys:user:update,sys:role:select', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('110104', '1101', '删除', null, 'sys:user:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1102', '11', '角色管理', 'sys/role', 'sys:role:list,sys:role:info', 1, 'role', 2);
INSERT INTO `SYS_MENU` VALUES ('110201', '1102', '新增', null, 'sys:role:save,sys:menu:list', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('110202', '1102', '修改', null, 'sys:role:update,sys:menu:list', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('110203', '1102', '删除', null, 'sys:role:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('12', '0', '短信平台', null, null, 0, 'duanxinpingtai', 2);
INSERT INTO `SYS_MENU` VALUES ('1211', '12', '短信配置', 'sys/smslog', 'sys:smslog:list', 1, 'duanxin', 1);
INSERT INTO `SYS_MENU` VALUES ('121101', '1211', '修改配置', null, 'sys:smslog:config', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('121102', '1211', '删除', null, 'sys:smslog:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('121103', '1211', '发送短信', null, 'sys:smslog:send', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('13', '0', '任务调度', null, null, 0, 'diaodu', 3);
INSERT INTO `SYS_MENU` VALUES ('1301', '13', '定时任务', 'job/schedule', 'sys:schedule:list,sys:schedule:info', 1, 'job', 1);
INSERT INTO `SYS_MENU` VALUES ('130101', '1301', '删除', null, 'sys:schedule:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('130102', '1301', '暂停', null, 'sys:schedule:pause', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('130103', '1301', '恢复', null, 'sys:schedule:resume', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('130104', '1301', '立即执行', null, 'sys:schedule:run', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('130105', '1301', '日志列表', null, 'sys:schedule:log', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('130106', '1301', '新增', null, 'sys:schedule:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('130107', '1301', '修改', null, 'sys:schedule:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('14', '0', '工作流管理', null, null, 0, 'activiti', 4);
INSERT INTO `SYS_MENU` VALUES ('1401', '14', '流程操作', 'act/reprocdef', 'act:reprocdef:list', 1, 'procdef', 1);
INSERT INTO `SYS_MENU` VALUES ('140101', '1401', '激活,挂起', null, 'act:reprocdef:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('140102', '1401', '删除', null, 'act:reprocdef:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('140103', '1401', '转为模型', null, 'act:reprocdef:convertToModel', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('140104', '1401', '部署流程', null, 'act:reprocdef:deploy', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1402', '14', '模型管理', 'act/remodel', 'act:remodel:list', 1, 'model', 2);
INSERT INTO `SYS_MENU` VALUES ('140201', '1402', '新增', null, 'act:remodel:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('140202', '1402', '编辑', null, 'act:remodel:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('140203', '1402', '部署', null, 'act:remodel:deploy', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('140204', '1402', '导出', null, 'act:remodel:export', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('140205', '1402', '删除', null, 'act:remodel:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('15', '0', '开发工具', null, null, 0, 'dev', 5);
INSERT INTO `SYS_MENU` VALUES ('1501', '15', '令牌管理', 'sys/usertoken', 'sys:usertoken:list', 1, 'zaixian', 1);
INSERT INTO `SYS_MENU` VALUES ('150101', '1501', '删除', null, 'sys:usertoken:offline', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1502', '15', '缓存信息', 'sys/redis', 'sys:cache:queryAll', 1, 'redis', 2);
INSERT INTO `SYS_MENU` VALUES ('150201', '1502', '删除', null, 'sys:cache:deleteCache', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1503', '15', 'SQL监控', 'http://fly2you.cn/platform-admin/druid/sql.html', null, 1, 'sql', 3);
INSERT INTO `SYS_MENU` VALUES ('1504', '15', '接口文档', 'http://fly2you.cn/platform-api/doc.html', null, 1, 'interface', 4);
INSERT INTO `SYS_MENU` VALUES ('1505', '15', '代码生成器', 'gen/generator', 'sys:generator:list', 1, 'code', 5);
INSERT INTO `SYS_MENU` VALUES ('150501', '1505', '生成代码', null, 'sys:generator:code', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('16', '0', '会员管理', null, null, 0, 'vip', 6);
INSERT INTO `SYS_MENU` VALUES ('1601', '16', '会员等级配置', 'mall/userlevel', 'mall:userlevel:list,mall:userlevel:info', 1, 'level', 1);
INSERT INTO `SYS_MENU` VALUES ('160101', '1601', '新增', null, 'mall:userlevel:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('160102', '1601', '修改', null, 'mall:userlevel:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('160103', '1601', '删除', null, 'mall:userlevel:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1602', '16', '我的会员', 'mall/user', 'mall:user:list,mall:user:info', 1, 'admin', 2);
INSERT INTO `SYS_MENU` VALUES ('160201', '1602', '用户账户余额变动记录', null, 'mall:accountlog:list', 2, null, 1);
INSERT INTO `SYS_MENU` VALUES ('160202', '1602', '修改', null, 'mall:user:update', 2, null, 2);
INSERT INTO `SYS_MENU` VALUES ('160203', '1602', '积分记录', '', 'mall:integrallog:list', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('160204', '1602', '充值余额', '', 'mall:user:modBalance', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('160205', '1602', '充值积分', '', 'mall:user:modIntegral', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('1603', '16', '收货地址', 'mall/address', 'mall:address:list,mall:address:info', 1, 'dangdifill', 3);
INSERT INTO `SYS_MENU` VALUES ('160301', '1603', '删除', null, 'mall:address:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1604', '16', '会员优惠券', 'mall/usercoupon', 'mall:usercoupon:list,mall:usercoupon:info', 1, 'coupon', 4);
INSERT INTO `SYS_MENU` VALUES ('160401', '1604', '删除', null, 'mall:usercoupon:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1605', '16', '会员收藏', 'mall/collect', 'mall:collect:list,mall:collect:info', 1, 'collect', 5);
INSERT INTO `SYS_MENU` VALUES ('160501', '1605', '删除', null, 'mall:collect:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1606', '16', '历史足迹', 'mall/footprint', 'mall:footprint:list,mall:footprint:info', 1, 'footprint', 6);
INSERT INTO `SYS_MENU` VALUES ('160601', '1606', '删除', null, 'mall:footprint:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1607', '16', '搜索历史', 'mall/searchhistory', 'mall:searchhistory:list,mall:searchhistory:info', 1, 'history', 7);
INSERT INTO `SYS_MENU` VALUES ('160701', '1607', '删除', null, 'mall:searchhistory:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1608', '16', '会员签到记录', 'mall/usersignrecord', 'mall:usersignrecord:list,mall:usersignrecord:info', 1, 'sign', 8);
INSERT INTO `SYS_MENU` VALUES ('160801', '1608', '删除', null, 'mall:usersignrecord:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1609', '16', '会员购物车', 'mall/cart', 'mall:cart:list,mall:cart:info', 1, 'cart', 9);
INSERT INTO `SYS_MENU` VALUES ('160901', '1609', '删除', null, 'mall:cart:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1610', '16', '会员反馈', 'mall/feedback', 'mall:feedback:list,mall:feedback:info', 1, 'feedback', 10);
INSERT INTO `SYS_MENU` VALUES ('161002', '1610', '删除', null, 'mall:feedback:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1611', '16', '会员银行卡', 'mall/userbankcard', 'mall:userbankcard:list,mall:userbankcard:info', 1, 'card', 11);
INSERT INTO `SYS_MENU` VALUES ('161101', '1601', '新增', null, 'mall:userbankcard:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('161102', '1601', '修改', null, 'mall:userbankcard:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('161103', '1601', '删除', null, 'mall:userbankcard:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('17', '0', '商城配置', null, null, 0, 'mall', 7);
INSERT INTO `SYS_MENU` VALUES ('1701', '17', '轮播设置', 'mall/banner', 'mall:banner:list,mall:banner:info', 1, 'banner', 1);
INSERT INTO `SYS_MENU` VALUES ('170101', '1701', '新增', null, 'mall:banner:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170102', '1701', '修改', null, 'mall:banner:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170103', '1701', '删除', null, 'mall:banner:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1702', '17', '商品分类', 'mall/category', 'mall:category:list,mall:category:info', 1, 'leibie', 3);
INSERT INTO `SYS_MENU` VALUES ('170201', '1702', '新增', null, 'mall:category:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170202', '1702', '修改', null, 'mall:category:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170203', '1702', '删除', null, 'mall:category:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1703', '17', '首页频道', 'mall/channel', 'mall:channel:list,mall:channel:info', 1, 'kuqu', 3);
INSERT INTO `SYS_MENU` VALUES ('170301', '1703', '新增', null, 'mall:channel:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170302', '1703', '修改', null, 'mall:channel:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170303', '1703', '删除', null, 'mall:channel:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1704', '17', '商品详情参数', 'mall/attribute', 'mall:attribute:list,mall:attribute:info', 1, 'kuwei', 4);
INSERT INTO `SYS_MENU` VALUES ('170401', '1704', '新增', null, 'mall:attribute:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170402', '1704', '修改', null, 'mall:attribute:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170403', '1704', '删除', null, 'mall:attribute:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1705', '17', '品牌制造商', 'mall/brand', 'mall:brand:list,mall:brand:info', 1, 'brand', 5);
INSERT INTO `SYS_MENU` VALUES ('170501', '1705', '新增', null, 'mall:brand:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170502', '1705', '修改', null, 'mall:brand:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170503', '1705', '删除', null, 'mall:brand:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1706', '17', '商品问答', 'mall/issue', 'mall:issue:list,mall:issue:info', 1, 'issue', 6);
INSERT INTO `SYS_MENU` VALUES ('170601', '1706', '新增', null, 'mall:issue:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170602', '1706', '修改', null, 'mall:issue:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170603', '1706', '删除', null, 'mall:issue:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1707', '17', '搜索关键词', 'mall/keywords', 'mall:keywords:list,mall:keywords:info', 1, 'sousuo', 7);
INSERT INTO `SYS_MENU` VALUES ('170701', '1707', '新增', null, 'mall:keywords:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170702', '1707', '修改', null, 'mall:keywords:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170703', '1707', '删除', null, 'mall:keywords:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1708', '17', '快递公司配置', 'mall/shipping', 'mall:shipping:list,mall:shipping:info', 1, 'shipping', 8);
INSERT INTO `SYS_MENU` VALUES ('170801', '1708', '新增', null, 'mall:shipping:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170802', '1708', '修改', null, 'mall:shipping:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170803', '1708', '删除', null, 'mall:shipping:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1709', '17', '商城公告', 'mall/bulletin', 'mall:bulletin:list,mall:bulletin:info', 1, 'bulletin', 9);
INSERT INTO `SYS_MENU` VALUES ('170901', '1709', '新增', null, 'mall:bulletin:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170902', '1709', '修改', null, 'mall:bulletin:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('170903', '1709', '删除', null, 'mall:bulletin:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1710', '17', '专题分类', 'mall/topiccategory', 'mall:topiccategory:list,mall:topiccategory:info', 1, 'leibie', 10);
INSERT INTO `SYS_MENU` VALUES ('171001', '1710', '新增', null, 'mall:topiccategory:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('171002', '1710', '修改', null, 'mall:topiccategory:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('171003', '1710', '删除', null, 'mall:topiccategory:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1711', '17', '专题', 'mall/topic', 'mall:topic:list,mall:topic:info', 1, 'collect', 11);
INSERT INTO `SYS_MENU` VALUES ('171101', '1711', '新增', null, 'mall:topic:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('171102', '1711', '修改', null, 'mall:topic:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('171103', '1711', '删除', null, 'mall:topic:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('18', '0', '评价管理', null, null, 0, 'goods', 8);
INSERT INTO `SYS_MENU` VALUES ('1801', '18', '商品评价', 'mall/comment', 'mall:comment:list,mall:comment:info', 1, 'bianji', 2);
INSERT INTO `SYS_MENU` VALUES ('180101', '1801', '审核', null, 'mall:commentpicture:list,mall:comment:changeStatus', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('19', '0', '店铺管理', null, null, 0, 'shop', 9);
INSERT INTO `SYS_MENU` VALUES ('1901', '19', '店铺列表', 'mall/shops', 'mall:shops:list,mall:shops:info', 1, 'shops', 1);
INSERT INTO `SYS_MENU` VALUES ('190101', '1901', '新增店铺', null, 'mall:shops:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('190102', '1901', '修改店铺', null, 'mall:shops:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('190103', '1901', '删除店铺', null, 'mall:shops:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1902', '19', '我的店铺', 'mall/myshop', 'mall:shops:myShop,mall:shops:info', 1, 'myshop', 2);
INSERT INTO `SYS_MENU` VALUES ('190201', '1902', '修改店铺', null, 'mall:shops:myUpdate', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1903', '19', '商品分类', 'mall/shopscategory', 'mall:shopscategory:list,mall:shopscategory:info', 1, 'leibie', 3);
INSERT INTO `SYS_MENU` VALUES ('190301', '1903', '新增', null, 'mall:shopscategory:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('190302', '1903', '修改', null, 'mall:shopscategory:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('190303', '1903', '删除', null, 'mall:shopscategory:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1904', '19', '商品管理', 'mall/goods', 'mall:goods:list,mall:goods:info', 1, 'shop', 4);
INSERT INTO `SYS_MENU` VALUES ('190401', '1904', '新增', null, 'mall:goods:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('190402', '1904', '修改', null, 'mall:goods:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('190403', '1904', '删除', null, 'mall:goods:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('190404', '1904', '上架、下架', null, 'mall:goods:changeSale', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1905', '19', '店铺打票机', 'sys/printer', 'sys:printer:list,sys:printer:info', 1, 'print', 5);
INSERT INTO `SYS_MENU` VALUES ('190501', '1905', '新增', '', 'sys:printer:save', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('190502', '1905', '修改', '', 'sys:printer:update', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('190503', '1905', '删除', '', 'sys:printer:delete', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('1906', '19', '秒杀配置', 'mall/seckill', 'mall:seckill:list,mall:seckill:info', 1, 'miaosha', 6);
INSERT INTO `SYS_MENU` VALUES ('190601', '1906', '新增', null, 'mall:seckill:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('190602', '1906', '修改', null, 'mall:seckill:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('190603', '1906', '删除', null, 'mall:seckill:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1907', '19', '当面付记录', 'mall/payfacetoface', 'mall:payfacetoface:list,mall:payfacetoface:info', 1, 'face', 7);
INSERT INTO `SYS_MENU` VALUES ('1908', '19', '销售统计', 'mall/report', '', 1, 'charts', 8);
INSERT INTO `SYS_MENU` VALUES ('190801', '1908', '所有分店销售统计', '', 'mall:order:allReport', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('190802', '1908', '分店商品销售统计', '', 'mall:order:report', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('1909', '19', '商家入驻审批', 'mall/shopsapproval', '', '1', 'shops', 9);
INSERT INTO `SYS_MENU` VALUES ('1910', '19', '商家提现', 'mall/shopswithdraw', 'mall:shopswithdraw:list,mall:shopswithdraw:info', 1, 'shops', 10);
INSERT INTO `SYS_MENU` VALUES ('191001', '1910', '新增', null, 'mall:shopswithdraw:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('191002', '1910', '修改', null, 'mall:shopswithdraw:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('191003', '1910', '删除', null, 'mall:shopswithdraw:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('191004', '1910', '审核', null, 'mall:shopswithdraw:check', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('1911', '19', '积分商品', 'mall/integralgoods', 'mall:integralgoods:list,mall:integralgoods:info', 1, 'vip', 11);
INSERT INTO `SYS_MENU` VALUES ('191101', '1911', '新增', '', 'mall:integralgoods:save', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('191102', '1911', '修改', '', 'mall:integralgoods:update', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('191103', '1911', '删除', '', 'mall:integralgoods:delete', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('1912', '19', '拼团记录', 'mall/groupbuyingrecord', 'mall:groupbuyingrecord:list,mall:groupbuyingrecord:info', 1, 'org', 5);
INSERT INTO `SYS_MENU` VALUES ('20', '0', '微信设置', null, null, 0, 'wechat', 10);
INSERT INTO `SYS_MENU` VALUES ('2001', '20', '公众号管理', '', '', 0, 'mp', 1);
INSERT INTO `SYS_MENU` VALUES ('200101', '2001', '公众号账号', 'wx/wx-account', 'wx:wxaccount:list,wx:wxaccount:info', 1, '', 1);
INSERT INTO `SYS_MENU` VALUES ('20010101', '200101', '新增', '', 'wx:wxaccount:save', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('20010102', '200101', '修改', '', 'wx:wxaccount:update', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('20010103', '200101', '删除', '', 'wx:wxaccount:delete', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('200102', '2001', '公众号消息', 'wx/wx-msg', 'wx:wxmsg:list,wx:wxmsg:info,wx:wxuser:list', 1, '', 2);
INSERT INTO `SYS_MENU` VALUES ('20010201', '200102', '回复', '', 'wx:wxmsg:save', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('20010202', '200102', '删除', '', 'wx:wxmsg:delete', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('200103', '2001', '自动回复规则', 'wx/msg-reply-rule', 'wx:msgreplyrule:list,wx:msgreplyrule:info', 1, '', 3);
INSERT INTO `SYS_MENU` VALUES ('20010301', '200103', '新增', '', 'wx:msgreplyrule:save', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('20010302', '200103', '修改', '', 'wx:msgreplyrule:update', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('20010303', '200103', '删除', '', 'wx:msgreplyrule:delete', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('200104', '2001', '素材管理', 'wx/wx-assets', 'wx:wxassets:list', 1, '', 3);
INSERT INTO `SYS_MENU` VALUES ('20010401', '200104', '新增修改', '', 'wx:wxassets:save', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('20010402', '200104', '删除', '', 'wx:wxassets:delete', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('200105', '2001', '公众号菜单', 'wx/wx-menu', '', 1, '', 4);
INSERT INTO `SYS_MENU` VALUES ('20010501', '200105', '更新公众号菜单', '', 'wx:menu:save', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('200106', '2001', '带参二维码', 'wx/wx-qrcode', 'wx:wxqrcode:list,wx:wxqrcode:info', 1, '', 5);
INSERT INTO `SYS_MENU` VALUES ('20010601', '200106', '新增', '', 'wx:wxqrcode:save', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('20010602', '200106', '删除', '', 'wx:wxqrcode:delete', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('2002', '20', '小程序配置', 'wx/maconfig', 'wx:maconfig:list,wx:maconfig:info', 1, 'xiaochengxu', 2);
INSERT INTO `SYS_MENU` VALUES ('200201', '2002', '新增', '', 'wx:maconfig:save', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('200202', '2002', '修改', '', 'wx:maconfig:update', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('200203', '2002', '删除', '', 'wx:maconfig:delete', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('2003', '20', '订阅消息设置', 'mall/templateconf', 'mall:templateconf:list,mall:templateconf:info', 1, 'tempmsg', 3);
INSERT INTO `SYS_MENU` VALUES ('200301', '2003', '修改', null, 'mall:templateconf:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('21', '0', '订单管理', null, null, 0, 'orders', 11);
INSERT INTO `SYS_MENU` VALUES ('2101', '21', '所有订单', 'mall/order', 'mall:order:list,mall:order:info', 1, 'myorder', 1);
INSERT INTO `SYS_MENU` VALUES ('210101', '2101', '发货', null, 'mall:order:sendGoods', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('210102', '2101', '确认收货', null, 'mall:order:confirmReceive', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('210103', '2101', '修改价格', null, 'mall:order:modPrice', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('210104', '2101', '导出', '', 'mall:order:exportOrderExcel', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('2102', '21', '我的店铺订单', 'mall/myorder', 'mall:order:myOrder,mall:order:info', 1, 'wuliaoguanli', 2);
INSERT INTO `SYS_MENU` VALUES ('210201', '2102', '发货', null, 'mall:order:sendGoods', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('210202', '2102', '确认收货', null, 'mall:order:confirmReceive', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('210203', '2102', '修改价格', null, 'mall:order:modPrice', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('2103', '21', '秒杀订单', 'mall/skillorder', 'mall:order:list,mall:order:info', 1, 'xiangqu', 3);
INSERT INTO `SYS_MENU` VALUES ('210301', '2103', '发货', null, 'mall:order:sendGoods', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('210302', '2103', '确认收货', null, 'mall:order:confirmReceive', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('210303', '2103', '修改价格', null, 'mall:order:modPrice', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('2104', '21', '退款审核', 'mall/ordersaleservice', 'mall:ordersaleservice:list,mall:ordersaleservice:info', 1, 'check', 4);
INSERT INTO `SYS_MENU` VALUES ('210401', '2104', '审核', '', 'mall:ordersaleservice:update', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('2105', '21', '退款记录', 'mall/orderrefund', 'mall:orderrefund:list,mall:orderrefund:info', 1, 'refund', 5);
INSERT INTO `SYS_MENU` VALUES ('22', '0', '推广管理', null, null, 0, 'gift', 12);
INSERT INTO `SYS_MENU` VALUES ('2201', '22', '优惠券管理', 'mall/coupon', 'mall:coupon:list,mall:coupon:info', 1, 'coupons', 1);
INSERT INTO `SYS_MENU` VALUES ('220101', '2201', '新增', null, 'mall:coupon:save', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('220102', '2201', '修改', null, 'mall:coupon:update', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('220103', '2201', '删除', null, 'mall:coupon:delete', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('220104', '2201', '发放优惠券', null, 'mall:coupon:sendUser', 2, null, 0);
INSERT INTO `SYS_MENU` VALUES ('2202', '22', '分销商列表', 'mall/dist', 'mall:dist:list,mall:dist:info', 1, 'admin', 2);
INSERT INTO `SYS_MENU` VALUES ('220201', '2202', '修改', null, 'mall:dist:update', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('220202', '2202', '删除', null, 'mall:dist:delete', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('220203', '2202', '审核通过', null, 'mall:dist:confirmAudit', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('2203', '22', '分销订单', 'mall/distorder', 'mall:distorder:list,mall:distorder:info', 1, 'myorder', 3);
INSERT INTO `SYS_MENU` VALUES ('220301', '2203', '删除', '', 'mall:distorder:delete', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('220302', '2203', '审核通过', '', 'mall:distorder:confirmAudit', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('220303', '2203', '审核', '', 'mall:distorder:confirmAudit', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('23', '0', '直播管理', '', '', 0, 'live', 13);
INSERT INTO `SYS_MENU` VALUES ('2301', '23', '直播房间', 'mall/room', 'mall:room:list,mall:room:info', 1, 'room', 1);
INSERT INTO `SYS_MENU` VALUES ('230101', '2301', '新增', '', 'mall:room:save', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('230102', '2301', '直播间导入商品', '', 'mall:room:addgoods', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('230103', '2301', '同步直播间信息', '', 'mall:room:getLiveInfo', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('230104', '2301', '删除', '', 'mall:room:delete', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('230105', '2301', '修改', '', 'mall:room:update', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('230106', '2301', '推流地址', '', 'mall:room:getPushUrl', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('230107', '2301', '分享二维码', '', 'mall:room:getSharedCode', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('2302', '23', '商品维护', 'mall/roomallgoods', 'mall:roomallgoods:list,mall:roomallgoods:info', 1, 'sousuo', 2);
INSERT INTO `SYS_MENU` VALUES ('230201', '2302', '商品添加并提审', '', 'mall:roomallgoods:save', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('230202', '2302', '更新商品', '', 'mall:roomallgoods:update', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('230203', '2302', '删除商品', '', 'mall:roomallgoods:delete', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('230204', '2302', '撤回审核', '', 'mall:roomallgoods:resetaudit', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('230205', '2302', '重新提交审核', '', 'mall:roomallgoods:audit', 2, '', 0);
INSERT INTO `SYS_MENU` VALUES ('230206', '2302', '同步商品', '', 'mall:roomallgoods:getapproved', 2, '', 0);

-- ----------------------------
-- Table structure for `SYS_ORG`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_ORG`;
CREATE TABLE `SYS_ORG` (
  `ORG_NO` varchar(10) NOT NULL COMMENT '机构编码',
  `ORG_NAME` varchar(50) DEFAULT NULL COMMENT '部门名称',
  `PARENT_NO` varchar(10) DEFAULT NULL COMMENT '上级部门ID，一级部门为0',
  `ORG_TYPE` int(11) DEFAULT NULL COMMENT '级别',
  `STATUS` int(11) DEFAULT '1' COMMENT '状态  0：无效   1：有效',
  `SORT` int(11) DEFAULT NULL COMMENT '排序',
  `CREATE_USER_ID` varchar(32) DEFAULT NULL COMMENT '创建者ID',
  `CREATE_USER_ORG_NO` varchar(32) DEFAULT NULL COMMENT '创建人所属机构',
  `CREATE_TIME` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`ORG_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='组织机构';

-- ----------------------------
-- Records of SYS_ORG
-- ----------------------------

-- ----------------------------
-- Table structure for `SYS_OSS`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_OSS`;
CREATE TABLE `SYS_OSS` (
  `ID` varchar(32) NOT NULL,
  `URL` varchar(200) DEFAULT NULL COMMENT 'URL地址',
  `CREATE_USER_ID` varchar(32) DEFAULT NULL COMMENT '创建者ID',
  `CREATE_USER_ORG_NO` varchar(32) DEFAULT NULL COMMENT '创建人所属机构',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文件上传';

-- ----------------------------
-- Records of SYS_OSS
-- ----------------------------

-- ----------------------------
-- Table structure for `SYS_ROLE`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_ROLE`;
CREATE TABLE `SYS_ROLE` (
  `ROLE_ID` varchar(32) NOT NULL,
  `ROLE_NAME` varchar(100) DEFAULT NULL COMMENT '角色名称',
  `REMARK` varchar(100) DEFAULT NULL COMMENT '备注',
  `CREATE_USER_ID` varchar(32) DEFAULT NULL COMMENT '创建者ID',
  `CREATE_USER_ORG_NO` varchar(32) DEFAULT NULL COMMENT '创建者所属机构',
  `CREATE_TIME` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`ROLE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色';

-- ----------------------------
-- Records of SYS_ROLE
-- ----------------------------
INSERT INTO `SYS_ROLE` VALUES ('3be7a1a791e7c58342893566ffe4636a', '商铺管理员', '商铺通用管理员', '1', '01', '2019-12-09 14:13:38');

-- ----------------------------
-- Table structure for `SYS_ROLE_MENU`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_ROLE_MENU`;
CREATE TABLE `SYS_ROLE_MENU` (
  `ID` varchar(32) NOT NULL,
  `ROLE_ID` varchar(32) DEFAULT NULL COMMENT '角色ID',
  `MENU_ID` varchar(8) DEFAULT NULL COMMENT '菜单ID',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色与菜单对应关系';

-- ----------------------------
-- Records of SYS_ROLE_MENU
-- ----------------------------
INSERT INTO `SYS_ROLE_MENU` VALUES ('0d8fec9afe5c24735ecac439890242af', '3be7a1a791e7c58342893566ffe4636a', '210201');
INSERT INTO `SYS_ROLE_MENU` VALUES ('11fb163514a4c4b5d8060e8a7ad2bbbd', '3be7a1a791e7c58342893566ffe4636a', '10');
INSERT INTO `SYS_ROLE_MENU` VALUES ('1919f6685561575cf3478a794aab4e70', '3be7a1a791e7c58342893566ffe4636a', '210203');
INSERT INTO `SYS_ROLE_MENU` VALUES ('1f566eb6d14af2f988301c16dd7e2f4e', '3be7a1a791e7c58342893566ffe4636a', '1005');
INSERT INTO `SYS_ROLE_MENU` VALUES ('20f6ce4fef5131c5fcf16cddc6c8f3fb', '3be7a1a791e7c58342893566ffe4636a', '190404');
INSERT INTO `SYS_ROLE_MENU` VALUES ('212b1a671ba0fe6ad255a33f684c7589', '3be7a1a791e7c58342893566ffe4636a', '190602');
INSERT INTO `SYS_ROLE_MENU` VALUES ('22f7b6f2552ceec027e17d25744df224', '3be7a1a791e7c58342893566ffe4636a', '1904');
INSERT INTO `SYS_ROLE_MENU` VALUES ('23ebce9938792e23fd391ac8251f3d30', '3be7a1a791e7c58342893566ffe4636a', '16');
INSERT INTO `SYS_ROLE_MENU` VALUES ('2440b88e4539040e52a661717c1e343e', '3be7a1a791e7c58342893566ffe4636a', '190601');
INSERT INTO `SYS_ROLE_MENU` VALUES ('28429e01df33b22273e9193e2d0c8747', '3be7a1a791e7c58342893566ffe4636a', '210202');
INSERT INTO `SYS_ROLE_MENU` VALUES ('2ed839b7277970e2b4ac89537c1f7d5b', '3be7a1a791e7c58342893566ffe4636a', '190401');
INSERT INTO `SYS_ROLE_MENU` VALUES ('39cc8b0ea412d294692e010bba35d201', '3be7a1a791e7c58342893566ffe4636a', '210303');
INSERT INTO `SYS_ROLE_MENU` VALUES ('3acc3a1c5bac863f95371cc2b0569684', '3be7a1a791e7c58342893566ffe4636a', '1907');
INSERT INTO `SYS_ROLE_MENU` VALUES ('5387cf975bad09f1779635978fd445a5', '3be7a1a791e7c58342893566ffe4636a', '2102');
INSERT INTO `SYS_ROLE_MENU` VALUES ('5f720c297e8308916ba53635f4772c14', '3be7a1a791e7c58342893566ffe4636a', '1905');
INSERT INTO `SYS_ROLE_MENU` VALUES ('627c78c90fd3691c911a099cf5224f5b', '3be7a1a791e7c58342893566ffe4636a', '190603');
INSERT INTO `SYS_ROLE_MENU` VALUES ('6aa572f9454759b5c8b3bcc032fcd88d', '3be7a1a791e7c58342893566ffe4636a', '190403');
INSERT INTO `SYS_ROLE_MENU` VALUES ('7407fd0dd1e0b1d7d1c676f300ee6c04', '3be7a1a791e7c58342893566ffe4636a', '190302');
INSERT INTO `SYS_ROLE_MENU` VALUES ('7e5b8c3e52bf946271fc348eeddef1bf', '3be7a1a791e7c58342893566ffe4636a', '190201');
INSERT INTO `SYS_ROLE_MENU` VALUES ('7fb1e80dbaadbd3993c7d0679a5808bf', '3be7a1a791e7c58342893566ffe4636a', '1908');
INSERT INTO `SYS_ROLE_MENU` VALUES ('82c7a1efe4323fc0f3940b329a01a651', '3be7a1a791e7c58342893566ffe4636a', '190303');
INSERT INTO `SYS_ROLE_MENU` VALUES ('8fae1f8fc436492acbb532fd7708bcae', '3be7a1a791e7c58342893566ffe4636a', '19');
INSERT INTO `SYS_ROLE_MENU` VALUES ('9280da08754b56564517d09c35d06d23', '3be7a1a791e7c58342893566ffe4636a', '190802');
INSERT INTO `SYS_ROLE_MENU` VALUES ('93e13d4641b44753e69efc0bba6410a9', '3be7a1a791e7c58342893566ffe4636a', '190402');
INSERT INTO `SYS_ROLE_MENU` VALUES ('96729dff422c3d610e6f1f162f4fcae9', '3be7a1a791e7c58342893566ffe4636a', '210301');
INSERT INTO `SYS_ROLE_MENU` VALUES ('adf65b0535e08d7ed5d3add90ec69303', '3be7a1a791e7c58342893566ffe4636a', '190503');
INSERT INTO `SYS_ROLE_MENU` VALUES ('b565c4296191ac31480cbb7fc380370f', '3be7a1a791e7c58342893566ffe4636a', '1903');
INSERT INTO `SYS_ROLE_MENU` VALUES ('bf4f3a5f216a0934687f91db4a9425b5', '3be7a1a791e7c58342893566ffe4636a', '190502');
INSERT INTO `SYS_ROLE_MENU` VALUES ('c35fd68a2a9adf6e2e4c6e20fb9259b5', '3be7a1a791e7c58342893566ffe4636a', '1906');
INSERT INTO `SYS_ROLE_MENU` VALUES ('c6caa9fca4118eb08a68791f1b6c6cf0', '3be7a1a791e7c58342893566ffe4636a', '2103');
INSERT INTO `SYS_ROLE_MENU` VALUES ('d0ddf7f6ded07f69b9b939284665788c', '3be7a1a791e7c58342893566ffe4636a', '21');
INSERT INTO `SYS_ROLE_MENU` VALUES ('dad851508d07c65bf2099a7567cd2e3f', '3be7a1a791e7c58342893566ffe4636a', '210302');
INSERT INTO `SYS_ROLE_MENU` VALUES ('dd90419a2389723a61a389b55e8e8fa4', '3be7a1a791e7c58342893566ffe4636a', '1902');
INSERT INTO `SYS_ROLE_MENU` VALUES ('ed913b8473dc83b44cdda1a78f15896e', '3be7a1a791e7c58342893566ffe4636a', '160901');
INSERT INTO `SYS_ROLE_MENU` VALUES ('f16987c13f41eb18853e1940a07a798b', '3be7a1a791e7c58342893566ffe4636a', '190501');
INSERT INTO `SYS_ROLE_MENU` VALUES ('f2877794ae73ce2d8e5c67ead6ee5785', '3be7a1a791e7c58342893566ffe4636a', '1609');
INSERT INTO `SYS_ROLE_MENU` VALUES ('f2a1aaeea5f1e92fc53b82ac4024f737', '3be7a1a791e7c58342893566ffe4636a', '100502');
INSERT INTO `SYS_ROLE_MENU` VALUES ('fd873e70774f76eccf5dbe628be4321f', '3be7a1a791e7c58342893566ffe4636a', '190301');

-- ----------------------------
-- Table structure for `SYS_ROLE_ORG`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_ROLE_ORG`;
CREATE TABLE `SYS_ROLE_ORG` (
  `ID` varchar(32) NOT NULL,
  `ROLE_ID` varchar(32) DEFAULT NULL COMMENT '角色ID',
  `ORG_NO` varchar(32) DEFAULT NULL COMMENT '部门ID',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色与机构对应关系';

-- ----------------------------
-- Records of SYS_ROLE_ORG
-- ----------------------------

-- ----------------------------
-- Table structure for `SYS_SMS_LOG`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_SMS_LOG`;
CREATE TABLE `SYS_SMS_LOG` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `USER_ID` varchar(32) DEFAULT NULL COMMENT '操作人ID',
  `TEMPLATE_ID` int(11) DEFAULT NULL COMMENT '模板ID',
  `CODE` int(11) DEFAULT NULL COMMENT '验证码',
  `CONTENT` text COMMENT '发送内容（1-500 个汉字）UTF-8编码',
  `MOBILE` text COMMENT '手机号码。多个以英文逗号隔开',
  `STIME` datetime DEFAULT NULL COMMENT '发送时间',
  `SIGN` varchar(32) DEFAULT NULL COMMENT '必填参数。用户签名',
  `SEND_STATUS` int(1) DEFAULT NULL COMMENT '0成功 1失败',
  `SEND_ID` varchar(32) DEFAULT NULL COMMENT '发送编号',
  `SUCCESS_NUM` int(11) DEFAULT NULL COMMENT '成功提交数',
  `RETURN_MSG` varchar(50) DEFAULT NULL COMMENT '返回消息',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='短信发送日志';

-- ----------------------------
-- Records of SYS_SMS_LOG
-- ----------------------------

-- ----------------------------
-- Table structure for `SYS_USER`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_USER`;
CREATE TABLE `SYS_USER` (
  `USER_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(50) NOT NULL COMMENT '用户名',
  `REAL_NAME` varchar(64) NOT NULL,
  `SEX` tinyint(4) NOT NULL,
  `ORG_NO` varchar(32) DEFAULT NULL COMMENT '机构编码',
  `SALT` varchar(20) DEFAULT NULL COMMENT '盐',
  `EMAIL_HOST` varchar(32) DEFAULT NULL COMMENT '邮件服务器地址',
  `EMAIL` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `EMAIL_PW` varchar(64) DEFAULT NULL COMMENT '用户邮箱密码',
  `MOBILE` varchar(100) DEFAULT NULL COMMENT '手机号',
  `STATUS` tinyint(4) DEFAULT NULL COMMENT '状态  0：禁用   1：正常',
  `PASSWORD` varchar(100) DEFAULT NULL COMMENT '密码',
  `CREATE_USER_ID` varchar(32) DEFAULT NULL COMMENT '创建者ID',
  `CREATE_USER_ORG_NO` varchar(32) DEFAULT NULL COMMENT '创建人所属机构',
  `CREATE_TIME` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`USER_ID`),
  UNIQUE KEY `USERNAME` (`USER_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统用户';

-- ----------------------------
-- Records of SYS_USER
-- ----------------------------
INSERT INTO `SYS_USER` VALUES ('1', 'admin', 'admin', '1', '01', 'YzcmCZNvbXocrsz9dm8e', 'smtp.qq.com', '939961241@qq.com', '', '15209831990', '1', '9ec9750e709431dad22365cabc5c625482e574c74adaebba7dd02f1129e4ce1d', '', null, '2016-11-11 11:11:11');

-- ----------------------------
-- Table structure for `SYS_USER_ROLE`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_USER_ROLE`;
CREATE TABLE `SYS_USER_ROLE` (
  `ID` varchar(32) NOT NULL,
  `USER_ID` varchar(32) DEFAULT NULL COMMENT '用户ID',
  `ROLE_ID` varchar(32) DEFAULT NULL COMMENT '角色ID',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户与角色对应关系';

-- ----------------------------
-- Records of SYS_USER_ROLE
-- ----------------------------

-- ----------------------------
-- Table structure for `SYS_USER_TOKEN`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_USER_TOKEN`;
CREATE TABLE `SYS_USER_TOKEN` (
  `USER_ID` varchar(32) NOT NULL,
  `TOKEN` varchar(100) NOT NULL COMMENT 'token',
  `EXPIRE_TIME` datetime DEFAULT NULL COMMENT '过期时间',
  `UPDATE_TIME` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`USER_ID`),
  UNIQUE KEY `TOKEN` (`TOKEN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统用户Token';

-- ----------------------------
-- Records of SYS_USER_TOKEN
-- ----------------------------

-- ----------------------------
-- Table structure for `SYS_PRINTER`
-- ----------------------------
DROP TABLE IF EXISTS `SYS_PRINTER`;
CREATE TABLE `SYS_PRINTER` (
  `ID` varchar(32) NOT NULL,
  `NAME` varchar(100) NOT NULL COMMENT '打印机名称',
  `SN` varchar(100) DEFAULT NULL COMMENT '打印机编号',
  `SHOPS_ID` varchar(100) DEFAULT NULL COMMENT '所属门店',
  `STUB_SN` varchar(100) DEFAULT NULL COMMENT '存根打印机',
  PRIMARY KEY (`ID`),
  KEY `SN` (`SN`) USING BTREE,
  KEY `SHOPS_ID` (`SHOPS_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='飞鹅打印机';

-- ----------------------------
-- Records of SYS_PRINTER
-- ----------------------------

DROP TABLE IF EXISTS `WX_MA_CONFIG`;
CREATE TABLE `WX_MA_CONFIG` (
    `ID` varchar(32) NOT NULL,
    `APP_ID` varchar(64) DEFAULT NULL COMMENT '微信小程序appId',
    `SECRET` varchar(128) DEFAULT NULL COMMENT '微信小程序secret',
    `TOKEN` varchar(128) DEFAULT NULL COMMENT '小程序token',
    `AES_KEY` varchar(128) DEFAULT NULL COMMENT '微信小程序EncodingAESKey',
    `MSG_DATA_FORMAT` varchar(32) DEFAULT NULL COMMENT '消息格式，XML或者JSON',
    PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='微信小程序配置';
INSERT INTO `WX_MA_CONFIG` VALUES ('1', 'wxeca4341756496160', '', '', '', 'JSON');

-- ----------------------------
-- Table structure for `MALL_DIST`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_DIST`;
CREATE TABLE `MALL_DIST` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `USER_ID` varchar(32) NOT NULL COMMENT '会员ID',
  `SUPERIOR_ID` int(10) unsigned NULL COMMENT '上级分销ID',
  `NAME` varchar(255) NOT NULL COMMENT '真实姓名',
  `IS_AUDIT` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已审核',
  `JOIN_TIME` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
  `AMOUNT_AVAILABLE` decimal(10, 2) NOT NULL DEFAULT '0' COMMENT '待取佣金',
  `AMOUNT_WITHDRAWN` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '已取佣金',
  `AMOUNT_TOTAL` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '累计佣金',
  `INVITATION_CODE` varchar(255) NOT NULL COMMENT '邀请码',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `USER_ID` (`USER_ID`) USING BTREE,
  UNIQUE KEY `INVITATION_CODE` (`INVITATION_CODE`) USING BTREE,
  KEY `SUPERIOR_ID` (`SUPERIOR_ID`) USING BTREE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COMMENT = '分销';

-- ----------------------------
-- Table structure for `MALL_DIST_ORDER`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_DIST_ORDER`;
CREATE TABLE `MALL_DIST_ORDER` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `USER_ID` varchar(32) NOT NULL COMMENT '会员ID',
  `BUYER_ID` varchar(32) NULL COMMENT '购买者ID',
  `ORDER_ID` varchar(32) NULL COMMENT '订单ID',
  `TYPE` varchar(32) NOT NULL COMMENT '订单类型 1：代理提成 2：推广提成 3：佣金提现',
  `INCOME` decimal(10, 2) NULL COMMENT '结算收益',
  `INCOME_TIME` datetime NULL COMMENT '结算时间',
  `COMMISSION_TYPE`varchar(32) NULL COMMENT '提成类型 1：一级分销 2：二级分销 3：一级推广 4：二级推广',
  `COMMISSION` decimal(10, 8) NULL COMMENT '提成比例 数值范围：0~1',
  `WITHDRAW_TYPE`varchar(32) NULL COMMENT '提现类型 1：付款到零钱 2：付款到银行卡',
  `ENC_BANK_NO`varchar(32) NULL COMMENT '收款方银行卡号',
  `ENC_TRUE_NAME`varchar(32) NULL COMMENT '收款方用户名',
  `BANK_CODE`varchar(32) NULL COMMENT '收款方开户行',
  `AUDIT_STATUS` tinyint(1) NOT NULL DEFAULT '0' COMMENT '审核状态 0：审核中 1：审核通过 2：审核不通过',
  `AUDIT_DESC` varchar(32) NULL COMMENT '审核说明',
  `GOODS_ID` varchar(32) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `SKU_ID` varchar(32) DEFAULT NULL COMMENT 'SKU_ID',
  `PAYMENT_NO` varchar(64) DEFAULT NULL COMMENT '企业付款成功，返回的微信付款单号',
  PRIMARY KEY (`ID`),
  KEY `SORT` (`USER_ID`, `INCOME_TIME`) USING BTREE,
  KEY `FILTER_1` (`USER_ID`, `TYPE`) USING BTREE,
  KEY `FILTER_2` (`USER_ID`, `COMMISSION_TYPE`) USING BTREE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COMMENT = '分销订单';

-- ----------------------------
-- Table structure for `MALL_DIST_INVITATION`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_DIST_INVITATION`;
CREATE TABLE `MALL_DIST_INVITATION` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `USER_ID` varchar(32) NOT NULL COMMENT '会员ID',
  `SUPERIOR_ID` int(10) unsigned NOT NULL COMMENT '上级分销ID',
  `CREATE_TIME` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `USER_ID` (`USER_ID`) USING BTREE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COMMENT = '分销上级邀请绑定';

-- ----------------------------
-- Table structure for `MALL_DIST_AMOUNT_SCHEDULED`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_DIST_AMOUNT_SCHEDULED`;
CREATE TABLE `MALL_DIST_AMOUNT_SCHEDULED` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `DIST_ORDER_ID` varchar(32) NOT NULL COMMENT '分销订单ID',
  `ORDER_ID` varchar(32) NOT NULL COMMENT '购物订单ID',
  `USER_ID` varchar(32) NOT NULL COMMENT '用户ID',
  `INCOME` decimal(10, 2) NULL COMMENT '收益',
  `ARRIVE_TIME` datetime NOT NULL COMMENT '到账时间',
  `STATUS` tinyint(1) NOT NULL DEFAULT '0' COMMENT '定时到账状态 0：未到账 1：已到账 2：购买者退款，失效',
  PRIMARY KEY (`ID`),
  KEY `USER_ID` (`USER_ID`) USING BTREE,
  KEY `ORDER_ID` (`ORDER_ID`) USING BTREE,
  KEY `ARRIVE_TIME` (`ARRIVE_TIME`) USING BTREE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COMMENT = '提成定时到账记录';

-- ----------------------------
-- Table structure for `MALL_DIST_PROMO`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_DIST_PROMO`;
CREATE TABLE `MALL_DIST_PROMO` (
    `ID` varchar(32) NOT NULL,
    `STATUS` tinyint(1) NOT NULL COMMENT '推广状态 1：加入购物车 2：已生成订单 3：已支付',
    `CART_ID` varchar(32) DEFAULT NULL COMMENT '购物车ID',
    `ORDER_ID` varchar(32) DEFAULT NULL COMMENT '订单ID',
    `GOODS_ID` varchar(32) DEFAULT NULL COMMENT '商品ID',
    `USER_ID` varchar(32) NOT NULL COMMENT '推广者用户ID',
    `SKU_ID` varchar(32) DEFAULT '0' COMMENT 'SKU_ID',
    `CREATED_AT`  datetime DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT '创建时间',
    `UPDATED_AT`  datetime DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`ID`),
    KEY `CART_ID` (`CART_ID`) USING BTREE,
    KEY `ORDER_ID` (`ORDER_ID`) USING BTREE,
    KEY `GOODS_ID` (`GOODS_ID`) USING BTREE,
    KEY `USER_ID` (`USER_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='推广追踪表';

-- ----------------------------
-- Table structure for `MALL_BANK_TYPE`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_BANK_TYPE`;
CREATE TABLE `MALL_BANK_TYPE` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `BANK_NAME` varchar(20) NOT NULL COMMENT '银行名称',
  `BANK_CODE` varchar(11) NOT NULL COMMENT '银行ID',
  PRIMARY KEY (`ID`),
  KEY `BANK_NAME` (`BANK_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='银行类型表';

-- ----------------------------
--  Records of `MALL_BANK_TYPE`
-- ----------------------------
INSERT INTO MALL_BANK_TYPE (ID, BANK_NAME, BANK_CODE) VALUES( 1, '中国工商银行', '1002'),( 2, '中国农业银行', '1005'),( 3, '中国建设银行', '1003'),( 4, '中国银行', '1026'),( 5, '交通银行', '1020'),( 6, '招商银行', '1001'),( 7, '中国邮政储蓄银行', '1066'),( 8, '中国民生银行', '1006'),( 9, '平安银行', '1010'),( 10, '中信银行', '1021'),( 11, '浦发银行', '1004'),( 12, '兴业银行', '1009'),( 13, '中国光大银行', '1022'),( 14, '广发银行', '1027'),( 15, '华夏银行', '1025'),( 16, '宁波银行', '1056'),( 17, '北京银行', '4836'),( 18, '上海银行', '1024'),( 19, '南京银行', '1054'),( 20, '长子县融汇村镇银行', '4755'),( 21, '长沙银行', '4216'),( 22, '浙江泰隆商业银行', '4051'),( 23, '中原银行', '4753'),( 24, '企业银行（中国）', '4761'),( 25, '顺德农商银行', '4036'),( 26, '衡水银行', '4752'),( 27, '长治银行', '4756'),( 28, '大同银行', '4767'),( 29, '河南省农村信用社', '4115'),( 30, '宁夏黄河农村商业银行', '4150'),( 31, '山西省农村信用社联合社', '4156'),( 32, '安徽省农村信用社联合社', '4166'),( 33, '甘肃省农村信用社联合社', '4157'),( 34, '天津农村商业银行', '4153'),( 35, '广西壮族自治区农村信用社联合社', '4113'),( 36, '陕西省农村信用社联合社', '4108'),( 37, '深圳农村商业银行', '4076'),( 38, '宁波鄞州农村商业银行', '4052'),( 39, '浙江省农村信用社联合社', '4764'),( 40, '江苏省农村信用社联合社', '4217'),( 41, '江苏紫金农村商业银行股份有限公司', '4072'),( 42, '北京中关村银行股份有限公司', '4769'),( 43, '星展银行（中国）有限公司', '4778'),( 44, '枣庄银行股份有限公司', '4766'),( 45, '海口联合农村商业银行股份有限公司', '4758'),( 46, '南洋商业银行（中国）有限公司', '4763');

-- ----------------------------
-- Table structure for `MALL_USER_BANK_CARD`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_USER_BANK_CARD`;
CREATE TABLE `MALL_USER_BANK_CARD` (
    `ID` varchar(32) NOT NULL COMMENT '主键',
    `USER_ID` varchar(32) DEFAULT NULL COMMENT '会员ID',
    `CARD_NAME` varchar(32) DEFAULT NULL COMMENT '收款人姓名',
    `CARD_NUMBER` varchar(32) DEFAULT NULL COMMENT '银行卡号',
    `CARD_TYPE` varchar(32) DEFAULT NULL COMMENT '卡类型',
    `BANK_TYPE_ID` int(11) unsigned NOT NULL COMMENT '银行ID',
    `CARD_STATUS` tinyint(1) NOT NULL COMMENT '1：已绑定 2：已解绑',
    `BOUND_AT`  datetime DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT '绑定时间',
    PRIMARY KEY (`ID`),
    KEY `USER_ID` (`USER_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户银行卡表';

-- ----------------------------
-- Table structure for `MALL_ORDER_SALESERVICE`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_ORDER_SALESERVICE`;
CREATE TABLE `MALL_ORDER_SALESERVICE` (
    `ID` varchar(32) NOT NULL COMMENT '主键',
    `ORDER_SN` varchar(32) DEFAULT NULL COMMENT '订单编号',
    `USER_ID` varchar(32) DEFAULT NULL COMMENT '申请人ID',
    `SALESERVICE_SN` varchar(255) DEFAULT NULL COMMENT '退款单编号',
    `REASON` varchar(100) DEFAULT NULL COMMENT '申请退款原因',
    `AMOUNT` DECIMAL(10,2) DEFAULT NULL COMMENT '申请退款金额',
    `STATUS` TINYINT DEFAULT 0 COMMENT '状态1：已申请 2：已审核 3：已退款 4：已驳回',
    `CREATE_TIME` DATETIME DEFAULT NULL COMMENT '申请时间',
    `HANDLE_TIME` DATETIME DEFAULT NULL COMMENT '审核时间',
    `REFUND_TIME` DATETIME DEFAULT NULL COMMENT '退款时间',
    `HANDLE_REASON` varchar(200) DEFAULT NULL COMMENT '审核原因',
    `REMARK` varchar(2000) DEFAULT NULL COMMENT '用户备注',
    PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='申请退款';

-- ----------------------------
-- Table structure for `MALL_ORDER_REFUND`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_ORDER_REFUND`;
CREATE TABLE `MALL_ORDER_REFUND` (
    `ID` varchar(32) NOT NULL COMMENT '主键',
    `ORDER_SN` varchar(32) DEFAULT NULL COMMENT '订单编号',
    `SALESERVICE_ID` varchar(32) DEFAULT NULL COMMENT '售后单ID',
    `USER_ID` varchar(32) DEFAULT NULL COMMENT '用户ID',
    `REFUND_TYPE` TINYINT DEFAULT 1 COMMENT '退款类型 1用户退款 2系统退款 3售后退款',
    `REFUND_STATUS` TINYINT DEFAULT 1 COMMENT ' 退款状态 1申请中 2退款成功 3已拒绝',
    `REFUND_TIME` DATETIME DEFAULT NULL COMMENT '退款时间',
    `REFUND_MONEY` DECIMAL(8,2) DEFAULT NULL COMMENT '退款金额',
    `REFUND_REASON` varchar(255) DEFAULT NULL COMMENT '退款原因',
    `APPROVER` varchar(32) DEFAULT NULL COMMENT '审核人',
    `APPROVAL_TIME` DATETIME DEFAULT NULL COMMENT '审核时间',
    `APPROVAL_REMARK` varchar(255) DEFAULT NULL COMMENT '审核备注',
    PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='退款记录';





-- ----------------------------
-- Table structure for WX_ACCOUNT
-- ----------------------------
DROP TABLE IF EXISTS `WX_ACCOUNT`;
CREATE TABLE `WX_ACCOUNT`  (
   `APPID` char(20) CHARACTER SET utf8 NOT NULL COMMENT 'appid',
   `NAME` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT '公众号名称',
   `TYPE` tinyint(1) UNSIGNED NULL DEFAULT 1 COMMENT '账号类型',
   `VERIFIED` tinyint(1) UNSIGNED NULL DEFAULT 1 COMMENT '认证状态',
   `SECRET` char(32) CHARACTER SET utf8 NOT NULL COMMENT 'appsecret',
   `TOKEN` varchar(32) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT 'token',
   `AES_KEY` varchar(43) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT 'aesKey',
   `CONTENT` text CHARACTER SET utf8 NULL DEFAULT NULL COMMENT '关注后自动回复',
   PRIMARY KEY (`APPID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT = '公众号账号';

-- ----------------------------
-- Table structure for WX_MSG
-- ----------------------------
DROP TABLE IF EXISTS `WX_MSG`;
CREATE TABLE `WX_MSG`  (
   `ID` VARCHAR(32) NOT NULL COMMENT '主键',
   `APPID` char(20) CHARACTER SET utf8 NOT NULL COMMENT 'appid',
   `OPENID` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '微信用户ID',
   `IN_OUT` tinyint(1) UNSIGNED NULL DEFAULT NULL COMMENT '消息方向',
   `MSG_TYPE` char(25) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT '消息类型',
   `DETAIL` json NULL COMMENT '消息详情',
   `CREATE_TIME` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
   PRIMARY KEY (`ID`) USING BTREE,
   INDEX `IDX_APPID`(`APPID`) USING BTREE COMMENT 'APPID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT = '微信消息';

-- ----------------------------
-- Table structure for WX_MSG_REPLY_RULE
-- ----------------------------
DROP TABLE IF EXISTS `WX_MSG_REPLY_RULE`;
CREATE TABLE `WX_MSG_REPLY_RULE`  (
  `RULE_ID` VARCHAR(32) NOT NULL,
  `APPID` char(20) CHARACTER SET utf8 NULL DEFAULT '' COMMENT 'appid',
  `RULE_NAME` varchar(20) CHARACTER SET utf8 NOT NULL COMMENT '规则名称',
  `MATCH_VALUE` varchar(200) CHARACTER SET utf8 NOT NULL COMMENT '匹配的关键词、事件等',
  `EXACT_MATCH` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否精确匹配',
  `REPLY_TYPE` varchar(20) CHARACTER SET utf8 NOT NULL DEFAULT '1' COMMENT '回复消息类型',
  `REPLY_CONTENT` varchar(1024) CHARACTER SET utf8 NOT NULL COMMENT '回复消息内容',
  `STATUS` tinyint(1) NOT NULL DEFAULT 1 COMMENT '规则是否有效',
  `DESC` varchar(255) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT '备注说明',
  `EFFECT_TIME_START` time(0) NULL DEFAULT '00:00:00' COMMENT '生效起始时间',
  `EFFECT_TIME_END` time(0) NULL DEFAULT '23:59:59' COMMENT '生效结束时间',
  `PRIORITY` int(3) UNSIGNED NULL DEFAULT 0 COMMENT '规则优先级',
  `UPDATE_TIME` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`RULE_ID`) USING BTREE,
  INDEX `IDX_APPID`(`APPID`) USING BTREE COMMENT 'APPID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT = '自动回复规则';

-- ----------------------------
-- Table structure for WX_QR_CODE
-- ----------------------------
DROP TABLE IF EXISTS `WX_QR_CODE`;
CREATE TABLE `WX_QR_CODE`  (
   `ID` VARCHAR(32) NOT NULL COMMENT 'ID',
   `APPID` char(20) CHARACTER SET utf8 NOT NULL COMMENT 'appid',
   `IS_TEMP` tinyint(1) NULL DEFAULT NULL COMMENT '是否为临时二维码',
   `SCENE_STR` varchar(64) CHARACTER SET utf8mb4 NULL DEFAULT NULL COMMENT '场景值ID',
   `TICKET` varchar(255) CHARACTER SET utf8mb4 NULL DEFAULT NULL COMMENT '二维码ticket',
   `URL` varchar(255) CHARACTER SET utf8mb4 NULL DEFAULT NULL COMMENT '二维码图片解析后的地址',
   `EXPIRE_TIME` datetime(0) NULL DEFAULT NULL COMMENT '该二维码失效时间',
   `CREATE_TIME` datetime(0) NULL DEFAULT NULL COMMENT '该二维码创建时间',
   PRIMARY KEY (`ID`) USING BTREE,
   INDEX `IDX_APPID`(`APPID`) USING BTREE COMMENT 'APPID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT = '公众号带参二维码';

-- ----------------------------
-- Table structure for WX_TEMPLATE_MSG_LOG
-- ----------------------------
DROP TABLE IF EXISTS `WX_TEMPLATE_MSG_LOG`;
CREATE TABLE `WX_TEMPLATE_MSG_LOG`  (
    `LOG_ID` VARCHAR(32) NOT NULL COMMENT 'ID',
    `APPID` char(20) CHARACTER SET utf8 NOT NULL COMMENT 'appid',
    `TOUSER` varchar(50) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT '用户openid',
    `TEMPLATE_ID` varchar(50) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT 'templateid',
    `DATA` json NULL COMMENT '消息数据',
    `URL` varchar(255) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT '消息链接',
    `MINIPROGRAM` json NULL COMMENT '小程序信息',
    `SEND_TIME` datetime(0) NULL DEFAULT NULL COMMENT '发送时间',
    `SEND_RESULT` varchar(255) CHARACTER SET utf8 NULL DEFAULT NULL COMMENT '发送结果',
    PRIMARY KEY (`LOG_ID`) USING BTREE,
    INDEX `IDX_APPID`(`APPID`) USING BTREE COMMENT 'APPID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT = '微信模版消息发送记录';

-- ----------------------------
-- Records of WX_TEMPLATE_MSG_LOG
-- ----------------------------

-- ----------------------------
-- Table structure for MALL_SHOPS_WITHDRAW
-- ----------------------------
DROP TABLE IF EXISTS `MALL_SHOPS_WITHDRAW`;
CREATE TABLE `MALL_SHOPS_WITHDRAW` (
   `ID` varchar(32) NOT NULL COMMENT '主键',
   `SHOPS_ID` varchar(32) DEFAULT NULL COMMENT '商户Id',
   `USER_ID` varchar(32) DEFAULT '0' COMMENT '用户Id',
   `APPLY_TYPE` tinyint(3) DEFAULT '1' COMMENT '类型 1申请提现',
   `APPLY_TIME` datetime DEFAULT NULL COMMENT '申请时间',
   `APPLY_MONEY` decimal(8,2) DEFAULT NULL COMMENT '申请金额',
   `APPROVER` varchar(32) DEFAULT NULL COMMENT '审核人',
   `APPROVAL_TIME` datetime DEFAULT NULL COMMENT '审核时间',
   `APPROVAL_REMARK` varchar(255) DEFAULT NULL COMMENT '审核备注',
   `APPLY_STATUS` tinyint(2) DEFAULT NULL COMMENT '申请状态 1申请中 2提现成功 3已拒绝  4线下提现成功',
   `COMMISSION` decimal(8,2) DEFAULT '0.00' COMMENT '佣金',
   `WITHDRAW_USER_ID` varchar(64) DEFAULT NULL COMMENT '提现会员Id',
   PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商家提现';

-- ----------------------------
-- Records of MALL_SHOPS_WITHDRAW
-- ----------------------------

-- ----------------------------
-- Table structure for `MALL_SHOPS_WITHDRAW_ORDER`
-- ----------------------------
DROP TABLE IF EXISTS `MALL_SHOPS_WITHDRAW_ORDER`;
CREATE TABLE `MALL_SHOPS_WITHDRAW_ORDER` (
 `ID` varchar(32) NOT NULL COMMENT '主键',
 `WITHDRAW_ID` varchar(32) DEFAULT NULL COMMENT '提现Id',
 `ORDER_ID` varchar(32) DEFAULT NULL COMMENT '用户Id',
 PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商家提现关联订单';

-- ----------------------------
-- Records of MALL_SHOPS_WITHDRAW_ORDER
-- ----------------------------
