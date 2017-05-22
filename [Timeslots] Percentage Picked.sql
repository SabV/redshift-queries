SELECT *
FROM
  (SELECT round(((count_inbound*100)/count_all), 2),
          count_all AS nb_calls,
          "country::filter",
          year_week, day, hour
   FROM
     (SELECT count(CASE WHEN t.call_type = 'inbound' THEN 1 END)::float AS count_inbound,
             count(1)::float AS count_all,
             'FR' AS "country::filter",
             date_trunc('week', convert_timezone('Europe/Paris', t.start_time)) AS year_week,
             to_char(convert_timezone('Europe/Paris', t.start_time), 'D') as day,
			to_char(convert_timezone('Europe/Paris', t.start_time), 'HH24') as hour -- FR (Transfers picked)

      FROM talkdesk_calls t
      WHERE t.in_business_hours IS TRUE
		AND to_char(convert_timezone('Europe/Paris', t.start_time), 'HH24:MI') between '09:30' and '19:00'
		AND t.call_type NOT IN ('outbound',
                                'outbound_missed',
                                'short_abandoned')
        AND t.phone_display_name IN ('FR Webhelp > Support',
                                     'FR Webhelp > Open') -- FR Webhelp Transfers ONLY

      GROUP BY "country::filter",
               year_week, day, hour
      
UNION ALL -- + Other Countries
     
     SELECT count(CASE WHEN call_type = 'inbound' THEN 1 END)::float AS count_inbound,
        count(1)::float AS count_all,
        country AS "country::filter",
        year_week, day, hour
      FROM
        (SELECT t.call_type,
                CASE WHEN (t.phone_display_name IN ('DE Support',
                                                    'DE Open Support',
                                                    'AT Support')
                           AND NOT (t.phone_display_name = 'DE Support'
                                    AND (left(t.ivr_options, 1) = 1 OR t.ivr_options = 3))) THEN 'DE-AT' WHEN (t.phone_display_name IN ('ES Support',
                                                                                                         'ES Open Support') AND left(t.ivr_options, 1) <> 1) THEN 'ES' WHEN (t.phone_display_name = 'BE Support' and left(t.ivr_options, 1) <> 1) THEN 'BE' ELSE 'ELSE' END AS country,
date_trunc('week', convert_timezone('Europe/Paris', t.start_time)) AS year_week,
to_char(convert_timezone('Europe/Paris', t.start_time), 'D') as day,
to_char(convert_timezone('Europe/Paris', t.start_time), 'HH24') as hour
         FROM talkdesk_calls t
WHERE t.in_business_hours IS TRUE
		AND to_char(convert_timezone('Europe/Paris', t.start_time), 'HH24:MI') between '09:30' and '19:00'
AND t.call_type NOT IN ('outbound',
                        'outbound_missed',
                        'short_abandoned'))
WHERE country <> 'ELSE'
      GROUP BY "country::filter",
             year_week, day, hour))
             
WHERE year_week = date_trunc('week', dateadd(w, -1, convert_timezone('Europe/Paris', CURRENT_DATE)))
ORDER BY "country::filter" DESC
