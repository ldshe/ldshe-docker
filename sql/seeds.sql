UPDATE `email` SET
    website_name = 'Learning Design Studio HE',
    from_name = 'LDSHE Admin',
    from_email = 'noreply@ldshe.docker',
    verify_url = 'http://ldshe.docker/'
WHERE id = 1;

INSERT INTO `pages` (`page`, `title`, `private`) VALUES ('ldsv2/design.php', 'Learning Design', 1);

INSERT INTO `permission_page_matches`(`permission_id`, `page_id`) SELECT 1, id FROM `pages` WHERE `page` = 'ldsv2/design.php';

INSERT INTO `permissions`(`id`, `name`) VALUES (3, 'Curator');

UPDATE `settings` SET
    recaptcha = '0',
    css_sample = '1',
    us_css1 = '../users/css/color_schemes/standard.css',
    us_css2 = '../users/css/sb-admin.css',
    us_css3 = '../users/css/custom-standard.css',
    site_name = 'Learning Design Studio HE',
    gid = 'Google ID Here',
    gsecret = 'Google Secret Here',
    gredirect = 'http://ldshe.docker/users/oauth_success.php',
    ghome = 'http://ldshe.docker/',
    fbid = 'FB ID Here',
    fbsecret = 'FB Secret Here',
    fbcallback = 'http://ldshe.docker/users/fb-callback.php',
    graph_ver = 'v2.2',
    finalredir = 'account.php',
    req_cap = '1',
    req_num = '1',
    min_pw = '6',
    max_pw = '20',
    min_un = '2',
    max_un = '40',
    messaging = '0',
    navigation_type = '0',
    copyright = 'All rights reserved, CITE, HKU &lt;br/&gt; This project is part of the HKUST MIT Research Alliance Consortium project &quot;An Open Learning Design, Data Analytics &amp; Visualization Framework for E-Learning (ITS/306/15FP)&quot;, funded by the Innovative Technology Fund of the HKSAR.'
WHERE id = 1;

INSERT INTO `user_permission_matches` (`user_id`, `permission_id`) VALUES (1, 3);

update `users` set
    `email` = 'admin@ldshe.docker',
    `password` = '$2y$12$J5.fZdDGmoxP3IJiBl0TOeDmdpjkTEPgl2kltI4HwKoyiCdkNqjPy'
where id = 1;

update `users` set
    `email` = 'user@ldshe.docker',
    `password` = '$2y$12$A8yRqzlBd/IcePoB6XIv8u..bkC0qNTZ3VByZf90GChPj5MytPfSe'
where id = 2;
