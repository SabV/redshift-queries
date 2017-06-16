select 'https://drivy.imgix.net/uploads/originals/' || split_part(split_part(uv.object_changes, '/uploads/originals/', 2), '.jpg', 1) || '.jpg'
from user_versions uv
where to_char(uv.created_at, 'YYYY-MM-DD') = '____-__-__'
and uv.item_id = '________'
and uv.whodunnit <> uv.item_id
and uv.object_changes like '%.jpg", null]%'