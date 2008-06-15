CREATE TABLE `bulletin_board_access_conditions` (
  `id` int(11) NOT NULL auto_increment,
  `bulletin_board_id` int(11) NOT NULL,
  `conditions` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `lock_version` int(11) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `bulletin_board_attachments` (
  `id` int(11) NOT NULL auto_increment,
  `bulletin_board_id` int(11) NOT NULL,
  `name` varchar(255) default NULL,
  `host` varchar(255) default NULL,
  `path` varchar(255) default NULL,
  `file_name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `lock_version` int(11) default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `bba_uniq` (`bulletin_board_id`,`file_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `bulletin_boards` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL,
  `comment` varchar(255) default NULL,
  `sort_order` int(11) default '0',
  `enable` tinyint(1) default '1',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `lock_version` int(11) default '0',
  PRIMARY KEY  (`id`),
  KEY `bb_sort` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `calendars` (
  `id` int(11) NOT NULL auto_increment,
  `date` date NOT NULL,
  `unit` int(11) NOT NULL,
  `start_at` time default NULL,
  `end_at` time default NULL,
  `term` int(11) default NULL,
  `reservation_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `room_id` int(11) NOT NULL,
  `lock_version` int(11) default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `room_date_unit` (`room_id`,`date`,`unit`),
  KEY `index_calendars_on_date_and_unit` (`date`,`unit`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8;

CREATE TABLE `plugin_schema_info` (
  `plugin_name` varchar(255) default NULL,
  `version` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `privileges` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `sort_order` int(11) NOT NULL default '0',
  `controller` varchar(255) default NULL,
  `action` varchar(255) default NULL,
  `node_type` varchar(255) default NULL,
  `parent_id` int(11) default NULL,
  `lock_version` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1016 DEFAULT CHARSET=utf8;

CREATE TABLE `privileges_roles` (
  `privilege_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  UNIQUE KEY `pk_privileges_roles` (`privilege_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `reservations` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `user_id` int(11) NOT NULL,
  `room_id` int(11) default NULL,
  `date` date NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `lock_version` int(11) default '0',
  `use_tel_meeting` tinyint(1) NOT NULL default '0',
  `have_a_visitor` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `lock_version` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8;

CREATE TABLE `rooms` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `capacity` int(11) default '0',
  `tel` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `time_table` (
  `id` int(11) NOT NULL auto_increment,
  `start_at` datetime default NULL,
  `end_at` datetime default NULL,
  `order` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login_id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `password_hash` varchar(255) default NULL,
  `password_salt` varchar(255) default NULL,
  `last_login_at` datetime default NULL,
  `admin` tinyint(1) default '0',
  `enable` tinyint(1) default '1',
  `password_term_valid` date default '2007-10-10',
  `password_issued` tinyint(1) default '0',
  `password_faults` int(11) default '0',
  `role_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8;

INSERT INTO schema_info (version) VALUES (15)