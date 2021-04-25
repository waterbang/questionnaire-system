-- -------------------------------------------------------------
-- TablePlus 3.9.1(342)
--
-- https://tableplus.com/
--
-- Database: questionnaire
-- Generation Time: 2020-11-02 16:33:50.6890
-- -------------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE TABLE `book` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL,
  `author` varchar(30) DEFAULT NULL,
  `summary` varchar(1000) DEFAULT NULL,
  `image` varchar(100) DEFAULT NULL,
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `delete_time` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `fill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL COMMENT '问卷id',
  `detail` json NOT NULL COMMENT '收集的详情',
  `quiz_time` int(11) NOT NULL COMMENT '答题时间（秒）',
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `delete_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fill_del` (`survey_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

CREATE TABLE `fill-rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL COMMENT '问卷id',
  `ip` varchar(30) DEFAULT '0' COMMENT '限制每个ip可以填几次',
  `username` varchar(20) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `delete_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fill_rule_del` (`survey_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

CREATE TABLE `lin_file` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `path` varchar(500) NOT NULL,
  `type` varchar(10) NOT NULL DEFAULT 'LOCAL' COMMENT 'LOCAL 本地，REMOTE 远程',
  `name` varchar(100) NOT NULL,
  `extension` varchar(50) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `md5` varchar(40) DEFAULT NULL COMMENT 'md5值，防止上传重复文件',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `delete_time` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `md5_del` (`md5`,`delete_time`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `lin_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL COMMENT '分组名称，例如：搬砖者',
  `info` varchar(255) DEFAULT NULL COMMENT '分组信息：例如：搬砖的人',
  `level` tinyint(2) NOT NULL DEFAULT '3' COMMENT '分组级别 1：root 2：guest 3：user（root、guest分组只能存在一个)',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `delete_time` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_del` (`name`,`delete_time`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `lin_group_permission` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(10) unsigned NOT NULL COMMENT '分组id',
  `permission_id` int(10) unsigned NOT NULL COMMENT '权限id',
  PRIMARY KEY (`id`),
  KEY `group_id_permission_id` (`group_id`,`permission_id`) USING BTREE COMMENT '联合索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `lin_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `message` varchar(450) DEFAULT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `username` varchar(24) DEFAULT NULL,
  `status_code` int(11) DEFAULT NULL,
  `method` varchar(20) DEFAULT NULL,
  `path` varchar(50) DEFAULT NULL,
  `permission` varchar(100) DEFAULT NULL,
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `delete_time` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `lin_permission` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL COMMENT '权限名称，例如：访问首页',
  `module` varchar(50) NOT NULL COMMENT '权限所属模块，例如：人员管理',
  `mount` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0：关闭 1：开启',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `delete_time` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `lin_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(24) NOT NULL COMMENT '用户名，唯一',
  `nickname` varchar(24) DEFAULT NULL COMMENT '用户昵称',
  `avatar` varchar(500) DEFAULT NULL COMMENT '头像url',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `delete_time` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_del` (`username`,`delete_time`),
  UNIQUE KEY `email_del` (`email`,`delete_time`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `lin_user_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL COMMENT '用户id',
  `group_id` int(10) unsigned NOT NULL COMMENT '分组id',
  PRIMARY KEY (`id`),
  KEY `user_id_group_id` (`user_id`,`group_id`) USING BTREE COMMENT '联合索引'
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `lin_user_identity` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL COMMENT '用户id',
  `identity_type` varchar(100) NOT NULL,
  `identifier` varchar(100) DEFAULT NULL,
  `credential` varchar(100) DEFAULT NULL,
  `create_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `update_time` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `delete_time` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) DEFAULT NULL COMMENT '问卷id',
  `is_copy` tinyint(1) DEFAULT '0' COMMENT '是否可以复制',
  `is_login` tinyint(1) DEFAULT '0' COMMENT '是否需要登录',
  `limit_ip` int(11) DEFAULT '0' COMMENT '限制每个ip可以填几次',
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `delete_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;

CREATE TABLE `survey` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` int(11) DEFAULT '1',
  `header_desc` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `footer_desc` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `detail` json NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `delete_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `book` (`id`, `title`, `author`, `summary`, `image`, `create_time`, `update_time`, `delete_time`) VALUES
('1', '朝花夕拾', '鲁迅', '鲁迅著作', 'https://localhost:5000/img/user-bg.2f78c271.png', '2020-10-09 12:23:56.000', '2020-10-09 12:23:56.000', NULL);

INSERT INTO `fill` (`id`, `survey_id`, `detail`, `quiz_time`, `create_time`, `update_time`, `delete_time`) VALUES
('1', '5', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": \"辣hei\"}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": \"一丢丢\"}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": \"肯德基\"}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"果汁\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\"]}], \"main_title\": \"菜单统计\"}]', '10', '2020-10-27 10:35:09', '2020-10-27 10:35:09', NULL),
('2', '5', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": \"辣hei\"}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": \"一丢丢\"}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": \"肯德基\"}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\"]}], \"main_title\": \"菜单统计\"}]', '11', '2020-10-27 10:37:05', '2020-10-27 10:37:05', NULL),
('3', '5', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": \"吃辣人莫得☠️\"}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": \"二丢丢\"}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": \"好味道\"}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"果汁\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\"]}], \"main_title\": \"菜单统计\"}]', '11', '2020-10-27 10:37:20', '2020-10-27 10:37:20', NULL),
('4', '5', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": \"辣hei\"}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": \"一丢丢\"}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": \"其他\"}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '17', '2020-10-27 10:37:42', '2020-10-27 10:37:42', NULL),
('5', '8', '[{\"type\": \"SingleChoice\", \"title\": \"你的性别\", \"choice_list\": \"男\"}, {\"type\": \"MultipleChoice\", \"title\": \"喝什么饮料\", \"choice_list\": [\"可乐\"]}, {\"type\": \"GapFilling\", \"title\": \"有什么忌口？\", \"fillGap\": \"没有忌口\"}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"餐位分配\", \"choice_list\": \"自由分配\"}, {\"type\": \"MultipleChoice\", \"title\": \"你吃不吃?️啊\", \"choice_list\": [\"吃\", \"不吃\"]}], \"main_title\": \"就餐规划\"}]', '16', '2020-10-29 09:58:23', '2020-10-29 09:58:23', NULL),
('6', '8', '[{\"type\": \"SingleChoice\", \"title\": \"你的性别\", \"choice_list\": \"男\"}, {\"type\": \"MultipleChoice\", \"title\": \"喝什么饮料\", \"elseCont\": \"白开水\", \"choice_list\": [\"可乐\", \"其他\"]}, {\"type\": \"GapFilling\", \"title\": \"有什么忌口？\", \"fillGap\": \"不吃辣椒\"}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"餐位分配\", \"choice_list\": \"自由分配\"}, {\"type\": \"MultipleChoice\", \"title\": \"你吃不吃?️啊\", \"choice_list\": [\"吃\"]}], \"main_title\": \"就餐规划\"}]', '22', '2020-10-29 09:58:53', '2020-10-29 09:58:53', NULL),
('7', '8', '[{\"type\": \"SingleChoice\", \"title\": \"你的性别\", \"choice_list\": \"女\"}, {\"type\": \"MultipleChoice\", \"title\": \"喝什么饮料\", \"choice_list\": [\"芬达\"]}, {\"type\": \"GapFilling\", \"title\": \"有什么忌口？\", \"fillGap\": \"不吃胡萝北\"}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"餐位分配\", \"choice_list\": \"公司分配\"}, {\"type\": \"MultipleChoice\", \"title\": \"你吃不吃?️啊\", \"choice_list\": [\"不吃\", \"吃\", \"还行\"]}], \"main_title\": \"就餐规划\"}]', '19', '2020-10-29 09:59:16', '2020-10-29 09:59:16', NULL),
('8', '8', '[{\"type\": \"SingleChoice\", \"title\": \"你的性别\", \"choice_list\": \"男\"}, {\"type\": \"MultipleChoice\", \"title\": \"喝什么饮料\", \"choice_list\": [\"芬达\"]}, {\"type\": \"GapFilling\", \"title\": \"有什么忌口？\", \"fillGap\": \"不吃?\"}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"餐位分配\", \"choice_list\": \"自由分配\"}, {\"type\": \"MultipleChoice\", \"title\": \"你吃不吃?️啊\", \"choice_list\": [\"吃\"]}], \"main_title\": \"就餐规划\"}]', '15', '2020-10-29 09:59:34', '2020-10-29 09:59:34', NULL),
('9', '22', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": \"辣hei\"}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": \"一丢丢\"}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": \"烧烤\"}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\"]}], \"main_title\": \"菜单统计\"}, {\"type\": \"MultipleChoice\", \"title\": \"请从下面选择多个选项\", \"choice_list\": [\"选项一\"]}, {\"type\": \"MultipleChoice\", \"title\": \"请从下面选择多个选项\", \"choice_list\": [\"选项二\"]}, {\"type\": \"GapFilling\", \"title\": \"我是填空题\", \"fillGap\": \"11\"}]', '13', '2020-11-02 15:27:43', '2020-11-02 15:27:43', NULL);

INSERT INTO `fill-rule` (`id`, `survey_id`, `ip`, `username`, `create_time`, `update_time`, `delete_time`) VALUES
('13', '5', '::1', 'root', '2020-10-27 10:35:09', '2020-10-27 10:35:09', NULL),
('14', '5', '::1', 'root', '2020-10-27 10:37:05', '2020-10-27 10:37:05', NULL),
('15', '5', '::1', 'root', '2020-10-27 10:37:20', '2020-10-27 10:37:20', NULL),
('16', '5', '::1', 'root', '2020-10-27 10:37:42', '2020-10-27 10:37:42', NULL),
('17', '8', '::1', 'root', '2020-10-29 09:58:23', '2020-10-29 09:58:23', NULL),
('18', '8', '::1', 'root', '2020-10-29 09:58:53', '2020-10-29 09:58:53', NULL),
('19', '8', '::1', 'root', '2020-10-29 09:59:16', '2020-10-29 09:59:16', NULL),
('20', '8', '::1', 'root', '2020-10-29 09:59:34', '2020-10-29 09:59:34', NULL),
('21', '22', '::1', NULL, '2020-11-02 15:27:43', '2020-11-02 15:27:43', NULL);

INSERT INTO `lin_file` (`id`, `path`, `type`, `name`, `extension`, `size`, `md5`, `create_time`, `update_time`, `delete_time`) VALUES
('1', '2020/10/02/89b1ce85-29a0-4691-977a-f0de1ae53d6a.jpg', 'LOCAL', '89b1ce85-29a0-4691-977a-f0de1ae53d6a.jpg', '.jpg', '3472', '623c50aa557e8ad6653e3d15c47eb0c6', '2020-10-02 21:34:14.000', '2020-10-02 21:34:14.000', NULL),
('2', '2020/10/02/dffb4a46-1973-4c87-ba55-4a132dd435d8.jpg', 'LOCAL', 'dffb4a46-1973-4c87-ba55-4a132dd435d8.jpg', '.jpg', '2926', '5ec61088f1d4d2b83cc088058c7346ed', '2020-10-02 21:34:59.000', '2020-10-02 21:34:59.000', NULL),
('3', '2020/10/09/4fd3b02e-2035-4775-94a8-149db720bdd4.jpg', 'LOCAL', '4fd3b02e-2035-4775-94a8-149db720bdd4.jpg', '.jpg', '3897', '4151ff0ea2cde51c22198b0ccd3bafe5', '2020-10-09 14:57:09.000', '2020-10-09 14:57:09.000', NULL),
('4', '2020/10/25/57f250e2-8a09-495e-b7e1-60a422d235f7.jpg', 'LOCAL', '57f250e2-8a09-495e-b7e1-60a422d235f7.jpg', '.jpg', '6632', '3ea71ec5322338db5d0e2ee26daa4788', '2020-10-25 16:46:46.000', '2020-10-25 16:46:46.000', NULL);

INSERT INTO `lin_group` (`id`, `name`, `info`, `level`, `create_time`, `update_time`, `delete_time`) VALUES
('1', 'root', '超级用户组', '1', '2020-10-01 14:24:06.780', '2020-10-01 14:24:06.780', NULL),
('2', 'guest', '游客组', '2', '2020-10-01 14:24:06.780', '2020-10-01 14:24:06.780', NULL);

INSERT INTO `lin_log` (`id`, `message`, `user_id`, `username`, `status_code`, `method`, `path`, `permission`, `create_time`, `update_time`, `delete_time`) VALUES
('29', 'root 发布了id为  的问卷', '1', 'root', '201', 'PUT', '/v1/survey/update/status/8', '发布问卷', '2020-10-15 17:32:02.000', '2020-10-15 17:32:02.000', NULL),
('30', 'root 发布了id为  的问卷', '1', 'root', '201', 'PUT', '/v1/survey/update/status/7', '发布问卷', '2020-10-15 17:33:47.000', '2020-10-15 17:33:47.000', NULL),
('31', 'root 发布了id为  的问卷', '1', 'root', '201', 'PUT', '/v1/survey/update/status/6', '发布问卷', '2020-10-15 17:36:15.000', '2020-10-15 17:36:15.000', NULL),
('32', 'root 发布了id为  的问卷', '1', 'root', '201', 'PUT', '/v1/survey/update/status/5', '发布问卷', '2020-10-15 17:47:22.000', '2020-10-15 17:47:22.000', NULL),
('33', 'root 发布了id为  的问卷', '1', 'root', '201', 'PUT', '/v1/survey/update/status/4', '发布问卷', '2020-10-15 17:48:53.000', '2020-10-15 17:48:53.000', NULL),
('34', 'root 发布了id为 3 的问卷', '1', 'root', '201', 'PUT', '/v1/survey/update/status/3', '发布问卷', '2020-10-15 17:51:09.000', '2020-10-15 17:51:09.000', NULL),
('35', 'root删除了id为  的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/4', '删除问卷', '2020-10-16 11:20:08.000', '2020-10-16 11:20:08.000', NULL),
('36', 'root删除了id为  的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/3', '删除问卷', '2020-10-16 11:23:10.000', '2020-10-16 11:23:10.000', NULL),
('37', 'root删除了id为  的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/8', '删除问卷', '2020-10-16 11:24:50.000', '2020-10-16 11:24:50.000', NULL),
('38', 'root删除了id为 /v1/survey/6 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/6', '删除问卷', '2020-10-16 11:25:34.000', '2020-10-16 11:25:34.000', NULL),
('39', 'root 发布了id为 3 的问卷', '1', 'root', '201', 'PUT', '/v1/survey/update/status/3', '发布问卷', '2020-10-19 09:09:19.000', '2020-10-19 09:09:19.000', NULL),
('40', 'root删除了id为 /v1/survey/1 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/1', '删除问卷', '2020-10-19 09:27:43.000', '2020-10-19 09:27:43.000', NULL),
('41', 'root删除了id为 /v1/survey/1 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/1', '删除问卷', '2020-10-19 09:36:51.000', '2020-10-19 09:36:51.000', NULL),
('42', 'root删除了id为 /v1/survey/7 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/7', '删除问卷', '2020-10-19 09:48:44.000', '2020-10-19 09:48:44.000', NULL),
('43', 'root 发布了id为 3 的问卷', '1', 'root', '201', 'PUT', '/v1/survey/update/status/3', '发布问卷', '2020-10-21 22:42:04.000', '2020-10-21 22:42:04.000', NULL),
('44', 'root 发布了id为 4 的问卷', '1', 'root', '201', 'PUT', '/v1/survey/update/status/4', '发布问卷', '2020-10-22 15:18:46.000', '2020-10-22 15:18:46.000', NULL),
('45', 'root 发布了id为 5 的问卷', '1', 'root', '201', 'PUT', '/v1/survey/update/status/5', '发布问卷', '2020-10-22 15:22:02.000', '2020-10-22 15:22:02.000', NULL),
('46', 'root 发布了id为 7 的问卷', '1', 'root', '201', 'PUT', '/v1/survey/update/status/7', '发布问卷', '2020-10-24 14:39:56.000', '2020-10-24 14:39:56.000', NULL),
('47', 'root删除了id为 /v1/survey/9 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/9', '删除问卷', '2020-10-24 15:16:52.000', '2020-10-24 15:16:52.000', NULL),
('48', 'root删除了id为 /v1/survey/6 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/6', '删除问卷', '2020-10-24 15:17:06.000', '2020-10-24 15:17:06.000', NULL),
('49', 'root删除了id为 /v1/survey/7 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/7', '删除问卷', '2020-10-24 15:17:17.000', '2020-10-24 15:17:17.000', NULL),
('50', 'root删除了id为 /v1/survey/13 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/13', '删除问卷', '2020-10-24 15:22:57.000', '2020-10-24 15:22:57.000', NULL),
('51', 'root删除了id为 /v1/survey/12 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/12', '删除问卷', '2020-10-24 15:22:59.000', '2020-10-24 15:22:59.000', NULL),
('52', 'root删除了id为 /v1/survey/11 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/11', '删除问卷', '2020-10-24 15:23:04.000', '2020-10-24 15:23:04.000', NULL),
('53', 'root删除了id为 /v1/survey/10 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/10', '删除问卷', '2020-10-24 15:23:07.000', '2020-10-24 15:23:07.000', NULL),
('54', 'root删除了id为 /v1/survey/15 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/15', '删除问卷', '2020-10-25 13:44:36.000', '2020-10-25 13:44:36.000', NULL),
('55', 'root删除了id为 /v1/survey/17 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/17', '删除问卷', '2020-10-25 13:44:46.000', '2020-10-25 13:44:46.000', NULL),
('56', 'root删除了id为 /v1/survey/16 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/16', '删除问卷', '2020-10-25 13:44:48.000', '2020-10-25 13:44:48.000', NULL),
('57', 'root删除了id为 /v1/survey/14 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/14', '删除问卷', '2020-10-25 13:44:53.000', '2020-10-25 13:44:53.000', NULL),
('58', 'root删除了id为 /v1/survey/2 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/2', '删除问卷', '2020-10-25 13:45:16.000', '2020-10-25 13:45:16.000', NULL),
('59', 'root删除了id为 /v1/survey/20 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/20', '删除问卷', '2020-10-25 17:04:35.000', '2020-10-25 17:04:35.000', NULL),
('60', 'root删除了id为 /v1/survey/18 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/18', '删除问卷', '2020-10-25 17:04:38.000', '2020-10-25 17:04:38.000', NULL),
('61', 'root删除了id为 /v1/survey/19 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/19', '删除问卷', '2020-10-25 17:04:43.000', '2020-10-25 17:04:43.000', NULL),
('62', 'root删除了id为 /v1/survey/21 的问卷', '1', 'root', '201', 'DELETE', '/v1/survey/21', '删除问卷', '2020-10-25 17:10:22.000', '2020-10-25 17:10:22.000', NULL),
('63', 'root 发布了id为 8 的问卷', '1', 'root', '201', 'PUT', '/v1/survey/update/status/8', '发布问卷', '2020-10-29 09:58:06.000', '2020-10-29 09:58:06.000', NULL),
('64', 'root 发布了id为 22 的问卷', '1', 'root', '201', 'PUT', '/v1/survey/update/status/22', '发布问卷', '2020-11-02 15:11:35.000', '2020-11-02 15:11:35.000', NULL);

INSERT INTO `lin_permission` (`id`, `name`, `module`, `mount`, `create_time`, `update_time`, `delete_time`) VALUES
('1', '查询所有日志', '日志', '1', '2020-10-02 18:29:05.000', '2020-10-02 18:29:05.000', NULL),
('2', '搜索日志', '日志', '1', '2020-10-02 18:29:05.000', '2020-10-02 18:29:05.000', NULL),
('3', '查询日志记录的用户', '日志', '1', '2020-10-02 18:29:05.000', '2020-10-02 18:29:05.000', NULL),
('4', '测试日志记录', '信息', '1', '2020-10-02 18:29:05.000', '2020-10-02 18:29:05.000', NULL),
('5', '查看lin的信息', '信息', '1', '2020-10-02 18:29:05.000', '2020-10-02 18:29:05.000', NULL),
('6', '删除图书', '图书', '1', '2020-10-02 18:29:05.000', '2020-10-06 13:19:13.000', NULL),
('7', '删除问卷', '问卷', '1', '2020-10-05 13:05:47.000', '2020-10-05 13:05:47.000', NULL),
('8', '查询日志记录的用户', '问卷', '0', '2020-10-06 14:09:38.000', '2020-10-06 14:09:48.000', NULL),
('9', '搜索日志', '问卷', '0', '2020-10-06 14:18:51.000', '2020-10-06 14:21:09.000', NULL),
('10', '发布问卷', '问卷', '1', '2020-10-06 17:12:03.000', '2020-10-06 17:12:03.000', NULL),
('11', '查看问卷统计信息', '问卷', '1', '2020-10-26 10:50:21.000', '2020-10-26 10:50:21.000', NULL),
('12', '查看数据分析', '问卷', '1', '2020-11-02 15:58:20.000', '2020-11-02 15:58:20.000', NULL);

INSERT INTO `lin_user` (`id`, `username`, `nickname`, `avatar`, `email`, `create_time`, `update_time`, `delete_time`) VALUES
('1', 'root', 'root', '2020/10/09/4fd3b02e-2035-4775-94a8-149db720bdd4.jpg', NULL, '2020-10-01 14:24:06.779', '2020-10-09 14:57:09.000', NULL),
('2', 'survey', NULL, '2020/10/25/57f250e2-8a09-495e-b7e1-60a422d235f7.jpg', 'water_bang@163.com', '2020-10-09 12:26:50.000', '2020-10-25 16:46:46.000', NULL);

INSERT INTO `lin_user_group` (`id`, `user_id`, `group_id`) VALUES
('1', '1', '1'),
('3', '2', '2');

INSERT INTO `lin_user_identity` (`id`, `user_id`, `identity_type`, `identifier`, `credential`, `create_time`, `update_time`, `delete_time`) VALUES
('1', '1', 'USERNAME_PASSWORD', 'root', 'sha1$2e4dc4e6$1$21d3d2315989107ea42458be2ddc099b03fe78f7', '2020-10-01 14:24:06.779', '2020-10-21 22:01:31.000', NULL),
('2', '2', 'USERNAME_PASSWORD', 'survey', 'sha1$06ff1e13$1$16703fcb4cbe3b4965665536552ef0f17f6cc917', '2020-10-09 12:26:50.000', '2020-10-25 16:42:13.000', NULL);

INSERT INTO `rule` (`id`, `survey_id`, `is_copy`, `is_login`, `limit_ip`, `create_time`, `update_time`, `delete_time`) VALUES
('1', '1', '1', '0', '1', '2020-10-21 22:35:45', '2020-10-21 22:35:45', NULL),
('2', '2', '1', '0', '1', '2020-10-21 22:36:36', '2020-10-21 22:36:36', '2020-10-25 13:45:16'),
('3', '3', '1', '0', '1', '2020-10-21 22:36:59', '2020-10-21 22:36:59', NULL),
('4', '4', '0', '0', '0', '2020-10-22 15:18:33', '2020-10-22 15:18:33', NULL),
('5', '5', '1', '1', '10', '2020-10-22 15:21:53', '2020-10-22 15:21:53', NULL),
('6', '6', '0', '0', '0', '2020-10-23 17:49:35', '2020-10-23 17:49:35', '2020-10-24 15:17:06'),
('7', '7', '0', '0', '0', '2020-10-24 14:39:48', '2020-10-24 14:39:48', '2020-10-24 15:17:16'),
('8', '8', '0', '1', '5', '2020-10-24 15:14:46', '2020-10-25 17:23:36', NULL),
('9', '9', '0', '0', '0', '2020-10-24 15:15:17', '2020-10-24 15:15:17', '2020-10-24 15:16:52'),
('10', '10', '1', '1', '5', '2020-10-24 15:18:29', '2020-10-24 15:18:29', '2020-10-24 15:23:07'),
('11', '11', '1', '1', '5', '2020-10-24 15:18:54', '2020-10-24 15:18:54', '2020-10-24 15:23:04'),
('12', '12', '1', '1', '5', '2020-10-24 15:20:51', '2020-10-24 15:20:51', '2020-10-24 15:22:59'),
('13', '13', '1', '1', '5', '2020-10-24 15:22:53', '2020-10-24 15:22:53', '2020-10-24 15:22:57'),
('14', '14', '1', '1', '5', '2020-10-24 15:23:54', '2020-10-24 15:23:54', '2020-10-25 13:44:53'),
('15', '15', '1', '1', '5', '2020-10-25 13:40:53', '2020-10-25 13:40:53', '2020-10-25 13:44:36'),
('16', '16', '1', '0', '1', '2020-10-25 13:41:20', '2020-10-25 13:41:20', '2020-10-25 13:44:48'),
('17', '17', '1', '0', '1', '2020-10-25 13:43:07', '2020-10-25 13:43:07', '2020-10-25 13:44:46'),
('18', '18', '1', '1', '5', '2020-10-25 13:45:25', '2020-10-25 13:45:25', '2020-10-25 17:04:38'),
('19', '19', '0', '0', '0', '2020-10-25 16:57:56', '2020-10-25 16:57:56', '2020-10-25 17:04:43'),
('20', '20', '0', '0', '0', '2020-10-25 17:02:31', '2020-10-25 17:02:31', '2020-10-25 17:04:35'),
('21', '21', '0', '0', '0', '2020-10-25 17:05:10', '2020-10-25 17:05:10', '2020-10-25 17:10:22'),
('22', '22', '0', '0', '1', '2020-11-02 15:11:14', '2020-11-02 15:11:14', NULL);

INSERT INTO `survey` (`id`, `title`, `status`, `header_desc`, `footer_desc`, `detail`, `create_time`, `update_time`, `delete_time`) VALUES
('1', '晚上吃大餐啊?', '1', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-21 22:35:45', '2020-10-21 22:35:45', NULL),
('2', '晚上吃大餐?', '1', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-21 22:36:36', '2020-10-21 22:36:36', '2020-10-25 13:45:16'),
('3', '中午吃大餐?', '2', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-21 22:36:59', '2020-10-21 22:42:04', NULL),
('4', '芜湖起飞', '2', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-22 15:18:33', '2020-10-22 15:18:46', NULL),
('5', '芜湖第二次起飞?️', '2', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-22 15:21:53', '2020-10-22 15:22:02', NULL),
('6', '晚上吃大餐?', '1', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"maxChoice\": 3, \"minChoice\": 1, \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"maxChoice\": 4, \"minChoice\": 2, \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-23 17:49:35', '2020-10-23 17:49:35', '2020-10-24 15:17:06'),
('7', '这里是默认的问卷标题', '2', '这里是问卷描述', '您已完成本次问卷，感谢您的帮助与支持', '[{\"type\": \"SingleChoice\", \"title\": \"请从下面选择一个选项\", \"choice_list\": [\"选项一\", \"选项二\"]}, {\"type\": \"MultipleChoice\", \"title\": \"请从下面选择多个选项\", \"maxChoice\": 3, \"minChoice\": 2, \"choice_list\": [\"选项一\", \"选项二\", \"嘿嘿\"]}]', '2020-10-24 14:39:48', '2020-10-24 14:39:56', '2020-10-24 15:17:16'),
('8', '今天晚上吃肯得接', '2', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的性别\", \"choice_list\": [\"男\", \"女\"]}, {\"type\": \"MultipleChoice\", \"title\": \"喝什么饮料\", \"choice_list\": [\"可乐\", \"芬达\", \"雪碧\", \"其他\"]}, {\"type\": \"GapFilling\", \"title\": \"有什么忌口？\", \"fillGap\": \"\"}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"餐位分配\", \"choice_list\": [\"自由分配\", \"公司分配\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你吃不吃?️啊\", \"choice_list\": [\"吃\", \"不吃\", \"还行\"]}], \"main_title\": \"就餐规划\"}]', '2020-10-24 15:14:46', '2020-10-29 09:58:06', NULL),
('9', '复制测试', '1', '这里是问卷描述', '您已完成本次问卷，感谢您的帮助与支持', '[{\"type\": \"SingleChoice\", \"title\": \"请从下面选择一个选项\", \"choice_list\": [\"选项一\", \"选项二\"]}, {\"type\": \"MultipleChoice\", \"title\": \"请从下面选择多个选项\", \"minChoice\": 1, \"choice_list\": [\"选项一\", \"选项二\"]}]', '2020-10-24 15:15:17', '2020-10-24 15:15:17', '2020-10-24 15:16:52'),
('10', '芜湖第二次起飞?️(副本)', '1', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-24 15:18:29', '2020-10-24 15:18:29', '2020-10-24 15:23:07'),
('11', '芜湖第二次起飞?️(副本)(副本)', '1', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-24 15:18:54', '2020-10-24 15:18:54', '2020-10-24 15:23:04'),
('12', '芜湖第二次起飞?️(副本)(副本)(副本)', '1', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-24 15:20:51', '2020-10-24 15:20:51', '2020-10-24 15:22:59'),
('13', '芜湖第二次起飞?️(副本)(副本)(副本)(副本)', '1', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-24 15:22:53', '2020-10-24 15:22:53', '2020-10-24 15:22:57'),
('14', '芜湖第二次起飞?️(副本)', '1', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-24 15:23:54', '2020-10-24 15:23:54', '2020-10-25 13:44:53'),
('15', '芜湖第二次起飞?️(副本)(副本)', '1', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-25 13:40:53', '2020-10-25 13:40:53', '2020-10-25 13:44:36'),
('16', '中午吃大餐?(副本)', '1', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-25 13:41:20', '2020-10-25 13:41:20', '2020-10-25 13:44:48'),
('17', '晚上吃大餐?(副本)', '1', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-25 13:43:07', '2020-10-25 13:43:07', '2020-10-25 13:44:46'),
('18', '芜湖第二次起飞?️(副本)', '1', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-25 13:45:25', '2020-10-25 13:45:25', '2020-10-25 17:04:38'),
('19', '芜湖第二次起飞?️(副本)', '1', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-25 16:57:56', '2020-10-25 16:57:56', '2020-10-25 17:04:43'),
('20', '芜湖第二次起飞?️(副本)', '1', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-25 17:02:31', '2020-10-25 17:02:31', '2020-10-25 17:04:35'),
('21', '晚上吃大餐?', '1', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"maxChoice\": 3, \"minChoice\": 1, \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"maxChoice\": 4, \"minChoice\": 2, \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}]', '2020-10-25 17:05:09', '2020-10-25 17:05:09', '2020-10-25 17:10:22'),
('22', '芜湖第二次起飞?️(副本)', '2', '快来提提意见吧！', '感谢提意见~', '[{\"type\": \"SingleChoice\", \"title\": \"你的口味\", \"choice_list\": [\"辣hei\", \"微辣\", \"吃辣人莫得☠️\"]}, {\"type\": \"SingleChoice\", \"title\": \"你的饭量\", \"choice_list\": [\"一丢丢\", \"二丢丢\", \"三碗不过岗\"]}, {\"type\": \"SubQuestions\", \"vice\": [{\"type\": \"SingleChoice\", \"title\": \"聚餐地点\", \"choice_list\": [\"肯德基\", \"烧烤\", \"好味道\", \"其他\"]}, {\"type\": \"MultipleChoice\", \"title\": \"你的爱好\", \"choice_list\": [\"啤酒\", \"果汁\", \"白开水\"]}, {\"type\": \"MultipleChoice\", \"title\": \"选择套餐\", \"choice_list\": [\"水煮白菜\", \"新疆?肉\", \"白灼虾\", \"拔丝芋头\"]}], \"main_title\": \"菜单统计\"}, {\"type\": \"MultipleChoice\", \"title\": \"请从下面选择多个选项\", \"choice_list\": [\"选项一\", \"选项二\"]}, {\"type\": \"MultipleChoice\", \"title\": \"请从下面选择多个选项\", \"choice_list\": [\"选项一\", \"选项二\"]}, {\"type\": \"GapFilling\", \"title\": \"我是填空题\", \"fillGap\": \"\"}]', '2020-11-02 15:11:14', '2020-11-02 15:11:35', NULL);



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;