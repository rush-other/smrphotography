CREATE TABLE `galleries` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `gallery_name` varchar(255) NOT NULL,
  `context` varchar(255) default NULL,
  `password` varchar(255) default NULL,
  `active` tinyint(1) NOT NULL default '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_galleries_on_gallery_name` (`gallery_name`),
  UNIQUE KEY `index_galleries_on_context` (`context`),
  KEY `index_galleries_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `newsletter_subscribers` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_newsletter_subscribers_on_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `photo_categories` (
  `id` int(11) NOT NULL auto_increment,
  `category` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `active` tinyint(1) NOT NULL default '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_photo_categories_on_name` (`name`),
  KEY `index_photo_categories_on_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `photos` (
  `id` int(11) NOT NULL auto_increment,
  `number` int(11) NOT NULL,
  `orig_file_name` varchar(255) NOT NULL,
  `shoot_id` int(11) NOT NULL,
  `photo` longblob NOT NULL,
  `show_on_home` tinyint(1) NOT NULL default '0',
  `photo_category_id` int(11) default NULL,
  `active` tinyint(1) NOT NULL default '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_photos_on_shoot_id_and_number` (`shoot_id`,`number`),
  KEY `index_photos_on_photo_category_id` (`photo_category_id`),
  KEY `index_photos_on_show_on_home` (`show_on_home`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_roles_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `shoots` (
  `id` int(11) NOT NULL auto_increment,
  `gallery_id` int(11) NOT NULL,
  `shoot_name` varchar(255) NOT NULL,
  `active` tinyint(1) NOT NULL default '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_shoots_on_gallery_id_and_shoot_name` (`gallery_id`,`shoot_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) default NULL,
  `role_id` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL default '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_users_on_username` (`username`),
  KEY `index_users_on_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_info (version) VALUES (7)