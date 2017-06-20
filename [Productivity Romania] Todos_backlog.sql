select sum(backlog), action_type, year_created, week_created

from (select case when t.action_type = 'avatar_quality' then 'UPQ'
when t.action_type = 'car_photo_quality' then 'CPQ'
when t.action_type = 'suspicious_messages' then 'BS'
when t.action_type = 'new_car_compliance' then 'NCC'
when t.action_type = 'new_car_quality' then 'NCQ'
end as action_type,

w.year_created, w.week_created, t.id,
			
case when t.date_created <= w.date_created and t.date_closed > w.date_created then 1 else 0 end as backlog,
			
t.date_created, t.date_closed

from (select *

from (select t.id, t.action_type, t.country, t.locale, t.state,

case when to_char(convert_timezone('Europe/Paris', t.created_at), 'D') = 1 and to_char(convert_timezone('Europe/Paris', t.created_at), 'HH24') >= 21 then date_trunc('week', dateadd(w, 1, convert_timezone('Europe/Paris', t.created_at)))
else date_trunc('week', convert_timezone('Europe/Paris', t.created_at))
end as date_created,

case when t.closed_at is null then date_trunc('week', convert_timezone('Europe/Paris', current_date))
else date_trunc('week', convert_timezone('Europe/Paris', t.closed_at))
end as date_closed

from todos t 

where ((t.country = 'FR' and t.locale = 'fr' and t.action_type in ('new_car_compliance', 'car_photo_quality', 'avatar_quality', 'new_car_quality', 'suspicious_messages')) or
(t.country in ('BE', 'DE', 'AT', 'ES') and t.locale in ('fr_BE', 'nl_BE', 'de_AT', 'de', 'es') and t.action_type in ('new_car_compliance', 'car_photo_quality', 'avatar_quality')))
and t.created_at >= '2017-02-27'
and state <> 'canceled')
											
where date_created < date_closed)t

left join (select to_char(date_created, 'IW') as week_created, to_char(date_created, 'YYYY') as year_created, date_created

from (select t.id, t.action_type, t.country, t.locale, t.state,

case when to_char(convert_timezone('Europe/Paris', t.created_at), 'D') = 1 and to_char(convert_timezone('Europe/Paris', t.created_at), 'HH24') >= 21 then date_trunc('week', dateadd(w, 1, convert_timezone('Europe/Paris', t.created_at)))
else date_trunc('week', convert_timezone('Europe/Paris', t.created_at))
end as date_created,

case when t.closed_at is null then date_trunc('week', convert_timezone('Europe/Paris', current_date))
else date_trunc('week', convert_timezone('Europe/Paris', t.closed_at))
end as date_closed

from todos t 

where ((t.country = 'FR' and t.locale = 'fr' and t.action_type in ('new_car_compliance', 'car_photo_quality', 'avatar_quality', 'new_car_quality', 'suspicious_messages')) or
(t.country in ('BE', 'DE', 'AT', 'ES') and t.locale in ('fr_BE', 'nl_BE', 'de_AT', 'de', 'es') and t.action_type in ('new_car_compliance', 'car_photo_quality', 'avatar_quality')))
and t.created_at >= '2017-02-27'
and state <> 'canceled')

where date_created < date_closed

group by week_created, year_created, date_created, date_closed)w on 1=1

group by w.week_created, w.year_created, t.action_type, t.id, backlog, t.date_created, t.date_closed

order by t.id, t.action_type, w.week_created)

where year_created = 2017
and week_created = ---

group by action_type, year_created, week_created

order by year_created, week_created, action_type
