select 'https://www.drivy.com/admin/car_photos/' || cp.id || '/edit'
from car_photos cp
inner join todos t on t.subject_id = cp.id and t.subject_type = 'CarPhoto' and t.action_type = 'car_photo_quality'
inner join cars c on c.id = cp.car_id
inner join users u on u.id = c.user_id
where to_char(t.closed_at, 'YYYY-MM-DD') = '____-__-__'
and u.id = '________'
and cp.state = 'deleted'