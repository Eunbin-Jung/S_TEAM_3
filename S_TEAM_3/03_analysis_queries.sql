-- ============================================================
-- OTT platform analysis queries
-- Role: 3. SQL analysis query writer
-- ============================================================

-- 1. Top 5 most watched contents
select
    c.title as content_title,
    c.genre,
    c.content_type,
    count(v.history_id) as view_count
from viewing_history v
join contents c on v.content_id = c.content_id
group by c.title, c.genre, c.content_type
order by view_count desc
limit 5;


-- 2. Average watch time by subscription plan
select
    p.plan_name,
    count(distinct u.user_id) as user_count,
    round(avg(v.watched_time), 2) as avg_watched_time
from viewing_history v
join users u on v.user_id = u.user_id
join plans p on u.plan_id = p.plan_id
group by p.plan_name
order by avg_watched_time desc;


-- 3. Preferred genre by age group
select
    case
        when u.age between 10 and 19 then '10s'
        when u.age between 20 and 29 then '20s'
        when u.age between 30 and 39 then '30s'
        when u.age between 40 and 49 then '40s'
        else '50s+'
    end as age_group,
    c.genre,
    count(v.history_id) as watch_count
from viewing_history v
join users u on v.user_id = u.user_id
join contents c on v.content_id = c.content_id
group by age_group, c.genre
order by age_group, watch_count desc;


-- 4. Average review score by genre
select
    c.genre,
    count(r.review_id) as review_count,
    round(avg(r.score), 2) as avg_score
from reviews r
join contents c on r.content_id = c.content_id
group by c.genre
order by avg_score desc;


-- 5. Completion rate by content
-- If watched_time is at least 90% of runtime, it is counted as completed.
select
    c.title as content_title,
    c.runtime,
    count(v.history_id) as total_views,
    sum(case when v.watched_time >= c.runtime * 0.9 then 1 else 0 end) as completed_views,
    round(
        sum(case when v.watched_time >= c.runtime * 0.9 then 1 else 0 end) * 100.0
        / count(v.history_id),
        2
    ) as completion_rate
from viewing_history v
join contents c on v.content_id = c.content_id
group by c.title, c.runtime
order by completion_rate desc;


-- 6. Watch count and share by device
select
    device,
    count(history_id) as watch_count,
    round(count(history_id) * 100.0 / (select count(*) from viewing_history), 2) as watch_share
from viewing_history
group by device
order by watch_count desc;


-- 7. Monthly watch trend
select
    to_char(viewed_at, 'YYYY-MM') as watch_month,
    count(history_id) as watch_count,
    sum(watched_time) as total_watched_time
from viewing_history
group by watch_month
order by watch_month;


-- 8. Average review score by completion status
select
    case
        when v.watched_time >= c.runtime * 0.9 then 'completed'
        else 'dropped'
    end as watch_status,
    count(distinct v.history_id) as history_count,
    round(avg(r.score), 2) as avg_score
from viewing_history v
join contents c on v.content_id = c.content_id
left join reviews r
    on v.user_id = r.user_id
    and v.content_id = r.content_id
group by watch_status
order by avg_score desc;
