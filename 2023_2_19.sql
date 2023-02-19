-- 세그먼트 추출 코드 작성

-- noph
SELECT a.courierid AS courierid
		,a.active_type AS group_name
		,a.vehicle_type AS vehicletype
		,UPPER(b.group_name) AS control_yn
		,a.favorite_region_name_kr_365d AS region
		,a.district AS district
		,'202307' AS week -- 원하는 week 입력
FROM eats_dw.adm_courier_profile_region_ops AS a
RIGHT JOIN ( SELECT uid
				,description AS group_name
				,dt
			FROM eats_dw.dwd_segmentation_enriched
			WHERE segment_createdby IN ('chsong47')
			AND description IN ('CONTROL', 'TEST1', 'TEST2') 
			-- eats_dw.dwd_segmentation_enriched을 확인해보니 플랫폼에서 추출한 세그먼트에만 description열에 'CONTROL','TEST1','TEST2' 형태로 데이터 기입
			-- Coupang Eats Operation Center에서 잠재고객 세그먼트로 등록하는 경우엔 세그먼트 이름으로 description 열에 등록됨 
			-- 현재로선 문제는 없지만.. 테이블에서의 존재하는 규칙성을 찾은 부분이라 혹시 문제가 생길수도 있지 않을까? 불안 요소 존재
			AND dt = '20230216') AS b  -- 타겟 세그먼트 추출 당일 날짜 입력
			ON a.courierid = CAST(b.uid AS int)
			AND CAST(a.dt AS int) = CAST(b.dt AS int) - 1 
			-- eats_dw.dwd_segmentation_enriched 테이블은 세그먼트 플랫폼에서 추출된 날짜로 dt 입력 추측
			-- eats_dw.adm_courier_profile_region_ops 테이블은 매일매일 갱신됨, 즉 플랫폼에서  eats_dw.adm_courier_profile_region_ops 테이블의 dt 전날 날짜로 가져오기 때문에 이 같은 내용 반영
			
-- loginid 추가
SELECT a.courierid AS courierid
		,a.active_type AS group_name
		,a.vehicle_type AS vehicletype
		,c.loginid AS loginid
		,UPPER(b.group_name) AS control_yn
		,a.favorite_region_name_kr_365d AS region
		,a.district AS district
		,'202307' AS week 
FROM eats_dw.adm_courier_profile_region_ops AS a
RIGHT JOIN ( SELECT uid
				,description AS group_name
				,dt
			FROM eats_dw.dwd_segmentation_enriched
			WHERE segment_createdby IN ('chsong47')
			AND description IN ('CONTROL', 'TEST1', 'TEST2')
			AND dt = '20230216') AS b  -
			ON a.courierid = CAST(b.uid AS int)
			AND CAST(a.dt AS int) = CAST(b.dt AS int) - 1 
INNER JOIN  ods.obs_account  AS c ON a.courierid = c.userid -- 하리님 쿼리 이용
