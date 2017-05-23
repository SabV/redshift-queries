(((select date_trunc('week', convert_timezone('Europe/Paris', start_date)) as year_week, task_level_2 as disposition_code, count(1), 'inbounds' as type, 'FR' as country
from webhelp
where task_level = 'Appels entrants'
and task_type = 'support'
and date_trunc('week', convert_timezone('Europe/Paris', start_date)) = (date_trunc('week', dateadd(w, -1, convert_timezone('Europe/Paris', CURRENT_DATE))))
group by year_week, task_level_2
order by count desc
limit 5)

UNION ALL

(SELECT date_trunc('week', convert_timezone('Europe/Paris', start_time)) as year_week, disposition_code, count(1), 'transfers' as type, 'FR' as country
FROM talkdesk_calls
WHERE ((phone_display_name = 'FR Support'
                         AND left(ivr_options, 1) <> '1')
                        OR (phone_display_name = 'FR Support'
                            AND ivr_options IS NULL)
                        OR (phone_display_name IN ('FR Open Support',
                                                   'FR Owner',
                                                   'FR Webhelp > Support',
                                                   'FR Webhelp > Open')))
AND disposition_code is not null
AND agent_name IN ('Caroline',
                         'Chloe',
                         'Chloe Roux',
                         'Gabriela',
                         'Imane',
                         'Jamal',
                         'Laura Gagne',
                         'Lionel',
                         'Melody',
                         'Sabrina',
                         'Schérazade',
                         'Soline',
                         'Soline Vincent-Gabourg',
                         'If-No-Answer Agent')
AND disposition_code <> 'Not Found'
AND call_type = 'inbound'
and date_trunc('week', convert_timezone('Europe/Paris', start_time)) = (date_trunc('week', dateadd(w, -1, convert_timezone('Europe/Paris', CURRENT_DATE))))
group by year_week, disposition_code
order by count desc
limit 5)

order by type asc, count desc)

UNION ALL

(SELECT date_trunc('week', convert_timezone('Europe/Paris', start_time)) as year_week, disposition_code, count(1), 'inbounds' as type, 'DE-AT' as country
FROM talkdesk_calls
WHERE ((phone_display_name = 'DE Support' AND left(ivr_options, 1) <> 1) OR phone_display_name IN ('DE Open Support',
                                                                                     'AT Support',
                                                                                     'DE Webhelp > Support'))
      
      AND agent_name IN ('Robert',
                         'Jasmin',
                         'Julia M',
                         'Laura Gagne',
                         'If-No-Answer Agent')
AND disposition_code is not null
AND disposition_code <> 'Not Found'
AND call_type = 'inbound'
and date_trunc('week', convert_timezone('Europe/Paris', start_time)) = (date_trunc('week', dateadd(w, -1, convert_timezone('Europe/Paris', CURRENT_DATE))))
group by year_week, disposition_code
order by count desc
limit 5)

UNION ALL

(SELECT date_trunc('week', convert_timezone('Europe/Paris', start_time)) as year_week, disposition_code, count(1), 'inbounds' as type, 'ES' as country
FROM talkdesk_calls
WHERE ((phone_display_name = 'ES Support' AND left(ivr_options, 1) <> 1) OR phone_display_name  = 'ES Open Support')
      AND agent_name IN ('Dulce Amor',
                         'Mariela',
                         'Luis',
                         'If-No-Answer Agent')
AND disposition_code is not null
AND disposition_code <> 'Not Found'
AND call_type = 'inbound'
and date_trunc('week', convert_timezone('Europe/Paris', start_time)) = (date_trunc('week', dateadd(w, -1, convert_timezone('Europe/Paris', CURRENT_DATE))))
group by year_week, disposition_code
order by count desc
limit 5)

UNION ALL

(SELECT date_trunc('week', convert_timezone('Europe/Paris', start_time)) as year_week, disposition_code, count(1), 'inbounds' as type, 'BE' as country
FROM talkdesk_calls
WHERE phone_display_name = 'BE Support'
      AND agent_name IN ('Victor',
                         'Lionel',
                         'If-No-Answer Agent')
AND disposition_code is not null
AND disposition_code <> 'Not Found'
AND call_type = 'inbound'
and date_trunc('week', convert_timezone('Europe/Paris', start_time)) = (date_trunc('week', dateadd(w, -1, convert_timezone('Europe/Paris', CURRENT_DATE))))
group by year_week, disposition_code
order by count desc
limit 5))
order by country desc, type asc, count desc
