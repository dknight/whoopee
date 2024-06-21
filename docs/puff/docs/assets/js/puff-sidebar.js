const collapse = () => document.body.classList.remove('expanded');
const burger = document.querySelector('.burger');
const wrap = document.querySelector('.wrap');
const sidebar = document.getElementById('sidebar');
burger.addEventListener('click', () => {
  const isExpanded = document.body.classList.contains('expanded');
  document.body.classList.toggle('expanded', !isExpanded);
});
sidebar.addEventListener(
  'click',
  (e) => e.target.nodeName === 'A' && collapse()
);
wrap.addEventListener('click', collapse);
const noSidebar = new URL(window.location).search.includes('nosidebar');
if (noSidebar) {
  document.body.style.display = 'block';
  sidebar.remove();
}
