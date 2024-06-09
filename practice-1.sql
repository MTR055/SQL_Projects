use production;

select sum(s.quantity) as total_sales,year(s2.order_date) as year1,monthname(s2.order_date) as month1
from sales.order_items as s
join sales.orders as s2 on s.order_id=s2.order_id
join production.products as p on p.product_id=s.product_id
join production.categories as p2 on p.category_id=p2.category_id
where p2.category_id=5 
group by year1,month1;

select monthname(s1.order_date) as month1,sum(s.quantity) as total
from sales.orders as s1
join sales.order_items as s
group by month1
order by total
limit 3;

use employees;

select * from dept_manager
where emp_no in (select emp_no from employees where hire_date between '1990-01-01' and '1995-01-01');

select e.first_name , e.last_name
from employees as e
where
exists (select * from dept_manager as d where e.emp_no=d.emp_no);

select e.first_name , e.last_name
from employees as e
join dept_manager as d on e.emp_no=d.emp_no
order by e.first_name;

select * 
from dept_manager
join employees on dept_manager.emp_no=employees.emp_no
where employees.hire_date between '1990-01-01' and '1995-01-01';

select * from employees
where emp_no in(select emp_no from dept_manager where dept_no in(select dept_no from departments where dept_name='Finance'));

select * from employees
where exists(select * from titles  where  titles.emp_no=employees.emp_no and title='Assistant Engineer');

select * from departments;

select * from (select e.emp_no,min(d.dept_no), (select emp_no from dept_manager where emp_no='110022') as manager
from employees as e
join dept_emp as d on d.emp_no=e.emp_no
where e.emp_no<=10020
group by  e.emp_no
order by e.emp_no) as A
union 
select * from(select e.emp_no,min(d.dept_no), (select emp_no from dept_manager where emp_no='110039') as manager
from employees as e
join dept_emp as d on d.emp_no=e.emp_no
where e.emp_no between 10020 and 10040
group by  e.emp_no
order by e.emp_no) as B;

drop table if exists emp_manager;
create table emp_manager
(
emp_no INT(11) not null,
dept_no char(4) null,
manager_no int(11) not null
);

