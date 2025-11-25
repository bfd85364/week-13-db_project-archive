
-- popular_products 테이블 기반 작업
select * from popular_products;

-- 문제 3) 아래 출력 결과를 위한 쿼리를 작성하세요~
-- # product_id	score	r	min_item
-- A001	94	1	D005
-- D001	90	2	D005
-- D002	82	3	D005
-- A002	81	4	D005
-- A003	78	5	D005
-- D003	78	6	D005
-- A004	64	7	D005
-- D004	58	8	D005
-- D005	38	9	D005

SELECT product_id, count(*) over(partition by product_id), 
score, rank() over(order BY score DESC) AS r, min(product_id) as min_item
FROM review GROUP BY product_id;

-- 정답: 
SELECT product_id, score, row_number() over(order by score DESC) AS R,
last_value(product_id) over(ORDER BY score DESC 
rows BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)  #끝나는 수 
AS min_item FROM popular_products; 

-- 다른 정답:

SELECT product_id, score, row_number() over(order by score) AS R, 
first_value(product_id) over(ORDER BY score) AS min_item 
FROM popular_products order by score desc; 




-- 문제 4) 아래 출력 결과를 위한 쿼리를 작성하세요~
-- # product_id	score	category	r	cumulated_score	total_score	local_avg	max_item	min_item
-- A001	94	action	1	94	663	92.0000	A001	D005
-- D001	90	drama	2	184	663	88.6667	A001	D005
-- D002	82	drama	3	266	663	84.3333	A001	D005
-- A002	81	action	4	347	663	80.3333	A001	D005
-- A003	78	action	5	425	663	79.0000	A001	D005 동점에 대한 누적합 시작됨
-- D003	78	drama	6	503	663	73.3333	A001	D005
-- A004	64	action	7	567	663	66.6667	A001	D005
-- D004	58	drama	8	625	663	53.3333	A001	D005
-- D005	38	drama	9	663	663	48.0000	A001	D005

# 5등 6등 동점이지만 누적하이 다르므로 물리적인 행의 합으로 비교해야함 
SELECT *, row_number() over(order by score desc) as r, 
SUM(score) over(ORDER BY score DESC ROWS BETWEEN UNBOUNDED PRECEDING 
AND CURRENT ROW) AS CUM_SUM, 
SUM(SCORE) OVER() AS total_score,
AVG(score) OVER(ORDER BY score DESC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
as local_avg,
first_value(product_id) OVER(ORDER BY score desc) as max_item,
last_value(product_id) OVER(ORDER BY score desc rows between UNBOUNDED PRECEDING
AND UNBOUNDED FOLLOWING) as min_item FROM popular_products;

	



 -- 문제 5) 아래 출력 결과를 위한 쿼리를 작성하세요~ (utility function 활용 필요)   
-- # product_id	category	score	r	whole_aggregation	cumulated_aggregation	local_aggregation
-- A001	action	94	1	["A001", "A002", "A003", "A004"]	["A001"]							["A001", "A002"]
-- A002	action	81	2	["A001", "A002", "A003", "A004"]	["A001", "A002"]					["A001", "A002", "A003"]
-- A003	action	78	3	["A001", "A002", "A003", "A004"]	["A001", "A002", "A003"]			["A002", "A003", "A004"]
-- A004	action	64	4	["A001", "A002", "A003", "A004"]	["A001", "A002", "A003", "A004"]	["A003", "A004"]

-- utility function : JSON_OBJECTTAG -> dictonary 형태로 제공 / JSON_ARRAYAGG -> list 형태
					

SELECT product_id, category, rank() over(ORDER BY score DESC) as r,
json_arrayagg(product_id) OVER(order by score desc 
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS whole_aggregation,
json_arrayagg(product_id) OVER(order by score desc 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulated_aggregation,
json_arrayagg(product_id) OVER(order by score desc 
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS local_aggregation
FROM popular_products WHERE category LIKE "%action%";

# 혹은 아래와 같이 구현
SELECT product_id, category, rank() over(ORDER BY score DESC) as r,
json_arrayagg(product_id) OVER(order by score desc 
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS whole_aggregation,
json_arrayagg(product_id) OVER(order by score desc 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulated_aggregation,
json_arrayagg(product_id) OVER(order by score desc) as cum_agg,
json_arrayagg(product_id) OVER(order by score desc 
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS local_aggregation
FROM popular_products WHERE category LIKE "%action%";

 -- 문제 6) 아래 출력 결과를 위한 쿼리를 작성하세요~ (카테고리 모두 포함) 
-- # category	product_id	row_num	total_agg	cum_agg	local_agg
-- action	A001	1	["A001", "A002", "A003", "A004"]			["A001"]									["A001", "A002"]
-- action	A002	2	["A001", "A002", "A003", "A004"]			["A001", "A002"]							["A001", "A002", "A003"]
-- action	A003	3	["A001", "A002", "A003", "A004"]			["A001", "A002", "A003"]					["A002", "A003", "A004"]
-- action	A004	4	["A001", "A002", "A003", "A004"]			["A001", "A002", "A003", "A004"]			["A003", "A004"]
-- drama	D001	1	["D001", "D002", "D003", "D004", "D005"]	["D001"]									["D001", "D002"]
-- drama	D002	2	["D001", "D002", "D003", "D004", "D005"]	["D001", "D002"]							["D001", "D002", "D003"]
-- drama	D003	3	["D001", "D002", "D003", "D004", "D005"]	["D001", "D002", "D003"]					["D002", "D003", "D004"]
-- drama	D004	4	["D001", "D002", "D003", "D004", "D005"]	["D001", "D002", "D003", "D004"]			["D003", "D004", "D005"]
-- drama	D005	5	["D001", "D002", "D003", "D004", "D005"]	["D001", "D002", "D003", "D004", "D005"]	["D004", "D005"]

SELECT category, product_id, row_number() over(partition BY category ORDER BY score DESC) as r,
json_arrayagg(product_id) OVER(order by score desc 
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS whole_aggregation,
json_arrayagg(product_id) OVER(order by score desc 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulated_aggregation,
json_arrayagg(product_id) OVER(order by score desc 
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS local_aggregation
FROM popular_products;

-- 문제 7) 카테고리별 순위 최상위 상품을 조회하시오. (윈도우 함수 + 서브쿼리문)

SELECT * FROM( 
SELECT * , row_number() over(partition BY category ORDER BY score DESC) AS R 
FROM popular_products) AS SUB
WHERE SUB.R =1;

with TEMP AS(
SELECT *, RANK() OVER(partition by category order by score desc) AS r
FROM popular_products) SELECT * FROM temp WHERE r = 1;

-- 문제 8) 카테고리별 순위 최상위 상품을 조회하시오. (윈도우 함수 + CTE)
SELECT category, FIRST_VALUE(product_id) over(Partition by category
ORDER BY score DESC) FROM popular_products;

-- 문제 9) 카테고리별 순위 최상위 상품을 조회하시오. (윈도우 함수 사용 without 서브쿼리 or CTEs )

SELECT DISTINCT category, FIRST_VALUE(product_id) over(Partition by category
ORDER BY score DESC) FROM popular_products;


-- 문제 10번)  아래 출력과 같이, 각 카테고리별 상위 2개씩 추출하기
-- # category	product_id	score	rank_
-- action	A001	94	1
-- action	A002	81	2
-- drama	D001	90	1
-- drama	D002	82	2

WITH TEMP AS(
SELECT *, rank() over(partition by category ORDER BY score DESC) as rank_
FROM popular_products) 
SELECT * FROM TEMP WHERE rank_ <= 2;


-- 문제 11번) 카테고리별 최상위 제품과 점수를 조회하는 아래 윈도우 함수 기반 쿼리가 있다. 같은 결과를 윈도우 함수 사용 없이, group by를  사용하여 작성해 보세요~
with temp as(
	select MAX(product_id) , score from review
    GROUP BY category
)SELECT PP.* FROM popular_products PP JOIN temp T ON PP.category = T.category
	AND PP.score = T.score;

--  최상위 제품 -> MAX를 의미 
-- product_id를 join을 통해 가져옴 


 -- > CTE없이 서브쿼리를 사용하여 동일한 결과 도출하시오.



-- 문제 12번) 위의 결과에 카테고리별 평균점수까지 추가하여 조회하세요~ (카테고리별 최상위 제품, 점수, 평균점수)
with temp AS(
SELECT category, max(score) as best_score, avg(score) AS acg_score
FROM popular_products
group by category
) SELECT a.category, a.product_id, b.best_score, b.avg_score
from popular_products a JOIN temo b
ON a.category = b.category AND a.score = b.score;


-- 문제 13번) 카테고리별 순위 3등인 제품 아이디, score를 조회하시오.  

WITH TEMP as(
SELECT *, rank() over(partition by category order by score desc) as rank_
from popular_products
) select * from temp where rank_= 3;


