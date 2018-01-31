set names utf8;

CREATE TABLE `online_ip` (
  `id` bigint(64) unsigned NOT NULL AUTO_INCREMENT,
  `ip` varchar(64) NOT NULL DEFAULT '' COMMENT '用户id',
  `module_id` smallint(4) DEFAULT '0' COMMENT '系统编号id',
  `module_name` varchar(128) NOT NULL DEFAULT '' COMMENT '系统编号名称',
  `env_id` varchar(128) NOT NULL DEFAULT 0 COMMENT '系统编号名称',
  `env_name` varchar(128) NOT NULL DEFAULT '' COMMENT '系统编号名称',
  `status` smallint(4) DEFAULT '1' COMMENT '本条记录状态,1有效,0无效',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_uniq_ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='线上ip查询表';

UNIQUE KEY `idx_uniq_ip_module_id` (`ip`,`module_id`)

# module是模块名，即拥有同一个ip列表的模块
# 比如登陆模块，他可能会涉及一个ip列表，那么就将该模块作为一个id
CREATE TABLE `online_module` (
  `id` bigint(64) unsigned NOT NULL AUTO_INCREMENT,
  `module_id` smallint(4) DEFAULT '0' COMMENT '系统编号id',
  `module_name` varchar(128) NOT NULL DEFAULT '' COMMENT '系统编号名称',
  `status` smallint(4) DEFAULT '1' COMMENT '本条记录状态,1有效,0无效',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='模块名表';


CREATE TABLE `online_env` (
  `id` bigint(64) unsigned NOT NULL AUTO_INCREMENT,
  `env_id` smallint(4) DEFAULT '0' COMMENT '环境标号id',
  `env_name` varchar(128) NOT NULL DEFAULT '' COMMENT 'env编号名称',
  `status` smallint(4) DEFAULT '1' COMMENT '本条记录状态,1有效,0无效',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='模块名表';


# 假设我们总共需要设计管理四个环境的ip：beta、huidu、test、dev
# 此处你可以根据自己要求来决定插入online_env的sql
insert into online_env(env_id, env_name, status) values(1, 'beta', 1);
insert into online_env(env_id, env_name, status) values(2, 'huidu', 1);
insert into online_env(env_id, env_name, status) values(3, 'test', 1);
insert into online_env(env_id, env_name, status) values(4, 'dev', 1);

