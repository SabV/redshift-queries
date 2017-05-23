SELECT *
FROM
  (SELECT avg(t.waiting_time),
          count(t.waiting_time) AS nb_calls,
          'FR' AS "country::filter",
          date_trunc('week', convert_timezone('Europe/Paris', t.start_time)) AS year_week,
          to_char(convert_timezone('Europe/Paris', t.start_time), 'D') as day,
          to_char(convert_timezone('Europe/Paris', t.start_time), 'HH24') as hour -- FR (Transferring Time)

   FROM talkdesk_calls t
   WHERE t.in_business_hours IS TRUE -- INBOUND ONLY
   AND to_char(convert_timezone('Europe/Paris', t.start_time), 'HH24:MI') between '09:30' and '19:00'

AND t.call_type NOT IN ('outbound',
                        'outbound_missed')
     AND t.phone_display_name IN ('FR Webhelp > Support',
                                  'FR Webhelp > Open') -- FR Webhelp Transfers ONLY
AND date_trunc('week', convert_timezone('Europe/Paris', t.start_time)) >= date_trunc('week', convert_timezone('Europe/Paris', '2016-11-01 00:00:00'))
   GROUP BY "country::filter",
            year_week, day, hour
   UNION ALL -- + Other Countries
   
 SELECT avg(waiting_time),
        count(waiting_time) AS nb_calls,
        country AS "country::filter",
        year_week, day, hour
   FROM
     (SELECT t.waiting_time,
             CASE WHEN (t.phone_display_name IN ('DE Support',
                                                    'DE Open Support',
                                                    'AT Support')
                           AND NOT (t.phone_display_name = 'DE Support'
                                    AND (left(t.ivr_options, 1) = 1 OR t.ivr_options = 3))) THEN 'DE-AT' WHEN (t.phone_display_name = 'ES Support' AND left(t.ivr_options, 1) <> 1) OR t.phone_display_name = 'ES Open Support' THEN 'ES' WHEN t.phone_display_name = 'BE Support' THEN 'BE' ELSE 'ELSE' END AS country,
date_trunc('week', convert_timezone('Europe/Paris', t.start_time)) AS year_week,
          to_char(convert_timezone('Europe/Paris', t.start_time), 'D') as day,
          to_char(convert_timezone('Europe/Paris', t.start_time), 'HH24') as hour -- Countries (Waiting Time)

      FROM talkdesk_calls t
WHERE t.in_business_hours IS TRUE -- INBOUND ONLY
AND to_char(convert_timezone('Europe/Paris', t.start_time), 'HH24:MI') between '09:30' and '19:00'
AND t.call_type NOT IN ('outbound',
                        'outbound_missed')
AND date_trunc('week', convert_timezone('Europe/Paris', t.start_time)) >= date_trunc('week', convert_timezone('Europe/Paris', '2016-11-01 00:00:00')))
WHERE country <> 'ELSE'
   GROUP BY "country::filter",
          year_week, day, hour)
          
WHERE year_week = date_trunc('week', dateadd(w, -1, convert_timezone('Europe/Paris', CURRENT_DATE)))
ORDER BY "country::filter" DESC
