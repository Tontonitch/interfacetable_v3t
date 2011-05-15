// Written by Yannick Charton
// For check_interface_table_v3t

function ChangeColor(tableRow, highLight) {
  if (highLight) { tableRow.style.backgroundColor = "#81BEF7"; }
  else { tableRow.style.backgroundColor = ""; }
}
function DoNav(theUrl) {
  document.location.href = theUrl;
}