select
case when (r.registration_country='DE' or r.registration_country='AT') then 'DE-AT'
else r.registration_country
end as country,
to_char(convert_timezone('Europe/Paris', r.ends_at), 'IW') as week, to_char(convert_timezone('Europe/Paris', r.ends_at), 'MM') as month, to_char(convert_timezone('Europe/Paris', r.ends_at), 'YYYY') as year, count(distinct(r.id))

	from rentals r

		where r.state='ended'
		and r.registration_country in ( 'FR', 'BE', 'AT', 'DE', 'ES')
		and to_char(convert_timezone('Europe/Paris', r.ends_at), 'YYYY') = 2017
		and to_char(convert_timezone('Europe/Paris', r.ends_at), 'IW') = ---

			group by country, week, month, year
;
