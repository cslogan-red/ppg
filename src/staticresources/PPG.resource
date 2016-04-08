
.detail_background {
	background-color: #cfeef8;
	border-radius: 15px;
	padding-bottom: 20px;
	margin-bottom: 10px;
}
.padding_around {
	padding-top: 15px;
	padding-left: 8px;
	padding-right: 8px;
	padding-bottom: 8px;
}
.padding_around_p {
	padding: 2px;
	-webkit-margin-before: 0px;
    -webkit-margin-after: 0px;
    -webkit-margin-start: 0px;
    -webkit-margin-end: 0px;
}
.padding_panel {
	padding: 3px;
}
.output_panel_text {
	font-weight: normal;
	font-size: 1em;
}
.output_label_text {
	font-weight: bold;
	font-size: 1em;
}
.output_panel_text_title {
	font-weight: normal;
	font-size: 1.2em;
}
.output_label_text_title {
	font-weight: bold;
	font-size: 1.2em;
}
.table_label_text {
	margin-left: 10px;
	padding-bottom: 5px;
	font-weight: bold;
	font-size: 1em;
}
.table_align {
	margin-left: 15px;
	margin-top: 8px;
}
table.payment_table {
	background-color: white;
	border: 1px solid #007fcc;
	border-radius: 10px;
	font-weight: normal;
	margin-left: 15px;
	margin-right: 15px;
	table-layout: fixed;
}
table.payment_table th {
	background-color: #007fcc;
	border-radius: 10px;
	color: white;
}
table.payment_table th, table.payment_table td {
    padding: 10px;
    text-align: left;
    width: 30%;
    border-bottom: 1px solid #ddd;
}
table.payment_table tr { 
	background-color: #white
}
table.payment_table tr:last-child td {
  	border-bottom: 0;
}
/* handle a "modal" dialog for new records */
.popup{
    background-color: white;
    border-width: 2px;
    border-style: solid;
    border-radius: 20px;
    z-index: 9999;
    left: 50%;
    padding: 10px;
    position: absolute;
    width: 50%;
    margin-left: -25%;
    top: 100px;
}
.popup_background{
    background-color: rgba(0,0,0,.5);
    position: absolute;
    width: 100%;
    height: 100%;
    top: 0;
    left: 0;
    z-index: 9998;
}
.required {
	color: Red;
	font-size: 10px;
	font-family: Arial,Helvetica,sans-serif;
}
.required_border {
	border: 2px solid red;
}