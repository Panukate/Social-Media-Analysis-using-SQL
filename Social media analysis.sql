# Project 2- Social Media Analysis

-- Designed and implemented a MySQL-based social media analysis project, 
-- leveraging relational database capabilities to efficiently 
-- store, retrieve, and analyze extensive social media data. 
-- Developed features including user profiles, post storage, s
-- entiment analysis, and trend tracking to provide 
-- aluable insights into user behavior and trending topics. 
-- Demonstrated proficiency in database management for 
-- effective data organization and retrieval, showcasing 
-- a keen understanding of scalable and well-structured MySQL systems

# 8 Feb
use social_media;
select * from post;
select * from users;
select * from login;
select * from comments;

-- ER Entity relationship Diagram
-- database>> reverse engineer
-- data modelling

-- 1) display the location of user
select distinct location from post;
-- location is not mentioned in a proper way

-- 2) total post
select count(*) from post;
-- there are 100 posts are done by users

-- 3)total user
select count(*) from users;
-- total 50 users

-- 4) avg post per user
select distinct user_id from post;
select round(count(*)/count(distinct user_id)) from post;
-- on an avg 2 posts are done by each user

-- 5) displau users who posted 5 or more than 5 post
select user_id,count(post_id) as count_post from post group by user_id having count_post>=5 ;

#By using join
select u1.user_id,username,count(*) as total from post p1
inner join users u1
on p1.user_id=u1.user_id
group by user_id
having total>=5;

-- subquery
select username from users 
where user_id in (select user_id from (select user_id,count(*) 
 as total from post group by user_id having total>=5 ) p1);

with cte AS (SELECT user_id,count(*) AS total 
FROM post
GROUP BY user_id
HAVING total>=5)

SELECT username FROM users WHERE user_id in 
(SELECT user_id FROM cte);

-- total 4 users have posted 5 or more than 5 post

-- 6) the user who have not posted any post
select * from users
where user_id not in (select distinct(user_id) from post);

-- 7) display users with 0 comment
select * from users
where user_id not in (select distinct(user_id) from comments);
-- just one user raj gupta has not commented yet

-- by join
select u1.user_id,username,count(comment_id) as total from users u1
left join comments c1
on u1.user_id=c1.user_id
group by username
having total=0;

-- 8) display users who dont follow anybody
select * from users
where user_id not in (select follower_id from follows);
-- no such user who dont follow anybody

-- 9)most inactive user...in terms of post
select * from users
where user_id not in (select distinct(user_id) from post);

# 12 feb
-- 10) check for bot
-- user who comented every post
use social_media;
select * from post;
select * from comments;

select username,count(*) as num_comment
from users u1
inner join comments c1 on u1.user_id=c1.user_id
group by u1.user_id
having num_comment=(select count(distinct post_id) from comments);

-- 11)users who like every post(BOT)
select username,count(*) as like_post
from users u1
inner join post_likes p1 on u1.user_id=p1.user_id
group by u1.user_id
having like_post=(select count(distinct post_id) from post_likes);

-- 12) display most liked post
select * from post_likes;

with cte1 as
(select post_id,count(*) as countlike from post_likes
group by post_id
order by countlike desc
limit 1)
select post_id,user_id,caption from post 
where post_id=(select post_id from cte1);

-- 13) people who have been using the platform for the longest time
select user_id,username,created_at from users order by created_at limit 5;

-- 14) find longest caption in post
select post_id,user_id, caption,length(caption) as longest_caption from post order by 4 desc limit 1;

-- 15) Find the users who has followers > 40
select followee_id ,count(follower_id) as follower_count
from follows
group by followee_id
having follower_count>40
order by 2 desc;

-- 16)Find most commonly used hashtags
select * from hashtags;
select * from post_tags;

select h1.hashtag_id,hashtag_name,count(*) as counttags
from hashtags h1
inner join post_tags p1 on h1.hashtag_id=p1.hashtag_id
group by h1.hashtag_id
order by 3 desc;
-- #beautiful is the most commonly used hasgtag

-- 17)Find most followed hashtag
select hashtag_id from hashtag_follow order by 1 desc;

select h1.hashtag_id,hashtag_name,count(hashtag_name)
from hashtags h1
inner join hashtag_follow h2 on h1.hashtag_id=h2.hashtag_id
group by  h2.hashtag_id
order by 3 desc;
-- #festivsale is most trending hashtag in data